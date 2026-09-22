# Diseño del dashboard general

## Objetivo

Mostrar el avance de los nueve ejes de la Política Antidroga 2026-2030 con datos reales de PostgreSQL, filtros de gestión e institución y estados de carga o error.

## Integración

Vite mantiene el proxy `/api` hacia `http://localhost:3001`. Se implementan primero cuatro rutas de lectura: `/api/ejes`, `/api/instituciones`, `/api/reportes/dashboard` y `/api/reportes/avance-anual`.

## Interfaz

`App.tsx` obtiene datos con `fetch`, controla loading/error y combina los filtros con la tabla y las tarjetas. Los componentes son `EjeCard`, `Semaforo`, `BarraProgreso`, `GraficoAvance` y `Filtros`.

Cada tarjeta muestra nombre, número de acciones, resultado 2030 resumido, porcentaje y semáforo. Verde corresponde a 70% o más, amarillo a 40%–69.99% y rojo a menos de 40%. El gráfico de barras compara ejes; el SVG nativo de línea muestra la tendencia anual. La interfaz es mobile-first con Tailwind.

## Contrato de datos

Dashboard devuelve por eje código, nombre, acciones, meta programada, ejecutado y porcentaje. Avance anual devuelve gestión y avance agregado por eje. Instituciones devuelve sigla y nombre para el filtro.

## Validación

Las rutas validan gestión de 2026 a 2030 e institución existente. El frontend muestra el error de la API y permite reintentar. Las pruebas cubren las rutas de lectura y los estados loading/error/datos del dashboard.
