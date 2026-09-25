import { Router } from 'express';
import type { Pool } from 'pg';
import { verificarRol, verificarToken } from '../middleware/auth.js';
import { createMatrizController } from '../controllers/matrizController.js';

export function createMatrizRouter(pool: Pool) {
  const router = Router();
  const controller = createMatrizController(pool);
  router.use(verificarToken, verificarRol('admin'));
  router.get('/ejes/:codigo/acciones', controller.listActions);
  router.post('/ejes/:codigo/acciones', controller.createAction);
  router.put('/acciones/:id', controller.updateAction);
  router.put('/acciones/:id/planificacion', controller.savePlanification);
  router.post('/acciones/:id/publicar', controller.publishAction);
  router.get('/acciones/:id/ficha', controller.getAction);
  return router;
}
