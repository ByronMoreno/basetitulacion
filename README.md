# Ejemplos de Datos - Modelo Académico Completo

Este documento contiene ejemplos de datos (3 tuplas por tabla) para entender el flujo completo del sistema, incluyendo módulos base, fase práctica (dual), vinculación y portafolio docente.

---

## FASE 1: ESTRUCTURA PERMANENTE E INSTITUCIONAL

**1. Tabla: `carrera`**
| id_carrera | codigo | nombre | modalidad | estado |
| :--- | :--- | :--- | :--- | :--- |
| 1 | DS-01 | Desarrollo de Software | DUAL | ACTIVO |
| 2 | MKT-01 | Marketing Digital | PRESENCIAL | ACTIVO |
| 3 | EL-01 | Electricidad Industrial | DUAL | ACTIVO |

**2. Tabla: `nivel`**
| id_nivel | id_carrera | nombre | estado |
| :--- | :--- | :--- | :--- |
| 4 | 1 | Cuarto Semestre | ACTIVO |
| 5 | 1 | Quinto Semestre | ACTIVO |
| 6 | 2 | Tercer Semestre | ACTIVO |

**3. Tabla: `asignatura`**
| id_asignatura | id_nivel | codigo | nombre | horas | creditos |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 44 | 4 | PPP-401 | Prácticas Pre Profesionales IV | 400 | 10 |
| 45 | 5 | PPP-501 | Prácticas Pre Profesionales V | 400 | 10 |
| 46 | 5 | PROG-502 | Programación Móvil Avanzada | 120 | 4 |

**4. Tablas Base: `jornada` y `paralelo`**
| id_jornada | nombre | | id_paralelo | nombre |
| :--- | :--- | :--- | :--- | :--- |
| 1 | MATUTINA | | 1 | A |
| 2 | VESPERTINA | | 2 | B |
| 3 | NOCTURNA | | 3 | C |

**5. Tabla: `docente`**
| id_docente | cedula | nombres | apellidos | correo |
| :--- | :--- | :--- | :--- | :--- |
| 8 | 1700000001 | Ana | Martínez | amartinez@instituto.edu.ec |
| 9 | 1700000002 | Luis | Fernando | lfernando@instituto.edu.ec |
| 10 | 1700000003 | Carlos | Ruiz | cruiz@instituto.edu.ec |

---

## FASE 2: APERTURA DEL PERÍODO Y OFERTA ACADÉMICA

**6. Tabla: `periodo_academico`**
| id_periodo | codigo | nombre | fecha_inicio | fecha_fin | estado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 9 | 2025-II | Período Lectivo 2025-II | 2025-10-01 | 2026-02-28 | INACTIVO |
| 10 | 2026-I | Período Lectivo 2026-I | 2026-04-01 | 2026-08-30 | ACTIVO |
| 11 | 2026-II | Período Lectivo 2026-II | 2026-10-01 | 2027-02-28 | PLANIFICADO |

**7. Tabla: `periodo_carrera`**
| id_periodo_carrera | id_periodo | id_carrera | inicio_fase_teorica | fin_fase_teorica | inicio_fase_practica | fin_fase_practica |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 24 | 9 | 1 | 2025-10-01 | 2025-12-30 | 2026-01-01 | 2026-02-28 |
| 25 | 10 | 1 | 2026-04-01 | 2026-05-30 | 2026-06-01 | 2026-08-30 |
| 26 | 10 | 2 | 2026-04-01 | 2026-07-30 | null | null |

**8. Tabla: `oferta_asignatura`**
| id_oferta_asignatura | id_periodo_carrera | id_asignatura | id_docente | id_jornada | id_paralelo | cupos |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 150 | 25 | 45 | 8 | 1 | 1 | 40 |
| 151 | 25 | 46 | 8 | 1 | 1 | 40 |
| 152 | 25 | 44 | 9 | 2 | 2 | 35 |

---

## FASE 3: MATRICULACIÓN DEL ESTUDIANTE

**9. Tabla: `estudiante`**
| id_estudiante | cedula | nombres | apellidos |
| :--- | :--- | :--- | :--- |
| 1 | 1712345678 | Juan Carlos | Pérez López |
| 2 | 1723456789 | María Fernanda | Gómez Silva |
| 3 | 1734567890 | Pedro Luis | Castro Vega |

**10. Tabla: `matricula`**
| id_matricula | numero | id_estudiante | id_periodo | id_carrera | fecha_matricula | estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 800 | MAT-2026-001 | 1 | 10 | 1 | 2026-03-25 | ACTIVA |
| 801 | MAT-2026-002 | 2 | 10 | 1 | 2026-03-26 | ACTIVA |
| 802 | MAT-2026-003 | 3 | 10 | 1 | 2026-03-27 | ACTIVA |

**11. Tabla: `matricula_detalle`**
| id_matricula_detalle | id_matricula | id_oferta_asignatura | nota_ap1 | nota_ap2 | nota_supletorio | estado |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1005 | 800 | 150 | 8.50 | 9.00 | null | APROBADO |
| 1006 | 801 | 150 | 7.00 | 6.50 | 8.00 | APROBADO |
| 1007 | 802 | 151 | 9.50 | 9.00 | null | APROBADO |

---

## FASE 4: MÓDULO DE FASE PRÁCTICA (DUAL)

**12. Tablas: `empresa` y `tutor_empresarial`**
| id_empresa | ruc | razon_social | | id_tutor_empresarial | id_empresa | nombres | cargo |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 5 | 179001 | TechCorp S.A. | | 12 | 5 | Roberto Gómez | Jefe Dev |
| 6 | 179002 | DataSoft Cía | | 13 | 6 | Lucía Paz | Gerente |
| 7 | 179003 | MegaRedes S.A. | | 14 | 7 | Jorge Torres | Sup. IT |

**13. Tabla: `practica_estudiante`**
| id_practica | id_matricula_detalle | id_empresa | id_tutor_empresarial | id_docente | total_horas |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 50 | 1005 (Juan) | 5 | 12 | 8 | 400 |
| 51 | 1006 (María) | 6 | 13 | 9 | 400 |
| 52 | 1007 (Pedro) | 7 | 14 | 8 | 400 |

**14. Tabla: `item_plan_marco`**
| id_item_pm | id_plan_marco | resultado_aprendizaje | nivel_logro_esperado |
| :--- | :--- | :--- | :--- |
| 201 | 3 (5to Nivel) | Desarrollar APIs RESTful | 4 |
| 202 | 3 (5to Nivel) | Administrar Bases de Datos | 3 |
| 203 | 3 (5to Nivel) | Despliegue en la Nube | 4 |

**15. Tabla: `evaluacion_plan_marco`**
| id_evaluacion_pm | id_practica | id_item_pm | nivel_real_alcanzado |
| :--- | :--- | :--- | :--- |
| 801 | 50 (Juan) | 201 | 4 |
| 802 | 50 (Juan) | 202 | 4 |
| 803 | 51 (María) | 201 | 3 |

**16. Tabla: `plan_rotacion`**
| id_plan_rotacion | id_practica | id_item_pm | puesto_aprendizaje |
| :--- | :--- | :--- | :--- |
| 301 | 50 | 201 | Backend |
| 302 | 50 | 202 | DBA |
| 303 | 51 | 201 | Desarrollo |

**17. Tabla: `plan_rotacion_semana`**
| id_rotacion_semana | id_plan_rotacion | semana |
| :--- | :--- | :--- |
| 1 | 301 | 1 |
| 2 | 301 | 2 |
| 3 | 302 | 3 |

**18. Tabla: `registro_diario_practica`**
| id_registro | id_practica | fecha | ingreso | sal_alm | reg_alm | salida |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 50 | 2026-06-01 | 08:00 | 13:00 | 14:00 | 17:00 |
| 2 | 50 | 2026-06-02 | 08:00 | 13:00 | 14:00 | 17:00 |
| 3 | 51 | 2026-06-01 | 09:00 | 13:00 | 14:00 | 18:00 |

**19. Tabla: `informe_aprendizaje` y `bitacora_semanal`**
| id_informe | id_practica | reflexion | | id_bitacora | semana | actividades_realizadas |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 70 | 50 | Todo excelente | | 140 | 1 | Creación de CRUD |
| 71 | 51 | Muy complejo | | 141 | 1 | Diseño de interfaces |
| 72 | 52 | Buen ambiente | | 142 | 1 | Testing |

**20. Tabla: `evaluacion_practica` y `detalle_evaluacion`**
| id_evaluacion | id_practica | tipo | final | | id_detalle | id_item | puntaje |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 500 | 50 | EMPRESARIAL | 9.00 | | 1 | 901 | 9.00 |
| 501 | 50 | ACADEMICA | 8.50 | | 2 | 902 | 8.50 |
| 502 | 51 | EMPRESARIAL | 7.00 | | 3 | 901 | 7.00 |

---

## FASE 5: CV DEL ESTUDIANTE

**21. Tabla: `cv_practica_dual`**
| id | id_estudiante | anio_periodo | institucion | cargo | actividades_realizadas |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 34 | 1 | 2025-II | SoftSolutions | Asistente QA | Automatización |
| 35 | 2 | 2025-II | InfoTech | Junior | Soporte técnico |
| 36 | 3 | 2025-II | RedesCorp | Técnico | Instalación de red |

---

## FASE 6: MÓDULO DE VINCULACIÓN CON LA SOCIEDAD

**22. Tabla: `vinculacion_estudiante`**
| id | id_matricula_detalle | empresa | docente | proyecto | fecha_inicio | fecha_fin |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 1005 (Juan) | 5 | 8 | Alfabetización Digital | 2025-10-20 | 2025-12-20 |
| 2 | 1006 (María) | 6 | 9 | Reciclaje Tecnológico | 2025-10-21 | 2025-12-21 |
| 3 | 1007 (Pedro) | 7 | 8 | Desarrollo Web ONGs | 2025-10-22 | 2025-12-22 |

**23. Tabla: `vinculacion_actividad_estudiante` (Horas Alumno)**
| id | id_vinc | fecha | h_inicio | h_fin | total_h | actividades |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | 2025-10-20 | 10:00 | 12:00 | 2.0 | Charla a la comunidad |
| 2 | 1 | 2025-10-21 | 14:00 | 17:00 | 3.0 | Taller de ofimática |
| 3 | 2 | 2025-10-21 | 09:00 | 11:00 | 2.0 | Clasificación de PC |

**24. Tabla: `vinculacion_asistencia_tutor` (Horas Docente)**
| id | id_vinc | fecha | h_inicio | h_fin | total_h | observaciones |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | 2025-10-22 | 09:00 | 10:00 | 1.0 | Revisión de avance |
| 2 | 1 | 2025-10-29 | 09:00 | 10:00 | 1.0 | Corrección de errores |
| 3 | 2 | 2025-10-23 | 10:00 | 11:00 | 1.0 | Todo en orden |

**25. Tabla: `vinculacion_informe`**
| id | id_vinc | fecha | actividad_macro | resultado_aprendizaje |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | 2025-10-27 | Capacitación Excel | Usuarios manejan celdas |
| 2 | 1 | 2025-11-03 | Capacitación Word | Usuarios redactan cartas |
| 3 | 2 | 2025-10-28 | Desarme equipos | 10 PCs reciclados |

**26. Tabla: `evaluacion_vinculacion`**
| id | id_vinc | id_rubrica | nota_final |
| :--- | :--- | :--- | :--- |
| 1 | 1 | 4 (Vinc) | 9.50 |
| 2 | 2 | 4 (Vinc) | 8.80 |
| 3 | 3 | 4 (Vinc) | 10.00 |

---

## FASE 7: PORTAFOLIO DOCENTE (ACEPTACIÓN DE NOTAS)

**27. Tabla: `portafolio_reporte_notas` (Cabecera)**
| id_reporte | id_oferta_asignatura | tipo_reporte | fecha_generacion | estado |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 150 (Prácticas V) | APORTE_1 | 2026-05-15 10:00 | GENERADO |
| 2 | 150 (Prácticas V) | APORTE_2 | 2026-07-15 11:00 | GENERADO |
| 3 | 151 (Móvil) | APORTE_1 | 2026-05-16 09:30 | GENERADO |

**28. Tabla: `portafolio_aceptacion_estudiante` (Firma Estudiante)**
| id_aceptacion | id_reporte | id_matricula_det | nota_registrada | estado_aceptacion |
| :--- | :--- | :--- | :--- | :--- |
| 1 | 1 | 1005 (Juan) | 8.50 | ACEPTADO |
| 2 | 1 | 1006 (María) | 7.00 | PENDIENTE |
| 3 | 3 | 1007 (Pedro) | 9.50 | ACEPTADO |

---

## FASE 8: SEGURIDAD (USUARIOS Y ROLES)

**29. Tabla: `usuario`, `rol` y `usuario_rol`**
| id_usuario | correo | | id_rol | nombre | | id_usuario | id_rol |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 100 | jperez@... | | 1 | ESTUDIANTE | | 100 | 1 |
| 101 | amartinez@...| | 2 | DOCENTE | | 101 | 2 |
| 102 | mgomez@... | | 1 | ESTUDIANTE | | 102 | 1 |
