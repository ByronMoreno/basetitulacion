# Ejemplos de Datos - Modelo Académico Completo

Este documento simula el flujo de información de extremo a extremo, desde la creación de un período académico hasta la calificación final de la práctica de un estudiante. Usaremos como ejemplo a **Juan Pérez** en la carrera de **Desarrollo de Software**.

---

## FASE 1: ESTRUCTURA PERMANENTE E INSTITUCIONAL

**1. Tabla: `carrera`**
| id_carrera | codigo | nombre | modalidad | estado |
| :--- | :--- | :--- | :--- | :--- |
| 1 | DS-01 | Desarrollo de Software | DUAL | ACTIVO |

**2. Tabla: `nivel`**
| id_nivel | id_carrera | nombre | estado |
| :--- | :--- | :--- | :--- |
| 5 | 1 *(Software)* | Quinto Semestre | ACTIVO |

**3. Tabla: `asignatura`**
| id_asignatura | id_nivel | codigo | nombre | horas | creditos |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 45 | 5 *(Quinto)* | PPP-501 | Prácticas Pre Profesionales V | 400 | 10 |
| 46 | 5 *(Quinto)* | PROG-502 | Programación Móvil Avanzada | 120 | 4 |

**4. Tablas Base: `jornada` y `paralelo`**
| id_jornada | nombre | | id_paralelo | nombre |
| :--- | :--- | :--- | :--- | :--- |
| 1 | MATUTINA | | 1 | A |

**5. Tabla: `docente`**
| id_docente | cedula | nombres | apellidos | correo |
| :--- | :--- | :--- | :--- | :--- |
| 8 | 1700000001 | Ana | Martínez | amartinez@instituto.edu.ec |

---

## FASE 2: APERTURA DEL PERÍODO Y OFERTA ACADÉMICA

**6. Tabla: `periodo_academico`**
| id_periodo | codigo | nombre | fecha_inicio | fecha_fin | estado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 10 | 2026-I | Período Lectivo 2026-I | 2026-04-01 | 2026-08-30 | ACTIVO |

**7. Tabla: `periodo_carrera`** (Fechas específicas para la carrera)
| id_periodo_carrera | id_periodo | id_carrera | inicio_fase_teorica | fin_fase_teorica | inicio_fase_practica | fin_fase_practica |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 25 | 10 *(2026-I)* | 1 *(Software)* | 2026-04-01 | 2026-05-30 | 2026-06-01 | 2026-08-30 |

**8. Tabla: `oferta_asignatura`** (Las clases que se van a dictar)
| id_oferta_asignatura | id_periodo_carrera | id_asignatura | id_docente | id_jornada | id_paralelo | cupos |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 150 | 25 | 45 *(Prácticas)* | 8 *(Ana)* | 1 | 1 | 40 |
| 151 | 25 | 46 *(Móvil)* | 8 *(Ana)* | 1 | 1 | 40 |

---

## FASE 3: MATRICULACIÓN DEL ESTUDIANTE

**9. Tabla: `estudiante`**
| id_estudiante | cedula | nombres | apellidos |
| :--- | :--- | :--- | :--- |
| 1 | 1712345678 | Juan Carlos | Pérez López |

**10. Tabla: `matricula`** (Cabecera)
| id_matricula | numero | id_estudiante | id_periodo | id_carrera | fecha_matricula | estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 800 | MAT-2026-001 | 1 *(Juan)* | 10 | 1 | 2026-03-25 | ACTIVA |

**11. Tabla: `matricula_detalle`** (Las materias que toma Juan)
| id_matricula_detalle | id_matricula | id_oferta_asignatura | nota_ap1 | nota_final | estado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1005 | 800 | 150 *(Prácticas V)* | *null* | *null* | CURSANDO |
| 1006 | 800 | 151 *(Móvil)* | 8.50 | *null* | CURSANDO |

---

## FASE 4: MÓDULO DE FASE PRÁCTICA (DUAL)

### 4.1 Entorno Laboral
**12. Tabla: `empresa` y `tutor_empresarial`**
| id_empresa | razon_social | | id_tutor_empresarial | id_empresa | nombres | cargo |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 5 | TechCorp S.A. | | 12 | 5 *(TechCorp)* | Ing. Roberto Gómez | Jefe Dev |

**13. Tabla: `practica_estudiante`** (Asignación)
| id_practica | id_matricula_detalle | id_empresa | id_tutor_empresarial | id_docente | total_horas | estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **50** | 1005 *(Juan en Prácticas V)* | 5 | 12 *(Roberto)* | 8 *(Ana)* | 400 | EN_CURSO |

### 4.2 Plan Marco y Rotación
**14. Tabla: `item_plan_marco`** (Lo que el instituto espera en 5to Nivel)
| id_item_pm | id_plan_marco | resultado_aprendizaje | nivel_logro_esperado |
| :--- | :--- | :--- | :--- |
| 201 | 3 *(5to Nivel)* | Desarrollar APIs RESTful | 4 |

**15. Tabla: `evaluacion_plan_marco`** (Lo que Juan alcanzó al final de la práctica)
| id_evaluacion_pm | id_practica | id_item_pm | nivel_real_alcanzado |
| :--- | :--- | :--- | :--- |
| 801 | **50** | 201 *(Desarrollar APIs)* | 4 |

**16. Tabla: `plan_rotacion` y `plan_rotacion_semana`**
| id_plan_rotacion | id_practica | id_item_pm | puesto_aprendizaje | | id_rotacion_semana | semana |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 301 | **50** | 201 | Backend | | 1 | 1 |
| | | | | | 2 | 2 |

### 4.3 Asistencia y Bitácora
**17. Tabla: `registro_diario_practica`**
| id | id_practica | fecha | ingreso | sal_almuerzo | reg_almuerzo | salida | firma_estudiante |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | **50** | 2026-06-01 | 08:00 | 13:00 | 14:00 | 17:00 | TRUE |

**18. Tabla: `informe_aprendizaje` (Cabecera) y `bitacora_semanal` (Detalle)**
| id_informe | reflexion_aprendizaje | | id_bitacora | semana | actividades_realizadas | actividades_autonomas |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 70 | *"Aprendí sobre arquitectura..."* | | 140 | 1 | Creación de CRUD | Documentación Express |

### 4.4 Evaluación con Rúbricas
**19. Tabla: `item_rubrica`**
| id_item | id_rubrica | descripcion_criterio | puntaje_maximo | ponderacion |
| :--- | :--- | :--- | :--- | :--- |
| 901 | 2 *(Empresarial)* | Calidad técnica del trabajo | 10.00 | 100% |

**20. Tabla: `evaluacion_practica` y `detalle_evaluacion`** (Notas de Juan)
| id_evaluacion | id_practica | evaluador | nota_final | | id_detalle | id_item | puntaje_asignado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 500 | **50** | EMPRESARIAL | 9.00 | | 1 | 901 | 9.00 |

---

## FASE 5: CV DEL ESTUDIANTE

**21. Tablas del CV (`cv_dato_academico`, `cv_experiencia_laboral`, `cv_practica_dual`)**
*Ejemplo Histórico de Juan:*
| id_cv_practica | id_estudiante | anio_periodo | institucion | cargo | actividades_realizadas |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 34 | 1 *(Juan)* | 2025-II | SoftSolutions | Asistente QA | Automatización |

---

## FASE 6: SEGURIDAD (USUARIOS Y ROLES)

**22. Tabla: `usuario`, `rol` y `usuario_rol`**
| id_usuario | correo | id_estudiante | | id_rol | nombre | | id_usuario | id_rol |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 100 | jperez@edu.ec | 1 *(Juan)* | | 1 | ESTUDIANTE | | 100 | 1 |
| 101 | amartinez@edu.ec | *null* (Es docente) | | 2 | DOCENTE | | 101 | 2 |
