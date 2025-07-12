// =====================================================
// CONSULTAS DE EJEMPLO PARA CARESYNC (NoSQL)
// =====================================================

// CONSULTA 1: Pacientes con más citas en el último mes
// Objetivo: Encontrar los pacientes que han tenido más citas en el último mes
// y mostrar información detallada de sus tratamientos

db.historia_clinica.aggregate([
  {
    $match: {
      "citas.fecha": {
        $gte: new Date(new Date().setMonth(new Date().getMonth() - 1))
      }
    }
  },
  {
    $project: {
      id_paciente: 1,
      id_especialista: 1,
      motivo_consulta: 1,
      total_citas: { $size: "$citas" },
      citas_atendidas: {
        $size: {
          $filter: {
            input: "$citas",
            cond: { $eq: ["$$this.estado", "CONFIRMADA"] }
          }
        }
      },
      citas_pendientes: {
        $size: {
          $filter: {
            input: "$citas",
            cond: { $eq: ["$$this.estado", "PENDIENTE"] }
          }
        }
      },
      tratamientos: 1
    }
  },
  {
    $match: {
      total_citas: { $gte: 2 }
    }
  },
  {
    $lookup: {
      from: "pacientes",
      localField: "id_paciente",
      foreignField: "id_paciente",
      as: "datos_paciente"
    }
  },
  {
    $lookup: {
      from: "especialistas",
      localField: "id_especialista",
      foreignField: "id_especialista",
      as: "datos_especialista"
    }
  },
  {
    $project: {
      id_paciente: 1,
      nombre_completo: {
        $concat: [
          { $arrayElemAt: ["$datos_paciente.Nombres", 0] },
          " ",
          { $arrayElemAt: ["$datos_paciente.Apellidos", 0] }
        ]
      },
      telefono: { $arrayElemAt: ["$datos_paciente.Telefono", 0] },
      total_citas: 1,
      citas_atendidas: 1,
      citas_pendientes: 1,
      motivo_consulta: 1,
      especialista: {
        $concat: [
          { $arrayElemAt: ["$datos_especialista.nombres", 0] },
          " ",
          { $arrayElemAt: ["$datos_especialista.apellidos", 0] }
        ]
      },
      tratamientos_activos: {
        $size: {
          $filter: {
            input: "$tratamientos",
            cond: { $eq: ["$$this.estado", "ACTIVO"] }
          }
        }
      }
    }
  },
  {
    $sort: { total_citas: -1 }
  }
]);

// CONSULTA 2: Especialistas con mejor rendimiento y sus pacientes
// Objetivo: Analizar el rendimiento de los especialistas basado en 
// el número de pacientes atendidos y el progreso de los tratamientos

db.historia_clinica.aggregate([
  {
    $group: {
      _id: "$id_especialista",
      total_pacientes: { $addToSet: "$id_paciente" },
      total_citas: { $sum: { $size: "$citas" } },
      citas_atendidas: {
        $sum: {
          $size: {
            $filter: {
              input: "$citas",
              cond: { $eq: ["$$this.estado", "CONFIRMADA"] }
            }
          }
        }
      },
      tratamientos_activos: {
        $sum: {
          $size: {
            $filter: {
              input: "$tratamientos",
              cond: { $eq: ["$$this.estado", "ACTIVO"] }
            }
          }
        }
      },
      tratamientos_finalizados: {
        $sum: {
          $size: {
            $filter: {
              input: "$tratamientos",
              cond: { $eq: ["$$this.estado", "FINALIZADO"] }
            }
          }
        }
      }
    }
  },
  {
    $lookup: {
      from: "especialistas",
      localField: "_id",
      foreignField: "id_especialista",
      as: "datos_especialista"
    }
  },
  {
    $project: {
      id_especialista: "$_id",
      nombre_especialista: {
        $concat: [
          { $arrayElemAt: ["$datos_especialista.nombres", 0] },
          " ",
          { $arrayElemAt: ["$datos_especialista.apellidos", 0] }
        ]
      },
      total_pacientes: { $size: "$total_pacientes" },
      total_citas: 1,
      citas_atendidas: 1,
      tratamientos_activos: 1,
      tratamientos_finalizados: 1,
      porcentaje_efectividad: {
        $cond: {
          if: { $gt: ["$total_citas", 0] },
          then: {
            $multiply: [
              { $divide: ["$citas_atendidas", "$total_citas"] },
              100
            ]
          },
          else: 0
        }
      },
      porcentaje_exito: {
        $cond: {
          if: {
            $gt: [
              { $add: ["$tratamientos_activos", "$tratamientos_finalizados"] },
              0
            ]
          },
          then: {
            $multiply: [
              {
                $divide: [
                  "$tratamientos_finalizados",
                  { $add: ["$tratamientos_activos", "$tratamientos_finalizados"] }
                ]
              },
              100
            ]
          },
          else: 0
        }
      }
    }
  },
  {
    $sort: { porcentaje_efectividad: -1, total_pacientes: -1 }
  }
]);

// CONSULTA 3: Análisis de medicamentos más prescritos por especialista
// Objetivo: Identificar qué medicamentos son más prescritos por cada especialista
// y analizar patrones de prescripción

db.historia_clinica.aggregate([
  {
    $unwind: "$tratamientos"
  },
  {
    $unwind: "$tratamientos.medicacion"
  },
  {
    $group: {
      _id: {
        id_especialista: "$id_especialista",
        medicamento: "$tratamientos.medicacion.nombre_medicamento"
      },
      veces_prescrito: { $sum: 1 },
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
      pacientes_unicos: { $addToSet: "$id_paciente" },
      precio_promedio: { $avg: "$tratamientos.medicacion.precio_unitario_soles" },
      duracion_promedio: { $avg: "$tratamientos.medicacion.duracion_medicamento_dias" }
    }
  },
  {
    $lookup: {
      from: "especialistas",
      localField: "_id.id_especialista",
      foreignField: "id_especialista",
      as: "datos_especialista"
    }
  },
  {
    $lookup: {
      from: "pacientes",
      localField: "pacientes_unicos",
      foreignField: "id_paciente",
      as: "datos_pacientes"
    }
  },
  {
    $project: {
      id_especialista: "$_id.id_especialista",
      nombre_especialista: {
        $concat: [
          { $arrayElemAt: ["$datos_especialista.nombres", 0] },
          " ",
          { $arrayElemAt: ["$datos_especialista.apellidos", 0] }
        ]
      },
      medicamento: "$_id.medicamento",
      veces_prescrito: 1,
      dosis_promedio: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" },
      precio_promedio: 1,
      duracion_promedio: 1,
      lista_pacientes: {
        $map: {
          input: "$datos_pacientes",
          as: "paciente",
          in: {
            $concat: ["$$paciente.Nombres", " ", "$$paciente.Apellidos"]
          }
        }
      }
    }
  },
  {
    $match: {
      veces_prescrito: { $gte: 2 }
    }
  },
  {
    $sort: { id_especialista: 1, veces_prescrito: -1 }
  }
]);

// CONSULTA 4: Análisis de diagnósticos por edad y género
// Objetivo: Analizar patrones de diagnósticos según la edad y género de los pacientes

db.historia_clinica.aggregate([
  {
    $unwind: "$diagnosticos"
  },
  {
    $lookup: {
      from: "pacientes",
      localField: "id_paciente",
      foreignField: "id_paciente",
      as: "datos_paciente"
    }
  },
  {
    $project: {
      diagnostico: "$diagnosticos.enfermedad",
      fecha_diagnostico: "$diagnosticos.fecha_diagnostico",
      sintomas: "$diagnosticos.sintomas",
      observaciones: "$diagnosticos.observaciones",
      nombre_paciente: { $arrayElemAt: ["$datos_paciente.Nombres", 0] },
      apellidos_paciente: { $arrayElemAt: ["$datos_paciente.Apellidos", 0] },
      sexo: { $arrayElemAt: ["$datos_paciente.Sexo", 0] },
      fecha_nacimiento: { $arrayElemAt: ["$datos_paciente.Fecha_nacimiento", 0] }
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
        diagnostico: "$diagnostico",
        grupo_edad: "$grupo_edad",
        sexo: "$sexo"
      },
      total_diagnosticos: { $sum: 1 },
      pacientes_unicos: { $addToSet: { $concat: ["$nombre_paciente", " ", "$apellidos_paciente"] } },
      edad_promedio: { $avg: "$edad" },
      sintomas_comunes: { $addToSet: "$sintomas" }
    }
  },
  {
    $project: {
      diagnostico: "$_id.diagnostico",
      grupo_edad: "$_id.grupo_edad",
      sexo: "$_id.sexo",
      total_diagnosticos: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" },
      edad_promedio: 1,
      sintomas_comunes: 1
    }
  },
  {
    $sort: { diagnostico: 1, grupo_edad: 1, sexo: 1 }
  }
]);

// CONSULTA 5: Análisis de cobertura de seguros y costos de tratamiento
// Objetivo: Analizar la relación entre el tipo de cobertura de seguro
// y los tratamientos prescritos

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
      total_tratamientos: {
        $size: {
          $reduce: {
            input: "$historia_clinica",
            initialValue: [],
            in: { $concatArrays: ["$$value", "$$this.tratamientos"] }
          }
        }
      },
      total_medicamentos: {
        $size: {
          $reduce: {
            input: {
              $reduce: {
                input: "$historia_clinica",
                initialValue: [],
                in: { $concatArrays: ["$$value", "$$this.tratamientos"] }
              }
            },
            initialValue: [],
            in: { $concatArrays: ["$$value", "$$this.medicacion"] }
          }
        }
      },
      costo_total_medicamentos: {
        $sum: {
          $reduce: {
            input: {
              $reduce: {
                input: "$historia_clinica",
                initialValue: [],
                in: { $concatArrays: ["$$value", "$$this.tratamientos"] }
              }
            },
            initialValue: [],
            in: { $concatArrays: ["$$value", "$$this.medicacion"] }
          }
        }
      }
    }
  },
  {
    $group: {
      _id: {
        compania_seguro: "$plan_seguro.compania_seguro",
        poliza_activada: "$plan_seguro.poliza_activada"
      },
      pacientes_con_seguro: { $sum: 1 },
      total_tratamientos: { $sum: "$total_tratamientos" },
      total_medicamentos: { $sum: "$total_medicamentos" },
      costo_promedio_medicamentos: { $avg: "$costo_total_medicamentos" },
      pacientes_unicos: { $addToSet: { $concat: ["$nombres", " ", "$apellidos"] } }
    }
  },
  {
    $project: {
      compania_seguro: "$_id.compania_seguro",
      poliza_activada: "$_id.poliza_activada",
      pacientes_con_seguro: 1,
      total_tratamientos: 1,
      total_medicamentos: 1,
      costo_promedio_medicamentos: 1,
      pacientes_unicos: { $size: "$pacientes_unicos" },
      nivel_cobertura: {
        $cond: {
          if: { $eq: ["$_id.poliza_activada", true] },
          then: "Cobertura activa",
          else: "Sin cobertura"
        }
      }
    }
  },
  {
    $sort: { pacientes_con_seguro: -1, total_tratamientos: -1 }
  }
]);

print("Consultas NoSQL ejecutadas exitosamente"); 