import type { Request, Response } from 'express';
import type { Pool } from 'pg';

const send = (res: Response, status: number, data: unknown, error: string | null = null) =>
  res.status(status).json({ success: status < 400, data, error });

const numberValue = (value: unknown) => {
  const result = Number(value);
  return Number.isFinite(result) ? result : NaN;
};

const quarterlyValues = (value: unknown) => {
  if (!Array.isArray(value) || value.length !== 4) return null;
  const values = value.map(numberValue);
  return values.every((item) => item >= 0) ? values : null;
};

const technicalFields = (body: Record<string, unknown>) => ({
  codigo: typeof body.codigo === 'string' ? body.codigo.trim() : '',
  entidadId: Number(body.entidadId),
  nombre: typeof body.nombre === 'string' ? body.nombre.trim() : '',
  resultado: typeof body.resultado === 'string' ? body.resultado.trim() : '',
  tipoAccion: typeof body.tipoAccion === 'string' ? body.tipoAccion.trim() : '',
  unidadMedida: typeof body.unidadMedida === 'string' ? body.unidadMedida.trim() : '',
  lineaBase: body.lineaBase === undefined || body.lineaBase === null || body.lineaBase === '' ? null : numberValue(body.lineaBase),
  medioVerificacion: typeof body.medioVerificacion === 'string' ? body.medioVerificacion.trim() : null,
  meta2030: body.meta2030 === undefined || body.meta2030 === null || body.meta2030 === '' ? null : numberValue(body.meta2030)
});

const validTechnicalFields = (fields: ReturnType<typeof technicalFields>) =>
  Boolean(fields.codigo && Number.isInteger(fields.entidadId) && fields.entidadId > 0 && fields.nombre && fields.tipoAccion && fields.unidadMedida)
  && (fields.lineaBase === null || fields.lineaBase >= 0)
  && (fields.meta2030 === null || fields.meta2030 >= 0);

export function createMatrizController(pool: Pool) {
  return {
    createAction: async (req: Request, res: Response) => {
      const fields = technicalFields(req.body ?? {});
      const quarters = quarterlyValues(req.body?.trimestres);
      if (!validTechnicalFields(fields)) return send(res, 422, null, 'Variables técnicas inválidas');
      if (!quarters) return send(res, 422, null, 'Se requieren cuatro cantidades trimestrales no negativas');

      const client = await pool.connect();
      try {
        await client.query('BEGIN');
        const action = await client.query(
          `INSERT INTO acciones(eje_id,codigo,nombre,resultado,unidad_medida,meta_2030,institucion_principal_id,linea_base,tipo_accion,medio_verificacion,estado_planificacion,orden)
           SELECT id,$2,$3,$4,$5,$6,$7,$8,$9,$10,'borrador',COALESCE((SELECT MAX(orden)+1 FROM acciones WHERE eje_id=id),1)
           FROM ejes WHERE codigo=$1 RETURNING id,codigo`,
          [req.params.codigo, fields.codigo, fields.nombre, fields.resultado || null, fields.unidadMedida, fields.meta2030, fields.entidadId, fields.lineaBase, fields.tipoAccion, fields.medioVerificacion]
        );
        if (!action.rows[0]) {
          await client.query('ROLLBACK');
          return send(res, 404, null, 'Eje no encontrado');
        }
        for (const [index, amount] of quarters.entries()) {
          await client.query(
            'INSERT INTO metas_trimestrales(accion_id,gestion,trimestre,cantidad_programada) VALUES($1,$2,$3,$4)',
            [action.rows[0].id, 2026, index + 1, amount]
          );
        }
        await client.query('COMMIT');
        return send(res, 201, { id: action.rows[0].id, codigo: action.rows[0].codigo });
      } catch (error: any) {
        await client.query('ROLLBACK');
        if (error?.code === '23505') return send(res, 409, null, 'El código de acción ya existe en el eje');
        return send(res, 500, null, 'No se pudo crear la acción');
      } finally {
        client.release();
      }
    },

    updateAction: async (req: Request, res: Response) => {
      const id = Number(req.params.id);
      const fields = technicalFields(req.body ?? {});
      if (!Number.isInteger(id) || id <= 0 || !validTechnicalFields(fields)) return send(res, 422, null, 'Variables técnicas inválidas');
      try {
        const current = await pool.query('SELECT id FROM acciones WHERE id=$1 AND eje_id=(SELECT id FROM ejes WHERE codigo=$2)', [id, req.body.ejeCodigo]);
        if (!current.rows[0]) return send(res, 404, null, 'Acción no encontrada en el eje indicado');
        const result = await pool.query(
          `UPDATE acciones SET codigo=$1,nombre=$2,resultado=$3,unidad_medida=$4,meta_2030=$5,institucion_principal_id=$6,linea_base=$7,tipo_accion=$8,medio_verificacion=$9 WHERE id=$10 RETURNING *`,
          [fields.codigo, fields.nombre, fields.resultado || null, fields.unidadMedida, fields.meta2030, fields.entidadId, fields.lineaBase, fields.tipoAccion, fields.medioVerificacion, id]
        );
        return send(res, 200, result.rows[0]);
      } catch (error: any) {
        if (error?.code === '23505') return send(res, 409, null, 'El código de acción ya existe en el eje');
        return send(res, 500, null, 'No se pudo actualizar la acción');
      }
    },

    savePlanification: async (req: Request, res: Response) => {
      const id = Number(req.params.id);
      const gestion = Number(req.body?.gestion);
      const quarters = Array.isArray(req.body?.trimestres) ? req.body.trimestres : [];
      if (!Number.isInteger(id) || id <= 0 || !Number.isInteger(gestion) || gestion < 2026 || gestion > 2030 || quarters.length !== 4 || quarters.some((item: any) => !Number.isInteger(Number(item.trimestre)) || Number(item.trimestre) < 1 || Number(item.trimestre) > 4 || numberValue(item.cantidadProgramada) < 0)) {
        return send(res, 422, null, 'Planificación trimestral inválida');
      }
      const client = await pool.connect();
      try {
        await client.query('BEGIN');
        const action = await client.query('SELECT id FROM acciones WHERE id=$1', [id]);
        if (!action.rows[0]) { await client.query('ROLLBACK'); return send(res, 404, null, 'Acción no encontrada'); }
        for (const item of quarters) {
          await client.query(
            `INSERT INTO metas_trimestrales(accion_id,gestion,trimestre,cantidad_programada)
             VALUES($1,$2,$3,$4)
             ON CONFLICT (accion_id,gestion,trimestre) DO UPDATE SET cantidad_programada=EXCLUDED.cantidad_programada`,
            [id, gestion, Number(item.trimestre), numberValue(item.cantidadProgramada)]
          );
        }
        await client.query('COMMIT');
        return send(res, 200, { accionId: id, gestion, trimestres: quarters });
      } catch {
        await client.query('ROLLBACK');
        return send(res, 500, null, 'No se pudo guardar la planificación');
      } finally {
        client.release();
      }
    },

    publishAction: async (req: Request, res: Response) => {
      const id = Number(req.params.id);
      if (!Number.isInteger(id) || id <= 0) return send(res, 422, null, 'Acción inválida');
      try {
        const result = await pool.query(
          `SELECT a.id,a.unidad_medida,a.tipo_accion,COUNT(m.id)::int AS trimestres
           FROM acciones a LEFT JOIN metas_trimestrales m ON m.accion_id=a.id AND m.gestion=2026
           WHERE a.id=$1 GROUP BY a.id`,
          [id]
        );
        const action = result.rows[0];
        if (!action) return send(res, 404, null, 'Acción no encontrada');
        if (!action.unidad_medida || !action.tipo_accion || action.trimestres !== 4) return send(res, 422, null, 'La acción requiere unidad, tipo y cuatro trimestres');
        const updated = await pool.query("UPDATE acciones SET estado_planificacion='publicada' WHERE id=$1 RETURNING id,estado_planificacion", [id]);
        return send(res, 200, updated.rows[0]);
      } catch {
        return send(res, 500, null, 'No se pudo publicar la planificación');
      }
    },

    listActions: async (req: Request, res: Response) => {
      const codigo = Array.isArray(req.params.codigo) ? '' : req.params.codigo;
      if (!/^[1-9]$/.test(codigo)) return send(res, 400, null, 'Código de eje inválido');
      try {
        const result = await pool.query(
          `SELECT a.id AS accion_id,a.codigo,a.nombre,a.resultado,a.meta_2030,a.linea_base,a.tipo_accion,a.unidad_medida,a.medio_verificacion,a.estado_planificacion,
             i.id AS entidad_id,i.siglas AS entidad,
             COALESCE(json_agg(json_build_object('trimestre',mt.trimestre,'cantidadProgramada',mt.cantidad_programada) ORDER BY mt.trimestre) FILTER (WHERE mt.id IS NOT NULL),'[]'::json) AS trimestres,
             COALESCE(SUM(mt.cantidad_programada) FILTER (WHERE mt.gestion=2026),0) AS meta_2026
           FROM acciones a JOIN ejes e ON e.id=a.eje_id LEFT JOIN instituciones i ON i.id=a.institucion_principal_id
           LEFT JOIN metas_trimestrales mt ON mt.accion_id=a.id AND mt.gestion=2026
           WHERE e.codigo=$1 GROUP BY a.id,i.id ORDER BY a.orden`,
          [codigo]
        );
        return send(res, 200, { acciones: result.rows });
      } catch {
        return send(res, 500, null, 'No se pudieron listar las acciones');
      }
    },

    getAction: async (req: Request, res: Response) => {
      const id = Number(req.params.id);
      if (!Number.isInteger(id) || id <= 0) return send(res, 400, null, 'Acción inválida');
      try {
        const result = await pool.query(
          `SELECT a.*,i.siglas AS entidad FROM acciones a LEFT JOIN instituciones i ON i.id=a.institucion_principal_id WHERE a.id=$1`,
          [id]
        );
        if (!result.rows[0]) return send(res, 404, null, 'Acción no encontrada');
        return send(res, 200, result.rows[0]);
      } catch {
        return send(res, 500, null, 'No se pudo consultar la ficha');
      }
    }
  };
}
