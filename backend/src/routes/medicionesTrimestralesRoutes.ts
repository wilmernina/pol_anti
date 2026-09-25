import { Router } from 'express';
import type { Pool } from 'pg';
import { verificarRol, verificarToken } from '../middleware/auth.js';
import { createMedicionesTrimestralesController } from '../controllers/medicionesTrimestralesController.js';
import multer from 'multer';

export function createMedicionesTrimestralesRouter(pool: Pool) {
  const router = Router(); const controller = createMedicionesTrimestralesController(pool); const upload = multer({ dest: 'uploads/', limits: { fileSize: 10 * 1024 * 1024 } });
  router.get('/acciones/:id/mediciones-trimestrales', verificarToken, controller.list);
  router.put('/acciones/:id/mediciones-trimestrales', verificarToken, verificarRol('admin', 'coordinador_cpi', 'responsable_institucional'), upload.array('evidencias', 5), controller.save);
  return router;
}
