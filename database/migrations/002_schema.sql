CREATE TABLE ejes (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(2) UNIQUE NOT NULL CHECK (codigo IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')),
  nombre TEXT NOT NULL,
  objetivo TEXT,
  indicadores_principales TEXT,
  resultados_2030 TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE instituciones (
  id SERIAL PRIMARY KEY,
  siglas VARCHAR(50) UNIQUE NOT NULL,
  nombre TEXT NOT NULL,
  ministerio VARCHAR(150),
  rol VARCHAR(30) CHECK (rol IN ('coordinador', 'ejecutor', 'apoyo')),
  activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE acciones (
  id SERIAL PRIMARY KEY,
  eje_id INT REFERENCES ejes(id) ON DELETE CASCADE,
  codigo VARCHAR(10) NOT NULL,
  nombre TEXT NOT NULL,
  resultado TEXT,
  indicador_proceso TEXT,
  unidad_medida VARCHAR(30),
  meta_2030 NUMERIC,
  institucion_principal_id INT REFERENCES instituciones(id),
  instituciones_apoyo TEXT,
  orden INT,
  UNIQUE (eje_id, codigo)
);

CREATE TABLE metas_fisicas (
  id SERIAL PRIMARY KEY,
  accion_id INT REFERENCES acciones(id) ON DELETE CASCADE,
  gestion INT CHECK (gestion BETWEEN 2026 AND 2030),
  valor_programado NUMERIC,
  valor_ejecutado NUMERIC DEFAULT 0,
  porcentaje_avance NUMERIC GENERATED ALWAYS AS (
    CASE
      WHEN valor_programado > 0 THEN (valor_ejecutado / valor_programado) * 100
      ELSE 0
    END
  ) STORED,
  evidencia_url TEXT,
  fecha_reporte DATE,
  validado BOOLEAN DEFAULT FALSE,
  validado_por INT,
  observaciones TEXT,
  UNIQUE (accion_id, gestion)
);

CREATE TABLE presupuesto (
  id SERIAL PRIMARY KEY,
  eje_id INT REFERENCES ejes(id),
  institucion_id INT REFERENCES instituciones(id),
  fuente VARCHAR(10) CHECK (fuente IN ('10', '11', '41', 'INV')),
  gestion INT,
  monto_programado NUMERIC,
  monto_ejecutado NUMERIC DEFAULT 0,
  UNIQUE (eje_id, institucion_id, fuente, gestion)
);

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  nombre_completo TEXT,
  email TEXT,
  institucion_id INT REFERENCES instituciones(id),
  rol VARCHAR(30) CHECK (rol IN ('admin', 'coordinador_cpi', 'responsable_institucional', 'analista_vdssc', 'observador', 'publico')),
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE reportes_avance (
  id SERIAL PRIMARY KEY,
  meta_fisica_id INT REFERENCES metas_fisicas(id),
  usuario_id INT REFERENCES usuarios(id),
  valor_reportado NUMERIC,
  fecha_reporte TIMESTAMP DEFAULT NOW(),
  justificacion TEXT,
  estado VARCHAR(20) CHECK (estado IN ('borrador', 'enviado', 'validado', 'rechazado')),
  validado_por INT REFERENCES usuarios(id),
  fecha_validacion TIMESTAMP
);

CREATE TABLE evidencias (
  id SERIAL PRIMARY KEY,
  reporte_id INT REFERENCES reportes_avance(id) ON DELETE CASCADE,
  nombre_archivo TEXT,
  url TEXT,
  tipo_mime VARCHAR(50),
  tamaño_bytes BIGINT,
  subido_por INT REFERENCES usuarios(id),
  fecha_subida TIMESTAMP DEFAULT NOW()
);

CREATE TABLE auditoria (
  id SERIAL PRIMARY KEY,
  tabla_afectada VARCHAR(50),
  registro_id INT,
  accion VARCHAR(20) CHECK (accion IN ('INSERT', 'UPDATE', 'DELETE')),
  usuario_id INT,
  datos_anteriores JSONB,
  datos_nuevos JSONB,
  fecha TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_acciones_eje ON acciones(eje_id);
CREATE INDEX idx_metas_accion ON metas_fisicas(accion_id);
CREATE INDEX idx_metas_gestion ON metas_fisicas(gestion);
CREATE INDEX idx_reportes_meta ON reportes_avance(meta_fisica_id);

CREATE OR REPLACE FUNCTION set_ejes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ejes_updated_at
BEFORE UPDATE ON ejes
FOR EACH ROW
EXECUTE FUNCTION set_ejes_updated_at();
