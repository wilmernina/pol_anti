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
        const result = await pool.query(`SELECT id,accion_id,gestion,trimestre,cantidad_programada,cantidad_ejecutada,medio_verificacion,evidencia_url,evidencias,justificacion,medidas_correctivas,observaciones,usuario_id,fecha_registro FROM metas_trimestrales WHERE accion_id=$1 AND gestion=$2 ORDER BY trimestre`, [actionId, gestion]);
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
        const planned = await pool.query('SELECT cantidad_programada,evidencias FROM metas_trimestrales WHERE accion_id=$1 AND gestion=$2 AND trimestre=$3', [actionId, gestion, trimestre]);
        if (!planned.rows[0]) return response(res, 404, null, 'No existe planificación para ese trimestre');
        if (ejecutada > Number(planned.rows[0].cantidad_programada)) return response(res, 422, null, 'La cantidad ejecutada no puede superar la cantidad programada');
        const incomingFiles = ((req.files || []) as Express.Multer.File[]).map((file) => ({ nombre: file.originalname, url: `/uploads/${file.filename}`, tipo: file.mimetype, tamano: file.size }));
        const previousFiles = Array.isArray(planned.rows[0].evidencias) ? planned.rows[0].evidencias : [];
        const evidencias = JSON.stringify([...previousFiles, ...incomingFiles]);
        const result = await pool.query(`UPDATE metas_trimestrales SET cantidad_ejecutada=$1,medio_verificacion=$2,evidencia_url=$3,evidencias=$4,justificacion=$5,medidas_correctivas=$6,usuario_id=$7,fecha_registro=NOW() WHERE accion_id=$8 AND gestion=$9 AND trimestre=$10 RETURNING id,accion_id,gestion,trimestre,cantidad_programada,cantidad_ejecutada,medio_verificacion,evidencia_url,evidencias,justificacion,medidas_correctivas,observaciones,usuario_id,fecha_registro`, [ejecutada, req.body.medioVerificacion || null, req.body.evidenciaUrl || null, evidencias, req.body.justificacion || null, req.body.medidasCorrectivas || null, req.user.id, actionId, gestion, trimestre]);
        return response(res, 200, result.rows[0]);
      } catch { return response(res, 500, null, 'No se pudo guardar la medición'); }
    }
  };
}
