// =====================================================
// SCRIPT DE DATOS DE EJEMPLO PARA CARESYNC (NoSQL)
// =====================================================

// Colección: Pacientes
db.pacientes.insertMany([
  {
    "_id": ObjectId("686e013c36b75142b04e4db1"),
    "id_paciente": "p001",
    "Nombres": "María García",
    "Apellidos": "López Suárez",
    "Sexo": "Femenino",
    "Fecha_nacimiento": "1985-03-15",
    "Telefono": "+51 999 111 222",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 12345678
    },
    "Datos_direccion": [
      {
        "Codigo_postal": 15001,
        "Direccion": "Av. Arequipa 123, Lima"
      },
      {
        "Codigo_postal": 15002,
        "Direccion": "Jr. Huancavelica 456, Lima"
      }
    ],
    "Plan_seguro": {
      "numero_poliza": "POL-001-2024",
      "poliza_activada": true,
      "compania_seguro": "Rimac Seguros",
      "cobertura_seguro": [
        "salud mental",
        "psicología",
        "psiquiatría"
      ]
    },
    "fecha_registro": new Date("2024-01-15"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e013c36b75142b04e4db2"),
    "id_paciente": "p002",
    "Nombres": "Carlos Rodríguez",
    "Apellidos": "Martínez Pérez",
    "Sexo": "Masculino",
    "Fecha_nacimiento": "1990-07-22",
    "Telefono": "+51 999 333 444",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 23456789
    },
    "Datos_direccion": [
      {
        "Codigo_postal": 15003,
        "Direccion": "Av. Tacna 789, Lima"
      }
    ],
    "Plan_seguro": {
      "numero_poliza": "POL-002-2024",
      "poliza_activada": true,
      "compania_seguro": "Pacifico Seguros",
      "cobertura_seguro": [
        "psicología básica",
        "terapia familiar"
      ]
    },
    "fecha_registro": new Date("2024-02-10"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e013c36b75142b04e4db3"),
    "id_paciente": "p003",
    "Nombres": "Ana Fernández",
    "Apellidos": "González Ruiz",
    "Sexo": "Femenino",
    "Fecha_nacimiento": "1988-11-08",
    "Telefono": "+51 999 555 666",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 34567890
    },
    "Datos_direccion": [
      {
        "Codigo_postal": 15004,
        "Direccion": "Calle Los Pinos 321, Lima"
      }
    ],
    "Plan_seguro": {
      "numero_poliza": "POL-003-2024",
      "poliza_activada": true,
      "compania_seguro": "La Positiva",
      "cobertura_seguro": [
        "salud integral",
        "psicología",
        "psiquiatría",
        "terapia ocupacional"
      ]
    },
    "fecha_registro": new Date("2024-01-20"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e013c36b75142b04e4db4"),
    "id_paciente": "p004",
    "Nombres": "Luis Pérez",
    "Apellidos": "Sánchez Torres",
    "Sexo": "Masculino",
    "Fecha_nacimiento": "1992-05-30",
    "Telefono": "+51 999 777 888",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 45678901
    },
    "Datos_direccion": [
      {
        "Codigo_postal": 15005,
        "Direccion": "Av. La Marina 654, Lima"
      }
    ],
    "Plan_seguro": {
      "numero_poliza": "POL-004-2023",
      "poliza_activada": false,
      "compania_seguro": "Mapfre Seguros",
      "cobertura_seguro": [
        "especialidades médicas"
      ]
    },
    "fecha_registro": new Date("2024-02-05"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e013c36b75142b04e4db5"),
    "id_paciente": "p005",
    "Nombres": "Carmen López",
    "Apellidos": "Díaz Vargas",
    "Sexo": "Femenino",
    "Fecha_nacimiento": "1987-09-14",
    "Telefono": "+51 999 999 000",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 56789012
    },
    "Datos_direccion": [
      {
        "Codigo_postal": 15006,
        "Direccion": "Jr. Washington 987, Lima"
      }
    ],
    "Plan_seguro": {
      "numero_poliza": "POL-005-2024",
      "poliza_activada": true,
      "compania_seguro": "Rimac Seguros",
      "cobertura_seguro": [
        "cobertura familiar",
        "psicología",
        "terapia de pareja"
      ]
    },
    "fecha_registro": new Date("2024-01-25"),
    "estado": "ACTIVO"
  }
]);

// Colección: Especialistas
db.especialistas.insertMany([
  {
    "_id": ObjectId("686e35be36b75142b04e4db8"),
    "id_especialista": "e001",
    "nombres": "Dr. Juan Martínez",
    "apellidos": "Herrera García",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 67890123
    },
    "credenciales": [
      {
        "rama_especializada": "Licenciatura en Psicología",
        "institucion": "UNMSM",
        "fecha_emision": "2018-03-15",
        "estado": "vigente"
      },
      {
        "rama_especializada": "Maestría en Psicología Clínica",
        "institucion": "PUCP",
        "fecha_emision": "2020-06-20",
        "estado": "vigente"
      }
    ],
    "direccion_trabajo": [
      {
        "institucion": "Clínica San José",
        "direccion": "Av. Javier Prado 1234, Lima"
      },
      {
        "institucion": "Centro Médico Lima",
        "direccion": "Jr. Washington 567, Lima"
      }
    ],
    "agenda_especialista": [
      {
        "id_reunion": "r001",
        "id_paciente": "p001",
        "sesion_tratamiento": [
          {
            "fecha_actividad": "2024-01-22",
            "descripcion_actividad": "Sesión de terapia cognitiva",
            "estado_actividad": "programada"
          },
          {
            "fecha_actividad": "2024-01-29",
            "descripcion_actividad": "Sesión de terapia cognitiva",
            "estado_actividad": "programada"
          }
        ]
      },
      {
        "id_reunion": "r002",
        "id_paciente": "p002",
        "sesion_tratamiento": [
          {
            "fecha_actividad": "2024-02-17",
            "descripcion_actividad": "Sesión de terapia de depresión",
            "estado_actividad": "programada"
          }
        ]
      }
    ],
    "fecha_registro": new Date("2020-01-15"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e35be36b75142b04e4db9"),
    "id_especialista": "e002",
    "nombres": "Dra. Elena Gutiérrez",
    "apellidos": "Ruiz Mendoza",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 78901234
    },
    "credenciales": [
      {
        "rama_especializada": "Licenciatura en Psicología",
        "institucion": "UNMSM",
        "fecha_emision": "2015-07-10",
        "estado": "vigente"
      },
      {
        "rama_especializada": "Especialización en Terapia Familiar",
        "institucion": "Universidad de Lima",
        "fecha_emision": "2017-12-05",
        "estado": "vigente"
      }
    ],
    "direccion_trabajo": [
      {
        "institucion": "Centro Médico Lima",
        "direccion": "Jr. Washington 567, Lima"
      }
    ],
    "agenda_especialista": [
      {
        "id_reunion": "r003",
        "id_paciente": "p003",
        "sesion_tratamiento": [
          {
            "fecha_actividad": "2024-01-27",
            "descripcion_actividad": "Sesión de terapia de autoestima",
            "estado_actividad": "programada"
          }
        ]
      },
      {
        "id_reunion": "r004",
        "id_paciente": "p004",
        "sesion_tratamiento": [
          {
            "fecha_actividad": "2024-02-12",
            "descripcion_actividad": "Sesión de terapia de pánico",
            "estado_actividad": "programada"
          }
        ]
      }
    ],
    "fecha_registro": new Date("2018-03-20"),
    "estado": "ACTIVO"
  },
  {
    "_id": ObjectId("686e35be36b75142b04e4dba"),
    "id_especialista": "e003",
    "nombres": "Dr. Roberto Jiménez",
    "apellidos": "Moreno Silva",
    "tipo_documento": {
      "nombre_documento": "dni",
      "numero_documento": 89012345
    },
    "credenciales": [
      {
        "rama_especializada": "Licenciatura en Psicología",
        "institucion": "UNMSM",
        "fecha_emision": "2012-11-15",
        "estado": "vigente"
      },
      {
        "rama_especializada": "Maestría en Terapia de Pareja",
        "institucion": "Universidad de Lima",
        "fecha_emision": "2014-08-30",
        "estado": "vigente"
      }
    ],
    "direccion_trabajo": [
      {
        "institucion": "Hospital San Martín",
        "direccion": "Av. Brasil 890, Lima"
      }
    ],
    "agenda_especialista": [
      {
        "id_reunion": "r005",
        "id_paciente": "p005",
        "sesion_tratamiento": [
          {
            "fecha_actividad": "2024-02-01",
            "descripcion_actividad": "Sesión de terapia de pareja",
            "estado_actividad": "programada"
          }
        ]
      }
    ],
    "fecha_registro": new Date("2015-06-10"),
    "estado": "ACTIVO"
  }
]);

// Colección: Historia Clínica
db.historia_clinica.insertMany([
  {
    "_id": ObjectId("686e42d736b75142b04e4dcb"),
    "id_paciente": "p001",
    "id_especialista": "e001",
    "fecha_creacion": "2024-01-15",
    "motivo_consulta": "Ansiedad y estrés laboral",
    "antecedentes_paciente": "Paciente presenta síntomas de ansiedad desde hace 6 meses",
    "estado": "ABIERTA",
    "citas": [
      {
        "id_cita": "c001",
        "fecha": "2024-01-22",
        "estado": "CONFIRMADA",
        "descripcion": "Primera consulta",
        "informe_clinico": {
          "fecha_emision": "2024-01-22",
          "resumen": "Paciente presenta síntomas de ansiedad moderada",
          "analisis": "Ansiedad relacionada con estrés laboral",
          "progreso": "Inicio de tratamiento",
          "recomendacion": "Seguimiento semanal"
        }
      },
      {
        "id_cita": "c002",
        "fecha": "2024-01-29",
        "estado": "PENDIENTE",
        "descripcion": "Seguimiento",
        "informe_clinico": {
          "fecha_emision": "2024-01-29"
        }
      }
    ],
    "diagnosticos": [
      {
        "id_diag": "d001",
        "enfermedad": "Trastorno de Ansiedad Generalizada",
        "fecha_diagnostico": "2024-01-15",
        "sintomas": [
          "preocupación excesiva",
          "tensión muscular",
          "dificultad para concentrarse"
        ],
        "observaciones": "Paciente presenta síntomas de ansiedad excesiva y preocupación",
        "recomendaciones": "Terapia cognitiva-conductual y medicación"
      }
    ],
    "tratamientos": [
      {
        "id_tratamiento": "t001",
        "fecha_inicio": "2024-01-15",
        "estado": "ACTIVO",
        "duracion_dias": 90,
        "medicacion": [
          {
            "nombre_medicamento": "Sertralina",
            "descripcion_dosis": "50mg",
            "intervalor_dosis_horas": 24,
            "precio_unitario_soles": 2.5,
            "duracion_medicamento_dias": 90
          }
        ]
      }
    ]
  },
  {
    "_id": ObjectId("686e42d736b75142b04e4dcc"),
    "id_paciente": "p002",
    "id_especialista": "e001",
    "fecha_creacion": "2024-02-10",
    "motivo_consulta": "Depresión post-parto",
    "antecedentes_paciente": "Paciente con síntomas depresivos después del nacimiento de su hijo",
    "estado": "ABIERTA",
    "citas": [
      {
        "id_cita": "c003",
        "fecha": "2024-02-17",
        "estado": "CONFIRMADA",
        "descripcion": "Primera consulta",
        "informe_clinico": {
          "fecha_emision": "2024-02-17",
          "resumen": "Síntomas depresivos leves",
          "analisis": "Depresión post-parto",
          "progreso": "Inicio de terapia",
          "recomendacion": "Seguimiento quincenal"
        }
      }
    ],
    "diagnosticos": [
      {
        "id_diag": "d002",
        "enfermedad": "Depresión Post-parto",
        "fecha_diagnostico": "2024-02-10",
        "sintomas": [
          "tristeza persistente",
          "pérdida de interés",
          "cambios en el apetito"
        ],
        "observaciones": "Síntomas depresivos después del parto",
        "recomendaciones": "Terapia psicológica y apoyo familiar"
      }
    ],
    "tratamientos": [
      {
        "id_tratamiento": "t002",
        "fecha_inicio": "2024-02-10",
        "estado": "ACTIVO",
        "duracion_dias": 120,
        "medicacion": [
          {
            "nombre_medicamento": "Fluoxetina",
            "descripcion_dosis": "20mg",
            "intervalor_dosis_horas": 24,
            "precio_unitario_soles": 3.0,
            "duracion_medicamento_dias": 120
          }
        ]
      }
    ]
  },
  {
    "_id": ObjectId("686e42d736b75142b04e4dcd"),
    "id_paciente": "p003",
    "id_especialista": "e002",
    "fecha_creacion": "2024-01-20",
    "motivo_consulta": "Problemas de autoestima",
    "antecedentes_paciente": "Paciente refiere baja autoestima y dificultades sociales",
    "estado": "ABIERTA",
    "citas": [
      {
        "id_cita": "c004",
        "fecha": "2024-01-27",
        "estado": "CONFIRMADA",
        "descripcion": "Primera consulta",
        "informe_clinico": {
          "fecha_emision": "2024-01-27",
          "resumen": "Baja autoestima significativa",
          "analisis": "Problemas de autoconcepto",
          "progreso": "Inicio de terapia cognitiva",
          "recomendacion": "Seguimiento semanal"
        }
      }
    ],
    "diagnosticos": [
      {
        "id_diag": "d003",
        "enfermedad": "Trastorno de Autoestima",
        "fecha_diagnostico": "2024-01-20",
        "sintomas": [
          "baja autoestima",
          "dificultades sociales",
          "autocrítica excesiva"
        ],
        "observaciones": "Baja autoestima y dificultades de autoconcepto",
        "recomendaciones": "Terapia cognitiva y ejercicios de autoestima"
      }
    ],
    "tratamientos": [
      {
        "id_tratamiento": "t003",
        "fecha_inicio": "2024-01-20",
        "estado": "ACTIVO",
        "duracion_dias": 60,
        "medicacion": [
          {
            "nombre_medicamento": "Alprazolam",
            "descripcion_dosis": "0.5mg",
            "intervalor_dosis_horas": 12,
            "precio_unitario_soles": 1.8,
            "duracion_medicamento_dias": 30
          }
        ]
      }
    ]
  },
  {
    "_id": ObjectId("686e42d736b75142b04e4dce"),
    "id_paciente": "p004",
    "id_especialista": "e002",
    "fecha_creacion": "2024-02-05",
    "motivo_consulta": "Trastorno de pánico",
    "antecedentes_paciente": "Paciente experimenta ataques de pánico recurrentes",
    "estado": "ABIERTA",
    "citas": [
      {
        "id_cita": "c005",
        "fecha": "2024-02-12",
        "estado": "CONFIRMADA",
        "descripcion": "Primera consulta",
        "informe_clinico": {
          "fecha_emision": "2024-02-12",
          "resumen": "Ataques de pánico frecuentes",
          "analisis": "Trastorno de pánico",
          "progreso": "Inicio de tratamiento farmacológico",
          "recomendacion": "Seguimiento semanal"
        }
      }
    ],
    "diagnosticos": [
      {
        "id_diag": "d004",
        "enfermedad": "Trastorno de Pánico",
        "fecha_diagnostico": "2024-02-05",
        "sintomas": [
          "ataques de pánico",
          "miedo a morir",
          "palpitaciones"
        ],
        "observaciones": "Ataques de pánico recurrentes",
        "recomendaciones": "Terapia y medicación ansiolítica"
      }
    ],
    "tratamientos": [
      {
        "id_tratamiento": "t004",
        "fecha_inicio": "2024-02-05",
        "estado": "ACTIVO",
        "duracion_dias": 180,
        "medicacion": [
          {
            "nombre_medicamento": "Diazepam",
            "descripcion_dosis": "5mg",
            "intervalor_dosis_horas": 24,
            "precio_unitario_soles": 2.2,
            "duracion_medicamento_dias": 180
          }
        ]
      }
    ]
  },
  {
    "_id": ObjectId("686e42d736b75142b04e4dcf"),
    "id_paciente": "p005",
    "id_especialista": "e003",
    "fecha_creacion": "2024-01-25",
    "motivo_consulta": "Problemas de pareja",
    "antecedentes_paciente": "Paciente busca orientación para problemas de comunicación",
    "estado": "ABIERTA",
    "citas": [
      {
        "id_cita": "c006",
        "fecha": "2024-02-01",
        "estado": "CONFIRMADA",
        "descripcion": "Primera consulta",
        "informe_clinico": {
          "fecha_emision": "2024-02-01",
          "resumen": "Dificultades de comunicación",
          "analisis": "Problemas de pareja",
          "progreso": "Inicio de terapia de pareja",
          "recomendacion": "Seguimiento quincenal"
        }
      }
    ],
    "diagnosticos": [
      {
        "id_diag": "d005",
        "enfermedad": "Problemas de Pareja",
        "fecha_diagnostico": "2024-01-25",
        "sintomas": [
          "dificultades de comunicación",
          "conflictos frecuentes",
          "falta de intimidad"
        ],
        "observaciones": "Dificultades en la comunicación de pareja",
        "recomendaciones": "Terapia de pareja y ejercicios de comunicación"
      }
    ],
    "tratamientos": [
      {
        "id_tratamiento": "t005",
        "fecha_inicio": "2024-01-25",
        "estado": "ACTIVO",
        "duracion_dias": 90,
        "medicacion": [
          {
            "nombre_medicamento": "Paroxetina",
            "descripcion_dosis": "20mg",
            "intervalor_dosis_horas": 24,
            "precio_unitario_soles": 2.8,
            "duracion_medicamento_dias": 90
          }
        ]
      }
    ]
  }
]);

print("Datos insertados exitosamente en las colecciones de CareSync"); 