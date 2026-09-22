# Diseño de reporte de avance

La ruta `/reportar/:accionId` consulta la acción y meta seleccionada y muestra un formulario `react-hook-form`. Calcula avance, valida límites, justificación bajo 70% y evidencia cuando existe ejecución.

El backend recibe `multipart/form-data` con `multer`, valida `x-user-id`, crea `reportes_avance`, actualiza la meta y registra archivos en `evidencias` dentro de una transacción. Los archivos permitidos son PDF, imágenes y Excel, se guardan bajo `backend/uploads/` y se exponen como URL pública.

Guardar crea estado `borrador`; enviar crea estado `enviado`. Tras éxito se redirige a la vista del eje; cancelar no envía datos.
