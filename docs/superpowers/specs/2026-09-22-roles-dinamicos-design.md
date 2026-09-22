# Diseño: roles dinámicos y administración separada

## Objetivo

Separar claramente las secciones Usuarios, Roles y Auditoría, y permitir administrar roles desde una tabla propia sin romper la autorización existente.

## Modelo

Nueva tabla `roles`:

- `id` serial primary key
- `codigo` varchar unique
- `nombre` text
- `descripcion` text
- `activo` boolean
- `sistema` boolean
- `created_at`, `updated_at`

Los seis roles actuales se migran como roles de sistema. La tabla `usuarios` conservará temporalmente el campo `rol` para compatibilidad, y las operaciones administrativas validarán contra `roles` activos.

## Reglas

- Los roles de sistema no se eliminan.
- Un rol usado por usuarios no se puede eliminar; solo desactivar si no es crítico.
- No se puede desactivar `admin` si dejaría el sistema sin administradores activos.
- La auditoría es de solo lectura y registra cambios de roles y usuarios.

## Interfaz

- Secciones independientes con títulos: Usuarios, Roles y Auditoría.
- Roles: listado, agregar, editar, activar/desactivar.
- Auditoría: filtros por usuario, acción, tabla y fecha, con detalle en modal.
