import { Router } from 'express';
import type { Pool } from 'pg';
import { verificarRol, verificarToken } from '../middleware/auth.js';
import { createAdminController } from '../controllers/adminController.js';

export function createAdminRouter(pool: Pool) {
  const router = Router(); const controller = createAdminController(pool);
  router.use(verificarToken, verificarRol('admin'));
  router.get('/usuarios', controller.listUsers); router.post('/usuarios', controller.createUser); router.put('/usuarios/:id', controller.updateUser); router.patch('/usuarios/:id/estado', controller.changeStatus); router.patch('/usuarios/:id/password', controller.changePassword); router.get('/roles', controller.listRoles); router.post('/roles', controller.createRole); router.put('/roles/:id', controller.updateRole); router.patch('/roles/:id/estado', controller.changeRoleStatus); router.get('/auditoria', controller.audit); router.get('/instituciones', controller.institutions);
  return router;
}
