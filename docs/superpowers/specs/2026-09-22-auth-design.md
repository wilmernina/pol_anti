# Diseño de autenticación y roles

JWT firmado con `JWT_SECRET` y expiración de ocho horas identifica usuarios activos. `bcrypt` protege contraseñas. Login emite token; `me` devuelve perfil; register requiere rol admin. Un seed idempotente crea `admin` con contraseña inicial `admin123` hasheada.

Middleware `verificarToken` carga el usuario y `verificarRol` restringe operaciones. Admin tiene acceso completo; coordinador CPI aprueba; responsable institucional reporta para su institución; analista VDSSC valida y genera; observador y público solo leen.

React mantiene token y perfil en contexto/localStorage, protege rutas y muestra header con usuario e institución. Se retirará `react-hook-form` del backend.
