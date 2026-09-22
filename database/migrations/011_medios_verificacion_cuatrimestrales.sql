ALTER TABLE resultados_cuatrimestrales
  ADD COLUMN IF NOT EXISTS medio_verificacion TEXT,
  ADD COLUMN IF NOT EXISTS referencia_verificacion TEXT,
  ADD COLUMN IF NOT EXISTS evidencias JSONB NOT NULL DEFAULT '[]'::jsonb;
