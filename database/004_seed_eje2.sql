BEGIN;

INSERT INTO ejes (codigo, nombre, objetivo, indicadores_principales, resultados_2030)
VALUES (
  '2',
  'Interdicción Estratégica y Eficiencia Operativa',
  'Fortalecer la capacidad operativa del Estado para ejecutar acciones de interdicción aérea, terrestre, lacustre y fluvial, orientadas a afectar la producción, comercialización, tránsito y logística del narcotráfico, priorizando resultados estructurales.',
  'Número de Operaciones de interdicción antinarcóticos ejecutadas; Número de Operaciones Coordinadas y Simultáneas con países de la región ejecutadas; Porcentaje de avance del Sistema de Información Interoperable de la DGFELCN; Número de estudios especializados concluidos con validez científica y aprobados mediante resolución',
  '51.500 operaciones de interdicción antinarcóticos ejecutadas; 20 operaciones Coordinadas y Simultaneas con países de la región ejecutadas; Sistema de Información Interoperable de la FELCN fortalecida; 1 Estudio del Factor de Conversión Coca–Cocaína actualizada.'
)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  objetivo = EXCLUDED.objetivo,
  indicadores_principales = EXCLUDED.indicadores_principales,
  resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (
  SELECT id FROM ejes WHERE codigo = '2'
), fuente (codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, siglas_responsable, instituciones_apoyo, orden) AS (
  VALUES
    ('2.1', 'Ejecutar operaciones de interdicción antinarcóticos aéreas, terrestres, fluviales y lacustres.', 'Operaciones de interdicción antinarcóticos aéreas, terrestres, fluviales y lacustres ejecutadas', 'Número de operaciones de interdicción antinarcóticos ejecutadas', 'número', 51500::NUMERIC, 'DGFELCN', NULL::TEXT, 1),
    ('2.2', 'Ejecutar operaciones coordinadas y simultáneas con países de la región y de interés estratégico.', 'Operaciones coordinadas y simultáneas con países de la región e interés estratégico ejecutadas', 'Número de operaciones coordinadas y simultáneas con la región ejecutadas', 'número', 20::NUMERIC, 'DGFELCN', NULL::TEXT, 2),
    ('2.3', 'Fortalecer los sistemas de información interoperables a nivel nacional e internacional en materia de narcotráfico.', 'Sistemas de información interoperables a nivel nacional e internacional en materia de narcotráfico fortalecida', 'Porcentaje de avance del Sistema de Información Interoperable fortalecida', '%', 100::NUMERIC, 'DGFELCN', NULL::TEXT, 3),
    ('2.4', 'Fortalecer a la Fuerza Especial de Lucha Contra el Narcotráfico (FELCN) mediante capacitación y especialización para la lucha contra el narcotráfico.', 'Fuerza Especial de Lucha Contra el Narcotráfico (FELCN) capacitada y especializada', 'Número de servidores públicos policiales capacitados yespecializados', 'número', 3700::NUMERIC, 'DGFELCN', NULL::TEXT, 4),
    ('2.5', 'Fortalecer a la Fuerza Especial de Lucha Contra el Narcotráfico (FELCN) en cuanto a asistencias técnicas, equipamiento e innovación tecnológica y estructural para lucha contra el narcotráfico.', 'Fuerza Especial de Lucha Contra el Narcotráfico (FELCN) fortalecido', 'Número de asistencias técnicas equipamiento e innovación tecnológica', 'número', 54::NUMERIC, 'DGFELCN', NULL::TEXT, 5),
    ('2.6', 'Actualizar el Estudio del Factor de Conversión Coca–Cocaína.', 'Estudio del Factor de Conversión Coca - Cocaína actualizada', 'Número de estudios especializados concluidos con validez científica y aprobados mediante resolución', 'número', 1::NUMERIC, 'VLICN', 'MG', 6)
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
JOIN (
  VALUES
    ('2.1', 2026, 10000::NUMERIC), ('2.1', 2027, 10200::NUMERIC), ('2.1', 2028, 10300::NUMERIC), ('2.1', 2029, 10500::NUMERIC), ('2.1', 2030, 10500::NUMERIC),
    ('2.2', 2026, 4::NUMERIC), ('2.2', 2027, 4::NUMERIC), ('2.2', 2028, 4::NUMERIC), ('2.2', 2029, 4::NUMERIC), ('2.2', 2030, 4::NUMERIC),
    ('2.3', 2026, 70::NUMERIC), ('2.3', 2027, 20::NUMERIC), ('2.3', 2028, 10::NUMERIC), ('2.3', 2029, 0::NUMERIC), ('2.3', 2030, 0::NUMERIC),
    ('2.4', 2026, 640::NUMERIC), ('2.4', 2027, 690::NUMERIC), ('2.4', 2028, 740::NUMERIC), ('2.4', 2029, 800::NUMERIC), ('2.4', 2030, 830::NUMERIC),
    ('2.5', 2026, 7::NUMERIC), ('2.5', 2027, 9::NUMERIC), ('2.5', 2028, 13::NUMERIC), ('2.5', 2029, 12::NUMERIC), ('2.5', 2030, 13::NUMERIC),
    ('2.6', 2026, 0::NUMERIC), ('2.6', 2027, 1::NUMERIC), ('2.6', 2028, 0::NUMERIC), ('2.6', 2029, 0::NUMERIC), ('2.6', 2030, 0::NUMERIC)
) AS metas(codigo, gestion, valor) ON metas.codigo = acciones_insertadas.codigo
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
