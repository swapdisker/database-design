// =====================================================
// CONSULTAS NOSQL ADICIONALES PARA CARESYNC
// (Completamente diferentes a las ya existentes)
// =====================================================

// CONSULTA 1: Análisis de efectividad de medicamentos por diagnóstico
// Objetivo: Analizar qué medicamentos son más efectivos para cada tipo de diagnóstico
// y calcular tasas de éxito de tratamientos

db.historia_clinica.aggregate([
  {
    $unwind: "$diagnosticos"
  },
  {
    $unwind: "$tratamientos"
  },
  {
    $unwind: "$tratamientos.medicacion"
  },
  {
    $group: {
      _id: {
        diagnostico: "$diagnosticos.enfermedad",
        medicamento: "$tratamientos.medicacion.nombre_medicamento"
      },
      total_tratamientos: { $sum: 1 },
      tratamientos_exitosos: {
        $sum: {
          $cond: [
            { $eq: ["$tratamientos.estado", "FINALIZADO"] },
            1,
            0
          ]
        }
      },
      tratamientos_activos: {
        $sum: {
          $cond: [
            { $eq: ["$tratamientos.estado", "ACTIVO"] },
            1,
            0
          ]
        }
      },
      duracion_promedio: { $avg: "$tratamientos.duracion_dias" },
      dosis_promedio: {
        $avg: {
          $toDouble: {
            $substr: [
              "$tratamientos.medicacion.descripcion_dosis",
              0,
              { $indexOfBytes: ["$tratamientos.medicacion.descripcion_dosis", "mg"] }
            ]
          }
        }
      },
      precio_promedio: { $avg: "$tratamientos.medicacion.precio_unitario_soles" }
    }
  },
  {
    $project: {
      diagnostico: "$_id.diagnostico",
      medicamento: "$_id.medicamento",
      total_tratamientos: 1,
      tratamientos_exitosos: 1,
      tratamientos_activos: 1,
      duracion_promedio: 1,
      dosis_promedio: 1,
      precio_promedio: 1,
      porcentaje_exito: {
        $cond: {
          if: { $gt: ["$total_tratamientos", 0] },
          then: {
            $multiply: [
              { $divide: ["$tratamientos_exitosos", "$total_tratamientos"] },
              100
            ]
          },
          else: 0
        }
      },
      porcentaje_activos: {
        $cond: {
          if: { $gt: ["$total_tratamientos", 0] },
          then: {
            $multiply: [
              { $divide: ["$tratamientos_activos", "$total_tratamientos"] },
              100
            ]
          },
          else: 0
        }
      }
    }
  },
  {
    $match: {
      total_tratamientos: { $gte: 2 }
    }
  },
  {
    $sort: { diagnostico: 1, porcentaje_exito: -1 }
  }
]);

// CONSULTA 2: Análisis de patrones de citas por día de la semana y hora
// Objetivo: Identificar patrones de programación de citas
// para optimizar la agenda de especialistas

db.historia_clinica.aggregate([
  {
    $unwind: "$citas"
  },
  {
    $addFields: {
      fecha_cita: { $dateFromString: { dateString: "$citas.fecha" } },
      hora_cita: { $dateFromString: { dateString: "$citas.fecha" } }
    }
  },
  {
    $addFields: {
      dia_semana: {
        $switch: {
          branches: [
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 1] }, then: "Domingo" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 2] }, then: "Lunes" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 3] }, then: "Martes" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 4] }, then: "Miércoles" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 5] }, then: "Jueves" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 6] }, then: "Viernes" },
            { case: { $eq: [{ $dayOfWeek: "$fecha_cita" }, 7] }, then: "Sábado" }
          ],
          default: "Desconocido"
        }
      },
      hora_dia: { $hour: "$hora_cita" }
    }
  },
  {
    $group: {
      _id: {
        dia_semana: "$dia_semana",
        hora_dia: "$hora_dia",
        especialista: "$id_especialista"
      },
      total_citas: { $sum: 1 },
      citas_confirmadas: {
        $sum: {
          $cond: [
            { $eq: ["$citas.estado", "CONFIRMADA"] },
            1,
            0
          ]
        }
      },
      citas_pendientes: {
        $sum: {
          $cond: [
            { $eq: ["$citas.estado", "PENDIENTE"] },
            1,
            0
          ]
        }
      },
      citas_canceladas: {
        $sum: {
          $cond: [
            { $eq: ["$citas.estado", "CANCELADA"] },
            1,
            0
          ]
        }
      },
      citas_atendidas: {
        $sum: {
          $cond: [
            { $eq: ["$citas.estado", "ATENDIDA"] },
            1,
            0
          ]
        }
      },
      pacientes_unicos: { $addToSet: "$id_paciente" }
    }
  },
  {
    $lookup: {
      from: "especialistas",
      localField: "_id.especialista",
      foreignField: "id_especialista",
      as: "datos_especialista"
    }
  },
  {
    $project: {
      dia_semana: "$_id.dia_semana",
      hora_dia: "$_id.hora_dia",
      especialista: {
        $concat: [
          { $arrayElemAt: ["$datos_especialista.nombres", 0] },
          " ",
          { $arrayElemAt: ["$datos_especialista.apellidos", 0] }
        ]
      },
      total_citas: 1,
      citas_confirmadas: 1,
      citas_pendientes: 1,
      citas_canceladas: 1,
      citas_atendidas: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" }
    }
  },
  {
    $sort: {
      dia_semana: 1,
      hora_dia: 1
    }
  }
]);

// CONSULTA 3: Análisis de progreso de tratamientos por edad del paciente
// Objetivo: Analizar si la edad del paciente influye en el éxito del tratamiento
// y calcular tasas de finalización por grupos de edad

db.historia_clinica.aggregate([
  {
    $lookup: {
      from: "pacientes",
      localField: "id_paciente",
      foreignField: "id_paciente",
      as: "datos_paciente"
    }
  },
  {
    $unwind: "$tratamientos"
  },
  {
    $addFields: {
      fecha_nacimiento: { $arrayElemAt: ["$datos_paciente.Fecha_nacimiento", 0] },
      sexo: { $arrayElemAt: ["$datos_paciente.Sexo", 0] }
    }
  },
  {
    $addFields: {
      edad: {
        $floor: {
          $divide: [
            { $subtract: [new Date(), { $dateFromString: { dateString: "$fecha_nacimiento" } }] },
            365 * 24 * 60 * 60 * 1000
          ]
        }
      }
    }
  },
  {
    $addFields: {
      grupo_edad: {
        $switch: {
          branches: [
            { case: { $lt: ["$edad", 25] }, then: "18-24" },
            { case: { $lt: ["$edad", 35] }, then: "25-34" },
            { case: { $lt: ["$edad", 45] }, then: "35-44" },
            { case: { $lt: ["$edad", 55] }, then: "45-54" }
          ],
          default: "55+"
        }
      }
    }
  },
  {
    $group: {
      _id: {
        grupo_edad: "$grupo_edad",
        sexo: "$sexo",
        estado_tratamiento: "$tratamientos.estado"
      },
      total_tratamientos: { $sum: 1 },
      duracion_promedio: { $avg: "$tratamientos.duracion_dias" },
      edad_promedio: { $avg: "$edad" },
      pacientes_unicos: { $addToSet: "$id_paciente" }
    }
  },
  {
    $project: {
      grupo_edad: "$_id.grupo_edad",
      sexo: "$_id.sexo",
      estado_tratamiento: "$_id.estado_tratamiento",
      total_tratamientos: 1,
      duracion_promedio: 1,
      edad_promedio: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" },
      estado_descripcion: {
        $switch: {
          branches: [
            { case: { $eq: ["$_id.estado_tratamiento", "FINALIZADO"] }, then: "Completado" },
            { case: { $eq: ["$_id.estado_tratamiento", "ACTIVO"] }, then: "En Progreso" },
            { case: { $eq: ["$_id.estado_tratamiento", "SUSPENDIDO"] }, then: "Interrumpido" }
          ],
          default: "Otro"
        }
      }
    }
  },
  {
    $sort: { grupo_edad: 1, sexo: 1 }
  }
]);

// CONSULTA 4: Análisis de cobertura de seguros por zona geográfica
// Objetivo: Analizar la distribución de seguros por códigos postales
// y calcular estadísticas de cobertura por área

db.pacientes.aggregate([
  {
    $lookup: {
      from: "historia_clinica",
      localField: "id_paciente",
      foreignField: "id_paciente",
      as: "historia_clinica"
    }
  },
  {
    $project: {
      id_paciente: 1,
      nombres: 1,
      apellidos: 1,
      plan_seguro: 1,
      datos_direccion: 1,
      total_tratamientos: {
        $size: {
          $reduce: {
            input: "$historia_clinica",
            initialValue: [],
            in: { $concatArrays: ["$$value", "$$this.tratamientos"] }
          }
        }
      },
      total_citas: {
        $size: {
          $reduce: {
            input: "$historia_clinica",
            initialValue: [],
            in: { $concatArrays: ["$$value", "$$this.citas"] }
          }
        }
      }
    }
  },
  {
    $unwind: "$datos_direccion"
  },
  {
    $group: {
      _id: {
        codigo_postal: "$datos_direccion.Codigo_postal",
        compania_seguro: "$plan_seguro.compania_seguro",
        tipo_cobertura: "$plan_seguro.poliza_activada"
      },
      pacientes_con_seguro: { $sum: 1 },
      tratamientos_activos: { $sum: "$total_tratamientos" },
      total_citas: { $sum: "$total_citas" },
      pacientes_unicos: { $addToSet: { $concat: ["$nombres", " ", "$apellidos"] } }
    }
  },
  {
    $project: {
      codigo_postal: "$_id.codigo_postal",
      compania_seguro: "$_id.compania_seguro",
      poliza_activada: "$_id.tipo_cobertura",
      pacientes_con_seguro: 1,
      tratamientos_activos: 1,
      total_citas: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" },
      nivel_cobertura_descripcion: {
        $cond: {
          if: { $eq: ["$_id.tipo_cobertura", true] },
          then: "Cobertura activa",
          else: "Sin cobertura"
        }
      }
    }
  },
  {
    $sort: { codigo_postal: 1, pacientes_con_seguro: -1 }
  }
]);

// CONSULTA 5: Análisis de credenciales y especialización de especialistas
// Objetivo: Analizar las credenciales de los especialistas y su distribución
// por tipo de especialización

db.especialistas.aggregate([
  {
    $unwind: "$credenciales"
  },
  {
    $group: {
      _id: {
        rama_especializada: "$credenciales.rama_especializada",
        institucion: "$credenciales.institucion"
      },
      total_especialistas: { $sum: 1 },
      especialistas: { $addToSet: { $concat: ["$nombres", " ", "$apellidos"] } },
      credenciales_vigentes: {
        $sum: {
          $cond: [
            { $eq: ["$credenciales.estado", "vigente"] },
            1,
            0
          ]
        }
      },
      promedio_anos_experiencia: {
        $avg: {
          $floor: {
            $divide: [
              { $subtract: [new Date(), { $dateFromString: { dateString: "$credenciales.fecha_emision" } }] },
              365 * 24 * 60 * 60 * 1000
            ]
          }
        }
      }
    }
  },
  {
    $project: {
      rama_especializada: "$_id.rama_especializada",
      institucion: "$_id.institucion",
      total_especialistas: 1,
      especialistas: 1,
      credenciales_vigentes: 1,
      promedio_anos_experiencia: 1,
      porcentaje_vigentes: {
        $cond: {
          if: { $gt: ["$total_especialistas", 0] },
          then: {
            $multiply: [
              { $divide: ["$credenciales_vigentes", "$total_especialistas"] },
              100
            ]
          },
          else: 0
        }
      }
    }
  },
  {
    $sort: { total_especialistas: -1, promedio_anos_experiencia: -1 }
  }
]);

print("Consultas NoSQL adicionales ejecutadas exitosamente"); 