CREATE OR REPLACE PROCEDURE create_task_view_by_tag(id_tag INTEGER)
AS $$
DECLARE
    tag_name TEXT;
    view_name TEXT;
BEGIN
    -- Obtener el nombre de la etiqueta para informar
    SELECT tg_name INTO tag_name FROM tags WHERE tgid = id_tag;

    IF tag_name IS NULL THEN
        RAISE NOTICE 'No se encontró la etiqueta con ID %', id_tag;
        RETURN;
    END IF;

    -- Construir nombre dinámico de la vista
    view_name := format('view_tasks_by_tag_%s', id_tag);

    -- Crear o reemplazar la vista con las tareas de la etiqueta indicada
    EXECUTE format(
        'CREATE OR REPLACE VIEW %I AS
         SELECT t.tid, t.title, t.summary, t.status, t.created_date, t.limit_date
         FROM tasks t
         JOIN task_tags tt ON t.tid = tt.tid
         WHERE tt.tgid = %L',
         view_name, id_tag
    );

    RAISE NOTICE 'Vista % creada exitosamente para la etiqueta: %', view_name, tag_name;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE clonar_tareas_y_listar_resumen(
    usuario_origen INT,
    usuario_destino INT
) AS $$
DECLARE
    tarea RECORD;
    nueva_tarea_id INT;
    contador INT := 1;
    nombre_usuario TEXT;
    etiquetas TEXT;
    prioridad_nombre TEXT;
BEGIN
    -- Clonamos las tareas del usuario_origen al usuario_destino
    FOR tarea IN
        SELECT * FROM tareas WHERE usuario_id = usuario_origen
    LOOP
        INSERT INTO tareas(titulo, descripcion, fecha_limite, usuario_id, prioridad_id)
        VALUES (tarea.titulo, tarea.descripcion, tarea.fecha_limite, usuario_destino, tarea.prioridad_id)
        RETURNING id INTO nueva_tarea_id;

        -- Clonar etiquetas asociadas
        INSERT INTO tareas_etiquetas(tarea_id, etiqueta_id)
        SELECT nueva_tarea_id, etiqueta_id FROM tareas_etiquetas WHERE tarea_id = tarea.id;
    END LOOP;

    -- Obtener nombre del usuario destino
    SELECT nombre INTO nombre_usuario FROM usuarios WHERE id = usuario_destino;

    -- Mostrar resumen de tareas del usuario_destino
    RAISE NOTICE 'Resumen de tareas para el usuario: %', nombre_usuario;

    FOR tarea IN
        SELECT t.id, t.titulo, p.nombre AS prioridad
        FROM tareas t
        JOIN prioridades p ON t.prioridad_id = p.id
        WHERE t.usuario_id = usuario_destino
    LOOP
        -- Concatenar etiquetas
        SELECT string_agg(e.nombre, ', ') INTO etiquetas
        FROM tareas_etiquetas te
        JOIN etiquetas e ON te.etiqueta_id = e.id
        WHERE te.tarea_id = tarea.id;

        RAISE NOTICE '#% - % - % - % - %', contador, nombre_usuario, tarea.titulo, tarea.prioridad, etiquetas;
        contador := contador + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION nombre_tarea(uid INT, tid INT)
RETURNS TEXT AS $$
DECLARE
    nombre_usuario TEXT;
    titulo_tarea TEXT;
BEGIN
    SELECT u.nombre INTO nombre_usuario
    FROM usuarios u WHERE u.id = uid;

    SELECT t.titulo INTO titulo_tarea
    FROM tareas t WHERE t.id = tid;

    RETURN nombre_usuario || ' - ' || titulo_tarea;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE resumen_tareas_completo()
AS $$
DECLARE
    reg_tarea RECORD;
    etiquetas TEXT;
    linea TEXT;
    prioridad_nombre TEXT;
    contador INT := 1;
BEGIN
    FOR reg_tarea IN
        SELECT t.id, t.titulo, t.usuario_id, t.prioridad_id
        FROM tareas t
    LOOP
        -- Obtener nombre de prioridad
        SELECT p.nombre INTO prioridad_nombre
        FROM prioridades p WHERE p.id = reg_tarea.prioridad_id;

        -- Obtener etiquetas concatenadas
        SELECT string_agg(e.nombre, ', ') INTO etiquetas
        FROM tareas_etiquetas te
        JOIN etiquetas e ON e.id = te.etiqueta_id
        WHERE te.tarea_id = reg_tarea.id;

        -- Llamar a la función que genera "Nombre - Tarea"
        linea := nombre_tarea(reg_tarea.usuario_id, reg_tarea.id);

        -- Mostrar resumen completo
        RAISE NOTICE '#% - % - % - %', contador, linea, prioridad_nombre, etiquetas;

        contador := contador + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION nombre_tarea(uid INT, tid INT)
RETURNS TEXT AS $$
DECLARE
    nombre_usuario TEXT;
    titulo_tarea TEXT;
BEGIN
    SELECT u.nombre INTO nombre_usuario
    FROM usuarios u WHERE u.id = uid;

    SELECT t.titulo INTO titulo_tarea
    FROM tareas t WHERE t.id = tid;

    RETURN nombre_usuario || ' - ' || titulo_tarea;
END;
$$ LANGUAGE plpgsql;
--
CREATE OR REPLACE PROCEDURE crear_vista_materializada_usuario(
    pid_usuario INT,
    pnombre_vista TEXT
)
AS $$
BEGIN
    -- Eliminar la vista si ya existe
    EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %I;', pnombre_vista);

    -- Crear la nueva vista materializada
    EXECUTE format(
        'CREATE MATERIALIZED VIEW %I AS
         SELECT t.id AS tarea_id,
                t.titulo,
                t.descripcion,
                t.fecha_limite,
                nombre_tarea(t.usuario_id, t.id) AS resumen,
                p.nombre AS prioridad
         FROM tareas t
         JOIN prioridades p ON p.id = t.prioridad_id
         WHERE t.usuario_id = %L
         WITH DATA;',
        pnombre_vista,
        pid_usuario
    );

    RAISE NOTICE 'Vista materializada % ha sido creada para el usuario %', pnombre_vista, pid_usuario;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE PROCEDURE crear_vista_materializada_usuario(
    pid_usuario INT,
    pnombre_vista TEXT
)
AS $$
BEGIN
    BEGIN
        -- Intentar eliminar la vista si ya existe
        EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS %I;', pnombre_vista);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'No se pudo eliminar la vista materializada %', pnombre_vista;
    END;

    BEGIN
        -- Intentar crear la nueva vista materializada
        EXECUTE format(
            'CREATE MATERIALIZED VIEW %I AS
             SELECT t.id AS tarea_id,
                    t.titulo,
                    t.descripcion,
                    t.fecha_limite,
                    nombre_tarea(t.usuario_id, t.id) AS resumen,
                    p.nombre AS prioridad
             FROM tareas t
             JOIN prioridades p ON p.id = t.prioridad_id
             WHERE t.usuario_id = %L
             WITH DATA;',
            pnombre_vista,
            pid_usuario
        );

        RAISE NOTICE 'Vista materializada % creada correctamente para usuario %', pnombre_vista, pid_usuario;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al crear la vista materializada: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

