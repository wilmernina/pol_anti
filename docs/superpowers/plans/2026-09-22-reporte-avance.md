# Reporte de Avance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Registrar reportes de avance con archivos de evidencia.

**Architecture:** Express procesa multipart con multer y transacciones SQL; React Hook Form valida y publica el reporte.

**Tech Stack:** Express, pg, multer, React, react-hook-form, TypeScript.

**Spec:** `docs/superpowers/specs/2026-09-22-reporte-avance-design.md`

### Task 1: Backend de reportes

- [ ] Añadir pruebas fallidas multipart, usuario inválido y transacción.
- [ ] Instalar `multer` y tipos; implementar ruta, controlador, disco público y validación de MIME.
- [ ] Ejecutar pruebas backend y commit `feat: agregar carga de reportes`.

### Task 2: Formulario React

- [ ] Añadir prueba fallida para validaciones y éxito.
- [ ] Instalar `react-hook-form`; crear página `/reportar/:accionId` con botones borrador, enviar y cancelar.
- [ ] Ejecutar pruebas frontend y commit `feat: crear formulario de avance`.

### Task 3: Verificación

- [ ] Ejecutar `npm.cmd run build` y `npm.cmd run test`.
- [ ] Probar carga multipart contra backend local.
