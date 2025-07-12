-- Insertar en tipo_documento
INSERT INTO tipo_documento (nombre_tipo_documento)
VALUES
    ('DNI'),           -- 1
    ('Pasaporte'),     -- 2
    ('Carnet de extranjería');  -- 3

-- Insertar en persona
INSERT INTO persona (id_tipo_documento, numero_documento, nombre, apellido1, apellido2, fecha_nacimiento, sexo, correo, clave, rol)
VALUES
    (1, '73126080', 'Allison', 'Pezantes', 'Ayala', '2003-06-11', 'F', 'allison.mentalhealth@gmail.com', 'queso1802', 'PACIENTE'),
    (2, 'A12345678', 'Camilo', 'Perez', 'Florez', '1985-05-01', 'M', 'camilo.therapist@gmail.com', 'fresita1518', 'ESPECIALISTA'),
    (3, 'G1234567', 'Juan', 'Rodriguez', 'Martinez', '1990-07-10', 'M', 'juan.therapist@yahoo.com', 'juanj1234', 'ESPECIALISTA');


-- Insertar en paciente (paciente de salud mental)
INSERT INTO paciente (id_persona)
VALUES
    (1);  -- Allison es paciente (id_persona = 1)

-- Insertar en especialista (especialistas en salud mental)
INSERT INTO especialista (id_persona)
VALUES
    (2),  -- Camilo es terapeuta (id_persona = 2)
    (3);  -- Juan es terapeuta (id_persona = 3)

-- Insertar en medio_contacto (correos electrónicos, números telefónicos)
INSERT INTO medio_contacto (id_persona, tipo, valor, estado)
VALUES
    (1, 'EMAIL', 'allison.mentalhealth@gmail.com', 'ACTIVO'),
    (1, 'TEL', '987654321', 'ACTIVO'),
    (2, 'EMAIL', 'camilo.therapist@gmail.com', 'ACTIVO'),
    (2, 'TEL', '987123456', 'ACTIVO'),
    (3, 'EMAIL', 'juan.therapist@yahoo.com', 'ACTIVO');

-- Insertar en persona_direccion
INSERT INTO persona_direccion (id_persona, tipo_direccion, direccion, latitud, longitud, codigo_postal)
VALUES
    (1, 'DOMICILIO', 'Av. Principal 123, Lima, Perú', -12.045, -77.032, '15001'),
    (2, 'DOMICILIO', 'Calle Ficticia 456, Lima, Perú', -12.050, -77.050, '15002'),
    (3, 'DOMICILIO', 'Jr. Libertad 789, Lima, Perú', -12.060, -77.060, '15003');

-- Insertar en persona_telefono
INSERT INTO persona_telefono (id_persona, codigo_pais, numero_telefono, tipo_telefono)
VALUES
    (1, '+51', '987654321', 'MOVIL'),  -- Allison
    (2, '+51', '987123456', 'MOVIL'),  -- Camilo (terapeuta)
    (3, '+51', '987000000', 'MOVIL');  -- Juan (terapeuta)

-- Insertar en plan_seguro (plan de seguro de salud mental)
INSERT INTO plan_seguro (id_paciente, numero_poliza, estado_poliza, compania, cobertura, tipo_cobertura, fecha_inicio, fecha_vencimiento)
VALUES
    (1, 'POL123456', 'ACTIVA', 'SeguroVida', 'Cobertura Total en salud mental', 'PSICOLOGÍA', '2023-01-01', '2025-01-01');

-- Insertar en historia_clinica (condición de salud mental)
INSERT INTO historia_clinica (id_paciente, id_especialista, motivo_consulta, antecedentes, estado)
VALUES
    (1, 2, 'Ansiedad y estrés', 'Antecedentes de ansiedad generalizada', 'ABIERTA');

-- Insertar en tratamiento (tratamiento de salud mental)
INSERT INTO tratamiento (id_paciente, id_especialista, id_historia_clinica, estado, duracion_dias, fecha_inicio, fecha_fin)
VALUES
    (1, 2, 1, 'ACTIVO', 30, '2023-06-01', '2023-06-30');

-- Insertar en medicacion (medicación para salud mental)
INSERT INTO medicacion (nombre, via_administracion, dosis_default)
VALUES
    ('Alprazolam', 'Oral', '0.5mg'),
    ('Escitalopram', 'Oral', '10mg');

-- Insertar en receta (prescripción de medicamentos)
INSERT INTO receta (id_paciente, id_especialista)
VALUES
    (1, 2);  -- Camilo prescribió tratamiento para Allison

-- Insertar en receta_medicacion (prescripción de medicamentos para Allison)
INSERT INTO receta_medicacion (id_receta, id_medicacion, dosis, frecuencia)
VALUES
    (1, 1, '0.5mg', 'Cada 12 horas'),
    (1, 2, '10mg', 'Cada mañana');

-- Insertar en diagnostico (diagnóstico para el paciente)
INSERT INTO diagnostico (id_historia_clinica, id_paciente, id_especialista, nombre, descripcion)
VALUES
    (1, 1, 2, 'Trastorno de ansiedad generalizada', 'Diagnóstico de trastorno de ansiedad generalizada basado en evaluación clínica');

-- Insertar en informe_clinico (informe clínico)
INSERT INTO informe_clinico (id_especialista, id_paciente, resumen, analisis, progreso, recomendacion)
VALUES
    (2, 1, 'Informe sobre tratamiento psicológico', 'La paciente muestra mejoría progresiva', 'Mejoría leve en síntomas de ansiedad', 'Recomendar continuar con sesiones de terapia');

-- Insertar en agenda_psicologica (agendar sesión de terapia)
INSERT INTO agenda_psicologica (id_especialista, id_paciente, id_tratamiento, descripcion, estado)
VALUES
    (2, 1, 1, 'Sesión de terapia cognitivo-conductual para ansiedad', 
'PROGRAMADA');
