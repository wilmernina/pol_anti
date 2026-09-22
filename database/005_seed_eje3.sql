BEGIN;

INSERT INTO ejes (codigo, nombre, objetivo, indicadores_principales, resultados_2030)
VALUES (
  '3',
  'Inteligencia Financiera, Legitimación de Ganancias Ilícitas y Recuperación de Bienes',
  'Neutralizar la capacidad económica, operativa y logística de las organizaciones criminales dedicadas al narcotráfico mediante inteligencia financiera, investigación patrimonial, persecución penal de la legitimación de ganancias ilícitas, recuperación de bienes y administración transparente de activos incautados y confiscados.',
  'Número de mesas técnicas de seguimiento de acuerdos de fortalecimiento en el intercambio de información y la lucha contra la legitimación de ganancias ilícitas vinculado con el delito del narcotráfico y delitos conexos; Número de casos diseminados vinculados al narcotráfico y delitos conexos; número de informes de investigación o inteligencia financiera patrimonial elaborados bajo estándares internacionales; Número de bienes monetizados',
  '10 mesas técnicas de seguimiento de acuerdos de fortalecimiento en el intercambio de información y la lucha contra la legitimación de ganancias ilícitas vinculado con el delito del narcotráfico y delitos conexos realizada; 10 casos diseminados vinculados al narcotráfico y delitos conexos; 225 informes de investigación o inteligencia financiera patrimonial elaborados bajo estándares internacionales realizada; 4.674 de bienes monetizados'
)
ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, objetivo = EXCLUDED.objetivo, indicadores_principales = EXCLUDED.indicadores_principales, resultados_2030 = EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo = '3'),
fuente (codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, siglas_responsable, instituciones_apoyo, orden) AS (
  VALUES
  ('3.1', 'Promover la suscripción y actualización de acuerdos interinstitucionales de cooperación entre UIF, Fiscalía General del Estado, FELCN/GIAEF y otras entidades competentes, estableciendo mecanismos/herramientas y en la medida de lo posible estandarizadas de detección, prevención, investigación, así como para fortalecer el intercambio de información y la lucha de legitimación de ganancias ilícitas vinculado con el delito del narcotráfico y delitos conexos.', 'Acuerdos interinstitucionales de cooperación entre la UIF, Fiscalía General, FELCN/GIAEF, y otras instancias competentes promovidas y suscritas', 'Número de Acuerdos Interinstitucionales promovidos y suscritos', 'número', 9::NUMERIC, 'UIF', 'MEyFP;DGFELCN', 1),
  ('3.2', 'Elaborar y diseminar productos de inteligencia financiera y/o patrimonial de manera oportuna a las Autoridades Competentes vinculados al narcotráfico y delitos conexos, en el marco de las atribuciones de la UIF y de los estándares internacionales.', 'Productos de inteligencia financiera y/o patrimonial elaborados y diseminados', 'Número de casos diseminados vinculados al narcotráfico y delitos conexos', 'número', 10::NUMERIC, 'UIF', 'MEyFP', 2),
  ('3.3', 'Establecer espacios técnicos de trabajo para el cumplimiento de los estándares internacionales del GAFI, enfocados a la mejora del marco legal, regulatorio e institucional para prevenir y sancionar delitos de LGI /FT/FPADM vinculados al narcotráfico.', 'Espacios técnicos de trabajo para el cumplimiento de los estándares internacionales del GAFI, enfocados a la mejora del marco legal, regulatorio e institucional para prevenir y sancionar delitos de LGI /FT/FPADM vinculados al narcotráfico establecidos.', 'Número de investigaciones guiadas por los productos de inteligencia financiera promovida', 'número', 225::NUMERIC, 'DGFELCN', NULL::TEXT, 3),
  ('3.4', 'Formar analistas y peritos especializados en inteligencia financiera.', 'analistas y peritos especializados en inteligencia financiera formados', 'Servidores públicos y personal policial especializados', 'número', 25::NUMERIC, 'UIF', 'MEyFP;DGFELCN;DIRCABI', 4),
  ('3.5', 'Actualizar normas, sistemas, métodos y procedimientos de entrega, recuperación, monetización, inventario, custodia, disposición, procesos de devolución y conversión de bienes incautados bajo la administración del Estado.', 'Normas, sistemas, métodos y procedimientos de entrega, recuperación, monetización, inventario, custodia, disposición, devolución y conversión de bienes incautados actualizados', 'Número de normas, sistemas, métodos y procedimientos actualizados', 'número', 36::NUMERIC, 'DIRCABI', 'MG', 5),
  ('3.6', 'Proponer y establecer protocolos y guías para la administración y uso definitivo o temporal de bienes incautados y confiscados.', 'Protocolos de procedimientos administrativos de bienes incautados y confiscados otorgados para su uso definitivo o temporal propuestos', 'Número de protocolos propuestos y establecidos', 'número', 10::NUMERIC, 'DIRCABI', 'MG', 6),
  ('3.7', 'Monetizar bienes vinculados a delitos de tráfico ilícito de sustancias controladas.', 'Bienes vinculados a delitos de tráfico ilícito de sustancias controladas monetizados', 'Número de bienes monetizados', 'número', 4674::NUMERIC, 'DIRCABI', 'MG', 7),
  ('3.8', 'Fortalecer el sistema digital integrado de inventario, custodia, recuperación, monetización y destino de activos.', 'Sistema digital integrado (Sistema Informático Integrado de Bienes SIIB) de inventario, custodia, recuperación, monetización y destino de activos fortalecido', 'Porcentaje del avance en el fortalecimiento del Sistema Informático Integrado de Bienes (SIIB) y de la infraestructura tecnológica institucional', '%', 100::NUMERIC, 'DIRCABI', 'MG', 8),
  ('3.9', 'Promover cooperación internacional para rastreo de capitales ilícitos y recuperación de activos.', 'Cooperación Internacional para el rastreo de capitales ilícitos y recuperación de activos promovida', 'Número de reuniones de coordinación realizadas en el marco de la cooperación internacional promovidas', 'número', 9::NUMERIC, 'DIRCABI', 'MG', 9)
), acciones_insertadas AS (
  INSERT INTO acciones (eje_id, codigo, nombre, resultado, indicador_proceso, unidad_medida, meta_2030, institucion_principal_id, instituciones_apoyo, orden)
  SELECT eje.id, fuente.codigo, fuente.nombre, fuente.resultado, fuente.indicador_proceso, fuente.unidad_medida, fuente.meta_2030, instituciones.id, fuente.instituciones_apoyo, fuente.orden FROM fuente CROSS JOIN eje JOIN instituciones ON instituciones.siglas = fuente.siglas_responsable
  ON CONFLICT (eje_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, resultado = EXCLUDED.resultado, indicador_proceso = EXCLUDED.indicador_proceso, unidad_medida = EXCLUDED.unidad_medida, meta_2030 = EXCLUDED.meta_2030, institucion_principal_id = EXCLUDED.institucion_principal_id, instituciones_apoyo = EXCLUDED.instituciones_apoyo, orden = EXCLUDED.orden
  RETURNING id, codigo
)
INSERT INTO metas_fisicas (accion_id, gestion, valor_programado)
SELECT acciones_insertadas.id, metas.gestion, metas.valor FROM acciones_insertadas JOIN (VALUES
 ('3.1',2026,2::NUMERIC),('3.1',2027,2::NUMERIC),('3.1',2028,2::NUMERIC),('3.1',2029,2::NUMERIC),('3.1',2030,1::NUMERIC),
 ('3.2',2026,2::NUMERIC),('3.2',2027,2::NUMERIC),('3.2',2028,2::NUMERIC),('3.2',2029,2::NUMERIC),('3.2',2030,2::NUMERIC),
 ('3.3',2026,40::NUMERIC),('3.3',2027,40::NUMERIC),('3.3',2028,40::NUMERIC),('3.3',2029,50::NUMERIC),('3.3',2030,50::NUMERIC),
 ('3.4',2026,5::NUMERIC),('3.4',2027,5::NUMERIC),('3.4',2028,5::NUMERIC),('3.4',2029,5::NUMERIC),('3.4',2030,5::NUMERIC),
 ('3.5',2026,3::NUMERIC),('3.5',2027,6::NUMERIC),('3.5',2028,8::NUMERIC),('3.5',2029,11::NUMERIC),('3.5',2030,8::NUMERIC),
 ('3.6',2026,1::NUMERIC),('3.6',2027,1::NUMERIC),('3.6',2028,2::NUMERIC),('3.6',2029,3::NUMERIC),('3.6',2030,3::NUMERIC),
 ('3.7',2026,868::NUMERIC),('3.7',2027,944::NUMERIC),('3.7',2028,1011::NUMERIC),('3.7',2029,1071::NUMERIC),('3.7',2030,780::NUMERIC),
 ('3.8',2026,0::NUMERIC),('3.8',2027,10::NUMERIC),('3.8',2028,10::NUMERIC),('3.8',2029,10::NUMERIC),('3.8',2030,0::NUMERIC),
 ('3.9',2026,1::NUMERIC),('3.9',2027,2::NUMERIC),('3.9',2028,2::NUMERIC),('3.9',2029,2::NUMERIC),('3.9',2030,2::NUMERIC)
) AS metas(codigo, gestion, valor) ON metas.codigo = acciones_insertadas.codigo
ON CONFLICT (accion_id, gestion) DO UPDATE SET valor_programado = EXCLUDED.valor_programado;

COMMIT;
