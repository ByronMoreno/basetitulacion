
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

    id_docente BIGINT,
    id_estudiante BIGINT,

    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',

    CONSTRAINT fk_usuario_docente
        FOREIGN KEY (id_docente)
        REFERENCES docente(id_docente),

    CONSTRAINT fk_usuario_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
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
    id_matricula_detalle BIGINT NOT NULL UNIQUE,
    id_empresa BIGINT NOT NULL,
    id_tutor_empresarial BIGINT NOT NULL,
    id_docente BIGINT NOT NULL,
    total_horas_requeridas INTEGER DEFAULT 400,
    total_horas_cumplidas INTEGER DEFAULT 0,
    estado VARCHAR(30) DEFAULT 'EN_CURSO',
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
