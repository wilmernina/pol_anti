ALTER TABLE usuarios DROP CONSTRAINT IF EXISTS usuarios_rol_check;
ALTER TABLE usuarios DROP CONSTRAINT IF EXISTS usuarios_rol_fkey;
ALTER TABLE usuarios ADD CONSTRAINT usuarios_rol_fkey FOREIGN KEY (rol) REFERENCES roles(codigo);
