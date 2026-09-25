# Matriz Trimestral Administrable Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Permitir que un administrador configure las variables de cada acción y sus cantidades programadas para T1–T4, y mostrar esa planificación en la matriz agrupada de cada eje.

**Architecture:** Se agregará una migración para completar los datos técnicos de `acciones` y crear `metas_trimestrales`. El backend expondrá CRUD administrativo protegido por JWT y una respuesta de matriz lista para renderizar. El frontend añadirá una pestaña de matriz en administración y reemplazará la tabla simple de `/eje/:codigo` por una matriz horizontal con grupos de columnas.

**Tech Stack:** PostgreSQL, Express, TypeScript, React 18, Tailwind CSS, Vitest, Supertest.

**Spec:** `docs/superpowers/specs/2026-09-25-matriz-trimestral-administrable-design.md`

## Global Constraints

- La periodicidad será trimestral: T1 (ENE-MAR), T2 (ABR-JUN), T3 (JUL-SEP), T4 (OCT-DIC).
- La Meta 2026 se calculará en servidor como T1 + T2 + T3 + T4.
- Las respuestas de API conservarán `{ success, data, error }`.
- Las mutaciones de planificación exigirán token válido y rol `admin`.
- Las cantidades no podrán ser negativas.
- Las acciones publicadas serán visibles en la matriz operativa; las de borrador solo serán visibles para administradores.
- Esta etapa no registra ejecución, evidencias, alertas ni cierre trimestral.

## Review Focus

- Una planificación parcial no debe producir una Meta 2026 incorrecta: la API debe exigir los cuatro trimestres al publicar y sumar en servidor.
- Una acción con unidad vacía o tipo de acción ausente no debe publicarse: la prueba de publicación debe recibir 422.
- Un usuario autenticado que no sea administrador no debe crear, editar ni publicar: la prueba de autorización debe recibir 403.
- Una acción de un eje no debe poder editarse desde otro eje: la API debe comprobar la relación `accion_id`/`eje_id` y devolver 404.
- La matriz debe conservar legibilidad en pantallas pequeñas: la prueba de componente debe verificar el contenedor con desplazamiento horizontal y los encabezados T1–T4.

## File Map

- Create: `database/migrations/014_matriz_trimestral.sql` — columnas técnicas y tabla trimestral.
- Create: `backend/src/controllers/matrizController.ts` — operaciones de acciones y planificación administrable.
- Create: `backend/src/routes/matrizRoutes.ts` — rutas protegidas de administración.
- Modify: `backend/src/routes/ejesRoutes.ts` — respuesta de matriz trimestral publicada.
- Modify: `backend/src/app.ts` — montaje de las rutas de matriz.
- Create: `backend/src/matriz.test.ts` — contratos, validaciones y permisos.
- Create: `frontend/src/components/admin/MatrizPlanificacion.tsx` — pantalla administrativa de selección y listado.
- Create: `frontend/src/components/admin/AccionPlanificacionModal.tsx` — formulario técnico y cantidades T1–T4.
- Create: `frontend/src/components/eje/MatrizPlanificacion.tsx` — tabla agrupada operativa.
- Create: `frontend/src/components/eje/QuarterCell.tsx` — celda trimestral de planificación.
- Modify: `frontend/src/pages/AdminPage.tsx` — nueva pestaña “Matriz”.
- Modify: `frontend/src/App.tsx` — integración de la matriz operativa y datos trimestrales.
- Create: `frontend/src/components/eje/MatrizPlanificacion.test.tsx` — renderizado, cálculo visible y responsive.

### Task 1: Crear el esquema trimestral

**Files:**
- Create: `database/migrations/014_matriz_trimestral.sql`
- Test reference: `backend/src/matriz.test.ts`

**Interfaces:**
- Produces columns `acciones.linea_base`, `acciones.tipo_accion`, `acciones.medio_verificacion`, `acciones.estado_planificacion`.
- Produces table `metas_trimestrales` with unique key `(accion_id, gestion, trimestre)`.

- [ ] **Step 1: Escribir una prueba de contrato para la estructura esperada**

En `backend/src/matriz.test.ts`, preparar un `Pool` simulado cuya consulta de migración/metadata confirme los nombres de columnas y la restricción trimestral esperada. La prueba debe verificar también que `trimestre` solo acepte 1–4 y que `cantidad_programada` no acepte valores negativos.

- [ ] **Step 2: Crear la migración SQL**

Agregar:

```sql
ALTER TABLE acciones
  ADD COLUMN IF NOT EXISTS linea_base NUMERIC,
  ADD COLUMN IF NOT EXISTS tipo_accion VARCHAR(30),
  ADD COLUMN IF NOT EXISTS medio_verificacion TEXT,
  ADD COLUMN IF NOT EXISTS estado_planificacion VARCHAR(20) NOT NULL DEFAULT 'borrador';

ALTER TABLE acciones
  ADD CONSTRAINT acciones_estado_planificacion_chk
  CHECK (estado_planificacion IN ('borrador', 'publicada'));

CREATE TABLE IF NOT EXISTS metas_trimestrales (
  id SERIAL PRIMARY KEY,
  accion_id INT NOT NULL REFERENCES acciones(id) ON DELETE CASCADE,
  gestion INT NOT NULL CHECK (gestion BETWEEN 2026 AND 2030),
  trimestre INT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
  cantidad_programada NUMERIC NOT NULL CHECK (cantidad_programada >= 0),
  cantidad_ejecutada NUMERIC NOT NULL DEFAULT 0 CHECK (cantidad_ejecutada >= 0),
  observaciones TEXT,
  UNIQUE (accion_id, gestion, trimestre)
);

CREATE INDEX IF NOT EXISTS idx_metas_trimestrales_accion
  ON metas_trimestrales(accion_id, gestion);
```

Si la base ya tiene datos, dejar `estado_planificacion` en `borrador` para que ninguna acción existente se publique accidentalmente.

- [ ] **Step 3: Ejecutar la migración y la prueba de esquema**

Ejecutar `npm.cmd run db:migrate --workspace=backend` contra la base configurada y después `npm.cmd run test --workspace=backend`. Confirmar que la migración sea idempotente al ejecutarla una segunda vez.

- [ ] **Step 4: Commit**

```bash
git add database/migrations/014_matriz_trimestral.sql backend/src/matriz.test.ts
git commit -m "feat: agregar esquema de planificacion trimestral"
```

### Task 2: Implementar API administrativa y consulta de matriz

**Files:**
- Create: `backend/src/controllers/matrizController.ts`
- Create: `backend/src/routes/matrizRoutes.ts`
- Modify: `backend/src/routes/ejesRoutes.ts`
- Modify: `backend/src/app.ts`
- Modify: `backend/src/matriz.test.ts`

**Interfaces:**
- `POST /matriz/ejes/:codigo/acciones` recibe `{ codigo, entidadId, nombre, resultado, tipoAccion, unidadMedida, lineaBase, medioVerificacion, meta2030, trimestres }`.
- `PUT /matriz/acciones/:id` recibe los mismos campos técnicos sin cambiar el eje.
- `PUT /matriz/acciones/:id/planificacion` recibe `{ gestion, trimestres: [{ trimestre, cantidadProgramada }] }`.
- `POST /matriz/acciones/:id/publicar` no recibe cuerpo y devuelve la acción publicada.
- `GET /ejes/:codigo/matriz` devuelve `{ eje, columnas, acciones }`; cada acción contiene `trimestres`, `meta2026` y `estadoPlanificacion`.

- [ ] **Step 1: Escribir pruebas fallidas para los contratos**

Agregar pruebas Supertest o de router que cubran:

```text
POST sin token -> 401
POST con rol no admin -> 403
POST con cantidades negativas -> 422
POST con código duplicado en el mismo eje -> 409
PUT de acción perteneciente a otro eje -> 404
POST publicar sin los cuatro trimestres o sin unidad -> 422
GET matriz -> devuelve T1, T2, T3, T4 y meta2026 = suma
```

- [ ] **Step 2: Crear el controlador con consultas parametrizadas**

Implementar funciones separadas `createAction`, `updateAction`, `savePlanification`, `publishAction` y `getMatrix`. Las funciones de escritura deben usar una transacción para guardar la acción y sus cuatro filas trimestrales. `getMatrix` debe agrupar los registros por acción y calcular `meta2026` en SQL con `SUM(cantidad_programada)`.

- [ ] **Step 3: Montar rutas protegidas**

En `matrizRoutes.ts`, aplicar `verificarToken` y `verificarRol('admin')` a las mutaciones. Montar el router en `app.ts` bajo `/matriz`. Mantener `GET /ejes/:codigo/matriz` como consulta autenticada para usuarios con acceso, filtrando acciones en borrador según el rol disponible.

- [ ] **Step 4: Ampliar `ejesRoutes.ts`**

Reemplazar la consulta anual de matriz por una consulta que devuelva las variables técnicas y los cuatro trimestres. No eliminar todavía compatibilidad con los campos anuales existentes; `meta_2030` seguirá proveniendo de `acciones`.

- [ ] **Step 5: Ejecutar pruebas backend y commit**

Ejecutar `npm.cmd run test --workspace=backend` y `npm.cmd run build --workspace=backend`. Confirmar respuestas 401, 403, 404, 409, 422 y 200. Después:

```bash
git add backend/src/controllers/matrizController.ts backend/src/routes/matrizRoutes.ts backend/src/routes/ejesRoutes.ts backend/src/app.ts backend/src/matriz.test.ts
git commit -m "feat: agregar api de matriz trimestral"
```

### Task 3: Crear formulario de configuración administrativa

**Files:**
- Create: `frontend/src/components/admin/MatrizPlanificacion.tsx`
- Create: `frontend/src/components/admin/AccionPlanificacionModal.tsx`
- Modify: `frontend/src/pages/AdminPage.tsx`

**Interfaces:**
- `MatrizPlanificacion` recibe instituciones, ejes y el token desde el contexto existente.
- `AccionPlanificacionModal` recibe `{ ejeCodigo, accion?, onClose, onSaved }`.
- El formulario envía `Authorization: Bearer <token>` y JSON al API de Task 2.

- [ ] **Step 1: Escribir pruebas de formulario**

Crear pruebas para:

```text
La pestaña Matriz aparece solo dentro de Administración.
Seleccionar un eje carga sus acciones.
El formulario muestra Cod., Entidad, Acción, Producto/Resultado, Tipo acción, Unidad, L. base, T1, T2, T3, T4 y Meta 2030.
Meta 2026 se actualiza como suma de los cuatro campos.
Cantidades negativas muestran error y no se envían.
Guardar muestra el error devuelto por API.
```

- [ ] **Step 2: Implementar la lista administrativa**

Agregar la pestaña `matriz` al tipo de pestañas de `AdminPage`. Mostrar selector de eje, tabla de acciones, estado de planificación y botón `Nueva acción`. El botón de edición abrirá `AccionPlanificacionModal`.

- [ ] **Step 3: Implementar el formulario**

Usar `react-hook-form` con cuatro campos numéricos controlados. Calcular Meta 2026 solo para visualización y dejar que el backend sea la fuente de verdad. Deshabilitar publicación hasta que estén completos unidad, tipo de acción y T1–T4.

- [ ] **Step 4: Probar frontend**

Ejecutar `npm.cmd run test --workspace=frontend -- MatrizPlanificacion` y corregir tipos, estados de carga, errores y cierre del modal.

- [ ] **Step 5: Commit**

```bash
git add frontend/src/components/admin/MatrizPlanificacion.tsx frontend/src/components/admin/AccionPlanificacionModal.tsx frontend/src/pages/AdminPage.tsx frontend/src/components/admin/MatrizPlanificacion.test.tsx
git commit -m "feat: agregar configuracion administrativa de matriz"
```

### Task 4: Construir la matriz operativa agrupada

**Files:**
- Create: `frontend/src/components/eje/MatrizPlanificacion.tsx`
- Create: `frontend/src/components/eje/QuarterCell.tsx`
- Modify: `frontend/src/App.tsx`
- Create: `frontend/src/components/eje/MatrizPlanificacion.test.tsx`

**Interfaces:**
- `MatrizPlanificacion` recibe `{ codigoEje, acciones, gestion }`.
- Cada acción contiene `{ codigo, entidad, nombre, resultado, tipoAccion, unidadMedida, medios, lineaBase, trimestres, meta2026, meta2030 }`.
- `QuarterCell` recibe `{ cantidadProgramada, unidadMedida, trimestre }` y no registra ejecución todavía.

- [ ] **Step 1: Escribir pruebas de renderizado**

Verificar que el componente muestre los grupos:

```text
IDENTIFICACIÓN INSTITUCIONAL
DEFINICIÓN TÉCNICA DEL INDICADOR Y TRAZABILIDAD
PROGRAMACIÓN PERIÓDICA GESTIÓN 2026 (TRIMESTRAL)
CIERRE Y METAS GLOBALES
ACCIÓN
```

También verificar encabezados `L. BASE`, `T1 (ENE-MAR)`, `T2 (ABR-JUN)`, `T3 (JUL-SEP)`, `T4 (OCT-DIC)`, `META 2026`, `META 2030` y `FICHA`.

- [ ] **Step 2: Implementar `QuarterCell`**

Mostrar cantidad y unidad, tratar cero como valor válido y usar `—` solo cuando no exista programación. La celda será de solo lectura en esta etapa.

- [ ] **Step 3: Implementar tabla agrupada**

Usar `colSpan` y `rowSpan` para reproducir los dos niveles de encabezado de la referencia. Agregar `overflow-x-auto`, anchos mínimos por columna, filas con separación visual y botón `Ficha`.

- [ ] **Step 4: Integrar en `App.tsx`**

Actualizar `EjePage` para consumir la nueva respuesta de `/api/ejes/:codigo/matriz`, mostrar únicamente acciones publicadas para usuarios no administradores y conservar loading/error. Retirar la tabla simple anterior cuando la nueva matriz esté integrada.

- [ ] **Step 5: Ejecutar pruebas, build y commit**

Ejecutar `npm.cmd run test --workspace=frontend`, `npm.cmd run build --workspace=frontend` y luego:

```bash
git add frontend/src/components/eje/MatrizPlanificacion.tsx frontend/src/components/eje/QuarterCell.tsx frontend/src/components/eje/MatrizPlanificacion.test.tsx frontend/src/App.tsx
git commit -m "feat: mostrar matriz trimestral agrupada"
```

### Task 5: Integración, migración de datos y verificación final

**Files:**
- Modify: `database/014_matriz_trimestral.sql` only if migration verification reveals a compatibility issue.
- Modify: seed files for the affected axes only if existing records require initial planning values.
- Modify: `README.md` with migration and usage commands.

**Interfaces:**
- Existing axes continue loading from their current seed data.
- New planning rows are created only through the administrator API or an explicit seed update.

- [ ] **Step 1: Ejecutar migraciones desde una base limpia y una base existente**

Run `npm.cmd run db:migrate --workspace=backend` twice in each environment. Confirm no duplicate columns, constraints or rows are created.

- [ ] **Step 2: Probar flujo completo de administración**

Create one action, save T1=10, T2=20, T3=30, T4=40, publish it, then request `/api/ejes/1/matriz` and confirm `meta2026=100` and all four cells are present.

- [ ] **Step 3: Ejecutar suite completa**

Run `npm.cmd run test`, `npm.cmd run build`, and inspect the matrix at `/eje/1` and the administration tab at `/admin` using an admin token.

- [ ] **Step 4: Actualizar documentación**

Document the quarterly fields, publication flow, required admin role and the fact that execution/evidence belong to the next phase.

- [ ] **Step 5: Commit final de integración**

```bash
git add README.md database backend frontend
git commit -m "chore: verificar matriz trimestral administrable"
```

