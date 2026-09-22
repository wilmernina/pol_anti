# Parte 1: Setup del proyecto y PostgreSQL Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Crear un monorepo ejecutable con React, Express y PostgreSQL para iniciar el sistema de seguimiento de la Política Antidroga 2026-2030.

**Architecture:** npm workspaces administra `backend` y `frontend`. El backend Express usa `pg.Pool`, expone una sonda de salud y recibe su configuración por entorno. Un script de migración SQL registra los archivos aplicados en PostgreSQL; el frontend Vite consume la sonda mediante proxy local.

**Tech Stack:** Node.js 20+, npm workspaces, Express, TypeScript, pg, React, Vite, Tailwind CSS y PostgreSQL 16+.

**Spec:** `docs/superpowers/specs/2026-09-22-parte-1-setup-design.md`

## Global Constraints

- Usar consultas SQL directas con `pg`; no incorporar ORM.
- Usar PostgreSQL en `localhost:5432`, base `politica_antidroga` y usuario `postgres`.
- No versionar credenciales ni archivos `.env`.
- Mantener migraciones SQL numeradas dentro de `database/migrations`.
- No crear tablas de dominio antes de la Parte 2.

## Review Focus

- Base `politica_antidroga` existente: `db:create` finaliza sin error y no intenta recrearla.
- Migración ya aplicada: `db:migrate` omite `001_init.sql` y conserva el historial.
- PostgreSQL no disponible: `/health` devuelve HTTP 503 sin revelar credenciales.
- Variable requerida ausente: el backend detiene el arranque con el nombre de variable faltante.
- Fallo de red al consultar salud: el frontend muestra un estado de conexión comprensible.

---

### Task 1: Raíz del monorepo y configuración común

**Files:**
- Create: `package.json`
- Create: `.gitignore`
- Create: `.env.example`
- Create: `README.md`

**Interfaces:**
- Produces: workspaces npm `backend` y `frontend`; scripts raíz `dev`, `build`, `db:create` y `db:migrate`.

- [ ] **Step 1: Crear el manifiesto raíz**

```json
{
  "private": true,
  "workspaces": ["backend", "frontend"],
  "scripts": {
    "dev": "concurrently \"npm run dev --workspace=backend\" \"npm run dev --workspace=frontend\"",
    "build": "npm run build --workspace=backend && npm run build --workspace=frontend",
    "db:create": "npm run db:create --workspace=backend",
    "db:migrate": "npm run db:migrate --workspace=backend"
  }
}
```

- [ ] **Step 2: Crear reglas de seguridad y ejemplo de entorno**

```dotenv
DB_HOST=localhost
DB_PORT=5432
DB_NAME=politica_antidroga
DB_USER=postgres
DB_PASSWORD=change_me
API_PORT=3001
```

Incluir `.env`, `node_modules`, `dist` y archivos de cobertura en `.gitignore`.

- [ ] **Step 3: Documentar la puesta en marcha**

Documentar la copia de `.env.example` a `backend/.env`, instalación, creación de base, migración y arranque.

- [ ] **Step 4: Instalar dependencias raíz y verificar scripts**

Run: `npm install`

Expected: se genera `package-lock.json` y npm reconoce ambos workspaces.

- [ ] **Step 5: Commit**

```powershell
git add package.json package-lock.json .gitignore .env.example README.md
git commit -m "chore: initialize workspace configuration"
```

### Task 2: Backend, configuración y sonda de salud

**Files:**
- Create: `backend/package.json`
- Create: `backend/tsconfig.json`
- Create: `backend/src/config/env.ts`
- Create: `backend/src/db/pool.ts`
- Create: `backend/src/app.ts`
- Create: `backend/src/server.ts`
- Create: `backend/src/scripts/createDatabase.ts`
- Create: `backend/src/scripts/migrate.ts`
- Create: `backend/.env.example`
- Test: `backend/src/app.test.ts`

**Interfaces:**
- Consumes: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` y `API_PORT` del entorno.
- Produces: `createApp(pool: Pool): Express`, `pool: Pool`, y scripts `db:create` y `db:migrate`.

- [ ] **Step 1: Escribir la prueba de salud**

```ts
it('returns PostgreSQL status when SELECT 1 succeeds', async () => {
  const query = vi.fn().mockResolvedValue({ rows: [{ ok: 1 }] });
  const response = await request(createApp({ query } as unknown as Pool)).get('/health');
  expect(response.status).toBe(200);
  expect(response.body).toEqual({ status: 'ok', database: 'connected' });
});
```

- [ ] **Step 2: Ejecutar la prueba para comprobar el fallo inicial**

Run: `npm run test --workspace=backend`

Expected: FAIL porque `createApp` aún no existe.

- [ ] **Step 3: Implementar configuración, pool y aplicación**

```ts
app.get('/health', async (_request, response) => {
  try {
    await pool.query('SELECT 1');
    response.status(200).json({ status: 'ok', database: 'connected' });
  } catch {
    response.status(503).json({ status: 'degraded', database: 'unavailable' });
  }
});
```

Validar las cinco variables de conexión y convertir `DB_PORT` y `API_PORT` a enteros positivos antes de iniciar el servidor.

- [ ] **Step 4: Implementar creación de base y ejecutor de migraciones**

`createDatabase.ts` consulta `pg_database` con `SELECT 1 FROM pg_database WHERE datname = $1`; si no hay resultado ejecuta `CREATE DATABASE politica_antidroga`. `migrate.ts` crea `schema_migrations(filename text primary key, applied_at timestamptz not null default now())`, lee `database/migrations/*.sql`, ejecuta cada archivo pendiente dentro de una transacción y registra su nombre.

- [ ] **Step 5: Ejecutar pruebas de backend**

Run: `npm run test --workspace=backend`

Expected: PASS, incluyendo el caso de respuesta 503 cuando `pool.query` rechaza.

- [ ] **Step 6: Commit**

```powershell
git add backend
git commit -m "feat: add database health backend"
```

### Task 3: Migración inicial SQL

**Files:**
- Create: `database/migrations/001_init.sql`

**Interfaces:**
- Consumes: ejecutor `backend/src/scripts/migrate.ts`.
- Produces: una migración segura y vacía de tablas de dominio para la Parte 1.

- [ ] **Step 1: Crear la migración**

```sql
-- Infraestructura inicial. Las tablas de negocio se crean en la Parte 2.
SELECT 1;
```

- [ ] **Step 2: Crear la base y aplicar migraciones**

Run: `npm run db:create && npm run db:migrate && npm run db:migrate`

Expected: la base existe y el segundo comando de migración informa que `001_init.sql` ya fue aplicada.

- [ ] **Step 3: Verificar el historial de migraciones**

Run: `psql -h localhost -p 5432 -U postgres -d politica_antidroga -c "SELECT filename FROM schema_migrations"`

Expected: una fila con `001_init.sql`.

- [ ] **Step 4: Commit**

```powershell
git add database/migrations/001_init.sql
git commit -m "chore: add initial SQL migration"
```

### Task 4: Frontend de estado

**Files:**
- Create: `frontend/package.json`
- Create: `frontend/tsconfig.json`
- Create: `frontend/vite.config.ts`
- Create: `frontend/tailwind.config.ts`
- Create: `frontend/postcss.config.cjs`
- Create: `frontend/index.html`
- Create: `frontend/src/main.tsx`
- Create: `frontend/src/App.tsx`
- Create: `frontend/src/index.css`
- Test: `frontend/src/App.test.tsx`

**Interfaces:**
- Consumes: `GET /api/health`, redirigido por Vite a `http://localhost:3001/health`.
- Produces: página de inicio que muestra conexión disponible, no disponible o cargando.

- [ ] **Step 1: Escribir la prueba del estado disponible**

```tsx
it('shows the connection status returned by the API', async () => {
  vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ ok: true, json: async () => ({ status: 'ok', database: 'connected' }) }));
  render(<App />);
  expect(await screen.findByText('PostgreSQL conectado')).toBeInTheDocument();
});
```

- [ ] **Step 2: Ejecutar la prueba para comprobar el fallo inicial**

Run: `npm run test --workspace=frontend`

Expected: FAIL porque `App` aún no existe.

- [ ] **Step 3: Implementar la interfaz y Tailwind**

`App.tsx` consulta `/api/health` al montarse. Ante `status: ok` muestra `PostgreSQL conectado`; ante error HTTP, error de red o cuerpo inválido muestra `No se pudo conectar con el backend`. Configurar el proxy `/api` en Vite.

- [ ] **Step 4: Ejecutar pruebas y compilación**

Run: `npm run test --workspace=frontend && npm run build`

Expected: PASS y los directorios `backend/dist` y `frontend/dist` se generan sin errores TypeScript.

- [ ] **Step 5: Commit**

```powershell
git add frontend
git commit -m "feat: add monitoring status frontend"
```

### Task 5: Verificación integrada y entrega

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: scripts raíz y `GET /health`.
- Produces: instrucciones verificadas para iniciar y probar la Parte 1.

- [ ] **Step 1: Arrancar ambos servicios**

Run: `npm run dev`

Expected: backend en `http://localhost:3001` y frontend en `http://localhost:5173`.

- [ ] **Step 2: Comprobar la sonda real**

Run: `Invoke-WebRequest -UseBasicParsing http://localhost:3001/health | Select-Object -ExpandProperty Content`

Expected: `{"status":"ok","database":"connected"}`.

- [ ] **Step 3: Actualizar README con resultados y comandos**

Incluir los comandos de instalación, configuración, creación de base, migración, arranque y la URL de la sonda.

- [ ] **Step 4: Confirmar estado de Git**

Run: `git status --short`

Expected: no hay archivos de credenciales ni cambios sin registrar.

- [ ] **Step 5: Commit**

```powershell
git add README.md
git commit -m "docs: document local project setup"
```
