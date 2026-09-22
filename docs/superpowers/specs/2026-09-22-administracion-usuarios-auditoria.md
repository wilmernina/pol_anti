# Diseño: administración de usuarios, roles y auditoría

## Objetivo

Incorporar un módulo institucional de administración para gestionar usuarios, asignar roles fijos, activar o desactivar cuentas y consultar la auditoría del sistema.

## Roles fijos

`admin`, `coordinador_cpi`, `responsable_institucional`, `analista_vdssc`, `observador` y `publico`.

Los roles no se eliminan dinámicamente porque están asociados a reglas de autorización del backend. La administración permite consultarlos y asignarlos a usuarios.

## API protegida

- `GET /admin/usuarios`: lista con búsqueda, rol, institución y estado.
- `POST /admin/usuarios`: crea usuario con contraseña hasheada.
- `PUT /admin/usuarios/:id`: actualiza perfil, institución y rol.
- `PATCH /admin/usuarios/:id/estado`: activa o desactiva una cuenta.
- `PATCH /admin/usuarios/:id/password`: cambia contraseña.
- `GET /admin/roles`: catálogo de roles y descripción.
- `GET /admin/auditoria`: lista filtrable de eventos.

Todos requieren JWT y rol `admin`.

## Auditoría

Registrar INSERT, UPDATE y cambios de estado de usuarios con usuario ejecutor, registro afectado, datos anteriores, datos nuevos y fecha. Las contraseñas nunca se almacenan en auditoría.

## Interfaz

- Entrada “Administración” visible solo para administradores.
- Pestañas Usuarios, Roles y Auditoría.
- Tabla responsive con búsqueda y filtros.
- Modal de alta y edición.
- Acciones de estado con confirmación.
- Consulta de detalle de auditoría en modal.
