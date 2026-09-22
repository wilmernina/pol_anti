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
      const result = await pool.query(`SELECT a.id AS accion_id,a.codigo,a.nombre,a.resultado,a.indicador_proceso,a.meta_2030,i.siglas AS institucion,
        json_agg(json_build_object('id',m.id,'gestion',m.gestion,'programado',m.valor_programado,'ejecutado',m.valor_ejecutado,'avance',m.porcentaje_avance) ORDER BY m.gestion) AS metas
        FROM ejes e JOIN acciones a ON a.eje_id=e.id LEFT JOIN instituciones i ON i.id=a.institucion_principal_id LEFT JOIN metas_fisicas m ON m.accion_id=a.id
        WHERE e.codigo=$1 GROUP BY a.id,i.siglas ORDER BY a.orden`, [codigo]);
      if (!result.rows.length) { const exists=await pool.query('SELECT 1 FROM ejes WHERE codigo=$1',[codigo]); if(!exists.rows.length) return error(response,404,'Eje no encontrado'); }
      return response.json({ success: true, data: result.rows, error: null });
    } catch { return error(response, 500, 'No se pudo obtener la matriz'); }
  });
  return router;
}
