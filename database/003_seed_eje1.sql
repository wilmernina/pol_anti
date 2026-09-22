BEGIN;

INSERT INTO ejes (
  codigo,
  nombre,
  objetivo,
  indicadores_principales,
  resultados_2030
) VALUES (
  '1',
  'Desarticulación de Organizaciones Criminales Transnacionales',
  'Desarticular estructuras criminales vinculadas al narcotráfico y delitos conexos, afectando sus liderazgos, redes logísticas, vínculos financieros, mecanismos de protección, estructuras de mando, capacidad de control territorial y posibilidades de reorganización.',
  'Número de organizaciones criminales transnacionales desarticuladas; Número de Investigaciones integrales sobre redes criminales generadas por el narcotráfico desarrolladas; Número de blancos de alto valor de organizaciones criminales transnacionales aprendidos o expulsados',
  '7 organizaciones criminales transnacionales desarticuladas; 15 Investigaciones integrales sobre redes criminales generadas por el narcotráfico desarrolladas; 10 blancos de alto valor de organizaciones criminales transnacionales aprendidos o expulsados.'
)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  objetivo = EXCLUDED.objetivo,
  indicadores_principales = EXCLUDED.indicadores_principales,
  resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.1', 'Desarticular organizaciones criminales transnacionales involucradas en el tráfico ilícito internacional de sustancias controladas.', 'Organizaciones criminales transnacionales involucradas en el tráfico ilícito internacional de sustancias controladas desarticuladas', 'Número de organizaciones criminales transnacionales desarticuladas', 'número', 7, institucion.id, NULL, 1
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 1::NUMERIC), (2027, 1::NUMERIC), (2028, 1::NUMERIC), (2029, 2::NUMERIC), (2030, 2::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.2', 'Establecer características delictivas de las organizaciones criminales transnacionales vinculadas al narcotráfico y delitos conexos.', 'Características delictivas de las organizaciones criminales transnacionales vinculadas al narcotráfico y delitos conexos establecidas', 'Características delictivas de organizaciones criminales establecidas.', 'número', 5, institucion.id, NULL, 2
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 1::NUMERIC), (2027, 1::NUMERIC), (2028, 1::NUMERIC), (2029, 1::NUMERIC), (2030, 1::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.3', 'Desarrollar investigaciones integrales sobre redes criminales internacionales, vinculadas al narcotráfico, sus mecanismos de financiamiento, logística y corrupción mediante acciones coordinadas con los países de la región y socios estratégicos.', 'Investigaciones integrales sobre redes criminales internacionales, financiamiento, logística y corrupción generadas por el narcotráfico coordinadas con países de la región y socios estratégicos desarrolladas', 'Número de Investigaciones integrales sobre redes criminales generadas por el narcotráfico desarrolladas', 'número', 15, institucion.id, NULL, 3
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 3::NUMERIC), (2027, 3::NUMERIC), (2028, 3::NUMERIC), (2029, 3::NUMERIC), (2030, 3::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.4', 'Fortalecer y operativizar las técnicas especiales de investigación antinarcóticos y la gestión de fuentes de información.', 'Técnicas especiales de investigación antinarcóticos fortalecidas y operativizadas', 'Porcentaje de avance en las Técnicas especiales de investigación fortalecidas y operativizadas', '%', 100, institucion.id, NULL, 4
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 50::NUMERIC), (2027, 25::NUMERIC), (2028, 25::NUMERIC), (2029, 0::NUMERIC), (2030, 0::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.5', 'Realizar la aprehensión y/o expulsión de blancos de alto valor de organizaciones criminales transnacionales.', 'Aprehensión y/o expulsión de blancos de alto valor de organizaciones criminales transnacionales realizadas', 'Número de blancos de alto valor de organizaciones criminales transnacionales aprendidos o expulsados', 'número', 10, institucion.id, NULL, 5
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 2::NUMERIC), (2027, 2::NUMERIC), (2028, 2::NUMERIC), (2029, 2::NUMERIC), (2030, 2::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.6', 'Fortalecer mecanismos de coordinación entre la FELCN, Ministerio Público, Sistema Judicial y otras entidades.', 'Mecanismos de coordinación entre la FELCN, Ministerio Público, Sistema Judicial y otras entidades fortalecidas', 'Número de Mecanismos de coordinación fortalecidas', 'número', 4, institucion.id, NULL, 6
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 0::NUMERIC), (2027, 1::NUMERIC), (2028, 1::NUMERIC), (2029, 1::NUMERIC), (2030, 1::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.7', 'Fortalecer el Análisis Criminal Integrado al interior de la FELCN', 'Análisis Criminal Integrado al interior de la FELCN fortalecida', 'Número de Análisis Criminal Integrado de la FELCN', 'número', 4, institucion.id, NULL, 7
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 0::NUMERIC), (2027, 1::NUMERIC), (2028, 1::NUMERIC), (2029, 1::NUMERIC), (2030, 1::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '1'
), accion AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, '1.8', 'Fortalecer mecanismos de interoperabilidad regional para intercambio seguro y oportuno de información estratégica, inteligencia criminal y trazabilidad financiera.', 'Mecanismos de interoperabilidad regional para intercambio seguro y oportuno de información estratégica, inteligencia criminal y trazabilidad financiera fortalecida', 'Número de mecanismos de interoperabilidad regional fortalecida', 'número', 5, institucion.id, NULL, 8
  FROM eje CROSS JOIN (SELECT id FROM instituciones WHERE siglas = 'DGFELCN') institucion
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT accion.id, metas.gestion, metas.valor FROM accion CROSS JOIN (VALUES (2026, 1::NUMERIC), (2027, 1::NUMERIC), (2028, 1::NUMERIC), (2029, 1::NUMERIC), (2030, 1::NUMERIC)) AS metas(gestion, valor)
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
