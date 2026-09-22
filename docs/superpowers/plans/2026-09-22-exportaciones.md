# Reportes Exportables Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Descargar informes anuales, institucionales y matrices por eje.

**Architecture:** PDFKit y ExcelJS transforman consultas SQL en streams descargables; React usa file-saver.

**Tech Stack:** Express, pg, PDFKit, ExcelJS, React, file-saver.

**Spec:** `docs/superpowers/specs/2026-09-22-exportaciones-design.md`

### Task 1: Backend exportador

- [ ] Pruebas RED de parámetros inválidos y content-type de PDF/XLSX.
- [ ] Instalar PDFKit y ExcelJS; implementar controladores y rutas de exportación.
- [ ] Ejecutar pruebas y commit `feat: agregar exportaciones`.

### Task 2: Botones frontend

- [ ] Pruebas RED de descarga.
- [ ] Instalar file-saver e integrar botones de PDF, Excel e informe anual.
- [ ] Ejecutar pruebas y commit `feat: agregar descargas frontend`.

### Task 3: Verificación

- [ ] Ejecutar build, pruebas y curl de cada descarga.
