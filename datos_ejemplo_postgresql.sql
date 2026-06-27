-- =========================================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE EJEMPLO PARA PRUEBAS (POSTGRESQL)
-- =========================================================================

-- FASE 1: ESTRUCTURA PERMANENTE E INSTITUCIONAL

INSERT INTO carrera (id_carrera, codigo, nombre, modalidad, estado) VALUES
(1, 'DS-01', 'Desarrollo de Software', 'DUAL', 'ACTIVO'),
(2, 'MKT-01', 'Marketing Digital', 'PRESENCIAL', 'ACTIVO'),
(3, 'EL-01', 'Electricidad Industrial', 'DUAL', 'ACTIVO');

INSERT INTO nivel (id_nivel, id_carrera, nombre, estado) VALUES
(4, 1, 'Cuarto Semestre', 'ACTIVO'),
(5, 1, 'Quinto Semestre', 'ACTIVO'),
(6, 2, 'Tercer Semestre', 'ACTIVO');

INSERT INTO asignatura (id_asignatura, id_nivel, codigo, nombre, horas, creditos) VALUES
(44, 4, 'PPP-401', 'Prácticas Pre Profesionales IV', 400, 10),
(45, 5, 'PPP-501', 'Prácticas Pre Profesionales V', 400, 10),
(46, 5, 'PROG-502', 'Programación Móvil Avanzada', 120, 4);

INSERT INTO jornada (id_jornada, nombre) VALUES
(1, 'MATUTINA'),
(2, 'VESPERTINA'),
(3, 'NOCTURNA');

INSERT INTO paralelo (id_paralelo, nombre) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');

INSERT INTO docente (id_docente, cedula, nombres, apellidos, correo) VALUES
(8, '1700000001', 'Ana', 'Martínez', 'amartinez@instituto.edu.ec'),
(9, '1700000002', 'Luis', 'Fernando', 'lfernando@instituto.edu.ec'),
(10, '1700000003', 'Carlos', 'Ruiz', 'cruiz@instituto.edu.ec');


-- FASE 2: APERTURA DEL PERÍODO Y OFERTA ACADÉMICA

INSERT INTO periodo_academico (id_periodo, codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES
(9, '2025-II', 'Período Lectivo 2025-II', '2025-10-01', '2026-02-28', 'INACTIVO'),
(10, '2026-I', 'Período Lectivo 2026-I', '2026-04-01', '2026-08-30', 'ACTIVO'),
(11, '2026-II', 'Período Lectivo 2026-II', '2026-10-01', '2027-02-28', 'PLANIFICADO');

INSERT INTO periodo_carrera (id_periodo_carrera, id_periodo, id_carrera, fecha_inicio, fecha_fin, fecha_inicio_fase_teorica, fecha_fin_fase_teorica, fecha_inicio_fase_practica, fecha_fin_fase_practica) VALUES
(24, 9, 1, '2025-10-01', '2026-02-28', '2025-10-01', '2025-12-30', '2026-01-01', '2026-02-28'),
(25, 10, 1, '2026-04-01', '2026-08-30', '2026-04-01', '2026-05-30', '2026-06-01', '2026-08-30'),
(26, 10, 2, '2026-04-01', '2026-08-30', '2026-04-01', '2026-07-30', null, null);

INSERT INTO oferta_asignatura (id_oferta_asignatura, id_periodo_carrera, id_asignatura, id_docente, id_jornada, id_paralelo, cupos) VALUES
(150, 25, 45, 8, 1, 1, 40),
(151, 25, 46, 8, 1, 1, 40),
(152, 25, 44, 9, 2, 2, 35);


-- FASE 3: MATRICULACIÓN DEL ESTUDIANTE

INSERT INTO estudiante (id_estudiante, cedula, nombres, apellidos) VALUES
(1, '1712345678', 'Juan Carlos', 'Pérez López'),
(2, '1723456789', 'María Fernanda', 'Gómez Silva'),
(3, '1734567890', 'Pedro Luis', 'Castro Vega');

INSERT INTO matricula (id_matricula, numero, id_estudiante, id_periodo, id_carrera, fecha_matricula, estado) VALUES
(800, 'MAT-2026-001', 1, 10, 1, '2026-03-25', 'ACTIVA'),
(801, 'MAT-2026-002', 2, 10, 1, '2026-03-26', 'ACTIVA'),
(802, 'MAT-2026-003', 3, 10, 1, '2026-03-27', 'ACTIVA');

INSERT INTO matricula_detalle (id_matricula_detalle, id_matricula, id_oferta_asignatura, nota_ap1, nota_ap2, nota_supletorio, estado) VALUES
(1005, 800, 150, 8.50, 9.00, null, 'APROBADO'),
(1006, 801, 150, 7.00, 6.50, 8.00, 'APROBADO'),
(1007, 802, 151, 9.50, 9.00, null, 'APROBADO');


-- FASE 4: MÓDULO DE FASE PRÁCTICA (DUAL)

INSERT INTO empresa (id_empresa, ruc, razon_social, direccion, estado) VALUES
(5, '1790010000001', 'TechCorp S.A.', 'Av. Principal', 'ACTIVO'),
(6, '1790020000001', 'DataSoft Cía', 'Av. Secundaria', 'ACTIVO'),
(7, '1790030000001', 'MegaRedes S.A.', 'Av. Tercera', 'ACTIVO');

INSERT INTO tutor_empresarial (id_tutor_empresarial, id_empresa, nombres, apellidos, cargo, estado) VALUES
(12, 5, 'Roberto', 'Gómez', 'Jefe Dev', 'ACTIVO'),
(13, 6, 'Lucía', 'Paz', 'Gerente', 'ACTIVO'),
(14, 7, 'Jorge', 'Torres', 'Sup. IT', 'ACTIVO');

INSERT INTO practica_estudiante (id_practica, id_periodo, id_matricula_detalle, id_empresa, id_tutor_empresarial, id_docente, total_horas_requeridas, estado) VALUES
(50, 10, 1005, 5, 12, 8, 400, 'EN_CURSO'),
(51, 10, 1006, 6, 13, 9, 400, 'EN_CURSO'),
(52, 10, 1007, 7, 14, 8, 400, 'EN_CURSO');

INSERT INTO plan_marco_formacion (id_plan_marco, id_nivel, estado) VALUES
(3, 5, 'ACTIVO');

INSERT INTO item_plan_marco (id_item_pm, id_plan_marco, resultado_aprendizaje, nivel_logro_esperado) VALUES
(201, 3, 'Desarrollar APIs RESTful', 4),
(202, 3, 'Administrar Bases de Datos', 3),
(203, 3, 'Despliegue en la Nube', 4);

INSERT INTO evaluacion_plan_marco (id_evaluacion_pm, id_practica, id_item_pm, nivel_real_alcanzado) VALUES
(801, 50, 201, 4),
(802, 50, 202, 4),
(803, 51, 201, 3);

INSERT INTO plan_rotacion (id_plan_rotacion, id_practica, id_item_pm, puesto_aprendizaje) VALUES
(301, 50, 201, 'Backend'),
(302, 50, 202, 'DBA'),
(303, 51, 201, 'Desarrollo');

INSERT INTO plan_rotacion_semana (id_rotacion_semana, id_plan_rotacion, semana) VALUES
(1, 301, 1),
(2, 301, 2),
(3, 302, 3);

INSERT INTO registro_diario_practica (id_registro_diario, id_practica, fecha, hora_ingreso, hora_salida_almuerzo, hora_regreso_almuerzo, hora_salida, firma_estudiante) VALUES
(1, 50, '2026-06-01', '08:00', '13:00', '14:00', '17:00', true),
(2, 50, '2026-06-02', '08:00', '13:00', '14:00', '17:00', true),
(3, 51, '2026-06-01', '09:00', '13:00', '14:00', '18:00', true);

INSERT INTO informe_aprendizaje (id_informe, id_practica, reflexion_aprendizaje) VALUES
(70, 50, 'Todo excelente'),
(71, 51, 'Muy complejo'),
(72, 52, 'Buen ambiente');

INSERT INTO bitacora_semanal (id_bitacora, id_informe, semana, actividades_realizadas) VALUES
(140, 70, 1, 'Creación de CRUD'),
(141, 71, 1, 'Diseño de interfaces'),
(142, 72, 1, 'Testing');

-- Motor de Rúbricas
INSERT INTO catalogo_rubrica (id_rubrica, nombre, tipo, estado) VALUES
(1, 'Evaluación Académica Práctica', 'ACADEMICA', 'ACTIVO'),
(2, 'Evaluación Empresarial Práctica', 'EMPRESARIAL', 'ACTIVO'),
(4, 'Rúbrica de Vinculación', 'VINCULACION', 'ACTIVO');

INSERT INTO item_rubrica (id_item, id_rubrica, descripcion_criterio, puntaje_maximo, ponderacion) VALUES
(901, 2, 'Calidad técnica del trabajo', 10.00, 100),
(902, 1, 'Cumplimiento de bitácoras', 10.00, 100),
(903, 4, 'Impacto social del proyecto', 10.00, 50),
(904, 4, 'Aplicación de conocimientos', 10.00, 50);

INSERT INTO evaluacion_practica (id_evaluacion, id_practica, id_rubrica, tipo_evaluador, nota_final_calculada) VALUES
(500, 50, 2, 'EMPRESARIAL', 9.00),
(501, 50, 1, 'ACADEMICA', 8.50),
(502, 51, 2, 'EMPRESARIAL', 7.00);

INSERT INTO detalle_evaluacion (id_detalle_evaluacion, id_evaluacion, id_item, puntaje_asignado) VALUES
(1, 500, 901, 9.00),
(2, 501, 902, 8.50),
(3, 502, 901, 7.00);


-- FASE 5: CV DEL ESTUDIANTE

INSERT INTO cv_practica_dual (id_cv_practica_dual, id_estudiante, anio_periodo, institucion, cargo, actividades_realizadas) VALUES
(34, 1, '2025-II', 'SoftSolutions', 'Asistente QA', 'Automatización'),
(35, 2, '2025-II', 'InfoTech', 'Junior', 'Soporte técnico'),
(36, 3, '2025-II', 'RedesCorp', 'Técnico', 'Instalación de red');


-- FASE 6: MÓDULO DE VINCULACIÓN CON LA SOCIEDAD
-- Nota: Usamos id_periodo 9 (un periodo anterior) para simular que ya la pasaron o están en ella.
INSERT INTO vinculacion_estudiante (id_vinculacion, id_periodo, id_matricula_detalle, id_empresa, id_docente, nombre_proyecto, fecha_inicio, fecha_fin) VALUES
(1, 9, 1005, 5, 8, 'Alfabetización Digital', '2025-10-20', '2025-12-20'),
(2, 9, 1006, 6, 9, 'Reciclaje Tecnológico', '2025-10-21', '2025-12-21'),
(3, 9, 1007, 7, 8, 'Desarrollo Web ONGs', '2025-10-22', '2025-12-22');

INSERT INTO vinculacion_actividad_estudiante (id_actividad_estudiante, id_vinculacion, fecha, hora_inicio, hora_fin, horas_total, actividades_realizadas) VALUES
(1, 1, '2025-10-20', '10:00', '12:00', 2.0, 'Charla a la comunidad'),
(2, 1, '2025-10-21', '14:00', '17:00', 3.0, 'Taller de ofimática'),
(3, 2, '2025-10-21', '09:00', '11:00', 2.0, 'Clasificación de PC');

INSERT INTO vinculacion_asistencia_tutor (id_asistencia_tutor, id_vinculacion, fecha, hora_inicio, hora_fin, horas_total, observaciones) VALUES
(1, 1, '2025-10-22', '09:00', '10:00', 1.0, 'Revisión de avance'),
(2, 1, '2025-10-29', '09:00', '10:00', 1.0, 'Corrección de errores'),
(3, 2, '2025-10-23', '10:00', '11:00', 1.0, 'Todo en orden');

INSERT INTO vinculacion_informe (id_informe, id_vinculacion, fecha_informe, actividad_macro, resultado_aprendizaje) VALUES
(1, 1, '2025-10-27', 'Capacitación Excel', 'Usuarios manejan celdas'),
(2, 1, '2025-11-03', 'Capacitación Word', 'Usuarios redactan cartas'),
(3, 2, '2025-10-28', 'Desarme equipos', '10 PCs reciclados');

INSERT INTO evaluacion_vinculacion (id_evaluacion_vinc, id_vinculacion, id_rubrica, nota_final) VALUES
(1, 1, 4, 9.50),
(2, 2, 4, 8.80),
(3, 3, 4, 10.00);

-- FASE 7: PORTAFOLIO DOCENTE (ACEPTACIÓN DE NOTAS)

INSERT INTO portafolio_reporte_notas (id_reporte_notas, id_periodo, id_oferta_asignatura, tipo_reporte, estado) VALUES
(1, 10, 150, 'APORTE_1', 'GENERADO'),
(2, 10, 150, 'APORTE_2', 'GENERADO'),
(3, 10, 151, 'APORTE_1', 'GENERADO');

INSERT INTO portafolio_aceptacion_estudiante (id_aceptacion, id_reporte_notas, id_matricula_detalle, nota_registrada, estado_aceptacion) VALUES
(1, 1, 1005, 8.50, 'ACEPTADO'),
(2, 1, 1006, 7.00, 'PENDIENTE'),
(3, 3, 1007, 9.50, 'ACEPTADO');


-- FASE 8: SEGURIDAD (USUARIOS Y ROLES)

INSERT INTO rol (id_rol, nombre) VALUES
(1, 'ESTUDIANTE'),
(2, 'DOCENTE');

INSERT INTO usuario (id_usuario, correo, password_hash, estado) VALUES
(100, 'jperez@instituto.edu.ec', 'hash123', 'ACTIVO'),
(101, 'amartinez@instituto.edu.ec', 'hash123', 'ACTIVO'),
(102, 'mgomez@instituto.edu.ec', 'hash123', 'ACTIVO');

INSERT INTO usuario_rol (id_usuario_rol, id_usuario, id_rol) VALUES
(1, 100, 1),
(2, 101, 2),
(3, 102, 1);

-- Ajuste de secuencias (Ejemplo para evitar errores futuros si se inserta desde la app)
SELECT setval('carrera_id_carrera_seq', (SELECT MAX(id_carrera) FROM carrera));
SELECT setval('estudiante_id_estudiante_seq', (SELECT MAX(id_estudiante) FROM estudiante));
-- (Las secuencias pueden ajustarse para el resto de tablas según se necesite)
