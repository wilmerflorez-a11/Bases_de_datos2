
### ✅ **Caso 1: Auditoría de cambios en tareas**

**Problema:** Necesitamos registrar automáticamente cuándo una tarea cambia de estado, para llevar un historial de seguimiento.

**✅ Solución:** Crear un trigger que inserte un registro en la tabla `historial` cada vez que se actualiza el campo `id_estado` en la tabla `tareas`.

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION registrar_cambio_estado()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_estado IS DISTINCT FROM OLD.id_estado THEN
        INSERT INTO historial (id_tarea, id_usuario, tipo_cambio, detalles, fecha_hora)
        VALUES (OLD.id_tarea, NEW.creador, 'Cambio de estado', 
                'Estado anterior: ' || OLD.id_estado || ', nuevo: ' || NEW.id_estado,
                CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_cambio_estado
AFTER UPDATE ON tareas
FOR EACH ROW
WHEN (OLD.id_estado IS DISTINCT FROM NEW.id_estado)
EXECUTE FUNCTION registrar_cambio_estado();
```

---

### ✅ **Caso 2: Notificación automática al asignar usuario a una tarea**

**Problema:** Cuando un usuario es asignado a una tarea (`tarea_usuarios`), es necesario notificarlo automáticamente.

**✅ Solución:** Crear un trigger que genere un mensaje de notificación al insertar una nueva asignación en `tarea_usuarios`.

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION notificar_asignacion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO notificaciones (id_usuario, mensaje, fecha_envio)
    VALUES (NEW.id_usuario, 
            'Has sido asignado a la tarea ID ' || NEW.id_tarea, 
            CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_notificar_asignacion
AFTER INSERT ON tarea_usuarios
FOR EACH ROW
EXECUTE FUNCTION notificar_asignacion();
```

---

### ✅ **Caso 3: Validación automática de fechas en entregables**

**Problema:** Queremos evitar que alguien registre un entregable con una `fecha_entrega_real` anterior a la `fecha_entrega_prev`.

**✅ Solución:** Crear un trigger que lance un error si se intenta guardar un entregable con fechas inconsistentes.

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION validar_fecha_entrega()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_entrega_real IS NOT NULL AND 
       NEW.fecha_entrega_real < NEW.fecha_entrega_prev THEN
        RAISE EXCEPTION 'La fecha de entrega real (%), no puede ser anterior a la prevista (%)',
                        NEW.fecha_entrega_real, NEW.fecha_entrega_prev;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_validar_fecha_entrega
BEFORE INSERT OR UPDATE ON entregables
FOR EACH ROW
EXECUTE FUNCTION validar_fecha_entrega();
```



