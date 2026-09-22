# Parte 1: Setup del proyecto y PostgreSQL

## Objetivo

Preparar una base ejecutable para el Sistema de Seguimiento y Monitoreo de la Política Antidroga 2026-2030, conectada a PostgreSQL local. Esta parte no crea tablas de negocio ni carga información del Capítulo IV.

## Alcance aprobado

- Monorepo con `npm workspaces` y los paquetes `backend` y `frontend`.
- Backend Node.js, Express, TypeScript y `pg`, con `GET /health` para comprobar la conectividad.
- Frontend React, TypeScript, Vite y Tailwind CSS, con una pantalla de estado que consulta el backend.
- Scripts para crear `politica_antidroga` y aplicar migraciones SQL ordenadas.
- Una migración inicial que crea el control técnico de migraciones. Las tablas `ejes`, `acciones`, `metas_fisicas`, `instituciones`, `presupuesto`, `usuarios`, `reportes_avance` y `evidencias` pertenecen a la Parte 2.

## Arquitectura

La raíz administra dependencias y comandos mediante npm workspaces. El backend toma su conexión desde variables de entorno, abre conexiones con `pg.Pool` y no contiene credenciales en código. El frontend se ejecuta con Vite y usa un proxy local para llamar a `/api/health` sin fijar una URL de backend en el navegador.

Las migraciones viven en `database/migrations` y se aplican por orden alfabético. Un ejecutor registra cada archivo aplicado en la tabla técnica `schema_migrations`, para que una migración no se ejecute dos veces.

## Seguridad y configuración

- El archivo `.env` es local, está ignorado por Git y contiene la conexión de desarrollo.
- `.env.example` expone nombres de variables y valores seguros de ejemplo, sin contraseña real.
- `db:create` se conecta primero a la base administrativa `postgres` y crea `politica_antidroga` solo si no existe.

## Comportamiento esperado

1. `npm install` instala las dependencias de los dos paquetes.
2. `npm run db:create` deja disponible la base `politica_antidroga`.
3. `npm run db:migrate` aplica `001_init.sql` una única vez.
4. `npm run dev` inicia backend y frontend.
5. `GET /health` responde `200` y un estado de PostgreSQL cuando la base es accesible; responde `503` con un mensaje seguro si no lo es.

## Validación

- Comprobar la sintaxis TypeScript y la compilación de ambos paquetes.
- Ejecutar la creación de base y la migración dos veces; la segunda migración no debe repetir cambios.
- Consultar `http://localhost:3000/health` y verificar que el frontend muestra el estado del backend.
