-- =========================================================
-- DATOS DE EJEMPLO — Sistema Académico Yavirac
-- Para probar el despliegue con información real de prueba.
-- Ejecutar DESPUÉS de modelo_academico_completo.sql
-- Usa subconsultas por clave natural (código/cédula) para
-- resolver los IDs, así no depende del orden de los SERIAL.
-- =========================================================

BEGIN;

-- ---------------------------------------------------------
-- 1. Carreras, niveles, tipos y asignaturas
-- ---------------------------------------------------------
INSERT INTO carrera (codigo, nombre, siglas, modalidad, estado) VALUES
    ('DS-01', 'Desarrollo de Software', 'DS', 'DUAL', 'ACTIVO'),
    ('MKT-01', 'Marketing Digital', 'MKT', 'PRESENCIAL', 'ACTIVO')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO nivel_academico (codigo, nombre, id_carrera) VALUES
    ('N4', 'Cuarto Semestre', (SELECT id_carrera FROM carrera WHERE codigo = 'DS-01')),
    ('N5', 'Quinto Semestre', (SELECT id_carrera FROM carrera WHERE codigo = 'DS-01'))
ON CONFLICT DO NOTHING;

INSERT INTO tipo_asignatura (nombre) VALUES
    ('Dual Teórica'), ('Dual Práctica'), ('Otro')
ON CONFLICT DO NOTHING;

INSERT INTO asignatura (codigo, nombre, id_nivel, id_tipo_asignatura) VALUES
    ('PPP-401', 'Prácticas Pre Profesionales IV',
        (SELECT id_nivel FROM nivel_academico WHERE codigo = 'N4'),
        (SELECT id_tipo_asignatura FROM tipo_asignatura WHERE nombre = 'Dual Práctica')),
    ('PPP-501', 'Prácticas Pre Profesionales V',
        (SELECT id_nivel FROM nivel_academico WHERE codigo = 'N5'),
        (SELECT id_tipo_asignatura FROM tipo_asignatura WHERE nombre = 'Dual Práctica')),
    ('SD4-515', 'DevOps',
        (SELECT id_nivel FROM nivel_academico WHERE codigo = 'N5'),
        (SELECT id_tipo_asignatura FROM tipo_asignatura WHERE nombre = 'Otro'))
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 2. Periodo académico activo
-- ---------------------------------------------------------
INSERT INTO periodo_academico (codigo, nombre, fecha_inicio, fecha_fin, estado) VALUES
    ('2026-1P', '2026-1P', '2026-04-01', '2026-08-30', 'VIGENTE')
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO periodo_carrera (id_periodo, id_carrera)
SELECT (SELECT id_periodo FROM periodo_academico WHERE codigo = '2026-1P'),
       (SELECT id_carrera FROM carrera WHERE codigo = 'DS-01')
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 3. Docentes, jornadas y paralelos
-- ---------------------------------------------------------
INSERT INTO docente (cedula, nombres, apellidos, correo, telefono) VALUES
    ('1803980844', 'Byron Rodrigo', 'Moreno Moreno', 'bmoreno@yavirac.edu.ec', '0999000001'),
    ('1700000002', 'Luis', 'Fernando', 'lfernando@yavirac.edu.ec', '0999000002')
ON CONFLICT (cedula) DO NOTHING;

INSERT INTO jornada (nombre) VALUES ('MATUTINA'), ('VESPERTINA'), ('INTENSIVA')
ON CONFLICT DO NOTHING;

INSERT INTO paralelo (nombre, id_jornada, id_docente) VALUES
    ('B', (SELECT id_jornada FROM jornada WHERE nombre = 'INTENSIVA'),
          (SELECT id_docente FROM docente WHERE cedula = '1803980844'))
ON CONFLICT DO NOTHING;

INSERT INTO docente_asignatura (id_docente, id_asignatura, id_paralelo, id_periodo)
SELECT (SELECT id_docente FROM docente WHERE cedula = '1803980844'),
       (SELECT id_asignatura FROM asignatura WHERE codigo = 'SD4-515'),
       (SELECT id_paralelo FROM paralelo WHERE nombre = 'B'),
       (SELECT id_periodo FROM periodo_academico WHERE codigo = '2026-1P')
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 4. Estudiantes, matrícula y matrícula_detalle
-- ---------------------------------------------------------
INSERT INTO estudiante (cedula, nombres, apellidos, correo) VALUES
    ('2250022114', 'Kevin Smith', 'Nivesela Armijos', 'ksanivesela@yavirac.edu.ec'),
    ('1752058170', 'Camila Lorenlay', 'Vivas Gualinga', 'clvivas@yavirac.edu.ec'),
    ('1722888524', 'Pablo Javier', 'Reyes Reyes', 'pjreyes@yavirac.edu.ec')
ON CONFLICT (cedula) DO NOTHING;

INSERT INTO matricula (numero, id_estudiante, id_periodo, id_carrera, id_nivel, id_paralelo)
SELECT 'MAT-2026-001',
       (SELECT id_estudiante FROM estudiante WHERE cedula = '2250022114'),
       (SELECT id_periodo FROM periodo_academico WHERE codigo = '2026-1P'),
       (SELECT id_carrera FROM carrera WHERE codigo = 'DS-01'),
       (SELECT id_nivel FROM nivel_academico WHERE codigo = 'N5'),
       (SELECT id_paralelo FROM paralelo WHERE nombre = 'B')
ON CONFLICT (numero) DO NOTHING;

INSERT INTO matricula_detalle (id_matricula, id_asignatura, id_paralelo, id_jornada, nota_1, nota_2)
SELECT (SELECT id_matricula FROM matricula WHERE numero = 'MAT-2026-001'),
       (SELECT id_asignatura FROM asignatura WHERE codigo = 'SD4-515'),
       (SELECT id_paralelo FROM paralelo WHERE nombre = 'B'),
       (SELECT id_jornada FROM jornada WHERE nombre = 'INTENSIVA'),
       10.00, NULL
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 5. Roles y usuario de prueba
-- ---------------------------------------------------------
INSERT INTO rol (nombre) VALUES ('ADMIN'), ('DOCENTE'), ('ESTUDIANTE'), ('COORDINADOR')
ON CONFLICT (nombre) DO NOTHING;

INSERT INTO usuario (nombres, apellidos, correo, password_hash, id_docente)
SELECT 'Byron Rodrigo', 'Moreno Moreno', 'bmoreno@yavirac.edu.ec', '$2b$10$reemplazar_por_hash_real',
       (SELECT id_docente FROM docente WHERE cedula = '1803980844')
ON CONFLICT (correo) DO NOTHING;

INSERT INTO usuario_rol (id_usuario, id_rol)
SELECT (SELECT id_usuario FROM usuario WHERE correo = 'bmoreno@yavirac.edu.ec'),
       (SELECT id_rol FROM rol WHERE nombre = 'DOCENTE')
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 6. Empresas y tutor empresarial
-- ---------------------------------------------------------
INSERT INTO empresa (ruc, razon_social, direccion, telefono, correo) VALUES
    ('179001', 'TechCorp S.A.', 'Av. Amazonas N34-451, Quito', '022345678', 'contacto@techcorp.ec'),
    ('179002', 'DataSoft Cía.', 'Av. 6 de Diciembre N24-100, Quito', '022345679', 'info@datasoft.ec')
ON CONFLICT (ruc) DO NOTHING;

INSERT INTO tutor_empresarial (id_empresa, nombres, cargo, correo, telefono)
SELECT (SELECT id_empresa FROM empresa WHERE ruc = '179001'), 'Roberto Gómez', 'Jefe Dev', 'rgomez@techcorp.ec', '0991112222'
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 7. Fase práctica (dependiente de matricula_detalle real)
-- ---------------------------------------------------------
INSERT INTO practica_estudiante (id_matricula_detalle, id_periodo_empresa, id_periodo_tutor_empresarial, id_periodo_docente, total_horas_requeridas)
SELECT md.id_matricula_detalle,
       (SELECT id_empresa FROM empresa WHERE ruc = '179001'),
       (SELECT id_tutor_empresarial FROM tutor_empresarial LIMIT 1),
       (SELECT id_docente FROM docente WHERE cedula = '1803980844'),
       400
FROM matricula_detalle md
JOIN matricula m ON m.id_matricula = md.id_matricula
JOIN estudiante e ON e.id_estudiante = m.id_estudiante
WHERE e.cedula = '2250022114'
ON CONFLICT DO NOTHING;

INSERT INTO registro_diario_practica (id_practica, fecha, ingreso, sal_alm, reg_alm, salida)
SELECT p.id_practica, '2026-06-01', '08:00', '13:00', '14:00', '17:00'
FROM practica_estudiante p
LIMIT 1
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 8. Vinculación con la sociedad
-- ---------------------------------------------------------
INSERT INTO vinculacion_estudiante (id_periodo, id_matricula_detalle, id_empresa, id_docente, proyecto, fecha_inicio, fecha_fin)
SELECT (SELECT id_periodo FROM periodo_academico WHERE codigo = '2026-1P'),
       md.id_matricula_detalle,
       (SELECT id_empresa FROM empresa WHERE ruc = '179001'),
       (SELECT id_docente FROM docente WHERE cedula = '1803980844'),
       'Alfabetización Digital', '2026-05-01', '2026-06-30'
FROM matricula_detalle md
JOIN matricula m ON m.id_matricula = md.id_matricula
JOIN estudiante e ON e.id_estudiante = m.id_estudiante
WHERE e.cedula = '2250022114'
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO vinculacion_objetivo (id_vinc, descripcion, orden)
SELECT id, 'Capacitar a la comunidad en herramientas ofimáticas básicas', 1
FROM vinculacion_estudiante LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO vinculacion_actividad_estudiante (id_vinc, fecha, h_inicio, h_fin, total_h, actividades, resultado_aprendizaje)
SELECT id, '2026-05-05', '10:00', '12:00', 2.0, 'Charla a la comunidad', 'Los participantes identifican las partes básicas de un computador'
FROM vinculacion_estudiante LIMIT 1
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------
-- 9. Portafolio docente
-- ---------------------------------------------------------
INSERT INTO portafolio_reporte_notas (id_periodo, id_docente_asignatura, tipo_reporte, estado)
SELECT (SELECT id_periodo FROM periodo_academico WHERE codigo = '2026-1P'),
       (SELECT id_docente_asignatura FROM docente_asignatura LIMIT 1),
       'APORTE_1', 'GENERADO'
ON CONFLICT DO NOTHING;

INSERT INTO portafolio_aceptacion_estudiante (id_reporte, id_matricula_detalle, nota_registrada, estado_aceptacion)
SELECT (SELECT id_reporte FROM portafolio_reporte_notas LIMIT 1),
       md.id_matricula_detalle,
       8.50, 'PENDIENTE'
FROM matricula_detalle md
LIMIT 1
ON CONFLICT DO NOTHING;

COMMIT;

-- =========================================================
-- FIN DE DATOS DE PRUEBA
-- Verifica con: SELECT * FROM practica_estudiante;
--               SELECT * FROM vinculacion_estudiante;
-- =========================================================
