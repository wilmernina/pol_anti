BEGIN;

INSERT INTO ejes (codigo, nombre, objetivo, indicadores_principales, resultados_2030)
VALUES (
  '6',
  'Desarrollo Integral e Inserción Económica Legal',
  'Promover alternativas económicas, sociales y productivas sostenibles en áreas de intervención con tareas de reducción de cultivos de coca, con el propósito de diversificar la matriz productiva territorial, fortalecer medios de vida legales, reducir la dependencia de economías ilícitas y consolidar presencia estatal en zonas vulnerables, mediante el desarrollo de cadenas productivas competitivas y sostenibles con acceso a mercados nacionales e internacionales.',
  'Porcentaje de avance en el fortalecimiento e implementación de las ACCIONES estratégicas de la Política de Desarrollo Integral Sustentable; Número de organizaciones productivas que acceden a mercados mediante mecanismos de articulación comercial promovidos.',
  'Política de Desarrollo Integral Sustentable implementada; 16 organizaciones productivas que acceden a mercados mediante mecanismos de articulación comercial promovidos.'
)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  objetivo = EXCLUDED.objetivo,
  indicadores_principales = EXCLUDED.indicadores_principales,
  resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo = '6'),
fuente (codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, siglas_responsable, instituciones_apoyo, orden) AS (
  VALUES
    ('6.1', 'Fortalecer e Implementar la Nueva Política de Desarrollo Integral Sustentable conforme a normativa vigente.', 'Nueva Política de Desarrollo Integral Sustentable fortalecida e implementada', 'Porcentaje de avance en el fortalecimiento e implementación de las acciones estratégicas de la Política de Desarrollo Integral Sustentable', '%', 100::NUMERIC, 'VDAyA', 'MPSMAyA', 1),
    ('6.2', 'Consolidar espacios permanentes de coordinación entre entidades nacionales, departamentales, municipales y cooperaciones para la sostenibilidad del Desarrollo Integral.', 'Espacios permanentes de coordinación entre entidades nacionales, departamentales, municipales y cooperaciones consolidada', 'Número de instancias de coordinación territorial formalmente consolidadas y en funcionamiento.', 'número', 9::NUMERIC, 'VDAyA', 'MPSMAyA', 2),
    ('6.3', 'Promover estrategias de articulación comercial para la inserción de productos del Desarrollo Integral en mercados nacionales e internacionales', 'Estrategias de articulación comercial para la inserción de productos del Desarrollo Integral en mercados nacionales e internacionales promovidas', 'Número de organizaciones productivas que acceden a mercados mediante mecanismos de articulación comercial promovidos', 'número', 16::NUMERIC, 'VDAyA', 'MPSMAyA', 3)
), acciones_insertadas AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, fuente.codigo, fuente.nombre, fuente.resultado, fuente.indicador_proceso, fuente.unidad_medida, fuente.meta_2030, instituciones.id, fuente.instituciones_apoyo, fuente.orden
  FROM fuente
  CROSS JOIN eje
  JOIN instituciones ON instituciones.siglas = fuente.siglas_responsable
  ON CONFLICT (eje_id, codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    resultado = EXCLUDED.resultado,
    indicador_proceso = EXCLUDED.indicador_proceso,
    unidad_medida = EXCLUDED.unidad_medida,
    meta_2030 = EXCLUDED.meta_2030,
    institucion_principal_id = EXCLUDED.institucion_principal_id,
    instituciones_apoyo = EXCLUDED.instituciones_apoyo,
    orden = EXCLUDED.orden
  RETURNING id, codigo
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT acciones_insertadas.id, metas.gestion, metas.valor
FROM acciones_insertadas
JOIN (VALUES
  ('6.1', 2026, 10::NUMERIC), ('6.1', 2027, 20::NUMERIC), ('6.1', 2028, 20::NUMERIC), ('6.1', 2029, 30::NUMERIC), ('6.1', 2030, 20::NUMERIC),
  ('6.2', 2026, 1::NUMERIC), ('6.2', 2027, 2::NUMERIC), ('6.2', 2028, 2::NUMERIC), ('6.2', 2029, 2::NUMERIC), ('6.2', 2030, 2::NUMERIC),
  ('6.3', 2026, 0::NUMERIC), ('6.3', 2027, 1::NUMERIC), ('6.3', 2028, 5::NUMERIC), ('6.3', 2029, 5::NUMERIC), ('6.3', 2030, 5::NUMERIC)
) AS metas(codigo, gestion, valor) ON metas.codigo = acciones_insertadas.codigo
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
