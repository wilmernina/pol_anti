# Diseño de matriz trimestral administrable

## Objetivo

Construir inicialmente la matriz de planificación de los ejes y acciones con periodicidad trimestral. El administrador podrá registrar las variables técnicas de cada acción y definir la cantidad programada para T1, T2, T3 y T4. La matriz será la base para una segunda etapa de seguimiento de ejecución, evidencias y validación.

## Alcance de la primera etapa

Incluye:

- Configuración administrativa de ejes y acciones.
- Variables institucionales y técnicas de la matriz.
- Programación trimestral para la gestión 2026.
- Cálculo automático de la Meta 2026 como suma de T1 a T4.
- Visualización de la matriz con encabezados agrupados como la referencia.
- Guardado de borradores y publicación de la planificación.
- Validaciones de datos y auditoría básica de cambios.

No incluye todavía:

- Registro de cantidades ejecutadas.
- Carga de evidencias.
- Alertas de desviación por ejecución.
- Cierre o aprobación de trimestre.
- Exportaciones Excel/PDF.

## Estructura visible de la matriz

La tabla conservará estas agrupaciones y etiquetas:

1. **Identificación institucional**: Cod., Entidad, Acción a corto plazo.
2. **Definición técnica del indicador y trazabilidad**: Producto/Resultado, Tipo acción, Unidad, Medios.
3. **Programación periódica gestión 2026 (trimestral)**: L. base, T1 (ENE-MAR), T2 (ABR-JUN), T3 (JUL-SEP), T4 (OCT-DIC).
4. **Cierre y metas globales**: Meta 2026, Meta 2030.
5. **Acción**: Ficha.

Cada celda trimestral mostrará inicialmente la cantidad programada y su unidad. Las cantidades ejecutadas y los estados visuales se incorporarán en la siguiente etapa sin cambiar la estructura principal de la matriz.

## Modelo de datos

La tabla `acciones` incorporará los datos técnicos que faltan:

- `linea_base NUMERIC`.
- `tipo_accion VARCHAR(30)`.
- `medio_verificacion TEXT`.
- `estado_planificacion VARCHAR(20)` con valores `borrador` y `publicada`.

Se creará `metas_trimestrales` con:

- `id`.
- `accion_id`.
- `gestion` entre 2026 y 2030.
- `trimestre` entre 1 y 4.
- `cantidad_programada NUMERIC NOT NULL`.
- `cantidad_ejecutada NUMERIC NOT NULL DEFAULT 0` como preparación para la segunda etapa.
- `observaciones TEXT`.
- Restricción única por `accion_id`, `gestion` y `trimestre`.

La Meta 2026 se calculará con la suma de las cuatro cantidades programadas. La Meta 2030 permanecerá como el valor global de la acción. No se duplicará la meta anual en cada trimestre.

## Pantallas y flujo

### Administración de matriz

Se agregará una vista administrativa para:

1. Seleccionar el eje.
2. Crear o editar una acción.
3. Completar sus variables institucionales y técnicas.
4. Registrar T1, T2, T3 y T4.
5. Visualizar la Meta 2026 calculada.
6. Guardar como borrador.
7. Publicar la planificación.

Las acciones publicadas serán visibles en la matriz operativa. Las acciones en borrador solo serán visibles para usuarios con permisos administrativos.

### Matriz operativa

La vista existente `/eje/:codigo` se reorganizará para mostrar la tabla agrupada. La acción “Ficha” abrirá el detalle de la acción y, en esta etapa, permitirá consultar la planificación registrada. El registro de ejecución se habilitará posteriormente.

## API

Se implementarán o ampliarán las siguientes operaciones:

- `GET /api/ejes/:codigo/matriz` para devolver la matriz trimestral.
- `POST /api/ejes/:codigo/acciones` para crear una acción.
- `PUT /api/acciones/:id` para editar los datos técnicos.
- `PUT /api/acciones/:id/planificacion` para guardar los cuatro trimestres.
- `POST /api/acciones/:id/publicar` para publicar la planificación.
- `GET /api/acciones/:id/ficha` para consultar el detalle.

Todas las respuestas conservarán el formato `{ success, data, error }`. Las mutaciones exigirán autenticación y permisos de administrador.

## Validaciones

- El código de acción será único dentro de su eje.
- La unidad de medida será obligatoria.
- Las cantidades no podrán ser negativas.
- El trimestre solo podrá ser 1, 2, 3 o 4.
- La Meta 2026 se calculará en servidor para evitar inconsistencias.
- Una acción no podrá publicarse si le falta unidad, tipo de acción o planificación trimestral.
- Los cambios administrativos se registrarán en auditoría.

## Componentes previstos

- `MatrizPlanificacion`.
- `MatrizGroupHeader`.
- `MatrizRow`.
- `QuarterCell`.
- `AccionFichaModal`.
- `PlanificacionAccionForm`.
- `AdminMatrizPage`.

Se conservarán y adaptarán `FichaEje`, `CeldaMeta` y la lógica existente de `EjePage` cuando sea conveniente.

## Pruebas

Backend:

- Crear acción con planificación válida.
- Rechazar cantidades negativas.
- Rechazar trimestre inválido.
- Calcular correctamente Meta 2026.
- Impedir publicación de acción incompleta.
- Restringir mutaciones a administradores.

Frontend:

- Renderizar los cinco grupos de columnas.
- Mostrar T1–T4 y Meta 2026 calculada.
- Editar y guardar una planificación.
- Mostrar errores de validación.
- Diferenciar borrador y publicada.
- Mantener desplazamiento horizontal en pantallas pequeñas.

