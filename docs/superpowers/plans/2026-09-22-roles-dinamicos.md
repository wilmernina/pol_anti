# Roles dinámicos y administración separada Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Administrar roles desde una tabla propia y separar Usuarios, Roles y Auditoría en el portal.

**Architecture:** PostgreSQL tendrá un catálogo `roles` con roles de sistema protegidos. Express expondrá CRUD administrativo validando uso y criticidad. React mostrará tres secciones independientes con tablas y modales.

**Tech Stack:** PostgreSQL, pg, Express, JWT, bcrypt, React, TypeScript y Tailwind.

**Spec:** `docs/superpowers/specs/2026-09-22-roles-dinamicos-design.md`

## Global Constraints

- Los roles de sistema no se eliminan.
- Un rol asignado a usuarios no se puede eliminar.
- No se puede dejar el sistema sin administradores activos.
- Auditoría es solo lectura.

### Task 1: Migración de roles

**Files:**
- Create: `database/migrations/012_roles.sql`
- Create: `database/012_roles.sql`

- [ ] Crear tabla `roles`.
- [ ] Insertar los seis roles actuales como roles de sistema.
- [ ] Añadir índice de roles activos.
- [ ] Aplicar migración.

### Task 2: API CRUD de roles

**Files:**
- Modify: `backend/src/controllers/adminController.ts`
- Modify: `backend/src/routes/adminRoutes.ts`

- [ ] Listar roles con usuarios asignados.
- [ ] Crear rol personalizado.
- [ ] Editar nombre y descripción.
- [ ] Activar/desactivar rol.
- [ ] Impedir eliminar roles de sistema o roles usados.
- [ ] Registrar cambios en auditoría.

### Task 3: Interfaz separada

**Files:**
- Create: `frontend/src/components/admin/RolModal.tsx`
- Modify: `frontend/src/pages/AdminPage.tsx`

- [ ] Mantener título y sección Usuarios.
- [ ] Crear sección Roles con tabla y acciones.
- [ ] Crear modal de alta y edición de roles.
- [ ] Convertir Auditoría en sección independiente con filtros y detalle.
- [ ] Ejecutar build frontend.

### Task 4: Verificación

- [ ] Aplicar migración.
- [ ] Crear y editar un rol de prueba.
- [ ] Confirmar que no se puede eliminar un rol usado.
- [ ] Confirmar que un no administrador recibe 403.
- [ ] Verificar auditoría de cambios.
