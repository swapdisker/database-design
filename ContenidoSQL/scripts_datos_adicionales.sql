-- =====================================================
-- SCRIPTS DE DATOS ADICIONALES PARA CARESYNC
-- (Diferentes a los ya existentes)
-- =====================================================

-- INSERTAR DATOS ADICIONALES PARA CONSULTAS AVANZADAS

-- 1. INSERTAR MÁS TIPOS DE DOCUMENTO
INSERT INTO tipo_documento (nombre_tipo_documento) VALUES
('RUC'),
('CARNET DE IDENTIDAD'),
('LICENCIA DE CONDUCIR');

-- 2. INSERTAR MÁS PERSONAS CON DIFERENTES ROLES
INSERT INTO persona (id_tipo_documento, numero_documento, nombre, apellido1, apellido2, fecha_nacimiento, sexo, correo, clave, rol) VALUES
-- Pacientes adicionales
(1, '87654321', 'Roberto', 'Silva', 'Mendoza', '1995-12-08', 'M', 'roberto.silva@email.com', 'hash_clave_567', 'PACIENTE'),
(1, '76543210', 'Patricia', 'Vargas', 'Ríos', '1983-04-22', 'F', 'patricia.vargas@email.com', 'hash_clave_890', 'PACIENTE'),
(1, '65432109', 'Miguel', 'Torres', 'Flores', '1991-08-15', 'M', 'miguel.torres@email.com', 'hash_clave_123', 'PACIENTE'),
(1, '54321098', 'Lucía', 'Herrera', 'Castro', '1989-11-30', 'F', 'lucia.herrera@email.com', 'hash_clave_456', 'PACIENTE'),
(1, '43210987', 'Fernando', 'Rojas', 'Paredes', '1993-06-12', 'M', 'fernando.rojas@email.com', 'hash_clave_789', 'PACIENTE'),

-- Especialistas adicionales
(1, '32109876', 'Dra. Carmen', 'Morales', 'Zapata', '1976-09-18', 'F', 'dra.carmen.morales@clinica.com', 'hash_clave_012', 'ESPECIALISTA'),
(1, '21098765', 'Dr. Alberto', 'Castro', 'Ríos', '1982-03-25', 'M', 'dr.alberto.castro@clinica.com', 'hash_clave_345', 'ESPECIALISTA'),
(1, '10987654', 'Dra. Isabel', 'Paredes', 'Morales', '1979-07-14', 'F', 'dra.isabel.paredes@clinica.com', 'hash_clave_678', 'ESPECIALISTA');

-- 3. INSERTAR PACIENTES ADICIONALES
INSERT INTO paciente (id_persona) VALUES
(9), (10), (11), (12), (13);

-- 4. INSERTAR ESPECIALISTAS ADICIONALES
INSERT INTO especialista (id_persona) VALUES
(14), (15), (16);

-- 5. INSERTAR MÁS MEDIOS DE CONTACTO
INSERT INTO medio_contacto (id_persona, tipo, valor, estado) VALUES
-- Pacientes adicionales
(9, 'EMAIL', 'roberto.silva@email.com', 'ACTIVO'),
(9, 'TEL', '+51 999 111 333', 'ACTIVO'),
(10, 'EMAIL', 'patricia.vargas@email.com', 'ACTIVO'),
(10, 'TEL', '+51 999 222 444', 'ACTIVO'),
(11, 'EMAIL', 'miguel.torres@email.com', 'ACTIVO'),
(11, 'TEL', '+51 999 333 555', 'ACTIVO'),
(12, 'EMAIL', 'lucia.herrera@email.com', 'ACTIVO'),
(12, 'TEL', '+51 999 444 666', 'ACTIVO'),
(13, 'EMAIL', 'fernando.rojas@email.com', 'ACTIVO'),
(13, 'TEL', '+51 999 555 777', 'ACTIVO'),

-- Especialistas adicionales
(14, 'EMAIL', 'dra.carmen.morales@clinica.com', 'ACTIVO'),
(14, 'TEL', '+51 999 666 888', 'ACTIVO'),
(15, 'EMAIL', 'dr.alberto.castro@clinica.com', 'ACTIVO'),
(15, 'TEL', '+51 999 777 999', 'ACTIVO'),
(16, 'EMAIL', 'dra.isabel.paredes@clinica.com', 'ACTIVO'),
(16, 'TEL', '+51 999 888 000', 'ACTIVO');

-- 6. INSERTAR MÁS DIRECCIONES
INSERT INTO persona_direccion (id_persona, tipo_direccion, direccion, latitud, longitud, codigo_postal) VALUES
-- Pacientes adicionales
(9, 'DOMICILIO', 'Av. San Martín 456, Lima', -12.0464, -77.0428, '15009'),
(10, 'DOMICILIO', 'Jr. Ayacucho 789, Lima', -12.0464, -77.0428, '15010'),
(11, 'DOMICILIO', 'Calle Los Rosales 123, Lima', -12.0464, -77.0428, '15011'),
(12, 'DOMICILIO', 'Av. Primavera 654, Lima', -12.0464, -77.0428, '15012'),
(13, 'DOMICILIO', 'Jr. Libertad 321, Lima', -12.0464, -77.0428, '15013'),

-- Especialistas adicionales
(14, 'TRABAJO', 'Centro Psicológico Integral, Av. Arequipa 2345', -12.0464, -77.0428, '15014'),
(15, 'TRABAJO', 'Clínica de Salud Mental, Jr. Washington 890', -12.0464, -77.0428, '15015'),
(16, 'TRABAJO', 'Instituto de Psicología, Av. Brasil 1234', -12.0464, -77.0428, '15016');

-- 7. INSERTAR MÁS PLANES DE SEGURO
INSERT INTO plan_seguro (id_paciente, numero_poliza, estado_poliza, compania, cobertura, tipo_cobertura, fecha_inicio, fecha_vencimiento) VALUES
(6, 'POL-006-2024', 'ACTIVA', 'La Positiva', 'Cobertura integral de salud mental', 'PREMIUM', '2024-01-01', '2024-12-31'),
(7, 'POL-007-2024', 'ACTIVA', 'Rimac Seguros', 'Cobertura básica de psicología', 'BASICA', '2024-01-01', '2024-12-31'),
(8, 'POL-008-2024', 'SUSPENDIDA', 'Pacifico Seguros', 'Cobertura de especialidades', 'ESPECIAL', '2024-01-01', '2024-12-31'),
(9, 'POL-009-2024', 'ACTIVA', 'Mapfre Seguros', 'Cobertura familiar', 'FAMILIAR', '2024-01-01', '2024-12-31'),
(10, 'POL-010-2024', 'ACTIVA', 'La Positiva', 'Cobertura integral', 'INTEGRAL', '2024-01-01', '2024-12-31');

-- 8. INSERTAR MÁS HISTORIAS CLÍNICAS
INSERT INTO historia_clinica (id_paciente, id_especialista, fecha_creacion, motivo_consulta, antecedentes, estado) VALUES
(6, 4, '2024-01-10 08:30:00', 'Trastorno de sueño', 'Paciente presenta insomnio crónico desde hace 2 años', 'ABIERTA'),
(7, 4, '2024-01-12 14:15:00', 'Problemas de concentración', 'Paciente refiere dificultades para concentrarse en el trabajo', 'ABIERTA'),
(8, 5, '2024-01-15 10:45:00', 'Estrés post-traumático', 'Paciente con síntomas de estrés post-traumático', 'ABIERTA'),
(9, 5, '2024-01-18 16:20:00', 'Problemas de alimentación', 'Paciente con trastorno de alimentación', 'ABIERTA'),
(10, 6, '2024-01-20 11:30:00', 'Problemas de socialización', 'Paciente con dificultades para socializar', 'ABIERTA');

-- 9. INSERTAR MÁS MEDICACIONES
INSERT INTO medicacion (nombre, via_administracion, dosis_default) VALUES
('Zolpidem', 'Oral', '10mg antes de dormir'),
('Methylphenidate', 'Oral', '20mg diario'),
('Propranolol', 'Oral', '40mg diario'),
('Escitalopram', 'Oral', '10mg diario'),
('Bupropion', 'Oral', '150mg diario');

-- 10. INSERTAR MÁS TRATAMIENTOS
INSERT INTO tratamiento (id_paciente, id_especialista, id_historia_clinica, estado, duracion_dias, fecha_inicio, fecha_fin) VALUES
(6, 4, 6, 'ACTIVO', 120, '2024-01-10', '2024-05-10'),
(7, 4, 7, 'ACTIVO', 90, '2024-01-12', '2024-04-12'),
(8, 5, 8, 'ACTIVO', 180, '2024-01-15', '2024-07-15'),
(9, 5, 9, 'ACTIVO', 150, '2024-01-18', '2024-06-18'),
(10, 6, 10, 'ACTIVO', 100, '2024-01-20', '2024-05-20');

-- 11. INSERTAR MÁS RELACIONES TRATAMIENTO-MEDICACIÓN
INSERT INTO tratamiento_medicacion (id_tratamiento, id_medicacion, dosis, frecuencia) VALUES
(6, 6, '10mg', 'Una vez al día antes de dormir'),
(7, 7, '20mg', 'Una vez al día'),
(8, 8, '40mg', 'Dos veces al día'),
(9, 9, '10mg', 'Una vez al día'),
(10, 10, '150mg', 'Una vez al día');

-- 12. INSERTAR MÁS RECETAS
INSERT INTO receta (id_paciente, id_especialista, fecha_receta) VALUES
(6, 4, '2024-01-10'),
(7, 4, '2024-01-12'),
(8, 5, '2024-01-15'),
(9, 5, '2024-01-18'),
(10, 6, '2024-01-20');

-- 13. INSERTAR MÁS RELACIONES RECETA-MEDICACIÓN
INSERT INTO receta_medicacion (id_receta, id_medicacion, dosis, frecuencia) VALUES
(6, 6, '10mg', 'Una vez al día antes de dormir'),
(7, 7, '20mg', 'Una vez al día'),
(8, 8, '40mg', 'Dos veces al día'),
(9, 9, '10mg', 'Una vez al día'),
(10, 10, '150mg', 'Una vez al día');

-- 14. INSERTAR MÁS DIAGNÓSTICOS
INSERT INTO diagnostico (id_historia_clinica, id_paciente, id_especialista, nombre, fecha_diagnostico, descripcion) VALUES
(6, 6, 4, 'Trastorno de Insomnio', '2024-01-10', 'Insomnio crónico con dificultades para conciliar el sueño'),
(7, 7, 4, 'Trastorno de Déficit de Atención', '2024-01-12', 'Dificultades de concentración y atención'),
(8, 8, 5, 'Trastorno de Estrés Post-traumático', '2024-01-15', 'Síntomas de estrés post-traumático'),
(9, 9, 5, 'Trastorno de Alimentación', '2024-01-18', 'Problemas con la alimentación'),
(10, 10, 6, 'Trastorno de Ansiedad Social', '2024-01-20', 'Dificultades para socializar');

-- 15. INSERTAR MÁS INFORMES CLÍNICOS
INSERT INTO informe_clinico (id_especialista, id_paciente, fecha_emision, resumen, analisis, progreso, recomendacion) VALUES
(4, 6, '2024-01-10', 'Evaluación inicial de insomnio', 'Paciente presenta insomnio crónico', 'Inicio de tratamiento', 'Seguimiento semanal'),
(4, 7, '2024-01-12', 'Evaluación de problemas de concentración', 'Dificultades de atención', 'Inicio de terapia', 'Seguimiento quincenal'),
(5, 8, '2024-01-15', 'Evaluación de estrés post-traumático', 'Síntomas de estrés post-traumático', 'Inicio de tratamiento', 'Seguimiento semanal'),
(5, 9, '2024-01-18', 'Evaluación de trastorno alimentario', 'Problemas con la alimentación', 'Inicio de terapia', 'Seguimiento semanal'),
(6, 10, '2024-01-20', 'Evaluación de ansiedad social', 'Dificultades para socializar', 'Inicio de terapia', 'Seguimiento quincenal');

-- 16. INSERTAR MÁS AGENDA PSICOLÓGICA
INSERT INTO agenda_psicologica (id_especialista, id_paciente, id_tratamiento, fecha_actividad, descripcion, estado) VALUES
(4, 6, 6, '2024-01-17 08:30:00', 'Sesión de terapia de sueño', 'PROGRAMADA'),
(4, 6, 6, '2024-01-24 08:30:00', 'Sesión de terapia de sueño', 'PROGRAMADA'),
(4, 7, 7, '20244-01-19 14:15:00', 'Sesión de terapia de concentración', 'PROGRAMADA'),
(5, 8, 8, '2024-01-22 10:45:00', 'Sesión de terapia post-traumática', 'PROGRAMADA'),
(5, 9, 9, '2024-01-25 16:20:00', 'Sesión de terapia alimentaria', 'PROGRAMADA'),
(6, 10, 10, '2024-01-27 11:30:00', 'Sesión de terapia social', 'PROGRAMADA');

-- 17. INSERTAR MÁS CITAS
INSERT INTO cita (id_paciente, id_especialista, fecha, hora, estado) VALUES
(6, 4, '2024-01-17', '08:30:00', 'CONFIRMADA'),
(6, 4, '2024-01-24', '08:30:00', 'PENDIENTE'),
(7, 4, '2024-01-19', '14:15:00', 'CONFIRMADA'),
(8, 5, '2024-01-22', '10:45:00', 'CONFIRMADA'),
(9, 5, '2024-01-25', '16:20:00', 'CONFIRMADA'),
(10, 6, '2024-01-27', '11:30:00', 'CONFIRMADA');

-- =====================================================
-- FIN DE LOS SCRIPTS ADICIONALES
-- ===================================================== 