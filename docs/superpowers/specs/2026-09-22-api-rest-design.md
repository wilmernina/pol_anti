# Diseño de la API REST

## Objetivo

Exponer los ejes, acciones, metas, instituciones y agregados de avance de la Política Antidroga 2026-2030 mediante una API JSON para los futuros dashboard, vistas por eje y formularios de reporte.

## Límites de esta parte

Se crean rutas HTTP, controladores SQL directos, validación de entradas y autenticación temporal para actualizar metas. La generación real de Excel y PDF queda para la Parte 18.

## Estructura

```text
backend/src/
├── controllers/
│   ├── accionesController.ts
│   ├── ejesController.ts
│   ├── institucionesController.ts
│   ├── metasController.ts
│   └── reportesController.ts
├── middleware/
│   └── requireUser.ts
├── routes/
│   ├── accionesRoutes.ts
│   ├── ejesRoutes.ts
│   ├── institucionesRoutes.ts
│   ├── metasRoutes.ts
│   └── reportesRoutes.ts
└── app.ts
```

Cada archivo de rutas recibe un `Pool` de PostgreSQL y delega a controladores que ejecutan consultas SQL parametrizadas. `app.ts` monta los routers bajo `/api`.

## Contrato común

Las respuestas siguen la forma:

```json
{ "success": true, "data": {}, "error": null }
```

Los errores de entrada usan HTTP 400; recursos inexistentes usan 404; falta de `x-user-id` o usuario inactivo usa 401; errores inesperados usan 500.

## Endpoints

| Recurso | Rutas |
| --- | --- |
| Ejes | `GET /api/ejes`, `GET /api/ejes/:codigo`, `GET /api/ejes/:codigo/resumen`, `GET /api/ejes/:codigo/matriz` |
| Acciones | `GET /api/acciones?eje=&institucion=`, `GET /api/acciones/:codigo`, `GET /api/acciones/:codigo/avance` |
| Metas | `PUT /api/metas/:id`, `POST /api/metas/:id/reporte` |
| Instituciones | `GET /api/instituciones` |
| Reportes | `GET /api/reportes/dashboard`, `GET /api/reportes/avance-anual`, `GET /api/reportes/exportar/:eje` |

`GET /api/ejes/:codigo` devuelve el eje, las acciones ordenadas y las cinco metas por acción. `/resumen` contiene la ficha del Cuadro A; `/matriz` contiene las filas del Cuadro B con metas por gestión.

El listado de acciones admite `eje` de `1` a `9` y `institucion` como sigla de institución. El código de acción se resuelve de forma única contra su eje prefijado.

## Mutaciones y autenticación temporal

`PUT /api/metas/:id` acepta `{ "valor_ejecutado": number, "observaciones"?: string }`. Requiere el encabezado `x-user-id`, que debe referirse a un usuario activo.

`POST /api/metas/:id/reporte` acepta `{ "valor_reportado": number, "justificacion"?: string }`, crea un reporte con estado `enviado` y actualiza la meta dentro de una transacción. El mismo encabezado identifica al usuario que reporta. La Parte 17 sustituirá este mecanismo por JWT.

## Agregados y exportación

`dashboard` entrega conteos globales, avance promedio por eje y metas programadas/ejecutadas. `avance-anual` acepta opcionalmente `gestion` entre 2026 y 2030 y agrega por eje. `exportar/:eje` devuelve un objeto tabular del eje solicitado, listo para que la Parte 18 lo convierta a Excel o PDF.

## Pruebas

Se añadirán pruebas Supertest con un `Pool` simulado para comprobar: contrato de respuesta, parámetros inválidos, recurso inexistente, validación temporal de usuario y actualización transaccional de metas. Las pruebas existentes de `/health` deben mantenerse.
