# 📌 Disparadores (Triggers) en Bases de Datos

## ¿Qué son los Disparadores?

Los **disparadores** o *triggers* son objetos de la base de datos que **se ejecutan automáticamente** cuando ocurre un evento específico sobre una tabla o vista. Estos eventos pueden ser:

- **INSERT** (cuando se inserta un nuevo dato)
- **UPDATE** (cuando se actualiza un dato)
- **DELETE** (cuando se elimina un dato)

> 💡 En resumen, un disparador es como una "acción automática" que se dispara cuando ocurre algo en la base de datos.

---

## ¿Para qué sirven los Disparadores?

Los disparadores se usan para **automatizar tareas** y **controlar la integridad de los datos**. Algunos usos comunes son:

- Validar datos antes de que se inserten o actualicen.
- Registrar cambios en una tabla de auditoría.
- Calcular valores automáticamente (como actualizar un total).
- Prevenir acciones indebidas (por ejemplo, no permitir eliminar registros importantes).

---

## ✅ Ventajas de los Disparadores

- ⚙️ Automatizan tareas repetitivas.
- 🔐 Refuerzan la integridad de los datos sin depender del código de la aplicación.
- 📊 Se pueden usar para auditoría (registrar quién hizo qué y cuándo).
- ♻️ Permiten mantener consistencia entre tablas relacionadas.

---

## ❌ Desventajas de los Disparadores

- 🔄 Pueden hacer que el comportamiento de la base de datos sea difícil de entender (si hay muchos triggers ocultos).
- 🐢 Disminuyen el rendimiento si no se usan bien (porque agregan operaciones adicionales).
- 🧪 Complican la depuración (a veces no es fácil saber qué disparador está fallando).
- 🔄 No todos los SGBD (como MySQL, PostgreSQL, Oracle, etc.) los manejan exactamente igual.

---

## 🔤 Sintaxis básica de un Disparador

La sintaxis puede variar según el motor de base de datos, pero este es un ejemplo general en **PostgreSQL**:

```sql
CREATE OR REPLACE FUNCTION nombre_funcion()
RETURNS TRIGGER AS $$
BEGIN
    -- Aquí va el código que se ejecutara
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER nombre_disparador
AFTER INSERT ON nombre_tabla
FOR EACH ROW
EXECUTE FUNCTION nombre_funcion();

