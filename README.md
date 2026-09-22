# Sistema de Seguimiento y Monitoreo

Sistema web para la Política Antidroga 2026-2030 de Bolivia.

## Requisitos

- Node.js 20 o superior
- PostgreSQL disponible en `localhost:5432`

## Configuración local

```powershell
Copy-Item backend/.env.example backend/.env
npm install
npm run db:create
npm run db:migrate
npm run dev
```

Edita `backend/.env` con la contraseña local de PostgreSQL. La aplicación se abre en `http://localhost:5173` y la sonda del backend está en `http://localhost:3001/health`.
