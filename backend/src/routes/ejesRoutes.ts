import { Router, type Request, type Response } from 'express';
import type { Pool } from 'pg';

const validCode = (value: string) => /^[1-9]$/.test(value);
const error = (response: Response, status: number, message: string) => response.status(status).json({ success: false, data: null, error: message });

/** Routes that expose the Cuadro A and Cuadro B of an action axis. */
export function createEjesRouter(pool: Pool): Router {
  const router = Router();
  router.get('/:codigo/resumen', async (request: Request, response: Response) => {
    const codigo = Array.isArray(request.params.codigo) ? '' : request.params.codigo;
    if (!validCode(codigo)) return error(response, 400, 'Código de eje inválido');
    try {
      const result = await pool.query('SELECT codigo, nombre, objetivo, indicadores_principales, resultados_2030 FROM ejes WHERE codigo = $1', [codigo]);
      if (!result.rows[0]) return error(response, 404, 'Eje no encontrado');
      return response.json({ success: true, data: result.rows[0], error: null });
    } catch { return error(response, 500, 'No se pudo obtener el eje'); }
  });
  router.get('/:codigo/matriz', async (request: Request, response: Response) => {
    const codigo = Array.isArray(request.params.codigo) ? '' : request.params.codigo;
    if (!validCode(codigo)) return error(response, 400, 'Código de eje inválido');
    try {
      const result = await pool.query(`SELECT e.codigo AS eje_codigo,e.nombre AS eje_nombre,
        a.id AS accion_id,a.codigo,a.nombre,a.resultado,a.indicador_proceso,a.meta_2030,
        a.linea_base,a.tipo_accion,a.unidad_medida,a.medio_verificacion,a.estado_planificacion,
        i.siglas AS entidad,
        COALESCE(json_agg(json_build_object('trimestre',mt.trimestre,'cantidadProgramada',mt.cantidad_programada,'cantidadEjecutada',mt.cantidad_ejecutada,'observaciones',mt.observaciones,'medioVerificacion',mt.medio_verificacion,'evidenciaUrl',mt.evidencia_url) ORDER BY mt.trimestre)
          FILTER (WHERE mt.id IS NOT NULL), '[]'::json) AS trimestres,
        COALESCE(SUM(mt.cantidad_programada) FILTER (WHERE mt.gestion=2026), 0) AS meta_2026
        FROM ejes e
        JOIN acciones a ON a.eje_id=e.id
        LEFT JOIN instituciones i ON i.id=a.institucion_principal_id
        LEFT JOIN metas_trimestrales mt ON mt.accion_id=a.id AND mt.gestion=2026
        WHERE e.codigo=$1 AND a.estado_planificacion='publicada'
        GROUP BY e.codigo,e.nombre,a.id,i.siglas ORDER BY a.orden`, [codigo]);
      if (!result.rows.length) { const exists=await pool.query('SELECT 1 FROM ejes WHERE codigo=$1',[codigo]); if(!exists.rows.length) return error(response,404,'Eje no encontrado'); }
      const first = result.rows[0];
      const acciones = result.rows.map((row) => ({
        ...row,
        trimestres: row.trimestres ?? [1, 2, 3, 4].map((trimestre) => ({ trimestre, cantidadProgramada: row[`t${trimestre}`] ?? 0 })),
        meta2026: Number(row.meta_2026 ?? row.meta2026 ?? 0)
      }));
      return response.json({ success: true, data: { eje: first ? { codigo: first.eje_codigo, nombre: first.eje_nombre } : { codigo, nombre: '' }, columnas: ['L. BASE', 'T1 (ENE-MAR)', 'T2 (ABR-JUN)', 'T3 (JUL-SEP)', 'T4 (OCT-DIC)', 'META 2026', 'META 2030'], acciones }, error: null });
    } catch { return error(response, 500, 'No se pudo obtener la matriz'); }
  });
  return router;
}
