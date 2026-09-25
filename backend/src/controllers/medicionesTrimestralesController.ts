import type { Request, Response } from 'express';
import type { Pool } from 'pg';

const allowedRoles = ['admin', 'coordinador_cpi', 'responsable_institucional'];
const response = (res: Response, status: number, data: unknown, error: string | null = null) => res.status(status).json({ success: status < 400, data, error });

export function createMedicionesTrimestralesController(pool: Pool) {
  return {
    list: async (req: Request, res: Response) => {
      const actionId = Number(req.params.id); const gestion = Number(req.query.gestion ?? 2026);
      if (!Number.isInteger(actionId) || actionId <= 0 || !Number.isInteger(gestion) || gestion < 2026 || gestion > 2030) return response(res, 400, null, 'Acción o gestión inválida');
      try {
        const result = await pool.query(`SELECT id,accion_id,gestion,trimestre,cantidad_programada,cantidad_ejecutada,medio_verificacion,evidencia_url,observaciones,usuario_id,fecha_registro FROM metas_trimestrales WHERE accion_id=$1 AND gestion=$2 ORDER BY trimestre`, [actionId, gestion]);
        return response(res, 200, result.rows);
      } catch { return response(res, 500, null, 'No se pudieron consultar las mediciones'); }
    },
    save: async (req: Request, res: Response) => {
      const actionId = Number(req.params.id); const gestion = Number(req.body?.gestion); const trimestre = Number(req.body?.trimestre); const ejecutada = Number(req.body?.cantidadEjecutada);
      if (!req.user || !allowedRoles.includes(req.user.rol) || !Number.isInteger(actionId) || actionId <= 0 || !Number.isInteger(gestion) || gestion < 2026 || gestion > 2030 || !Number.isInteger(trimestre) || trimestre < 1 || trimestre > 4 || !Number.isFinite(ejecutada) || ejecutada < 0) return response(res, 400, null, 'Datos inválidos o usuario sin permisos');
      try {
        const action = await pool.query('SELECT institucion_principal_id FROM acciones WHERE id=$1 AND estado_planificacion=\'publicada\'', [actionId]);
        if (!action.rows[0]) return response(res, 404, null, 'Acción no encontrada o no publicada');
        if (req.user.rol === 'responsable_institucional' && action.rows[0].institucion_principal_id !== req.user.institucionId) return response(res, 403, null, 'La acción no pertenece a su institución');
        const planned = await pool.query('SELECT cantidad_programada FROM metas_trimestrales WHERE accion_id=$1 AND gestion=$2 AND trimestre=$3', [actionId, gestion, trimestre]);
        if (!planned.rows[0]) return response(res, 404, null, 'No existe planificación para ese trimestre');
        if (ejecutada > Number(planned.rows[0].cantidad_programada)) return response(res, 422, null, 'La cantidad ejecutada no puede superar la cantidad programada');
        const result = await pool.query(`UPDATE metas_trimestrales SET cantidad_ejecutada=$1,medio_verificacion=$2,evidencia_url=$3,observaciones=$4,usuario_id=$5,fecha_registro=NOW() WHERE accion_id=$6 AND gestion=$7 AND trimestre=$8 RETURNING id,accion_id,gestion,trimestre,cantidad_programada,cantidad_ejecutada,medio_verificacion,evidencia_url,observaciones,usuario_id,fecha_registro`, [ejecutada, req.body.medioVerificacion || null, req.body.evidenciaUrl || null, req.body.observaciones || null, req.user.id, actionId, gestion, trimestre]);
        return response(res, 200, result.rows[0]);
      } catch { return response(res, 500, null, 'No se pudo guardar la medición'); }
    }
  };
}
