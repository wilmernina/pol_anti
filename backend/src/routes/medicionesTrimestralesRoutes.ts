import { Router } from 'express';
import type { Pool } from 'pg';
import { verificarRol, verificarToken } from '../middleware/auth.js';
import { createMedicionesTrimestralesController } from '../controllers/medicionesTrimestralesController.js';

export function createMedicionesTrimestralesRouter(pool: Pool) {
  const router = Router(); const controller = createMedicionesTrimestralesController(pool);
  router.get('/acciones/:id/mediciones-trimestrales', verificarToken, controller.list);
  router.put('/acciones/:id/mediciones-trimestrales', verificarToken, verificarRol('admin', 'coordinador_cpi', 'responsable_institucional'), controller.save);
  return router;
}
