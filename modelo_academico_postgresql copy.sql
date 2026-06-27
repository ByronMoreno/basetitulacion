
-- =====================================================
-- MODELO ACADÉMICO INSTITUTO TECNOLÓGICO
-- PostgreSQL
-- Versión basada en:
-- Carrera -> Nivel -> Asignatura
-- Periodo -> Oferta Asignatura
-- Estudiante -> Matrícula -> Calificaciones
-- =====================================================

CREATE TABLE periodo_academico (
    id_periodo BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE carrera (
    id_carrera BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    modalidad VARCHAR(30),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE nivel (
    id_nivel BIGSERIAL PRIMARY KEY,
    id_carrera BIGINT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT fk_nivel_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carrera(id_carrera),

    CONSTRAINT uk_nivel_carrera
        UNIQUE(id_carrera,nombre)
);

CREATE TABLE asignatura (
    id_asignatura BIGSERIAL PRIMARY KEY,
    id_nivel BIGINT NOT NULL,

    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,

    horas INTEGER,
    creditos INTEGER,

    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT fk_asignatura_nivel
        FOREIGN KEY (id_nivel)
        REFERENCES nivel(id_nivel)
);

CREATE TABLE docente (
    id_docente BIGSERIAL PRIMARY KEY,
    cedula VARCHAR(20) UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(150),
    telefono VARCHAR(20),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE jornada (
    id_jornada BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE paralelo (
    id_paralelo BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE periodo_carrera (
    id_periodo_carrera BIGSERIAL PRIMARY KEY,

    id_periodo BIGINT NOT NULL,
    id_carrera BIGINT NOT NULL,

    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    fecha_inicio_aporte1 DATE,
    fecha_fin_aporte1 DATE,

    fecha_inicio_aporte2 DATE,
    fecha_fin_aporte2 DATE,

    fecha_inicio_supletorio DATE,
    fecha_fin_supletorio DATE,

    fecha_inicio_fase_teorica DATE,
    fecha_fin_fase_teorica DATE,

    fecha_inicio_fase_practica DATE,
    fecha_fin_fase_practica DATE,

    estado VARCHAR(20) DEFAULT 'ACTIVO',

    CONSTRAINT fk_pc_periodo
        FOREIGN KEY(id_periodo)
        REFERENCES periodo_academico(id_periodo),

    CONSTRAINT fk_pc_carrera
        FOREIGN KEY(id_carrera)
        REFERENCES carrera(id_carrera),

    CONSTRAINT uk_pc
        UNIQUE(id_periodo,id_carrera)
);

-- Oferta académica por período y carrera
CREATE TABLE oferta_asignatura (
    id_oferta_asignatura BIGSERIAL PRIMARY KEY,

    id_periodo_carrera BIGINT NOT NULL,
    id_asignatura BIGINT NOT NULL,
    id_docente BIGINT NOT NULL,
    id_jornada BIGINT NOT NULL,
    id_paralelo BIGINT NOT NULL,

    cupos INTEGER DEFAULT 40,
    horas_semanales NUMERIC(5,2),

    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT fk_oferta_periodo_carrera
        FOREIGN KEY (id_periodo_carrera)
        REFERENCES periodo_carrera(id_periodo_carrera),

    CONSTRAINT fk_oferta_asignatura
        FOREIGN KEY (id_asignatura)
        REFERENCES asignatura(id_asignatura),

    CONSTRAINT fk_oferta_docente
        FOREIGN KEY (id_docente)
        REFERENCES docente(id_docente),

    CONSTRAINT fk_oferta_jornada
        FOREIGN KEY (id_jornada)
        REFERENCES jornada(id_jornada),

    CONSTRAINT fk_oferta_paralelo
        FOREIGN KEY (id_paralelo)
        REFERENCES paralelo(id_paralelo)
);

CREATE TABLE estudiante (
    id_estudiante BIGSERIAL PRIMARY KEY,

    cedula VARCHAR(20) UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(150),
    telefono VARCHAR(20),

    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE matricula (
    id_matricula BIGSERIAL PRIMARY KEY,

    numero VARCHAR(30) UNIQUE,

    id_estudiante BIGINT NOT NULL,
    id_periodo BIGINT NOT NULL,
    id_carrera BIGINT NOT NULL,

    fecha_matricula DATE NOT NULL DEFAULT CURRENT_DATE,

    tipo_matricula VARCHAR(30),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',

    CONSTRAINT fk_matricula_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante),

    CONSTRAINT fk_matricula_periodo
        FOREIGN KEY (id_periodo)
        REFERENCES periodo_academico(id_periodo),

    CONSTRAINT fk_matricula_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carrera(id_carrera)
);

CREATE TABLE matricula_detalle (
    id_matricula_detalle BIGSERIAL PRIMARY KEY,

    id_matricula BIGINT NOT NULL,
    id_oferta_asignatura BIGINT NOT NULL,

    nota_ap1 NUMERIC(5,2),
    nota_ap2 NUMERIC(5,2),
    nota_supletorio NUMERIC(5,2),
    nota_final NUMERIC(5,2),

    estado VARCHAR(20) NOT NULL DEFAULT 'CURSANDO',

    CONSTRAINT fk_detalle_matricula
        FOREIGN KEY (id_matricula)
        REFERENCES matricula(id_matricula),

    CONSTRAINT fk_detalle_oferta
        FOREIGN KEY (id_oferta_asignatura)
        REFERENCES oferta_asignatura(id_oferta_asignatura),

    CONSTRAINT uk_matricula_oferta
        UNIQUE(id_matricula,id_oferta_asignatura)
);

CREATE TABLE usuario (
    id_usuario BIGSERIAL PRIMARY KEY,

    correo VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE rol (
    id_rol BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE usuario_rol (
    id_usuario_rol BIGSERIAL PRIMARY KEY,

    id_usuario BIGINT NOT NULL,
    id_rol BIGINT NOT NULL,

    CONSTRAINT fk_usuario_rol_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario),

    CONSTRAINT fk_usuario_rol_rol
        FOREIGN KEY (id_rol)
        REFERENCES rol(id_rol),

    CONSTRAINT uk_usuario_rol
        UNIQUE(id_usuario,id_rol)
);

CREATE INDEX idx_nivel_carrera
ON nivel(id_carrera);

CREATE INDEX idx_asignatura_nivel
ON asignatura(id_nivel);

CREATE INDEX idx_oferta_periodo_carrera
ON oferta_asignatura(id_periodo_carrera);

CREATE INDEX idx_oferta_docente
ON oferta_asignatura(id_docente);

CREATE INDEX idx_matricula_estudiante
ON matricula(id_estudiante);

CREATE INDEX idx_matricula_periodo
ON matricula(id_periodo);

CREATE INDEX idx_detalle_matricula
ON matricula_detalle(id_matricula);

-- =====================================================
-- MÓDULO DE FASE PRÁCTICA / FORMACIÓN DUAL
-- =====================================================

-- 1. CV DEL ESTUDIANTE (HOJA DE VIDA)
CREATE TABLE cv_dato_academico (
    id_cv_dato_academico BIGSERIAL PRIMARY KEY,
    id_estudiante BIGINT NOT NULL,
    anio VARCHAR(20) NOT NULL,
    institucion VARCHAR(150) NOT NULL,
    titulo_mencion VARCHAR(150) NOT NULL,
    nota_final NUMERIC(5,2),
    CONSTRAINT fk_cv_da_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

CREATE TABLE cv_experiencia_laboral (
    id_cv_experiencia_laboral BIGSERIAL PRIMARY KEY,
    id_estudiante BIGINT NOT NULL,
    anio VARCHAR(20) NOT NULL,
    institucion VARCHAR(150) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    actividades TEXT NOT NULL,
    CONSTRAINT fk_cv_el_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

CREATE TABLE cv_practica_dual (
    id_cv_practica_dual BIGSERIAL PRIMARY KEY,
    id_estudiante BIGINT NOT NULL,
    anio_periodo VARCHAR(20) NOT NULL,
    institucion VARCHAR(150) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    actividades_realizadas TEXT NOT NULL,
    CONSTRAINT fk_cv_pd_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante)
);

-- 2. EMPRESAS Y TUTORES EMPRESARIALES
CREATE TABLE empresa (
    id_empresa BIGSERIAL PRIMARY KEY,
    ruc VARCHAR(20) UNIQUE NOT NULL,
    razon_social VARCHAR(200) NOT NULL,
    direccion TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

CREATE TABLE tutor_empresarial (
    id_tutor_empresarial BIGSERIAL PRIMARY KEY,
    id_empresa BIGINT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    correo VARCHAR(150),
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    CONSTRAINT fk_te_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa)
);

-- 3. ASIGNACIÓN DE PRÁCTICA ESTUDIANTIL
CREATE TABLE practica_estudiante (
    id_practica BIGSERIAL PRIMARY KEY,
    id_periodo BIGINT NOT NULL,
    id_matricula_detalle BIGINT NOT NULL UNIQUE,
    id_empresa BIGINT NOT NULL,
    id_tutor_empresarial BIGINT NOT NULL,
    id_docente BIGINT NOT NULL,
    total_horas_requeridas INTEGER DEFAULT 400,
    total_horas_cumplidas INTEGER DEFAULT 0,
    estado VARCHAR(30) DEFAULT 'EN_CURSO',
    CONSTRAINT fk_pe_periodo FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo),
    CONSTRAINT fk_pe_matricula_detalle FOREIGN KEY (id_matricula_detalle) REFERENCES matricula_detalle(id_matricula_detalle),
    CONSTRAINT fk_pe_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT fk_pe_tutor_empresarial FOREIGN KEY (id_tutor_empresarial) REFERENCES tutor_empresarial(id_tutor_empresarial),
    CONSTRAINT fk_pe_docente FOREIGN KEY (id_docente) REFERENCES docente(id_docente)
);

-- 4. PLAN MARCO DE FORMACIÓN
CREATE TABLE plan_marco_formacion (
    id_plan_marco BIGSERIAL PRIMARY KEY,
    id_nivel BIGINT NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    CONSTRAINT fk_pmf_nivel FOREIGN KEY (id_nivel) REFERENCES nivel(id_nivel)
);

CREATE TABLE item_plan_marco (
    id_item_pm BIGSERIAL PRIMARY KEY,
    id_plan_marco BIGINT NOT NULL,
    resultado_aprendizaje TEXT NOT NULL,
    nivel_logro_esperado INTEGER NOT NULL CHECK (nivel_logro_esperado BETWEEN 1 AND 4),
    CONSTRAINT fk_ipm_plan_marco FOREIGN KEY (id_plan_marco) REFERENCES plan_marco_formacion(id_plan_marco)
);

CREATE TABLE evaluacion_plan_marco (
    id_evaluacion_pm BIGSERIAL PRIMARY KEY,
    id_practica BIGINT NOT NULL,
    id_item_pm BIGINT NOT NULL,
    nivel_real_alcanzado INTEGER CHECK (nivel_real_alcanzado BETWEEN 1 AND 4),
    CONSTRAINT fk_epm_practica FOREIGN KEY (id_practica) REFERENCES practica_estudiante(id_practica),
    CONSTRAINT fk_epm_item_pm FOREIGN KEY (id_item_pm) REFERENCES item_plan_marco(id_item_pm)
);

-- 5. PLAN DE ROTACIÓN
CREATE TABLE plan_rotacion (
    id_plan_rotacion BIGSERIAL PRIMARY KEY,
    id_practica BIGINT NOT NULL,
    id_item_pm BIGINT NOT NULL,
    puesto_aprendizaje VARCHAR(150) NOT NULL,
    CONSTRAINT fk_pr_practica FOREIGN KEY (id_practica) REFERENCES practica_estudiante(id_practica),
    CONSTRAINT fk_pr_item_pm FOREIGN KEY (id_item_pm) REFERENCES item_plan_marco(id_item_pm)
);

CREATE TABLE plan_rotacion_semana (
    id_rotacion_semana BIGSERIAL PRIMARY KEY,
    id_plan_rotacion BIGINT NOT NULL,
    semana INTEGER NOT NULL,
    CONSTRAINT fk_prs_plan_rotacion FOREIGN KEY (id_plan_rotacion) REFERENCES plan_rotacion(id_plan_rotacion)
);

-- 6. REGISTRO DIARIO DE PRÁCTICA (ASISTENCIA)
CREATE TABLE registro_diario_practica (
    id_registro_diario BIGSERIAL PRIMARY KEY,
    id_practica BIGINT NOT NULL,
    fecha DATE NOT NULL,
    hora_ingreso TIME,
    hora_salida_almuerzo TIME,
    hora_regreso_almuerzo TIME,
    hora_salida TIME,
    observaciones TEXT,
    firma_estudiante BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_rdp_practica FOREIGN KEY (id_practica) REFERENCES practica_estudiante(id_practica)
);

-- 7. INFORME DE APRENDIZAJE (BITÁCORA SEMANAL)
CREATE TABLE informe_aprendizaje (
    id_informe BIGSERIAL PRIMARY KEY,
    id_practica BIGINT NOT NULL,
    reflexion_aprendizaje TEXT,
    observaciones_empresa TEXT,
    CONSTRAINT fk_ia_practica FOREIGN KEY (id_practica) REFERENCES practica_estudiante(id_practica)
);

CREATE TABLE bitacora_semanal (
    id_bitacora BIGSERIAL PRIMARY KEY,
    id_informe BIGINT NOT NULL,
    semana INTEGER NOT NULL,
    fecha_inicio_semana DATE,
    fecha_fin_semana DATE,
    puesto_aprendizaje VARCHAR(150),
    actividades_realizadas TEXT,
    actividades_autonomas TEXT,
    CONSTRAINT fk_bs_informe FOREIGN KEY (id_informe) REFERENCES informe_aprendizaje(id_informe)
);

-- 8. CONFIGURACIÓN DE RÚBRICAS
CREATE TABLE catalogo_rubrica (
    id_rubrica BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(50) NOT NULL, -- 'EMPRESARIAL', 'ACADEMICA'
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

CREATE TABLE item_rubrica (
    id_item BIGSERIAL PRIMARY KEY,
    id_rubrica BIGINT NOT NULL,
    descripcion_criterio TEXT NOT NULL,
    puntaje_maximo NUMERIC(5,2) NOT NULL,
    ponderacion NUMERIC(5,2) NOT NULL,
    CONSTRAINT fk_ir_rubrica FOREIGN KEY (id_rubrica) REFERENCES catalogo_rubrica(id_rubrica)
);

CREATE TABLE evaluacion_practica (
    id_evaluacion BIGSERIAL PRIMARY KEY,
    id_practica BIGINT NOT NULL,
    id_rubrica BIGINT NOT NULL,
    tipo_evaluador VARCHAR(50) NOT NULL,
    nota_final_calculada NUMERIC(5,2),
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_ep_practica FOREIGN KEY (id_practica) REFERENCES practica_estudiante(id_practica),
    CONSTRAINT fk_ep_rubrica FOREIGN KEY (id_rubrica) REFERENCES catalogo_rubrica(id_rubrica)
);

CREATE TABLE detalle_evaluacion (
    id_detalle_evaluacion BIGSERIAL PRIMARY KEY,
    id_evaluacion BIGINT NOT NULL,
    id_item BIGINT NOT NULL,
    puntaje_asignado NUMERIC(5,2) NOT NULL,
    CONSTRAINT fk_de_evaluacion FOREIGN KEY (id_evaluacion) REFERENCES evaluacion_practica(id_evaluacion),
    CONSTRAINT fk_de_item FOREIGN KEY (id_item) REFERENCES item_rubrica(id_item)
);

-- =====================================================
-- FIN DE MODELO ACADÉMICO Y FASE PRÁCTICA
-- =====================================================

-- =====================================================
-- MÓDULO DE VINCULACIÓN CON LA SOCIEDAD
-- =====================================================

-- 1. ASIGNACIÓN Y PROYECTO
CREATE TABLE vinculacion_estudiante (
    id_vinculacion BIGSERIAL PRIMARY KEY,
    id_periodo BIGINT NOT NULL,
    id_matricula_detalle BIGINT NOT NULL UNIQUE,
    id_empresa BIGINT NOT NULL,
    id_docente BIGINT NOT NULL,
    nombre_proyecto VARCHAR(255) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    total_horas_estudiante NUMERIC(5,2) DEFAULT 0,
    total_horas_docente NUMERIC(5,2) DEFAULT 0,
    estado VARCHAR(30) DEFAULT 'EN_CURSO',
    CONSTRAINT fk_ve_periodo FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo),
    CONSTRAINT fk_ve_matricula_detalle FOREIGN KEY (id_matricula_detalle) REFERENCES matricula_detalle(id_matricula_detalle),
    CONSTRAINT fk_ve_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT fk_ve_docente FOREIGN KEY (id_docente) REFERENCES docente(id_docente)
);

-- 2. REGISTRO DE ACTIVIDADES DEL ESTUDIANTE
CREATE TABLE vinculacion_actividad_estudiante (
    id_actividad_estudiante BIGSERIAL PRIMARY KEY,
    id_vinculacion BIGINT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    horas_total NUMERIC(5,2) NOT NULL,
    actividades_realizadas TEXT NOT NULL,
    CONSTRAINT fk_vae_vinculacion FOREIGN KEY (id_vinculacion) REFERENCES vinculacion_estudiante(id_vinculacion)
);

-- 3. REGISTRO DE ASISTENCIA DEL TUTOR / DOCENTE
CREATE TABLE vinculacion_asistencia_tutor (
    id_asistencia_tutor BIGSERIAL PRIMARY KEY,
    id_vinculacion BIGINT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    horas_total NUMERIC(5,2) NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_vat_vinculacion FOREIGN KEY (id_vinculacion) REFERENCES vinculacion_estudiante(id_vinculacion)
);

-- 4. INFORME DE ACTIVIDADES
CREATE TABLE vinculacion_informe (
    id_informe BIGSERIAL PRIMARY KEY,
    id_vinculacion BIGINT NOT NULL,
    fecha_informe DATE NOT NULL,
    actividad_macro TEXT NOT NULL,
    resultado_aprendizaje TEXT NOT NULL,
    CONSTRAINT fk_vi_vinculacion FOREIGN KEY (id_vinculacion) REFERENCES vinculacion_estudiante(id_vinculacion)
);

-- 5. EVALUACIÓN DE VINCULACIÓN
CREATE TABLE evaluacion_vinculacion (
    id_evaluacion_vinc BIGSERIAL PRIMARY KEY,
    id_vinculacion BIGINT NOT NULL,
    id_rubrica BIGINT NOT NULL,
    nota_final NUMERIC(5,2),
    fecha_evaluacion DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_ev_vinculacion FOREIGN KEY (id_vinculacion) REFERENCES vinculacion_estudiante(id_vinculacion),
    CONSTRAINT fk_ev_rubrica FOREIGN KEY (id_rubrica) REFERENCES catalogo_rubrica(id_rubrica)
);

CREATE TABLE detalle_evaluacion_vinculacion (
    id_detalle_vinc BIGSERIAL PRIMARY KEY,
    id_evaluacion_vinc BIGINT NOT NULL,
    id_item BIGINT NOT NULL,
    puntaje_asignado NUMERIC(5,2) NOT NULL,
    CONSTRAINT fk_dev_evaluacion FOREIGN KEY (id_evaluacion_vinc) REFERENCES evaluacion_vinculacion(id_evaluacion_vinc),
    CONSTRAINT fk_dev_item FOREIGN KEY (id_item) REFERENCES item_rubrica(id_item)
);

-- =====================================================
-- FIN DE MODELO DE VINCULACIÓN
-- =====================================================

-- =====================================================
-- MÓDULO DE PORTAFOLIO DOCENTE (ACEPTACIÓN DE NOTAS)
-- =====================================================

CREATE TABLE portafolio_reporte_notas (
    id_reporte_notas BIGSERIAL PRIMARY KEY,
    id_periodo BIGINT NOT NULL,
    id_oferta_asignatura BIGINT NOT NULL,
    tipo_reporte VARCHAR(20) NOT NULL CHECK (tipo_reporte IN ('APORTE_1', 'APORTE_2', 'SUPLETORIO')),
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ruta_archivo_pdf VARCHAR(255),
    estado VARCHAR(20) DEFAULT 'GENERADO',
    CONSTRAINT fk_prn_periodo FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo),
    CONSTRAINT fk_prn_oferta FOREIGN KEY (id_oferta_asignatura) REFERENCES oferta_asignatura(id_oferta_asignatura),
    CONSTRAINT uk_prn_oferta_tipo UNIQUE (id_oferta_asignatura, tipo_reporte)
);

CREATE TABLE portafolio_aceptacion_estudiante (
    id_aceptacion BIGSERIAL PRIMARY KEY,
    id_reporte_notas BIGINT NOT NULL,
    id_matricula_detalle BIGINT NOT NULL,
    nota_registrada NUMERIC(5,2),
    estado_aceptacion VARCHAR(20) DEFAULT 'PENDIENTE',
    fecha_aceptacion TIMESTAMP,
    CONSTRAINT fk_pae_reporte FOREIGN KEY (id_reporte_notas) REFERENCES portafolio_reporte_notas(id_reporte_notas),
    CONSTRAINT fk_pae_matricula_det FOREIGN KEY (id_matricula_detalle) REFERENCES matricula_detalle(id_matricula_detalle),
    CONSTRAINT uk_pae_reporte_matricula UNIQUE (id_reporte_notas, id_matricula_detalle)
);

-- Vista para extraer todos los datos del reporte de notas fácilmente
CREATE OR REPLACE VIEW vw_reporte_notas AS
SELECT 
    oa.id_oferta_asignatura,
    oa.id_periodo_carrera,
    c.nombre AS carrera,
    n.nombre AS nivel,
    a.nombre AS asignatura,
    p.nombre AS paralelo,
    j.nombre AS jornada,
    d.nombres || ' ' || d.apellidos AS docente,
    e.cedula AS estudiante_cedula,
    e.nombres || ' ' || e.apellidos AS estudiante_nombre,
    md.nota_ap1,
    md.nota_ap2,
    md.nota_supletorio,
    md.nota_final
FROM oferta_asignatura oa
JOIN asignatura a ON oa.id_asignatura = a.id_asignatura
JOIN nivel n ON a.id_nivel = n.id_nivel
JOIN carrera c ON n.id_carrera = c.id_carrera
JOIN paralelo p ON oa.id_paralelo = p.id_paralelo
JOIN jornada j ON oa.id_jornada = j.id_jornada
JOIN docente d ON oa.id_docente = d.id_docente
JOIN matricula_detalle md ON oa.id_oferta_asignatura = md.id_oferta_asignatura
JOIN matricula m ON md.id_matricula = m.id_matricula
JOIN estudiante e ON m.id_estudiante = e.id_estudiante;

-- =====================================================
-- FIN DE MÓDULO PORTAFOLIO DOCENTE
-- =====================================================
