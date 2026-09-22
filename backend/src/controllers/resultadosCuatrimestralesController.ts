import type { Request, Response } from 'express';
import type { Pool } from 'pg';

const roles = ['admin', 'coordinador_cpi', 'responsable_institucional', 'analista_vdssc'];
const response = (res: Response, status: number, data: unknown, error: string | null = null) => res.status(status).json({ success: status < 400, data, error });

function period(value: unknown) {
  const number = Number(value);
  return Number.isInteger(number) ? number : NaN;
}

export function createResultadosController(pool: Pool) {
  const canWrite = (req: Request) => Boolean(req.user && roles.includes(req.user.rol));
  const ownsAction = async (req: Request, accionId: number) => {
    if (req.user?.rol !== 'responsable_institucional') return true;
    const result = await pool.query('SELECT institucion_principal_id FROM acciones WHERE id = $1', [accionId]);
    return result.rows[0]?.institucion_principal_id === req.user.institucionId;
  };

  return {
    list: async (req: Request, res: Response) => {
      const accionId = period(req.params.id); const gestion = period(req.query.gestion ?? 2026);
      if (!Number.isInteger(accionId) || gestion < 2026 || gestion > 2030) return response(res, 400, null, 'Acción o gestión inválida');
      try { const result = await pool.query('SELECT id, accion_id, gestion, cuatrimestre, valor_resultado, medio_verificacion, referencia_verificacion, evidencias, observaciones, usuario_id, created_at, updated_at FROM resultados_cuatrimestrales WHERE accion_id=$1 AND gestion=$2 ORDER BY cuatrimestre', [accionId, gestion]); return response(res, 200, result.rows); } catch { return response(res, 500, null, 'No se pudieron consultar los resultados'); }
    },
    create: async (req: Request, res: Response) => {
      const accionId = period(req.params.id); const gestion = period(req.body.gestion); const cuatrimestre = period(req.body.cuatrimestre); const valor = Number(req.body.valor_resultado);
      if (!canWrite(req) || !Number.isInteger(accionId) || gestion < 2026 || gestion > 2030 || cuatrimestre < 1 || cuatrimestre > 3 || !Number.isFinite(valor) || valor < 0) return response(res, 400, null, 'Datos inválidos o usuario sin permisos');
      try { if (!(await ownsAction(req, accionId))) return response(res, 403, null, 'La acción no pertenece a su institución'); const evidencias = ((req.files || []) as Express.Multer.File[]).map((file) => ({ nombre: file.originalname, url: `/uploads/${file.filename}`, tipo: file.mimetype, tamaño: file.size })); const result = await pool.query('INSERT INTO resultados_cuatrimestrales(accion_id,gestion,cuatrimestre,valor_resultado,medio_verificacion,referencia_verificacion,evidencias,observaciones,usuario_id) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *', [accionId, gestion, cuatrimestre, valor, req.body.medio_verificacion || null, req.body.referencia_verificacion || null, JSON.stringify(evidencias), req.body.observaciones || null, req.user!.id]); return response(res, 201, result.rows[0]); } catch (error: any) { if (error?.code === '23505') return response(res, 409, null, 'Ya existe un resultado para ese cuatrimestre'); return response(res, 500, null, 'No se pudo registrar el resultado'); }
    },
    update: async (req: Request, res: Response) => {
      const id = period(req.params.id); const valor = Number(req.body.valor_resultado);
      if (!canWrite(req) || !Number.isInteger(id) || !Number.isFinite(valor) || valor < 0) return response(res, 400, null, 'Datos inválidos o usuario sin permisos');
      try { const current = await pool.query('SELECT accion_id, evidencias FROM resultados_cuatrimestrales WHERE id=$1', [id]); if (!current.rows[0]) return response(res, 404, null, 'Resultado no encontrado'); if (!(await ownsAction(req, current.rows[0].accion_id))) return response(res, 403, null, 'La acción no pertenece a su institución'); const nuevos = ((req.files || []) as Express.Multer.File[]).map((file) => ({ nombre: file.originalname, url: `/uploads/${file.filename}`, tipo: file.mimetype, tamaño: file.size })); const evidencias = [...(current.rows[0].evidencias || []), ...nuevos]; const result = await pool.query('UPDATE resultados_cuatrimestrales SET valor_resultado=$1, medio_verificacion=$2, referencia_verificacion=$3, evidencias=$4, observaciones=$5, updated_at=NOW() WHERE id=$6 RETURNING *', [valor, req.body.medio_verificacion || null, req.body.referencia_verificacion || null, JSON.stringify(evidencias), req.body.observaciones || null, id]); return response(res, 200, result.rows[0]); } catch { return response(res, 500, null, 'No se pudo actualizar el resultado'); }
    },
    remove: async (req: Request, res: Response) => {
      const id = period(req.params.id); if (!canWrite(req) || !Number.isInteger(id)) return response(res, 400, null, 'Identificador inválido o usuario sin permisos');
      try { const current = await pool.query('SELECT accion_id FROM resultados_cuatrimestrales WHERE id=$1', [id]); if (!current.rows[0]) return response(res, 404, null, 'Resultado no encontrado'); if (!(await ownsAction(req, current.rows[0].accion_id))) return response(res, 403, null, 'La acción no pertenece a su institución'); await pool.query('DELETE FROM resultados_cuatrimestrales WHERE id=$1', [id]); return response(res, 200, { id }); } catch { return response(res, 500, null, 'No se pudo eliminar el resultado'); }
    }
  };
}
