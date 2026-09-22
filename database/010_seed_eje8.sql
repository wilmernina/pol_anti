BEGIN;

INSERT INTO ejes (codigo,nombre,objetivo,indicadores_principales,resultados_2030)
VALUES (
  '8',
  'Fortalecimiento Institucional, Justicia e Integridad',
  'Fortalecer la institucionalidad estatal encargada de la política antidroga, la seguridad, la fiscalización, la prevención integral del consumo, la investigación financiera, la administración de bienes incautados y la cooperación internacional, garantizando eficiencia, transparencia, trazabilidad, integridad y gestión basada en evidencia.',
  'Número de instrumentos normativos relacionados con delitos vinculados al narcotráfico generados, promovidos y actualizados; Número de mecanismos de fortalecimiento en materia de transparencia y lucha contra la corrupción implementadas; Número de capacitaciones a los servidores públicos vinculados a la política antidroga; Número de acuerdos suscritos de interoperabilidad institucional entre sistemas de información.',
  '5 instrumentos normativos relacionados con delitos vinculados al narcotráfico generados, promovidos y actualizados; 1 mecanismos de fortalecimiento en materia de transparencia y lucha contra la corrupción implementadas; 12 capacitaciones a los servidores públicos vinculados a la política antidroga; 3 acuerdos suscritos de interoperabilidad institucional entre sistemas de información.'
)
ON CONFLICT (codigo) DO UPDATE SET nombre=EXCLUDED.nombre,objetivo=EXCLUDED.objetivo,indicadores_principales=EXCLUDED.indicadores_principales,resultados_2030=EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo='8'),
fuente (codigo,nombre,resultado,indicador_proceso,unidad_medida,meta_2030,siglas_responsable,instituciones_apoyo,orden) AS (
VALUES
('8.1','Generar, promover o actualizar instrumentos normativos relacionados con delitos vinculados al narcotráfico y de regulación de sustancias controladas en coordinación con instancias gubernamentales, académicas y de cooperación internacional bajo estándares internacionales aplicables.','Instrumentos normativos relacionados con delitos vinculados al narcotráfico y de regulación de sustancias controladas en coordinación con instancias gubernamentales, académicas y de cooperación internacional bajo estándares internacionales aplicables generados, promovidos y actualizados','Número de instrumentos normativos relacionados con delitos vinculados al narcotráfico generados, promovidos y actualizados','número',5,'VLICN','MG;DGDSyLCN',1),
('8.2','Fortalecer el sistema integral de gestión de riesgos, promoviendo acciones correctivas con apoyo de organismos internacionales.','Sistema integral de gestión de riesgos, promoviendo acciones correctivas con apoyo de organismos internacionales fortalecida','Número de sistema integral de riesgos implementada','número',1,'VLICN','MG;DGDSyLCN',2),
('8.3','Elaborar una hoja de ruta para la adopción de estándares internacionales aplicables al encarcelamiento y asistencia jurídica por delitos relacionados con drogas, respetando el debido proceso, perspectiva de género, enfoque comunitario y derechos humanos.','Hoja de ruta para la adopción de estándares internacionales aplicables de encarcelamiento y asistencia jurídica por delitos relacionados con drogas, respetando debido proceso, perspectiva de género, enfoque comunitario y derechos humanos elaborada','Propuesta de norma que adopte estándares internacionales para encarcelamiento y asistencia jurídica por delitos de relacionados con drogas','número',1,'VLICN','MG;DGDSyLCN',3),
('8.4','Fortalecer mecanismos de transparencia y anti-corrupción para personal vinculado a la lucha contra el narcotráfico.','Mecanismos de transparencia y anti-corrupción para personal vinculado a la lucha contra el narcotráfico fortalecidos.','Número de mecanismos de fortalecimiento en materia de transparencia y lucha contra la corrupción implementadas','número',1,'VLICN','MG;DGDSyLCN',4),
('8.5','Fortalecer la coordinación en investigación, persecución penal, juzgamiento de delitos complejos, transparencia y lucha contra la corrupción vinculada a la política antidroga.','Coordinación en investigación, persecución penal, juzgamiento de delitos complejos, transparencia y lucha contra la corrupción vinculada a la política antidroga fortalecida.','Número de capacitaciones a los servidores públicos vinculados a la política antidroga','número',12,'VLICN','MG;DGDSyLCN',5),
('8.6','Fortalecer la interoperabilidad y la seguridad institucional entre sistemas de información vinculados a seguridad, justicia, salud, aduanas, sustancias controladas y finanzas ilícitas.','Interoperabilidad institucional entre sistemas de información vinculados a seguridad, justicia, salud, aduanas, sustancias controladas y finanzas ilícitas fortalecida','Número de acuerdos suscritos de interoperabilidad institucional entre sistemas de información','número',3,'VLICN','MG;DGDSyLCN;DGFELCN',6)
), acciones_insertadas AS (
INSERT INTO acciones (eje_id,codigo,nombre,resultado,indicador_proceso,unidad_medida,meta_2030,institucion_principal_id,instituciones_apoyo,orden)
SELECT eje.id,fuente.codigo,fuente.nombre,fuente.resultado,fuente.indicador_proceso,fuente.unidad_medida,fuente.meta_2030,instituciones.id,fuente.instituciones_apoyo,fuente.orden FROM fuente CROSS JOIN eje JOIN instituciones ON instituciones.siglas=fuente.siglas_responsable
ON CONFLICT (eje_id,codigo) DO UPDATE SET nombre=EXCLUDED.nombre,resultado=EXCLUDED.resultado,indicador_proceso=EXCLUDED.indicador_proceso,unidad_medida=EXCLUDED.unidad_medida,meta_2030=EXCLUDED.meta_2030,institucion_principal_id=EXCLUDED.institucion_principal_id,instituciones_apoyo=EXCLUDED.instituciones_apoyo,orden=EXCLUDED.orden RETURNING id,codigo
)
INSERT INTO metas_fisicas (accion_id,gestion,valor_programado)
SELECT acciones_insertadas.id,metas.gestion,metas.valor FROM acciones_insertadas JOIN (VALUES
('8.1',2026,1),('8.1',2027,1),('8.1',2028,1),('8.1',2029,1),('8.1',2030,1),
('8.2',2026,0),('8.2',2027,1),('8.2',2028,0),('8.2',2029,0),('8.2',2030,0),
('8.3',2026,0),('8.3',2027,1),('8.3',2028,0),('8.3',2029,0),('8.3',2030,0),
('8.4',2026,1),('8.4',2027,1),('8.4',2028,1),('8.4',2029,0),('8.4',2030,0),
('8.5',2026,0),('8.5',2027,3),('8.5',2028,3),('8.5',2029,3),('8.5',2030,3),
('8.6',2026,0),('8.6',2027,2),('8.6',2028,1),('8.6',2029,0),('8.6',2030,0)
) AS metas(codigo,gestion,valor) ON metas.codigo=acciones_insertadas.codigo
ON CONFLICT (accion_id,gestion) DO UPDATE SET valor_programado=EXCLUDED.valor_programado;

COMMIT;
