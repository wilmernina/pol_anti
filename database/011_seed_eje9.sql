BEGIN;

INSERT INTO ejes (codigo,nombre,objetivo,indicadores_principales,resultados_2030)
VALUES (
  '9',
  'Cooperación Internacional Estratégica y Operativa',
  'Consolidar una cooperación internacional, técnica, operativa, científica, financiera e interoperable, orientada a fortalecer la capacidad del Estado frente al narcotráfico, la delincuencia organizada transnacional, los flujos financieros ilícitos, recuperación de activos incautados, el control de precursores, la reducción de la demanda, el control de cultivos de coca y desarrollo integral.',
  'Número de actas de reunión de comisiones mixtas; Número de Actas/Plan de Acción-Operaciones de interdicción al narcotráfico; Número de Instrumentos bilaterales (Declaraciones Conjuntas, Acuerdos Interinstitucionales, Memorándums de Entendimiento, Actas y/o Planes de Acción); Número de Documentos suscritos, Actas y/o decisiones.',
  '17 actas de reunión de comisiones mixtas; 13 número de Actas/Plan de Acción-Operaciones de interdicción al narcotráfico; 9 número de Instrumentos bilaterales (Declaraciones Conjuntas, Acuerdos Interinstitucionales, Memorándums de Entendimiento, Actas y/o Planes de Acción); 12 número de Documentos suscritos, Actas y/o decisiones.'
)
ON CONFLICT (codigo) DO UPDATE SET nombre=EXCLUDED.nombre,objetivo=EXCLUDED.objetivo,indicadores_principales=EXCLUDED.indicadores_principales,resultados_2030=EXCLUDED.resultados_2030;

WITH eje AS (SELECT id FROM ejes WHERE codigo='9'),
fuente (codigo,nombre,resultado,indicador_proceso,unidad_medida,meta_2030,siglas_responsable,instituciones_apoyo,orden) AS (
VALUES
('9.1','Realizar reuniones de comisiones mixtas con países fronterizos, de la región y socios estratégicos de Europa, Asia y América.','Reuniones de Comisiones Mixtas realizadas','Número de actas de reunión de comisiones mixtas','número',17,'VLICN','MG;DGDSyLCN',1),
('9.2','Realizar reuniones operativas de tres o más países fronterizos y/o en rutas compartidas del narcotráfico.','Reuniones Operativas de tres o más países fronterizos y/o en rutas compartidas del narcotráfico realizadas.','Número de Actas/Plan de Acción-Operaciones de interdicción al narcotráfico','número',13,'VLICN','MG;DGDSyLCN',2),
('9.3','Fortalecer la integración bilateral y regional en materia de lucha contra el narcotráfico y delitos conexos, con los países aliados y estratégicos','Integración bilateral y regional en materia de lucha contra el narcotráfico y delitos conexos fortalecida','Número de Instrumentos bilaterales (Declaraciones Conjuntas, Acuerdos Interinstitucionales, Memorándums de Entendimiento, Actas y/o Planes de Acción)','número',10,'VLICN','MG;DGDSyLCN',3),
('9.4','Fortalecer la participación de Bolivia en espacios regionales y multilaterales.','Participación activa de Bolivia en espacios regionales y multilaterales fortalecida','Número de Informes Técnicos de participación y logros alcanzados.','número',65,'VLICN','MG;DGDSyLCN',4),
('9.5','Ampliar la participación en programas y proyectos financiados por organismos regionales y multilaterales, agencias internacionales y otros socios cooperantes.','Participación en programas y proyectos financiados por organismos regionales y multilaterales, agencias internacionales y otros socios cooperantes ampliadas','Número de Documentos suscritos, Actas y/o decisiones','número',12,'VLICN','MG;DGDSyLCN',5)
), acciones_insertadas AS (
INSERT INTO acciones (eje_id,codigo,nombre,resultado,indicador_proceso,unidad_medida,meta_2030,institucion_principal_id,instituciones_apoyo,orden)
SELECT eje.id,fuente.codigo,fuente.nombre,fuente.resultado,fuente.indicador_proceso,fuente.unidad_medida,fuente.meta_2030,instituciones.id,fuente.instituciones_apoyo,fuente.orden FROM fuente CROSS JOIN eje JOIN instituciones ON instituciones.siglas=fuente.siglas_responsable
ON CONFLICT (eje_id,codigo) DO UPDATE SET nombre=EXCLUDED.nombre,resultado=EXCLUDED.resultado,indicador_proceso=EXCLUDED.indicador_proceso,unidad_medida=EXCLUDED.unidad_medida,meta_2030=EXCLUDED.meta_2030,institucion_principal_id=EXCLUDED.institucion_principal_id,instituciones_apoyo=EXCLUDED.instituciones_apoyo,orden=EXCLUDED.orden RETURNING id,codigo
)
INSERT INTO metas_fisicas (accion_id,gestion,valor_programado)
SELECT acciones_insertadas.id,metas.gestion,metas.valor FROM acciones_insertadas JOIN (VALUES
('9.1',2026,3),('9.1',2027,3),('9.1',2028,4),('9.1',2029,4),('9.1',2030,3),
('9.2',2026,2),('9.2',2027,3),('9.2',2028,3),('9.2',2029,3),('9.2',2030,2),
('9.3',2026,4),('9.3',2027,2),('9.3',2028,2),('9.3',2029,2),('9.3',2030,0),
('9.4',2026,13),('9.4',2027,13),('9.4',2028,13),('9.4',2029,13),('9.4',2030,13),
('9.5',2026,5),('9.5',2027,4),('9.5',2028,1),('9.5',2029,2),('9.5',2030,0)
) AS metas(codigo,gestion,valor) ON metas.codigo=acciones_insertadas.codigo
ON CONFLICT (accion_id,gestion) DO UPDATE SET valor_programado=EXCLUDED.valor_programado;

COMMIT;
