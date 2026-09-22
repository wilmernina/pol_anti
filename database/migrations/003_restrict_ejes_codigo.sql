ALTER TABLE ejes
  DROP CONSTRAINT ejes_codigo_check,
  ADD CONSTRAINT ejes_codigo_check
    CHECK (codigo IN ('1', '2', '3', '4', '5', '6', '7', '8', '9'));
