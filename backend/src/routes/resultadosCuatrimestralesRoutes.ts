import { Router } from 'express';
import type { Pool } from 'pg';
import { verificarToken } from '../middleware/auth.js';
import { createResultadosController } from '../controllers/resultadosCuatrimestralesController.js';
import multer from 'multer';

export function createResultadosCuatrimestralesRouter(pool: Pool) {
  const router = Router();
  const controller = createResultadosController(pool);
  const upload = multer({ dest: 'uploads/', limits: { fileSize: 10 * 1024 * 1024 } });
  router.get('/acciones/:id/cuatrimestres', controller.list);
  router.post('/acciones/:id/cuatrimestres', verificarToken, upload.array('evidencias', 5), controller.create);
  router.put('/resultados-cuatrimestrales/:id', verificarToken, upload.array('evidencias', 5), controller.update);
  router.delete('/resultados-cuatrimestrales/:id', verificarToken, controller.remove);
  return router;
}
