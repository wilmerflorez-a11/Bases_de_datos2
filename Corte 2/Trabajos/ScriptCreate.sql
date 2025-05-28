-- 1. Catálogos estáticos

CREATE TABLE roles (
    id_rol SMALLINT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE,
    CHECK (nombre IN ('Administrador', 'Manager', 'Colaborador', 'Estudiante', 'Tutor'))
);

CREATE TABLE estados (
    id_estado SMALLINT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE,
    CHECK (nombre IN ('Pendiente', 'En Curso', 'Finalizada', 'Cancelada'))
);

CREATE TABLE prioridades (
    id_prioridad SMALLINT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE,
    CHECK (nombre IN ('Alta', 'Media', 'Baja'))
);

CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- 2. Usuarios

CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    id_rol SMALLINT NOT NULL REFERENCES roles(id_rol),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Proyectos

CREATE TABLE proyectos (
    id_proyecto SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado SMALLINT NOT NULL REFERENCES estados(id_estado),
    CHECK (fecha_inicio < fecha_fin)
);

CREATE TABLE proyecto_usuarios (
    id_usuario INT REFERENCES usuarios(id_usuario),
    id_proyecto INT REFERENCES proyectos(id_proyecto),
    rol_proyecto VARCHAR(30) NOT NULL,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_usuario, id_proyecto)
);

-- 4. Tareas y Subtareas

CREATE TABLE tareas (
    id_tarea SERIAL PRIMARY KEY,
    id_proyecto INT REFERENCES proyectos(id_proyecto),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_limite DATE,
    id_estado SMALLINT NOT NULL REFERENCES estados(id_estado),
    id_prioridad SMALLINT NOT NULL REFERENCES prioridades(id_prioridad),
    id_categoria INT REFERENCES categorias(id_categoria),
    creador INT REFERENCES usuarios(id_usuario)
);

CREATE TABLE subtareas (
    id_subtarea SERIAL PRIMARY KEY,
    id_tarea INT REFERENCES tareas(id_tarea),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    id_estado SMALLINT NOT NULL REFERENCES estados(id_estado),
    responsable INT REFERENCES usuarios(id_usuario)
);

-- 5. Etiquetas

CREATE TABLE etiquetas (
    id_etiqueta SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tarea_etiquetas (
    id_tarea INT REFERENCES tareas(id_tarea),
    id_etiqueta INT REFERENCES etiquetas(id_etiqueta),
    PRIMARY KEY (id_tarea, id_etiqueta)
);

-- 6. Asignaciones

CREATE TABLE tarea_usuarios (
    id_tarea INT REFERENCES tareas(id_tarea),
    id_usuario INT REFERENCES usuarios(id_usuario),
    fecha_asignada DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_tarea, id_usuario)
);

-- 7. Entregables y revisiones

CREATE TABLE entregables (
    id_entregable SERIAL PRIMARY KEY,
    id_proyecto INT REFERENCES proyectos(id_proyecto),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    responsable INT REFERENCES usuarios(id_usuario),
    fecha_entrega_prev DATE,
    fecha_entrega_real DATE,
    id_estado SMALLINT REFERENCES estados(id_estado),
    version VARCHAR(20)
);

CREATE TABLE revision_entregable (
    id_revision SERIAL PRIMARY KEY,
    id_entregable INT REFERENCES entregables(id_entregable),
    revisor INT REFERENCES usuarios(id_usuario),
    fecha_revision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT,
    estado_post_review SMALLINT REFERENCES estados(id_estado),
    version_revision VARCHAR(20)
);

-- 8. Archivos adjuntos

CREATE TABLE archivo_tarea (
    id_archivo SERIAL PRIMARY KEY,
    id_tarea INT REFERENCES tareas(id_tarea),
    nombre_archivo VARCHAR(200) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    subido_por INT REFERENCES usuarios(id_usuario),
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE archivo_entregable (
    id_archivo SERIAL PRIMARY KEY,
    id_entregable INT REFERENCES entregables(id_entregable),
    nombre_archivo VARCHAR(200) NOT NULL,
    ruta_archivo VARCHAR(500) NOT NULL,
    subido_por INT REFERENCES usuarios(id_usuario),
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Comentarios, Notificaciones y Auditoría

CREATE TABLE comentarios (
    id_comentario SERIAL PRIMARY KEY,
    id_tarea INT REFERENCES tareas(id_tarea),
    id_usuario INT REFERENCES usuarios(id_usuario),
    contenido TEXT NOT NULL,
    fecha_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historial (
    id_historial SERIAL PRIMARY KEY,
    id_tarea INT REFERENCES tareas(id_tarea),
    id_usuario INT REFERENCES usuarios(id_usuario),
    tipo_cambio VARCHAR(30) NOT NULL,
    detalles TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES usuarios(id_usuario),
    mensaje TEXT NOT NULL,
    leido BOOLEAN DEFAULT FALSE,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
