CREATE TABLE IF NOT EXISTS resultados_cuatrimestrales (
  id SERIAL PRIMARY KEY,
  accion_id INT NOT NULL REFERENCES acciones(id) ON DELETE CASCADE,
  gestion INT NOT NULL CHECK (gestion BETWEEN 2026 AND 2030),
  cuatrimestre INT NOT NULL CHECK (cuatrimestre BETWEEN 1 AND 3),
  valor_resultado NUMERIC NOT NULL CHECK (valor_resultado >= 0),
  observaciones TEXT,
  usuario_id INT REFERENCES usuarios(id),
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (accion_id, gestion, cuatrimestre)
);
CREATE INDEX IF NOT EXISTS idx_resultados_cuat_accion ON resultados_cuatrimestrales(accion_id);
CREATE INDEX IF NOT EXISTS idx_resultados_cuat_gestion ON resultados_cuatrimestrales(gestion);
