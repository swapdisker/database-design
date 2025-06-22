-- 1. Lookup de tipo de documento
CREATE TABLE tipo_documento (
  id_tipo_documento INT IDENTITY(1,1) PRIMARY KEY,
  nombre_tipo_documento VARCHAR(50) NOT NULL
);

-- 2. Persona
CREATE TABLE persona (
  id_persona INT IDENTITY(1,1) PRIMARY KEY,
  id_tipo_documento INT NOT NULL,
  numero_documento VARCHAR(20) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido1 VARCHAR(50) NOT NULL,
  apellido2 VARCHAR(50) NULL,
  fecha_nacimiento DATE NULL,
  sexo CHAR(1) NULL CHECK (sexo IN ('M', 'F', 'O')),
  correo VARCHAR(100) NULL,
  clave VARCHAR(255) NULL,
  rol VARCHAR(20) NOT NULL CHECK (rol IN ('PACIENTE','ESPECIALISTA','ADMIN')),
  fecha_alta DATETIME DEFAULT GETDATE(),

  CONSTRAINT FK_persona_tipo_documento FOREIGN KEY (id_tipo_documento)
    REFERENCES tipo_documento(id_tipo_documento)
);

-- 3. Medios de contacto
CREATE TABLE medio_contacto (
  id_medio_contacto INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,
  tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('EMAIL','TEL','FAX','OTRO')),
  valor VARCHAR(100) NOT NULL,
  estado VARCHAR(10) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO')),

  CONSTRAINT FK_medio_contacto_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

-- 4. Direcciones de persona
CREATE TABLE persona_direccion (
  id_direccion INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,
  tipo_direccion VARCHAR(10) DEFAULT 'DOMICILIO' CHECK (tipo_direccion IN ('DOMICILIO','TRABAJO','OTRO')),
  direccion VARCHAR(255) NOT NULL,
  latitud DECIMAL(10,7) NULL,
  longitud DECIMAL(10,7) NULL,
  codigo_postal VARCHAR(10) NULL,

  CONSTRAINT FK_persona_direccion_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

-- 5. Teléfonos de persona
CREATE TABLE persona_telefono (
  id_telefono INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,
  codigo_pais VARCHAR(5) NULL,
  numero_telefono VARCHAR(20) NOT NULL,
  tipo_telefono VARCHAR(10) DEFAULT 'MOVIL' CHECK (tipo_telefono IN ('MOVIL','FIJO','OTRO')),

  CONSTRAINT FK_persona_telefono_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

-- 6. Paciente
CREATE TABLE paciente (
  id_paciente INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,

  CONSTRAINT FK_paciente_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

-- 7. Especialista
CREATE TABLE especialista (
  id_especialista INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,

  CONSTRAINT FK_especialista_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);

-- 8. Plan de seguro
CREATE TABLE plan_seguro (
  id_plan_seguro INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  numero_poliza VARCHAR(50) NULL,
  estado_poliza VARCHAR(10) DEFAULT 'ACTIVA' CHECK (estado_poliza IN ('ACTIVA','VENCIDA','SUSPENDIDA')),
  compania VARCHAR(100) NULL,
  cobertura VARCHAR(MAX) NULL,
  tipo_cobertura VARCHAR(50) NULL,
  fecha_inicio DATE NULL,
  fecha_vencimiento DATE NULL,

  CONSTRAINT FK_plan_seguro_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 9. Historia clínica
CREATE TABLE historia_clinica (
  id_historia_clinica INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_especialista INT NOT NULL,
  fecha_creacion DATETIME DEFAULT GETDATE(),
  motivo_consulta VARCHAR(MAX) NULL,
  antecedentes VARCHAR(MAX) NULL,
  estado VARCHAR(10) DEFAULT 'ABIERTA' CHECK (estado IN ('ABIERTA','CERRADA')),

  CONSTRAINT FK_historia_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_historia_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista)
);

-- 10. Tratamiento
CREATE TABLE tratamiento (
  id_tratamiento INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_especialista INT NOT NULL,
  id_historia_clinica INT NOT NULL,
  estado VARCHAR(15) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','FINALIZADO','SUSPENDIDO')),
  duracion_dias INT NULL,
  fecha_inicio DATE NULL,
  fecha_fin DATE NULL,

  CONSTRAINT FK_tratamiento_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_tratamiento_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista),
  CONSTRAINT FK_tratamiento_historia FOREIGN KEY (id_historia_clinica)
    REFERENCES historia_clinica(id_historia_clinica)
);

-- 11. Medicacion
CREATE TABLE medicacion (
  id_medicacion INT IDENTITY(1,1) PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  via_administracion VARCHAR(50) NULL,
  dosis_default VARCHAR(50) NULL
);

-- 12. Tratamiento_Medicacion (M:N)
CREATE TABLE tratamiento_medicacion (
  id_tratamiento INT NOT NULL,
  id_medicacion INT NOT NULL,
  dosis VARCHAR(50) NULL,
  frecuencia VARCHAR(50) NULL,
  PRIMARY KEY (id_tratamiento, id_medicacion),

  CONSTRAINT FK_trat_med_tratamiento FOREIGN KEY (id_tratamiento)
    REFERENCES tratamiento(id_tratamiento),
  CONSTRAINT FK_trat_med_medicacion FOREIGN KEY (id_medicacion)
    REFERENCES medicacion(id_medicacion)
);

-- 13. Receta
CREATE TABLE receta (
  id_receta INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_especialista INT NOT NULL,
  fecha_receta DATE DEFAULT CONVERT(date,GETDATE()),

  CONSTRAINT FK_receta_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_receta_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista)
);

-- 14. Receta_Medicacion (M:N)
CREATE TABLE receta_medicacion (
  id_receta INT NOT NULL,
  id_medicacion INT NOT NULL,
  dosis VARCHAR(50) NULL,
  frecuencia VARCHAR(50) NULL,
  PRIMARY KEY (id_receta, id_medicacion),

  CONSTRAINT FK_rec_med_receta FOREIGN KEY (id_receta)
    REFERENCES receta(id_receta),
  CONSTRAINT FK_rec_med_medicacion FOREIGN KEY (id_medicacion)
    REFERENCES medicacion(id_medicacion)
);

-- 15. Diagnostico
CREATE TABLE diagnostico (
  id_diagnostico INT IDENTITY(1,1) PRIMARY KEY,
  id_historia_clinica INT NOT NULL,
  id_paciente INT NOT NULL,
  id_especialista INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  fecha_diagnostico DATE DEFAULT CONVERT(date,GETDATE()),
  descripcion VARCHAR(MAX) NULL,

  CONSTRAINT FK_diag_historia FOREIGN KEY (id_historia_clinica)
    REFERENCES historia_clinica(id_historia_clinica),
  CONSTRAINT FK_diag_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_diag_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista)
);

-- 16. Informe clinico
CREATE TABLE informe_clinico (
  id_informe INT IDENTITY(1,1) PRIMARY KEY,
  id_especialista INT NOT NULL,
  id_paciente INT NOT NULL,
  fecha_emision DATETIME DEFAULT GETDATE(),
  resumen VARCHAR(MAX) NULL,
  analisis VARCHAR(MAX) NULL,
  progreso VARCHAR(MAX) NULL,
  recomendacion VARCHAR(MAX) NULL,

  CONSTRAINT FK_info_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista),
  CONSTRAINT FK_info_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 17. Agenda psicologica
CREATE TABLE agenda_psicologica (
  id_agenda INT IDENTITY(1,1) PRIMARY KEY,
  id_especialista INT NOT NULL,
  id_paciente INT NOT NULL,
  id_tratamiento INT NOT NULL,
  fecha_actividad DATETIME NULL,
  descripcion VARCHAR(MAX) NULL,
  estado VARCHAR(15) DEFAULT 'PROGRAMADA' CHECK (estado IN ('PROGRAMADA','CUMPLIDA','CANCELADA')),

  CONSTRAINT FK_agenda_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista),
  CONSTRAINT FK_agenda_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_agenda_tratamiento FOREIGN KEY (id_tratamiento)
    REFERENCES tratamiento(id_tratamiento)
);

-- 18. Cita
CREATE TABLE cita (
  id_cita INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  id_especialista INT NOT NULL,
  fecha DATE NULL,
  hora TIME NULL,
  estado VARCHAR(15) DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE','CONFIRMADA','CANCELADA','ATENDIDA')),

  CONSTRAINT FK_cita_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente),
  CONSTRAINT FK_cita_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista)
);

-- 19. Factura
CREATE TABLE factura (
  id_factura INT IDENTITY(1,1) PRIMARY KEY,
  id_cita INT NOT NULL,
  id_paciente INT NOT NULL,
  fecha_emision DATE DEFAULT CONVERT(date,GETDATE()),
  descuentos DECIMAL(10,2) DEFAULT 0,
  honorarios DECIMAL(10,2) NOT NULL,
  impuestos DECIMAL(10,2) DEFAULT 0,
  metodo_pago VARCHAR(15) NULL CHECK (metodo_pago IN ('EFECTIVO','TARJETA','TRANSFERENCIA','OTRO')),

  CONSTRAINT FK_factura_cita FOREIGN KEY (id_cita)
    REFERENCES cita(id_cita),
  CONSTRAINT FK_factura_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 20. Consentimiento de confidencialidad
CREATE TABLE consentimiento_confidencialidad (
  id_consentimiento INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  fecha_firma DATE NULL,
  afecta_terceros BIT DEFAULT 0,
  descripcion_terceros VARCHAR(MAX) NULL,
  estado_consentimiento VARCHAR(10) DEFAULT 'VIGENTE' CHECK (estado_consentimiento IN ('VIGENTE','REVOCADO')),

  CONSTRAINT FK_consentimiento_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 21. Contacto de emergencia
CREATE TABLE contacto_emergencia (
  id_contacto INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  relacion VARCHAR(50) NULL,
  telefono VARCHAR(20) NULL,
  notas VARCHAR(MAX) NULL,

  CONSTRAINT FK_contacto_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 22. Credencial de especialista
CREATE TABLE credencial_especialista (
  id_credencial INT IDENTITY(1,1) PRIMARY KEY,
  id_especialista INT NOT NULL,
  titulo VARCHAR(100) NULL,
  institucion VARCHAR(100) NULL,
  fecha_emision DATE NULL,
  estado_credencial VARCHAR(10) DEFAULT 'VALIDA' CHECK (estado_credencial IN ('VALIDA','CADUCADA','REVOCADA')),

  CONSTRAINT FK_credencial_especialista FOREIGN KEY (id_especialista)
    REFERENCES especialista(id_especialista)
);

-- 23. Promocion
CREATE TABLE promocion (
  id_promocion INT IDENTITY(1,1) PRIMARY KEY,
  id_paciente INT NOT NULL,
  nombre VARCHAR(100) NULL,
  descripcion VARCHAR(MAX) NULL,
  fecha_inicio DATE NULL,
  fecha_fin DATE NULL,
  estado_promocion VARCHAR(10) DEFAULT 'ACTIVA' CHECK (estado_promocion IN ('ACTIVA','INACTIVA')),

  CONSTRAINT FK_promocion_paciente FOREIGN KEY (id_paciente)
    REFERENCES paciente(id_paciente)
);

-- 24. Notificacion
CREATE TABLE notificacion (
  id_notificacion INT IDENTITY(1,1) PRIMARY KEY,
  id_persona INT NOT NULL,
  nombre VARCHAR(100) NULL,
  mensaje VARCHAR(MAX) NULL,
  fecha_envio DATETIME DEFAULT GETDATE(),
  leido BIT DEFAULT 0,
  tipo VARCHAR(10) NULL CHECK (tipo IN ('EMAIL','SMS','APP','OTRO')),

  CONSTRAINT FK_notificacion_persona FOREIGN KEY (id_persona)
    REFERENCES persona(id_persona)
);