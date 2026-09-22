# Dashboard General Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear el dashboard general con datos reales de PostgreSQL.

**Architecture:** Cuatro rutas read-only SQL alimentan un dashboard React. `App.tsx` centraliza fetch, estado y filtros; componentes presentacionales renderizan tarjetas, progreso y gráficos SVG.

**Tech Stack:** Express, pg, React 18, TypeScript, Vite, Tailwind, Vitest, Supertest.

**Spec:** `docs/superpowers/specs/2026-09-22-dashboard-design.md`

## Global Constraints

- Usar SQL parametrizado con `pg`.
- Responder JSON `{ success, data, error }`.
- Proxy `/api` hacia `http://localhost:3001`.
- Sin datos simulados ni librerías de gráficos.

## Review Focus

- Gestión fuera de 2026–2030 devuelve HTTP 400.
- Institución inexistente devuelve HTTP 400.
- Sin metas programadas, porcentaje es 0.
- Error de red muestra reintento.
- Pantalla de 320px mantiene tarjetas y tabla navegables.

### Task 1: Rutas de lectura del dashboard

**Files:** Create `backend/src/controllers/ejesController.ts`, `institucionesController.ts`, `reportesController.ts`, `backend/src/routes/ejesRoutes.ts`, `institucionesRoutes.ts`, `reportesRoutes.ts`; Modify `backend/src/app.ts`; Test `backend/src/dashboard.test.ts`.

- [ ] Escribir pruebas Supertest que esperen `{success:true}` para ejes, instituciones, dashboard y avance anual, y 400 para `gestion=2031`.
- [ ] Ejecutar `npm.cmd run test --workspace=backend` y confirmar fallo.
- [ ] Implementar consultas parametrizadas: conteo de acciones por eje; catálogo activo; agregados de metas; avance anual agrupado por eje y gestión.
- [ ] Montar routers bajo `/api` y preservar `/health`.
- [ ] Ejecutar `npm.cmd run test --workspace=backend` y confirmar aprobación.
- [ ] Commit: `git commit -m "feat: agregar datos de dashboard"`.

### Task 2: Componentes visuales y cliente API

**Files:** Create `frontend/src/components/EjeCard.tsx`, `Semaforo.tsx`, `BarraProgreso.tsx`, `GraficoAvance.tsx`, `Filtros.tsx`, `frontend/src/api/dashboard.ts`; Modify `frontend/src/App.tsx`, `frontend/src/App.test.tsx`.

- [ ] Escribir pruebas de loading, error, nueve tarjetas y tabla usando `fetch` simulado.
- [ ] Ejecutar `npm.cmd run test --workspace=frontend` y confirmar fallo.
- [ ] Implementar tipos, fetch de cuatro endpoints, semáforo, barra, gráfico de barras/SVG, filtros y diseño Tailwind responsive.
- [ ] Ejecutar `npm.cmd run test --workspace=frontend` y confirmar aprobación.
- [ ] Commit: `git commit -m "feat: crear dashboard general"`.

### Task 3: Verificación integrada

**Files:** Verify `backend/src/*`, `frontend/src/*`, `frontend/vite.config.ts`.

- [ ] Ejecutar `npm.cmd run build`.
- [ ] Ejecutar `npm.cmd run test`.
- [ ] Con backend y frontend activos, ejecutar `curl.exe http://localhost:3001/api/reportes/dashboard` y abrir `http://localhost:5173`.
- [ ] Commit final solo si hay cambios de corrección: `git commit -m "fix: validar dashboard integrado"`.
