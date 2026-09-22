CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50) UNIQUE NOT NULL,
  nombre TEXT NOT NULL,
  descripcion TEXT,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  sistema BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
INSERT INTO roles (codigo, nombre, descripcion, sistema) VALUES
 ('admin', 'Administrador', 'Administración completa del sistema', TRUE),
 ('coordinador_cpi', 'Coordinador CPI', 'Consulta general y aprobación de reportes', TRUE),
 ('responsable_institucional', 'Responsable institucional', 'Registro de avances de su institución', TRUE),
 ('analista_vdssc', 'Analista VDSSC', 'Validación y generación de reportes', TRUE),
 ('observador', 'Observador', 'Consulta de información', TRUE),
 ('publico', 'Público', 'Acceso público al dashboard', TRUE)
ON CONFLICT (codigo) DO NOTHING;
