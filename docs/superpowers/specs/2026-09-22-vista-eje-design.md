# Diseño de vista por eje

La ruta React `/eje/:codigo` muestra la ficha Cuadro A, matriz Cuadro B y resumen calculado del eje. Consume `GET /api/ejes/:codigo`, `/resumen`, `/matriz` y `/api/acciones/:codigo/avance` mediante SQL parametrizado.

`FichaEje` muestra objetivo, indicadores y resultados separados por `;`. `MatrizAcciones` presenta años 2026–2030; `CeldaMeta` muestra programado/ejecutado y color por porcentaje. `FilaAccion` expande `DetalleAccion`, que muestra reportes, evidencias y observaciones. Los datos inexistentes se muestran como `—`.

La exportación crea CSV UTF-8 descargable, compatible con Excel. El botón de reporte se presenta deshabilitado hasta la Parte 17. La vista es responsive y se prueba con Eje 1, respuesta 404 y estado loading/error.
