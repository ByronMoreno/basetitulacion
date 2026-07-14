-- =========================================================
-- MODELO ACADÉMICO COMPLETO — Sistema Académico Yavirac
-- Plataforma Modalidad Dual: Fase Práctica, Vinculación,
-- Portafolio Docente
-- PostgreSQL 16
--
-- Repo destino: ByronMoreno/basetitulacion
-- Reemplaza / consolida: modelo_academico_postgresql.sql
--
-- Responsables: Mateo Guerrón y Ricardo Astudillo (BD/DevOps)
--
-- ⚠️ Sección 4 (FASE PRÁCTICA) es una PROPUESTA basada en el
-- análisis de Jean sobre las entidades del backend. Confirmar
-- nombres de columna con Jean/Alisson antes de dar por
-- definitivo este bloque.
-- =========================================================

BEGIN;

-- =========================================================
-- 1. PERIODOS Y CARRERAS  (ya existente — se conserva igual)
-- =========================================================

CREATE TABLE IF NOT EXISTS periodo_academico (
    id_periodo                  BIGSERIAL PRIMARY KEY,
    codigo                      VARCHAR(20) NOT NULL UNIQUE,
    nombre                      VARCHAR(20) NOT NULL,
    fecha_inicio                DATE NOT NULL,
    fecha_fin                   DATE NOT NULL,
    fecha_inicio_aporte1        DATE,
    fecha_fin_aporte1           DATE,
    fecha_inicio_aporte2        DATE,
    fecha_fin_aporte2           DATE,
    fecha_inicio_supletorio     DATE,
    fecha_fin_supletorio        DATE,
    fecha_inicio_fase_teorica   DATE,
    fecha_fin_fase_teorica      DATE,
    fecha_inicio_fase_practica  DATE,
    fecha_fin_fase_practica     DATE,
    estado                      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                                 CHECK (estado IN ('ACTIVO', 'VIGENTE', 'CERRADO')),
    creado_en                   TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en              TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS carrera (
    id_carrera      BIGSERIAL PRIMARY KEY,
    codigo          VARCHAR(20) NOT NULL UNIQUE,
    nombre          VARCHAR(150) NOT NULL,
    siglas          VARCHAR(20),
    sede            VARCHAR(100),
    modalidad       VARCHAR(20) NOT NULL CHECK (modalidad IN ('PRESENCIAL', 'DUAL')),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS periodo_carrera (
    id_periodo_carrera  BIGSERIAL PRIMARY KEY,
    id_periodo          BIGINT NOT NULL REFERENCES periodo_academico(id_periodo),
    id_carrera          BIGINT NOT NULL REFERENCES carrera(id_carrera),
    estado              VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                        CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en           TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_periodo, id_carrera)
);

-- =========================================================
-- 2. ESTRUCTURA ACADÉMICA  (ya existente — se conserva igual)
-- =========================================================

CREATE TABLE IF NOT EXISTS nivel_academico (
    id_nivel        BIGSERIAL PRIMARY KEY,
    codigo          VARCHAR(20),
    nombre          VARCHAR(50) NOT NULL,
    id_carrera      BIGINT NOT NULL REFERENCES carrera(id_carrera),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tipo_asignatura (
    id_tipo_asignatura  BIGSERIAL PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL,
    estado              VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                        CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

CREATE TABLE IF NOT EXISTS asignatura (
    id_asignatura       BIGSERIAL PRIMARY KEY,
    codigo              VARCHAR(20) NOT NULL,
    nombre              VARCHAR(150) NOT NULL,
    id_nivel            BIGINT NOT NULL REFERENCES nivel_academico(id_nivel),
    id_tipo_asignatura  BIGINT NOT NULL REFERENCES tipo_asignatura(id_tipo_asignatura),
    estado              VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                        CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en           TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =========================================================
-- 3. DOCENTES, JORNADAS Y PARALELOS  (ya existente)
-- =========================================================

CREATE TABLE IF NOT EXISTS docente (
    id_docente      BIGSERIAL PRIMARY KEY,
    cedula          VARCHAR(20) NOT NULL UNIQUE,
    nombres         VARCHAR(100) NOT NULL,
    apellidos       VARCHAR(100) NOT NULL,
    correo          VARCHAR(150),
    telefono        VARCHAR(20),
    id_carrera      BIGINT REFERENCES carrera(id_carrera),
    id_nivel        BIGINT REFERENCES nivel_academico(id_nivel),
    es_coordinador  BOOLEAN NOT NULL DEFAULT FALSE,
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS jornada (
    id_jornada  BIGSERIAL PRIMARY KEY,
    nombre      VARCHAR(20) NOT NULL,
    estado      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

CREATE TABLE IF NOT EXISTS paralelo (
    id_paralelo BIGSERIAL PRIMARY KEY,
    nombre      VARCHAR(20) NOT NULL,
    id_jornada  BIGINT NOT NULL REFERENCES jornada(id_jornada),
    id_docente  BIGINT REFERENCES docente(id_docente),
    estado      VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en   TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS docente_asignatura (
    id_docente_asignatura  BIGSERIAL PRIMARY KEY,
    id_docente             BIGINT NOT NULL REFERENCES docente(id_docente),
    id_asignatura          BIGINT NOT NULL REFERENCES asignatura(id_asignatura),
    id_paralelo            BIGINT NOT NULL REFERENCES paralelo(id_paralelo),
    id_periodo             BIGINT NOT NULL REFERENCES periodo_academico(id_periodo),
    estado                 VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                           CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en              TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_asignatura, id_paralelo, id_periodo)
);

-- =========================================================
-- 4. ESTUDIANTES Y MATRÍCULAS  (ya existente)
-- =========================================================

CREATE TABLE IF NOT EXISTS estudiante (
    id_estudiante   BIGSERIAL PRIMARY KEY,
    cedula          VARCHAR(20) NOT NULL UNIQUE,
    nombres         VARCHAR(100) NOT NULL,
    apellidos       VARCHAR(100) NOT NULL,
    direccion       VARCHAR(200),
    telefono        VARCHAR(20),
    correo          VARCHAR(150),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS matricula (
    id_matricula    BIGSERIAL PRIMARY KEY,
    numero          VARCHAR(30) NOT NULL UNIQUE,
    id_estudiante   BIGINT NOT NULL REFERENCES estudiante(id_estudiante),
    id_periodo      BIGINT NOT NULL REFERENCES periodo_academico(id_periodo),
    id_carrera      BIGINT NOT NULL REFERENCES carrera(id_carrera),
    id_nivel        BIGINT NOT NULL REFERENCES nivel_academico(id_nivel),
    id_paralelo     BIGINT NOT NULL REFERENCES paralelo(id_paralelo),
    fecha_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('APROBADO', 'DENEGADO', 'ACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS matricula_detalle (
    id_matricula_detalle BIGSERIAL PRIMARY KEY,
    id_matricula         BIGINT NOT NULL REFERENCES matricula(id_matricula),
    id_asignatura        BIGINT NOT NULL REFERENCES asignatura(id_asignatura),
    id_paralelo          BIGINT NOT NULL REFERENCES paralelo(id_paralelo),
    id_jornada           BIGINT NOT NULL REFERENCES jornada(id_jornada),
    nota_1               NUMERIC(5,2),
    nota_2               NUMERIC(5,2),
    nota_supletorio      NUMERIC(5,2),
    nota_final           NUMERIC(5,2) GENERATED ALWAYS AS (
                             COALESCE(
                                 CASE
                                     WHEN nota_supletorio IS NOT NULL THEN nota_supletorio
                                     ELSE ROUND((COALESCE(nota_1,0) + COALESCE(nota_2,0)) / 2.0, 2)
                                 END,
                             0)
                         ) STORED,
    estado               VARCHAR(20) NOT NULL DEFAULT 'CURSANDO'
                         CHECK (estado IN ('CURSANDO', 'APROBADA', 'REPROBADA')),
    creado_en            TIMESTAMP NOT NULL DEFAULT NOW(),
    actualizado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_matricula, id_asignatura)
);

-- =========================================================
-- 5. USUARIOS Y ROLES  (ya existente)
-- =========================================================

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario      BIGSERIAL PRIMARY KEY,
    nombres         VARCHAR(100) NOT NULL,
    apellidos       VARCHAR(100) NOT NULL,
    correo          VARCHAR(150) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    id_docente      BIGINT REFERENCES docente(id_docente),
    id_estudiante   BIGINT REFERENCES estudiante(id_estudiante),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK (
        (id_docente IS NOT NULL AND id_estudiante IS NULL)
        OR (id_docente IS NULL AND id_estudiante IS NOT NULL)
        OR (id_docente IS NULL AND id_estudiante IS NULL)
    )
);

CREATE TABLE IF NOT EXISTS rol (
    id_rol  BIGSERIAL PRIMARY KEY,
    nombre  VARCHAR(50) NOT NULL UNIQUE,
    estado  VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
            CHECK (estado IN ('ACTIVO', 'INACTIVO'))
);

CREATE TABLE IF NOT EXISTS usuario_rol (
    id_usuario_rol  BIGSERIAL PRIMARY KEY,
    id_usuario      BIGINT NOT NULL REFERENCES usuario(id_usuario),
    id_rol          BIGINT NOT NULL REFERENCES rol(id_rol),
    UNIQUE (id_usuario, id_rol)
);

-- =========================================================
-- 6. EMPRESAS Y TUTORES EMPRESARIALES  (NUEVO)
--    Incluye el ajuste de feedback: telefono y correo
-- =========================================================

CREATE TABLE IF NOT EXISTS empresa (
    id_empresa      BIGSERIAL PRIMARY KEY,
    ruc             VARCHAR(20) NOT NULL UNIQUE,
    razon_social    VARCHAR(200) NOT NULL,
    direccion       VARCHAR(200),
    telefono        VARCHAR(20),
    correo          VARCHAR(150),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                    CHECK (estado IN ('ACTIVO', 'INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Si la tabla empresa ya existía sin estas columnas, este
-- ALTER las agrega sin duplicar (no falla si ya corriste el
-- script 01_ajustes_feedback_equipo.sql antes)
ALTER TABLE empresa
    ADD COLUMN IF NOT EXISTS telefono VARCHAR(20),
    ADD COLUMN IF NOT EXISTS correo   VARCHAR(150);

CREATE TABLE IF NOT EXISTS tutor_empresarial (
    id_tutor_empresarial BIGSERIAL PRIMARY KEY,
    id_empresa           BIGINT NOT NULL REFERENCES empresa(id_empresa),
    nombres               VARCHAR(150) NOT NULL,
    cargo                 VARCHAR(100),
    correo                VARCHAR(150),
    telefono              VARCHAR(20),
    creado_en             TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =========================================================
-- 7. RÚBRICA GENÉRICA (usada por fase práctica y vinculación)
-- =========================================================

CREATE TABLE IF NOT EXISTS rubrica (
    id_rubrica      BIGSERIAL PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    modulo          VARCHAR(20) NOT NULL
                    CHECK (modulo IN ('FASE_PRACTICA', 'VINCULACION')),
    tipo_evaluador  VARCHAR(20) CHECK (tipo_evaluador IN ('EMPRESA','INSTITUTO')),
    estado          VARCHAR(20) NOT NULL DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

-- =========================================================
-- 8. FASE PRÁCTICA (⚠️ propuesta — validar con Jean/Alisson)
-- =========================================================

CREATE TABLE IF NOT EXISTS practica_estudiante (
    id_practica                  BIGSERIAL PRIMARY KEY,
    id_matricula_detalle         BIGINT NOT NULL REFERENCES matricula_detalle(id_matricula_detalle),
    id_periodo_empresa           BIGINT NOT NULL REFERENCES empresa(id_empresa),
    id_periodo_tutor_empresarial BIGINT REFERENCES tutor_empresarial(id_tutor_empresarial),
    id_periodo_docente           BIGINT NOT NULL REFERENCES docente(id_docente),
    total_horas_requeridas       NUMERIC(6,2) NOT NULL DEFAULT 400,
    total_horas_cumplidas        NUMERIC(6,2) NOT NULL DEFAULT 0,
    estado                       VARCHAR(20) NOT NULL DEFAULT 'EN_CURSO'
                                  CHECK (estado IN ('EN_CURSO','FINALIZADA','SUSPENDIDA')),
    creado_en                    TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_practica_matricula ON practica_estudiante(id_matricula_detalle);

CREATE TABLE IF NOT EXISTS registro_diario_practica (
    id_registro   BIGSERIAL PRIMARY KEY,
    id_practica   BIGINT NOT NULL REFERENCES practica_estudiante(id_practica),
    fecha         DATE NOT NULL,
    ingreso       TIME,
    sal_alm       TIME,
    reg_alm       TIME,
    salida        TIME,
    horas_dia     NUMERIC(4,2),
    observacion   TEXT,
    creado_en     TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_practica, fecha)
);
CREATE INDEX IF NOT EXISTS idx_regdiario_practica ON registro_diario_practica(id_practica);

CREATE TABLE IF NOT EXISTS plan_rotacion (
    id_plan_rotacion   BIGSERIAL PRIMARY KEY,
    id_practica        BIGINT NOT NULL REFERENCES practica_estudiante(id_practica),
    puesto_aprendizaje VARCHAR(150) NOT NULL,
    semana_inicio      SMALLINT NOT NULL,
    semana_fin         SMALLINT NOT NULL,
    creado_en          TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_planrotacion_practica ON plan_rotacion(id_practica);

CREATE TABLE IF NOT EXISTS informe_aprendizaje (
    id_informe      BIGSERIAL PRIMARY KEY,
    id_practica     BIGINT NOT NULL REFERENCES practica_estudiante(id_practica),
    reflexion       TEXT,
    fecha_entrega   DATE DEFAULT CURRENT_DATE,
    estado          VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
                    CHECK (estado IN ('PENDIENTE','ENTREGADO','APROBADO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_informeaprend_practica ON informe_aprendizaje(id_practica);

CREATE TABLE IF NOT EXISTS bitacora_semanal (
    id_bitacora             BIGSERIAL PRIMARY KEY,
    id_informe              BIGINT NOT NULL REFERENCES informe_aprendizaje(id_informe),
    semana                  SMALLINT NOT NULL,
    actividades_realizadas  TEXT NOT NULL,
    creado_en               TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_informe, semana)
);
CREATE INDEX IF NOT EXISTS idx_bitacora_informe ON bitacora_semanal(id_informe);

CREATE TABLE IF NOT EXISTS evaluacion_practica (
    id_evaluacion         BIGSERIAL PRIMARY KEY,
    id_practica           BIGINT NOT NULL REFERENCES practica_estudiante(id_practica),
    id_rubrica            BIGINT NOT NULL REFERENCES rubrica(id_rubrica),
    tipo_evaluador        VARCHAR(20) NOT NULL CHECK (tipo_evaluador IN ('EMPRESA','INSTITUTO')),
    nota_final_calculada  NUMERIC(5,2),
    fecha_evaluacion      DATE DEFAULT CURRENT_DATE,
    creado_en             TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_practica, id_rubrica, tipo_evaluador)
);
CREATE INDEX IF NOT EXISTS idx_evalpractica_practica ON evaluacion_practica(id_practica);

CREATE TABLE IF NOT EXISTS documento_fase_practica (
    id_documento    BIGSERIAL PRIMARY KEY,
    id_practica     BIGINT NOT NULL REFERENCES practica_estudiante(id_practica),
    codigo_formato  VARCHAR(20) NOT NULL,
    nombre          VARCHAR(150) NOT NULL,
    url_archivo     VARCHAR(300),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_docfase_codigo ON documento_fase_practica(codigo_formato);

-- =========================================================
-- 9. VINCULACIÓN CON LA SOCIEDAD
--    Incluye los 2 ajustes de feedback: vinculacion_objetivo
--    y resultado_aprendizaje
-- =========================================================

CREATE TABLE IF NOT EXISTS vinculacion_estudiante (
    id              BIGSERIAL PRIMARY KEY,
    id_periodo      BIGINT NOT NULL REFERENCES periodo_academico(id_periodo),
    id_matricula_detalle BIGINT NOT NULL REFERENCES matricula_detalle(id_matricula_detalle),
    id_empresa      BIGINT REFERENCES empresa(id_empresa),
    id_docente      BIGINT NOT NULL REFERENCES docente(id_docente),
    proyecto        VARCHAR(200) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    estado          VARCHAR(20) NOT NULL DEFAULT 'EN_CURSO'
                    CHECK (estado IN ('EN_CURSO','FINALIZADO','SUSPENDIDO')),
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vinculacion_objetivo (
    id_objetivo   BIGSERIAL PRIMARY KEY,
    id_vinc       BIGINT NOT NULL REFERENCES vinculacion_estudiante(id),
    descripcion   TEXT NOT NULL,
    orden         SMALLINT NOT NULL DEFAULT 1,
    estado        VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
                  CHECK (estado IN ('ACTIVO','CUMPLIDO','INACTIVO')),
    creado_en     TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vincobjetivo_vinc ON vinculacion_objetivo(id_vinc);

CREATE TABLE IF NOT EXISTS vinculacion_actividad_estudiante (
    id                      BIGSERIAL PRIMARY KEY,
    id_vinc                 BIGINT NOT NULL REFERENCES vinculacion_estudiante(id),
    fecha                   DATE NOT NULL,
    h_inicio                TIME NOT NULL,
    h_fin                   TIME NOT NULL,
    total_h                 NUMERIC(4,2) NOT NULL,
    actividades             TEXT NOT NULL,
    resultado_aprendizaje   TEXT,
    creado_en               TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vincactividad_vinc ON vinculacion_actividad_estudiante(id_vinc);

ALTER TABLE vinculacion_actividad_estudiante
    ADD COLUMN IF NOT EXISTS resultado_aprendizaje TEXT;

CREATE TABLE IF NOT EXISTS vinculacion_asistencia_tutor (
    id              BIGSERIAL PRIMARY KEY,
    id_vinc         BIGINT NOT NULL REFERENCES vinculacion_estudiante(id),
    fecha           DATE NOT NULL,
    h_inicio        TIME NOT NULL,
    h_fin           TIME NOT NULL,
    total_h         NUMERIC(4,2) NOT NULL,
    observaciones   TEXT,
    creado_en       TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vincasistencia_vinc ON vinculacion_asistencia_tutor(id_vinc);

CREATE TABLE IF NOT EXISTS vinculacion_informe (
    id                  BIGSERIAL PRIMARY KEY,
    id_vinc             BIGINT NOT NULL REFERENCES vinculacion_estudiante(id),
    fecha               DATE NOT NULL,
    actividad_macro     VARCHAR(200) NOT NULL,
    resultado_aprendizaje TEXT,
    creado_en           TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vincinforme_vinc ON vinculacion_informe(id_vinc);

CREATE TABLE IF NOT EXISTS evaluacion_vinculacion (
    id           BIGSERIAL PRIMARY KEY,
    id_vinc      BIGINT NOT NULL REFERENCES vinculacion_estudiante(id),
    id_rubrica   BIGINT NOT NULL REFERENCES rubrica(id_rubrica),
    nota_final   NUMERIC(5,2),
    creado_en    TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (id_vinc, id_rubrica)
);
CREATE INDEX IF NOT EXISTS idx_evalvinc_vinc ON evaluacion_vinculacion(id_vinc);

-- =========================================================
-- 10. PORTAFOLIO DOCENTE
-- =========================================================

CREATE TABLE IF NOT EXISTS portafolio_reporte_notas (
    id_reporte          BIGSERIAL PRIMARY KEY,
    id_periodo          BIGINT NOT NULL REFERENCES periodo_academico(id_periodo),
    id_docente_asignatura BIGINT NOT NULL REFERENCES docente_asignatura(id_docente_asignatura),
    tipo_reporte        VARCHAR(20) NOT NULL CHECK (tipo_reporte IN ('APORTE_1','APORTE_2','SUPLETORIO')),
    fecha_generacion    TIMESTAMP NOT NULL DEFAULT NOW(),
    estado              VARCHAR(20) NOT NULL DEFAULT 'GENERADO'
                        CHECK (estado IN ('GENERADO','ANULADO'))
);
CREATE INDEX IF NOT EXISTS idx_portreporte_docasig ON portafolio_reporte_notas(id_docente_asignatura);

CREATE TABLE IF NOT EXISTS portafolio_aceptacion_estudiante (
    id_aceptacion       BIGSERIAL PRIMARY KEY,
    id_reporte          BIGINT NOT NULL REFERENCES portafolio_reporte_notas(id_reporte),
    id_matricula_detalle BIGINT NOT NULL REFERENCES matricula_detalle(id_matricula_detalle),
    nota_registrada     NUMERIC(5,2) NOT NULL,
    estado_aceptacion   VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
                        CHECK (estado_aceptacion IN ('PENDIENTE','ACEPTADO','RECHAZADO')),
    fecha_respuesta     TIMESTAMP,
    UNIQUE (id_reporte, id_matricula_detalle)
);
CREATE INDEX IF NOT EXISTS idx_portaceptacion_reporte ON portafolio_aceptacion_estudiante(id_reporte);

-- =========================================================
-- 11. ÍNDICES ADICIONALES SOBRE TABLAS BASE  (ya existentes)
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_nivel_carrera ON nivel_academico(id_carrera);
CREATE INDEX IF NOT EXISTS idx_asignatura_nivel ON asignatura(id_nivel);
CREATE INDEX IF NOT EXISTS idx_docente_carrera ON docente(id_carrera);
CREATE INDEX IF NOT EXISTS idx_paralelo_docente ON paralelo(id_docente);
CREATE INDEX IF NOT EXISTS idx_docasig_periodo ON docente_asignatura(id_periodo);
CREATE INDEX IF NOT EXISTS idx_matricula_estudiante ON matricula(id_estudiante);
CREATE INDEX IF NOT EXISTS idx_matricula_periodo ON matricula(id_periodo);
CREATE INDEX IF NOT EXISTS idx_matdetalle_matricula ON matricula_detalle(id_matricula);
CREATE INDEX IF NOT EXISTS idx_usuario_correo ON usuario(correo);

-- =========================================================
-- 12. TRIGGER GENÉRICO PARA actualizado_en  (ya existente)
-- =========================================================

CREATE OR REPLACE FUNCTION fn_actualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.actualizado_en = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_periodo_academico_upd ON periodo_academico;
CREATE TRIGGER trg_periodo_academico_upd
    BEFORE UPDATE ON periodo_academico
    FOR EACH ROW EXECUTE FUNCTION fn_actualizar_timestamp();

DROP TRIGGER IF EXISTS trg_carrera_upd ON carrera;
CREATE TRIGGER trg_carrera_upd
    BEFORE UPDATE ON carrera
    FOR EACH ROW EXECUTE FUNCTION fn_actualizar_timestamp();

DROP TRIGGER IF EXISTS trg_matricula_detalle_upd ON matricula_detalle;
CREATE TRIGGER trg_matricula_detalle_upd
    BEFORE UPDATE ON matricula_detalle
    FOR EACH ROW EXECUTE FUNCTION fn_actualizar_timestamp();

COMMIT;

-- =========================================================
-- FIN DEL SCRIPT DE ESTRUCTURA
-- Siguiente paso: correr datos_ejemplo_completo.sql para
-- poblar datos de prueba y validar el despliegue.
-- =========================================================
