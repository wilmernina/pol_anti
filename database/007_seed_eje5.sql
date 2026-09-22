BEGIN;

INSERT INTO ejes (codigo, nombre, objetivo, indicadores_principales, resultados_2030)
VALUES (
  '5',
  'Control Responsable de Cultivos de Coca',
  'Reducir de manera planificada, progresiva y sostenible la superficie de cultivos excedentarios e ilegales de coca, hasta alcanzar los límites establecidos por la normativa vigente, garantizando derechos humanos, paz social, control social, protección ambiental y presencia efectiva del Estado.',
  'Hectáreas de cultivos de coca racionalizadas y erradicadas ejecutadas; Operativos de control para evitar la resiembra; Número de mecanismos de corresponsabilidad para el control social ejercido por organizaciones productoras de coca impulsados; Tonelada de Hoja de coca desviada en rutas autorizadas y no autorizadas controladas y retenidas; Puestos avanzados de Control instalados para evitar el desvió de Ilegal de Hoja de Coca consolidada; Número de mapas temáticos de riesgo y vectores de expansión de cultivos ilegales elaborados y oficializados; Número de estudios especializados (Rendimiento y Consumo) actualizados, concluidos y aprobados.',
  '50.000 Hectáreas de cultivos de coca racionalizadas y erradicadas ejecutadas; 250 Operativos de control para evitar la resiembra; Número de mecanismos de corresponsabilidad para el control social ejercido por organizaciones productoras de coca impulsados; 1.400 Tonelada de Hoja de coca desviada en rutas autorizadas y no autorizadas controladas y retenidas; 12 Puestos avanzados de Control instalados para evitar el desvió de Ilegal de Hoja de Coca consolidada; 10 mapas temáticos de riesgo y vectores de expansión de cultivos ilegales elaborados y oficializados; 2 estudios especializados (Rendimiento y Consumo) actualizados, concluidos y aprobados.'
)
ON CONFLICT (codigo) DO UPDATE SET
  nombre = EXCLUDED.nombre,
  objetivo = EXCLUDED.objetivo,
  indicadores_principales = EXCLUDED.indicadores_principales,
  resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo = '5'),
fuente (codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, siglas_responsable, instituciones_apoyo, orden) AS (
  VALUES
    ('5.1', 'Ejecutar operaciones de racionalización y erradicación de cultivos de coca excedentaria e ilegal en zonas autorizadas y no autorizadas.', 'Operaciones de racionalización y erradicación de cultivos de coca excedentaria e ilegal en zonas no autorizadas ejecutadas', 'Hectáreas de cultivos de coca racionalizadas y erradicadas ejecutadas', 'hectáreas', 50000::NUMERIC, 'FFAA-CEO', 'MD', 1),
    ('5.2', 'Implementar mecanismos para evitar la re-siembra de cultivos de coca.', 'Mecanismos para evitar la re-siembra de cultivos de coca implementados', 'Operativos de control para evitar la resiembra.', 'número', 250::NUMERIC, 'FFAA-CEO', 'MD', 2),
    ('5.3', 'Fortalecer el CEO “Tte. Gironda” para la planificación participativa, ejecución y sostenibilidad de acciones de racionalización y erradicación de cultivos de coca.', 'CEO "TTE. GIRONDA" fortalecida', 'Porcentaje de fortalecimiento institucional, operativo y de planificación del CEO TTE. Gironda”', '%', 100::NUMERIC, 'FFAA-CEO', 'MD', 3),
    ('5.4', 'Impulsar el control social a la producción de la hoja de coca ejercido por organizaciones productoras de coca en zonas autorizadas, promoviendo mecanismos de corresponsabilidad en coordinación con las instituciones del Estado.', 'Control social ejercido por organizaciones productoras de coca en zonas autorizadas, promoviendo mecanismos de corresponsabilidad en coordinación con las instituciones del Estado impulsadas.', 'Número de mecanismos de corresponsabilidad para el control social ejercido por organizaciones productoras de coca impulsados', 'número', 10::NUMERIC, 'VLICN', 'MG;DGDSyLCN;MPSMAyA;VDAyA', 4),
    ('5.5', 'Fortalecer la coordinación interinstitucional entre entidades de seguridad, control territorial, medio ambiente, desarrollo productivo e instancias legales competentes para la implementación integral de las operaciones de racionalización y erradicación.', 'Coordinación interinstitucional entre entidades de seguridad, control territorial, medio ambiente, desarrollo productivo e instancias legales competentes para la implementación integral de las operaciones de racionalización y erradicación fortalecida', 'Número de coordinaciones interinstitucionales para la implementación integral de operaciones de racionalización y erradicación', 'número', 25::NUMERIC, 'FFAA-CEO', 'MG;VDSSC', 5),
    ('5.6', 'Controlar y retener la hoja de coca desviada en rutas autorizadas y no autorizadas en todo el territorio nacional por las instituciones involucradas.', 'hoja de coca desviada en rutas autorizadas y no autorizadas en todo el territorio nacional por las instituciones involucradas controladas y retenidas', 'Tonelada de Hoja de coca desviada en rutas autorizadas y no autorizadas controladas y retenidas', 'toneladas', 1400::NUMERIC, 'DGFELCN', 'MG', 6),
    ('5.7', 'Consolidar presencia estatal a través de la instalación de puestos avanzados de control en territorios críticos, y zonas vulnerables para evitar el desvío de Ilegal de Hoja de Coca.', 'Presencia estatal a través de la instalación de puestos avanzados de control en territorios críticos, y zonas vulnerables para evitar el desvío de Ilegal de Hoja de Coca consolidada', 'Puestos avanzados de Control instalados para evitar el desvió de Ilegal de Hoja de Coca consolidada', 'número', 12::NUMERIC, 'DGFELCN', 'MG', 7),
    ('5.8', 'Incorporar herramientas tecnológicas de monitoreo geoespacial, imágenes satelitales y sistemas de información territorial para fortalecer la ejecución y evaluación de las operaciones de erradicación y racionalización de cultivos de coca.', 'Herramientas tecnológicas de monitoreo geoespacial, imágenes satelitales y sistemas de información territorial para fortalecer la ejecución y evaluación de las operaciones de erradicación y racionalización de cultivos de coca incorporadas', 'Implementación de la plataforma WEB-SIG', '%', 100::NUMERIC, 'VLICN', 'MG;DGDSyLCN', 8),
    ('5.9', 'Realizar el monitoreo anual de cultivos de coca en coordinación con instituciones nacionales y organismos internacionales.', 'Monitoreo anual de cultivos de coca en coordinación con instituciones nacionales y organismos internacionales realizada', 'Número de informes oficiales de monitoreo anual de cultivos de coca realizados validados y publicados', 'número', 5::NUMERIC, 'VLICN', 'MG;DGDSyLCN', 9),
    ('5.10', 'Generar mapas de riesgo para identificar zonas de expansión e incremento de cultivos de coca excedentarios e ilegales.', 'Mapas de riesgo para identificar zonas de expansión de expansión e incremento de cultivos de coca excedentarios e ilegales generadas', 'Número de mapas temáticos de riesgo y vectores de expansión de cultivos ilegales elaborados y oficializados.', 'número', 100::NUMERIC, 'VLICN', 'MG;DGDSyLCN', 10),
    ('5.11', 'Desarrollar e integrar un sistema para el control y la retención de la hoja de coca fuera de las rutas autorizadas a cargo del GECC', 'Sistema para el control y retención de la hoja de coca fuera de las rutas autorizadas desarrollado e implementado.', 'Porcentaje de avance en el desarrollo de los módulos.', '%', 100::NUMERIC, 'DGFELCN', 'MG;VLICN;DGDSyLCN', 11),
    ('5.12', 'Actualizar Estudios de Rendimiento de Cultivos de Coca y Consumo de la Hoja de Coca en Bolivia.', 'Estudios de Rendimiento de Cultivos de Coca y Consumo de la Hoja de Coca en Bolivia actualizados', 'Número de estudios especializados (Rendimiento y Consumo) actualizados, concluidos y aprobados', 'número', 2::NUMERIC, 'VLICN', 'MG;DGDSyLCN', 12)
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
  ('5.1', 2026, 10000::NUMERIC), ('5.1', 2027, 10000::NUMERIC), ('5.1', 2028, 10000::NUMERIC), ('5.1', 2029, 10000::NUMERIC), ('5.1', 2030, 10000::NUMERIC),
  ('5.2', 2026, 50::NUMERIC), ('5.2', 2027, 50::NUMERIC), ('5.2', 2028, 50::NUMERIC), ('5.2', 2029, 50::NUMERIC), ('5.2', 2030, 50::NUMERIC),
  ('5.3', 2026, 20::NUMERIC), ('5.3', 2027, 20::NUMERIC), ('5.3', 2028, 20::NUMERIC), ('5.3', 2029, 20::NUMERIC), ('5.3', 2030, 20::NUMERIC),
  ('5.4', 2026, 2::NUMERIC), ('5.4', 2027, 2::NUMERIC), ('5.4', 2028, 2::NUMERIC), ('5.4', 2029, 2::NUMERIC), ('5.4', 2030, 2::NUMERIC),
  ('5.5', 2026, 5::NUMERIC), ('5.5', 2027, 5::NUMERIC), ('5.5', 2028, 5::NUMERIC), ('5.5', 2029, 5::NUMERIC), ('5.5', 2030, 5::NUMERIC),
  ('5.6', 2026, 280::NUMERIC), ('5.6', 2027, 280::NUMERIC), ('5.6', 2028, 280::NUMERIC), ('5.6', 2029, 280::NUMERIC), ('5.6', 2030, 280::NUMERIC),
  ('5.7', 2026, 0::NUMERIC), ('5.7', 2027, 2::NUMERIC), ('5.7', 2028, 2::NUMERIC), ('5.7', 2029, 2::NUMERIC), ('5.7', 2030, 6::NUMERIC),
  ('5.8', 2026, 40::NUMERIC), ('5.8', 2027, 40::NUMERIC), ('5.8', 2028, 20::NUMERIC), ('5.8', 2029, 0::NUMERIC), ('5.8', 2030, 0::NUMERIC),
  ('5.9', 2026, 1::NUMERIC), ('5.9', 2027, 1::NUMERIC), ('5.9', 2028, 1::NUMERIC), ('5.9', 2029, 1::NUMERIC), ('5.9', 2030, 1::NUMERIC),
  ('5.10', 2026, 20::NUMERIC), ('5.10', 2027, 20::NUMERIC), ('5.10', 2028, 20::NUMERIC), ('5.10', 2029, 20::NUMERIC), ('5.10', 2030, 20::NUMERIC),
  ('5.11', 2026, 20::NUMERIC), ('5.11', 2027, 40::NUMERIC), ('5.11', 2028, 40::NUMERIC), ('5.11', 2029, 0::NUMERIC), ('5.11', 2030, 0::NUMERIC),
  ('5.12', 2026, 0::NUMERIC), ('5.12', 2027, 1::NUMERIC), ('5.12', 2028, 1::NUMERIC), ('5.12', 2029, 0::NUMERIC), ('5.12', 2030, 0::NUMERIC)
) AS metas(codigo, gestion, valor) ON metas.codigo = acciones_insertadas.codigo
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
