
## ✅ **1. Trigger de auditoría de cambios de estado en tareas (`trg_cambio_estado`)**

### 🔹 Objetivo:

Registrar automáticamente en la tabla `historial` cada vez que se cambia el estado de una tarea.

### 🧪 Ejemplo:

```sql
-- Supongamos que tenemos la tarea con id 1 en estado 1 (Pendiente)

-- Actualizamos su estado a 'En Curso' (id_estado = 2)
UPDATE tareas
SET id_estado = 2
WHERE id_tarea = 1;

-- Verificamos que se registró en el historial
SELECT * FROM historial
WHERE id_tarea = 1;
```

🔎 **Resultado esperado:** Se inserta una fila en `historial` con tipo\_cambio = 'Cambio de estado', creador correspondiente, y la descripción con el estado anterior y nuevo.

---

## ✅ **2. Trigger de notificación al asignar un usuario a una tarea (`trg_notificar_asignacion`)**

### 🔹 Objetivo:

Enviar automáticamente una notificación al usuario cuando se le asigna una tarea.

### 🧪 Ejemplo:

```sql
-- Asignamos a Julia Torres (id_usuario = 5) a la tarea 3
INSERT INTO tarea_usuarios (id_tarea, id_usuario)
VALUES (3, 5);

-- Consultamos las notificaciones de Julia
SELECT * FROM notificaciones
WHERE id_usuario = 5;
```

🔎 **Resultado esperado:** Se genera una notificación del tipo: *"Has sido asignado a la tarea ID 3"* con la fecha actual.

---

## ✅ **3. Trigger de validación de fechas de entregables (`trg_validar_fecha_entrega`)**

### 🔹 Objetivo:

Evitar registrar entregables con una `fecha_entrega_real` anterior a la `fecha_entrega_prev`.

### 🧪 Ejemplo correcto (✅):

```sql
-- Este insert es válido (real >= prevista)
INSERT INTO entregables (id_proyecto, nombre, descripcion, responsable, fecha_entrega_prev, fecha_entrega_real, id_estado, version)
VALUES (1, 'Validación Trigger', 'Prueba exitosa', 1, '2025-06-01', '2025-06-02', 1, 'v1.0');
```

### 🧪 Ejemplo incorrecto (❌):

```sql
-- Este insert debería lanzar un error
INSERT INTO entregables (id_proyecto, nombre, descripcion, responsable, fecha_entrega_prev, fecha_entrega_real, id_estado, version)
VALUES (1, 'Error de Fecha', 'Debe fallar', 1, '2025-06-05', '2025-06-01', 1, 'v1.0');
```

🔴 **Resultado esperado:** El segundo insert fallará con un error como:

```
ERROR: La fecha de entrega real (2025-06-01), no puede ser anterior a la prevista (2025-06-05)
```

