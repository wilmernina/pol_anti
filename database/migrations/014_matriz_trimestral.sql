ALTER TABLE acciones
  ADD COLUMN IF NOT EXISTS linea_base NUMERIC,
  ADD COLUMN IF NOT EXISTS tipo_accion VARCHAR(30),
  ADD COLUMN IF NOT EXISTS medio_verificacion TEXT,
  ADD COLUMN IF NOT EXISTS estado_planificacion VARCHAR(20) NOT NULL DEFAULT 'borrador';

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'acciones_estado_planificacion_chk'
  ) THEN
    ALTER TABLE acciones
      ADD CONSTRAINT acciones_estado_planificacion_chk
      CHECK (estado_planificacion IN ('borrador', 'publicada'));
  END IF;
END $$;

UPDATE acciones
SET estado_planificacion = 'publicada'
WHERE estado_planificacion = 'borrador';

CREATE TABLE IF NOT EXISTS metas_trimestrales (
  id SERIAL PRIMARY KEY,
  accion_id INT NOT NULL REFERENCES acciones(id) ON DELETE CASCADE,
  gestion INT NOT NULL CHECK (gestion BETWEEN 2026 AND 2030),
  trimestre INT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
  cantidad_programada NUMERIC NOT NULL CHECK (cantidad_programada >= 0),
  cantidad_ejecutada NUMERIC NOT NULL DEFAULT 0 CHECK (cantidad_ejecutada >= 0),
  observaciones TEXT,
  UNIQUE (accion_id, gestion, trimestre)
);

CREATE INDEX IF NOT EXISTS idx_metas_trimestrales_accion
  ON metas_trimestrales(accion_id, gestion);
