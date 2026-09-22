# Administración de usuarios y auditoría Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Crear un módulo administrativo seguro para gestionar usuarios, asignar roles fijos y consultar la auditoría.

**Architecture:** Express expondrá endpoints protegidos exclusivamente para administradores. Las operaciones escribirán eventos en `auditoria` sin incluir contraseñas. React añadirá una vista de administración con pestañas y modales.

**Tech Stack:** PostgreSQL, pg, Express, bcrypt, JWT, React, TypeScript, Tailwind y react-hook-form.

**Spec:** `docs/superpowers/specs/2026-09-22-administracion-usuarios-auditoria.md`

## Global Constraints

- Roles fijos: `admin`, `coordinador_cpi`, `responsable_institucional`, `analista_vdssc`, `observador`, `publico`.
- Todas las rutas administrativas requieren JWT y rol `admin`.
- Nunca registrar contraseñas en auditoría.
- Un administrador no puede desactivarse a sí mismo.

## Review Focus

- Username duplicado: debe devolver conflicto.
- Institución inexistente: debe rechazarse.
- Rol fuera del catálogo: debe rechazarse.
- Desactivación del usuario actual: debe rechazarse.
- Auditoría de cambio de contraseña: no debe contener hash ni contraseña.

### Task 1: Backend de usuarios, roles y auditoría

**Files:**
- Create: `backend/src/routes/adminRoutes.ts`
- Create: `backend/src/controllers/adminController.ts`
- Modify: `backend/src/app.ts`

- [ ] Implementar listado con filtros.
- [ ] Implementar creación con bcrypt.
- [ ] Implementar edición y cambio de contraseña.
- [ ] Implementar activar/desactivar con protección de autodesactivación.
- [ ] Implementar catálogo de roles.
- [ ] Implementar consulta de auditoría.
- [ ] Registrar eventos sin contraseñas.
- [ ] Ejecutar build y probar endpoints.

### Task 2: Interfaz de administración

**Files:**
- Create: `frontend/src/pages/AdminPage.tsx`
- Create: `frontend/src/components/admin/UsuarioModal.tsx`
- Modify: `frontend/src/App.tsx`

- [ ] Añadir ruta `/admin` protegida por rol.
- [ ] Crear pestaña Usuarios con búsqueda y filtros.
- [ ] Crear modal de alta y edición.
- [ ] Añadir acciones de activar/desactivar y contraseña.
- [ ] Crear pestaña Roles.
- [ ] Crear pestaña Auditoría.
- [ ] Mostrar mensajes de éxito y error.
- [ ] Ejecutar build frontend.

### Task 3: Verificación integrada

- [ ] Probar acceso admin.
- [ ] Confirmar que un usuario no admin recibe 403.
- [ ] Crear, editar y desactivar usuario de prueba.
- [ ] Verificar evento en auditoría.
- [ ] Confirmar que la contraseña no aparece en auditoría.
