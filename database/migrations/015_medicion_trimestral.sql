ALTER TABLE metas_trimestrales
  ADD COLUMN IF NOT EXISTS medio_verificacion TEXT,
  ADD COLUMN IF NOT EXISTS evidencia_url TEXT,
  ADD COLUMN IF NOT EXISTS usuario_id INT REFERENCES usuarios(id),
  ADD COLUMN IF NOT EXISTS fecha_registro TIMESTAMP;

CREATE INDEX IF NOT EXISTS idx_metas_trimestrales_usuario
  ON metas_trimestrales(usuario_id);
