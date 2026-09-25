ALTER TABLE metas_trimestrales
  ADD COLUMN IF NOT EXISTS evidencias JSONB NOT NULL DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS justificacion TEXT,
  ADD COLUMN IF NOT EXISTS medidas_correctivas TEXT;
