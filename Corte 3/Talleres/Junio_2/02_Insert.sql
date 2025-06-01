--Roles
INSERT INTO roles (id_rol, nombre) VALUES
(1, 'Administrador'),
(2, 'Manager'),
(3, 'Colaborador'),
(4, 'Estudiante'),
(5, 'Tutor');

--Estados
INSERT INTO estados (id_estado, nombre) VALUES
(1, 'Pendiente'),
(2, 'En Curso'),
(3, 'Finalizada'),
(4, 'Cancelada');

--Prioridades
INSERT INTO prioridades (id_prioridad, nombre) VALUES
(1, 'Alta'),
(2, 'Media'),
(3, 'Baja');


--Categorias
INSERT INTO categorias (nombre, descripcion) VALUES
('Documentación', 'Tareas relacionadas con documentos'),
('Desarrollo', 'Programación y desarrollo de software'),
('Pruebas', 'Testeo de funcionalidades'),
('Diseño', 'Diseño de interfaces y gráficos'),
('Investigación', 'Tareas de análisis e investigación');

--Usuarios
INSERT INTO usuarios (nombre, email, password, id_rol) VALUES
('Ana Ruiz', 'ana@example.com', 'pass123', 1),
('Luis Pérez', 'luis@example.com', 'pass456', 2),
('Marta Díaz', 'marta@example.com', 'pass789', 3),
('Carlos Méndez', 'carlos@example.com', 'passabc', 4),
('Julia Torres', 'julia@example.com', 'passxyz', 5);

--Proyectos
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, estado) VALUES
('Proyecto A', 'Implementación del sistema', '2025-01-01', '2025-06-01', 1),
('Proyecto B', 'Migración de datos', '2025-02-01', '2025-05-15', 2),
('Proyecto C', 'Rediseño web', '2025-03-01', '2025-07-01', 3),
('Proyecto D', 'Automatización de procesos', '2025-01-20', '2025-04-30', 1),
('Proyecto E', 'Investigación UX', '2025-04-01', '2025-08-01', 2);

--Proyecto_usuario
INSERT INTO proyecto_usuarios (id_usuario, id_proyecto, rol_proyecto) VALUES
(1, 1, 'Líder'),
(2, 1, 'Analista'),
(3, 2, 'Tester'),
(4, 3, 'Diseñador'),
(5, 4, 'Investigador');

--Tareas
INSERT INTO tareas (id_proyecto, nombre, descripcion, fecha_limite, id_estado, id_prioridad, id_categoria, creador) VALUES
(1, 'Analizar requerimientos', 'Reunión con stakeholders', '2025-01-15', 1, 1, 5, 1),
(2, 'Diseñar mockups', 'Diseño visual de interfaz', '2025-02-10', 2, 2, 4, 4),
(3, 'Programar API', 'Desarrollar endpoints REST', '2025-03-20', 2, 1, 2, 2),
(4, 'Test de integración', 'Pruebas cruzadas', '2025-04-05', 1, 3, 3, 3),
(5, 'Documentar funcionalidades', 'Manual de usuario', '2025-05-01', 3, 2, 1, 5);

--Subtareas
INSERT INTO subtareas (id_tarea, nombre, descripcion, id_estado, responsable) VALUES
(1, 'Revisar requerimientos', 'Verificar con cliente', 1, 1),
(2, 'Crear prototipo', 'Figma y Adobe XD', 2, 4),
(3, 'Programar controlador', 'Logica de negocio', 2, 2),
(4, 'Test unitario', 'Cobertura del 80%', 1, 3),
(5, 'Redacción de manual', 'Sección de instalación', 3, 5);

--Etiquetas
INSERT INTO etiquetas (nombre) VALUES
('Urgente'),
('Frontend'),
('Backend'),
('Investigación'),
('Documentación');

--Tarea_etiquetas
INSERT INTO tarea_etiquetas (id_tarea, id_etiqueta) VALUES
(1, 4),
(2, 1),
(3, 3),
(4, 2),
(5, 5);

--Tarea_usuarios
INSERT INTO tarea_usuarios (id_tarea, id_usuario) VALUES
(1, 1),
(2, 4),
(3, 2),
(4, 3),
(5, 5);

--Entregables
INSERT INTO entregables (id_proyecto, nombre, descripcion, responsable, fecha_entrega_prev, fecha_entrega_real, id_estado, version) VALUES
(1, 'Informe inicial', 'Documento de análisis', 1, '2025-01-10', '2025-01-09', 3, 'v1.0'),
(2, 'Diseño UX', 'Prototipo interactivo', 4, '2025-02-05', NULL, 1, 'v0.9'),
(3, 'API funcional', 'Versión funcional REST', 2, '2025-03-15', NULL, 1, 'v0.1'),
(4, 'Pruebas ejecutadas', 'Evidencias de pruebas', 3, '2025-04-10', '2025-04-09', 3, 'v1.1'),
(5, 'Manual técnico', 'Guía para devs', 5, '2025-05-01', NULL, 1, 'draft');

--Revision_entregable
INSERT INTO revision_entregable (id_entregable, revisor, comentario, estado_post_review, version_revision) VALUES
(1, 2, 'Todo correcto', 3, 'v1.1'),
(2, 3, 'Falta navegación', 1, 'v0.95'),
(3, 4, 'Error en endpoint', 1, 'v0.2'),
(4, 5, 'Bien documentado', 3, 'v1.2'),
(5, 1, 'Agregar índice', 2, 'draft-2');

--Archivo_Tarea
INSERT INTO archivo_tarea (id_tarea, nombre_archivo, ruta_archivo, subido_por) VALUES
(1, 'requerimientos.pdf', '/docs/requerimientos.pdf', 1),
(2, 'mockup.fig', '/designs/mockup.fig', 4),
(3, 'api_postman.json', '/apis/postman.json', 2),
(4, 'pruebas.xlsx', '/tests/pruebas.xlsx', 3),
(5, 'manual.docx', '/docs/manual.docx', 5);

--Archivo_entregable
INSERT INTO archivo_entregable (id_entregable, nombre_archivo, ruta_archivo, subido_por) VALUES
(1, 'informe.pdf', '/entregables/informe.pdf', 1),
(2, 'ux_design.fig', '/ux/ux_design.fig', 4),
(3, 'api_code.zip', '/dev/api_code.zip', 2),
(4, 'test_report.pdf', '/qa/test_report.pdf', 3),
(5, 'tech_guide.pdf', '/docs/tech_guide.pdf', 5);

--Comentarios
INSERT INTO comentarios (id_tarea, id_usuario, contenido) VALUES
(1, 1, 'Revisar punto 3 del documento.'),
(2, 4, 'Agregar botón de búsqueda.'),
(3, 2, 'Endpoint GET no devuelve datos.'),
(4, 3, 'Cobertura menor al esperado.'),
(5, 5, 'Manual casi listo, falta la portada.');

--Historial
INSERT INTO historial (id_tarea, id_usuario, tipo_cambio, detalles) VALUES
(1, 1, 'Creación', 'Tarea creada'),
(2, 4, 'Edición', 'Cambiado nombre'),
(3, 2, 'Asignación', 'Asignado a Luis'),
(4, 3, 'Comentario', 'Añadido nuevo comentario'),
(5, 5, 'Entrega', 'Manual entregado');

--Notificaciones
INSERT INTO notificaciones (id_usuario, mensaje) VALUES
(1, 'Tienes una nueva tarea asignada.'),
(2, 'Revisión pendiente de API.'),
(3, 'Pruebas agendadas para mañana.'),
(4, 'Mockups aprobados.'),
(5, 'Revisar entrega del manual.');
