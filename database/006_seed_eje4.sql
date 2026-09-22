BEGIN;

INSERT INTO ejes (codigo, nombre, objetivo, indicadores_principales, resultados_2030)
VALUES (
  '4',
  'Control de Precursores Químicos, Sustancias Controladas, Psicotrópicos y Estupefacientes',
  'Mejorar los mecanismos de fiscalización, trazabilidad, control, inspección y alerta temprana sobre sustancias químicas controladas, psicotrópicos, estupefacientes y precursores químicos utilizados para la producción ilícita de drogas o desviados hacia mercados ilegales.',
  'Número de fiscalizaciones a importadores, productores, comercializadores de sustancias químicas controladas; Número de Autorizaciones Previas aprobadas; Número de fiscalizaciones realizadas; Porcentaje de Implementación de la plataforma digital integral de fiscalización de la AGEMED; Número de operativos de seguimiento a la producción, internación y destino final de sustancias químicas controladas realizados.',
  '3.565 fiscalizaciones a importadores, productores, comercializadores de sustancias químicas controladas; 29.210 Autorizaciones Previas aprobadas; 46 laboratorios industriales farmacéuticos e importadoras fiscalizadas; Plataforma digital integral de fiscalización de la AGEMED implementada; 4 operativos de seguimiento a la producción, internación y destino final de sustancias químicas controladas realizados.'
)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  objetivo = EXCLUDED.objetivo,
  indicadores_principales = EXCLUDED.indicadores_principales,
  resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo = '4'),
fuente (codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, siglas_responsable, instituciones_apoyo, orden) AS (
  VALUES
    ('4.1', 'Fortalecer el sistema de trazabilidad de sustancias químicas controladas, desde la producción, importación, comercialización hasta su uso final en tiempo real.', 'Sistema de trazabilidad de sustancias químicas controladas fortalecida', 'Porcentaje de avance en el fortalecimiento del sistema de trazabilidad de sustancias químicas controladas', '%', 100::NUMERIC, 'DGSC', 'MG', 1),
    ('4.2', 'Fiscalizar sustancias químicas controladas a productores, importadores, y comercializadores.', 'Sustancias químicas controladas a importadores, productores, comercializadores fiscalizadas', 'Número de productores, importadores, y comercializadores de sustancias químicas controladas fiscalizadas', 'número', 3565::NUMERIC, 'DGSC', 'MG', 2),
    ('4.3', 'Controlar la importación, exportación, producción de sustancias químicas controladas a personas naturales o jurídicas a nivel nacional mejorando la emisión de las Autorizaciones Previas', 'Importación, exportación, producción de sustancias químicas controladas', 'Número de Autorizaciones Previas aprobadas', 'número', 29210::NUMERIC, 'DGSC', 'MG', 3),
    ('4.4', 'Actualizar protocolos de inspección técnica, control y fiscalización de sustancias químicas controladasbajo estándares internacionales.', 'Protocolos de inspección técnica, control y fiscalización de sustancias químicas controladas bajo estándares internacionales actualizadas', 'Número de protocolos de inspección técnica, control, fiscalización de sustancias químicas actualizadas', 'número', 1::NUMERIC, 'DGSC', 'MG', 4),
    ('4.5', 'Modificar y Actualizar la normativa aplicada sobre subpartidas arancelarias relacionadas con sustancias químicas controladas', 'Normativa aplicada sobre subpartidas arancelarias relacionadas con sustancias químicas controladas modificadas y actualizadas', 'Número de instrumentos normativos actualizados', 'número', 1::NUMERIC, 'DGSC', 'MG', 5),
    ('4.6', 'Fiscalizar los laboratorios industriales farmacéuticos e importadores de precursores, psicotrópicos y estupefacientes de uso medicinal y científico en toda la cadena de suministro: fabricación, importación, almacenamiento, distribución y comercialización.', 'laboratorios industriales farmacéuticos e importadores de precursores, psicotrópicos y estupefacientes de uso medicinal y científico fiscalizados', 'Número de fiscalizaciones realizadas', 'número', 46::NUMERIC, 'AGEMED', 'MSyD', 6),
    ('4.7', 'Implementar la Plataforma Digital Integral de Fiscalización de la AGEMED para el control a nivel nacional (público y privado) de toda la cadena de suministro de estupefacientes, precursores y psicotrópicos de uso medicinal y científico desde su importación, fabricación, distribución, comercialización, prescripción (recetas electrónicas) y dispensaciones destinadas al paciente.', 'Plataforma Digital Integral de Fiscalización de AGEMED implementada', 'Porcentaje de avance en la Implementación de la plataforma digital integral de fiscalización de la AGEMED', '%', 100::NUMERIC, 'AGEMED', 'MSyD', 7),
    ('4.8', 'Aperturar oficinas regionales en el eje central de vigilancia y control para los puntos principales de ingreso y salida del país en coordinación con las entidades de alcance nacional.', 'Oficinas regionales en el eje central de vigilancia y control para los puntos principales de ingreso y salida del país en coordinación con las entidades de alcance nacional aperturadas', 'Número de oficinas regionales y puntos principales de ingreso y salida del país aperturadas', 'número', 2::NUMERIC, 'AGEMED', 'MSyD', 8),
    ('4.9', 'Analizar, perfilar y realizar el seguimiento a la producción, internación y destino final de sustancias químicas controladas.', 'Operativos de seguimiento a la producción, internación y destino final de sustancias químicas controladas realizados.', 'Número de operativos de seguimiento a la producción, internación y destino final de sustancias químicas controladas realizados.', 'número', 940::NUMERIC, 'DGFELCN', NULL::TEXT, 9)
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
  ('4.1', 2026, 10::NUMERIC), ('4.1', 2027, 30::NUMERIC), ('4.1', 2028, 40::NUMERIC), ('4.1', 2029, 10::NUMERIC), ('4.1', 2030, 10::NUMERIC),
  ('4.2', 2026, 365::NUMERIC), ('4.2', 2027, 520::NUMERIC), ('4.2', 2028, 680::NUMERIC), ('4.2', 2029, 850::NUMERIC), ('4.2', 2030, 1150::NUMERIC),
  ('4.3', 2026, 3270::NUMERIC), ('4.3', 2027, 4200::NUMERIC), ('4.3', 2028, 5350::NUMERIC), ('4.3', 2029, 7070::NUMERIC), ('4.3', 2030, 9320::NUMERIC),
  ('4.4', 2026, 0::NUMERIC), ('4.4', 2027, 1::NUMERIC), ('4.4', 2028, 0::NUMERIC), ('4.4', 2029, 0::NUMERIC), ('4.4', 2030, 0::NUMERIC),
  ('4.5', 2026, 0::NUMERIC), ('4.5', 2027, 1::NUMERIC), ('4.5', 2028, 0::NUMERIC), ('4.5', 2029, 0::NUMERIC), ('4.5', 2030, 0::NUMERIC),
  ('4.6', 2026, 6::NUMERIC), ('4.6', 2027, 10::NUMERIC), ('4.6', 2028, 10::NUMERIC), ('4.6', 2029, 10::NUMERIC), ('4.6', 2030, 10::NUMERIC),
  ('4.7', 2026, 10::NUMERIC), ('4.7', 2027, 20::NUMERIC), ('4.7', 2028, 30::NUMERIC), ('4.7', 2029, 20::NUMERIC), ('4.7', 2030, 20::NUMERIC),
  ('4.8', 2026, 0::NUMERIC), ('4.8', 2027, 0::NUMERIC), ('4.8', 2028, 1::NUMERIC), ('4.8', 2029, 1::NUMERIC), ('4.8', 2030, 0::NUMERIC),
  ('4.9', 2026, 180::NUMERIC), ('4.9', 2027, 180::NUMERIC), ('4.9', 2028, 190::NUMERIC), ('4.9', 2029, 190::NUMERIC), ('4.9', 2030, 200::NUMERIC)
) AS metas(codigo, gestion, valor) ON metas.codigo = acciones_insertadas.codigo
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
