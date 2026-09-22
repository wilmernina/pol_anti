# Diseño: submatriz de resultados cuatrimestrales

## Objetivo

Permitir que cada acción de un eje se expanda dentro de la matriz principal y muestre los resultados registrados por gestión y cuatrimestre, con operaciones CRUD mediante un formulario modal.

## Alcance

- Tres cuatrimestres por gestión: enero-abril, mayo-agosto y septiembre-diciembre.
- La matriz anual existente (`metas_fisicas`) se conserva.
- Los resultados cuatrimestrales se almacenan en una tabla independiente vinculada a `acciones`.
- Los valores serán numéricos, con observaciones opcionales y usuario que registró el dato.

## Modelo de datos

Nueva tabla `resultados_cuatrimestrales`:

- `id` serial primary key
- `accion_id` foreign key a `acciones`
- `gestion` entero entre 2026 y 2030
- `cuatrimestre` entero entre 1 y 3
- `valor_resultado` numeric not null
- `observaciones` text
- `usuario_id` foreign key a `usuarios`
- `created_at`, `updated_at`
- unique (`accion_id`, `gestion`, `cuatrimestre`)

## API

- `GET /api/acciones/:id/cuatrimestres?gestion=2026`
- `POST /api/acciones/:id/cuatrimestres`
- `PUT /api/resultados-cuatrimestrales/:id`
- `DELETE /api/resultados-cuatrimestrales/:id`

Las mutaciones requieren JWT y roles `admin`, `coordinador_cpi`, `responsable_institucional` o `analista_vdssc`. El responsable institucional solo podrá modificar acciones de su institución.

## Interfaz

- Selector de gestión encima de la matriz.
- Botón de expansión por acción.
- Submatriz con `Cod.`, `Acción`, `1er cuatrimestre`, `2do cuatrimestre`, `3er cuatrimestre` y acciones.
- Modal reutilizable para crear y editar resultados.
- Confirmación antes de eliminar.
- Colores para registrado, pendiente y valor cero.
- Recarga local de la fila después de guardar o eliminar.
