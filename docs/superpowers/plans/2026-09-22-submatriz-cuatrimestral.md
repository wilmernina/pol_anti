# Submatriz cuatrimestral Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Agregar resultados cuatrimestrales por acción, gestión y cuatrimestre con expansión de filas y CRUD modal.

**Architecture:** Una migración SQL independiente crea `resultados_cuatrimestrales`. Express expone consultas y mutaciones protegidas por JWT. React mantiene la matriz anual y carga la submatriz bajo demanda por fila.

**Tech Stack:** PostgreSQL, SQL directo con `pg`, Express, JWT, React, TypeScript, Tailwind y react-hook-form.

**Spec:** `docs/superpowers/specs/2026-09-22-submatriz-cuatrimestral-design.md`

## Global Constraints

- Tres cuatrimestres por gestión: 1 enero-abril, 2 mayo-agosto, 3 septiembre-diciembre.
- No modificar ni duplicar las metas anuales existentes.
- Las mutaciones requieren JWT y validan institución para responsables institucionales.
- Una acción solo puede tener un resultado por gestión y cuatrimestre.

## Review Focus

- Gestión fuera de 2026–2030: debe rechazarse.
- Cuatrimestre fuera de 1–3: debe rechazarse.
- Duplicado acción/gestión/cuatrimestre: debe devolver conflicto.
- Responsable de otra institución: debe recibir 403.
- Fila sin resultados: debe mostrar estado pendiente y permitir crear.

### Task 1: Migración y consultas base

**Files:**
- Create: `database/010_resultados_cuatrimestrales.sql`

- [ ] Crear tabla, claves foráneas, restricciones y único compuesto.
- [ ] Crear índices para acción y gestión.
- [ ] Aplicar migración con `psql`.
- [ ] Verificar estructura con `\d resultados_cuatrimestrales`.

### Task 2: API CRUD

**Files:**
- Modify: `backend/src/routes/reportesRoutes.ts`
- Create: `backend/src/controllers/resultadosCuatrimestralesController.ts`

- [ ] Implementar GET filtrado por acción y gestión.
- [ ] Implementar POST, PUT y DELETE con transacciones cuando corresponda.
- [ ] Añadir validación de gestión, cuatrimestre, valor y permisos.
- [ ] Responder con `{ success, data, error }`.
- [ ] Ejecutar build backend y probar endpoints con curl.

### Task 3: Componentes de submatriz

**Files:**
- Create: `frontend/src/components/eje/SubmatrizCuatrimestral.tsx`
- Create: `frontend/src/components/eje/ResultadoModal.tsx`
- Modify: `frontend/src/App.tsx`

- [ ] Añadir selector de gestión.
- [ ] Expandir una acción y cargar resultados bajo demanda.
- [ ] Mostrar columnas de los tres cuatrimestres y estado pendiente/registrado.
- [ ] Crear modal con react-hook-form para alta y edición.
- [ ] Añadir confirmación y eliminación.
- [ ] Ejecutar build frontend y probar flujo manual en `/eje/1`.

### Task 4: Verificación integrada

- [ ] Levantar backend y frontend.
- [ ] Iniciar sesión con usuario autorizado.
- [ ] Registrar, editar y eliminar un resultado.
- [ ] Confirmar que el responsable de otra institución no puede modificarlo.
- [ ] Documentar comandos de prueba y resultado.
