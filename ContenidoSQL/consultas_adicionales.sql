-- =====================================================
-- CONSULTAS ADICIONALES PARA CARESYNC
-- (Completamente diferentes a las ya existentes)
-- =====================================================

-- CONSULTA 1: Análisis de efectividad de medicamentos por diagnóstico
-- Objetivo: Analizar qué medicamentos son más efectivos para cada tipo de diagnóstico
-- y calcular tasas de éxito de tratamientos

CREATE PROCEDURE usp_EfectividadMedicamentosPorDiagnostico
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    WITH EfectividadMedicamentos AS (
        SELECT 
            d.nombre AS diagnostico,
            m.nombre AS medicamento,
            COUNT(DISTINCT t.id_tratamiento) AS total_tratamientos,
            COUNT(CASE WHEN t.estado = 'FINALIZADO' THEN 1 END) AS tratamientos_exitosos,
            COUNT(CASE WHEN t.estado = 'ACTIVO' THEN 1 END) AS tratamientos_activos,
            AVG(t.duracion_dias) AS duracion_promedio,
            AVG(CAST(SUBSTRING(tm.dosis, 1, CHARINDEX('mg', tm.dosis) - 1) AS INT)) AS dosis_promedio_mg
        FROM diagnostico d
        INNER JOIN historia_clinica hc ON d.id_historia_clinica = hc.id_historia_clinica
        INNER JOIN tratamiento t ON hc.id_paciente = t.id_paciente
        INNER JOIN tratamiento_medicacion tm ON t.id_tratamiento = tm.id_tratamiento
        INNER JOIN medicacion m ON tm.id_medicacion = m.id_medicacion
        WHERE d.fecha_diagnostico BETWEEN @fecha_inicio AND @fecha_fin
        GROUP BY d.nombre, m.nombre
    )
    SELECT 
        diagnostico,
        medicamento,
        total_tratamientos,
        tratamientos_exitosos,
        tratamientos_activos,
        duracion_promedio,
        dosis_promedio_mg,
        CASE 
            WHEN total_tratamientos > 0 THEN 
                CAST((tratamientos_exitosos * 100.0 / total_tratamientos) AS DECIMAL(5,2))
            ELSE 0 
        END AS porcentaje_exito,
        CASE 
            WHEN total_tratamientos > 0 THEN 
                CAST((tratamientos_activos * 100.0 / total_tratamientos) AS DECIMAL(5,2))
            ELSE 0 
        END AS porcentaje_activos
    FROM EfectividadMedicamentos
    WHERE total_tratamientos >= 2
    ORDER BY diagnostico, porcentaje_exito DESC;
END

-- Ejecutar: EXEC usp_EfectividadMedicamentosPorDiagnostico '2024-01-01', '2024-12-31'

-- CONSULTA 2: Análisis de costos por especialista y tipo de tratamiento
-- Objetivo: Calcular costos promedio de tratamientos por especialista
-- y analizar la rentabilidad de cada tipo de tratamiento

CREATE PROCEDURE usp_CostosPorEspecialista
    @anio INT
AS
BEGIN
    WITH CostosTratamiento AS (
        SELECT 
            e.id_especialista,
            per_esp.nombre + ' ' + per_esp.apellido1 AS nombre_especialista,
            d.nombre AS diagnostico,
            COUNT(DISTINCT t.id_tratamiento) AS total_tratamientos,
            SUM(t.duracion_dias * tm.precio_unitario_soles) AS costo_total_estimado,
            AVG(t.duracion_dias) AS duracion_promedio,
            COUNT(DISTINCT t.id_paciente) AS pacientes_unicos
        FROM especialista e
        INNER JOIN persona per_esp ON e.id_persona = per_esp.id_persona
        INNER JOIN tratamiento t ON e.id_especialista = t.id_especialista
        INNER JOIN diagnostico d ON t.id_paciente = d.id_paciente
        INNER JOIN tratamiento_medicacion tm ON t.id_tratamiento = tm.id_tratamiento
        INNER JOIN medicacion m ON tm.id_medicacion = m.id_medicacion
        WHERE YEAR(t.fecha_inicio) = @anio
        GROUP BY e.id_especialista, per_esp.nombre, per_esp.apellido1, d.nombre
    )
    SELECT 
        id_especialista,
        nombre_especialista,
        diagnostico,
        total_tratamientos,
        costo_total_estimado,
        duracion_promedio,
        pacientes_unicos,
        costo_total_estimado / total_tratamientos AS costo_promedio_por_tratamiento,
        costo_total_estimado / pacientes_unicos AS costo_promedio_por_paciente
    FROM CostosTratamiento
    WHERE total_tratamientos >= 1
    ORDER BY costo_total_estimado DESC;
END

-- Ejecutar: EXEC usp_CostosPorEspecialista 2024

-- CONSULTA 3: Análisis de patrones de citas por día de la semana y hora
-- Objetivo: Identificar patrones de programación de citas
-- para optimizar la agenda de especialistas

CREATE PROCEDURE usp_PatronesCitasPorDiaHora
    @mes INT,
    @anio INT
AS
BEGIN
    SELECT 
        DATENAME(WEEKDAY, c.fecha) AS dia_semana,
        DATEPART(HOUR, c.hora) AS hora_dia,
        COUNT(*) AS total_citas,
        COUNT(CASE WHEN c.estado = 'CONFIRMADA' THEN 1 END) AS citas_confirmadas,
        COUNT(CASE WHEN c.estado = 'PENDIENTE' THEN 1 END) AS citas_pendientes,
        COUNT(CASE WHEN c.estado = 'CANCELADA' THEN 1 END) AS citas_canceladas,
        COUNT(CASE WHEN c.estado = 'ATENDIDA' THEN 1 END) AS citas_atendidas,
        per_esp.nombre + ' ' + per_esp.apellido1 AS especialista,
        COUNT(DISTINCT c.id_paciente) AS pacientes_unicos
    FROM cita c
    INNER JOIN especialista e ON c.id_especialista = e.id_especialista
    INNER JOIN persona per_esp ON e.id_persona = per_esp.id_persona
    WHERE MONTH(c.fecha) = @mes AND YEAR(c.fecha) = @anio
    GROUP BY 
        DATENAME(WEEKDAY, c.fecha),
        DATEPART(HOUR, c.hora),
        per_esp.nombre,
        per_esp.apellido1
    ORDER BY 
        CASE DATENAME(WEEKDAY, c.fecha)
            WHEN 'Monday' THEN 1
            WHEN 'Tuesday' THEN 2
            WHEN 'Wednesday' THEN 3
            WHEN 'Thursday' THEN 4
            WHEN 'Friday' THEN 5
            WHEN 'Saturday' THEN 6
            WHEN 'Sunday' THEN 7
        END,
        DATEPART(HOUR, c.hora);
END

-- Ejecutar: EXEC usp_PatronesCitasPorDiaHora 1, 2024

-- CONSULTA 4: Análisis de progreso de tratamientos por edad del paciente
-- Objetivo: Analizar si la edad del paciente influye en el éxito del tratamiento
-- y calcular tasas de finalización por grupos de edad

CREATE PROCEDURE usp_ProgresoTratamientosPorEdad
    @edad_minima INT,
    @edad_maxima INT
AS
BEGIN
    WITH ProgresoPorEdad AS (
        SELECT 
            CASE 
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 25 THEN '18-24'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 35 THEN '25-34'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 45 THEN '35-44'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 55 THEN '45-54'
                ELSE '55+'
            END AS grupo_edad,
            per.sexo,
            t.estado AS estado_tratamiento,
            t.duracion_dias,
            DATEDIFF(DAY, t.fecha_inicio, GETDATE()) AS dias_transcurridos,
            d.nombre AS diagnostico,
            COUNT(*) AS cantidad
        FROM tratamiento t
        INNER JOIN paciente p ON t.id_paciente = p.id_paciente
        INNER JOIN persona per ON p.id_persona = per.id_persona
        INNER JOIN diagnostico d ON t.id_paciente = d.id_paciente
        WHERE DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) BETWEEN @edad_minima AND @edad_maxima
        GROUP BY 
            CASE 
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 25 THEN '18-24'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 35 THEN '25-34'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 45 THEN '35-44'
                WHEN DATEDIFF(YEAR, per.fecha_nacimiento, GETDATE()) < 55 THEN '45-54'
                ELSE '55+'
            END,
            per.sexo,
            t.estado,
            t.duracion_dias,
            DATEDIFF(DAY, t.fecha_inicio, GETDATE()),
            d.nombre
    )
    SELECT 
        grupo_edad,
        sexo,
        diagnostico,
        estado_tratamiento,
        COUNT(*) AS total_tratamientos,
        AVG(duracion_dias) AS duracion_promedio,
        AVG(dias_transcurridos) AS dias_transcurridos_promedio,
        CASE 
            WHEN estado_tratamiento = 'FINALIZADO' THEN 'Completado'
            WHEN estado_tratamiento = 'ACTIVO' THEN 'En Progreso'
            WHEN estado_tratamiento = 'SUSPENDIDO' THEN 'Interrumpido'
            ELSE 'Otro'
        END AS estado_descripcion
    FROM ProgresoPorEdad
    GROUP BY grupo_edad, sexo, diagnostico, estado_tratamiento
    ORDER BY grupo_edad, sexo, diagnostico;
END

-- Ejecutar: EXEC usp_ProgresoTratamientosPorEdad 18, 65

-- CONSULTA 5: Análisis de cobertura de seguros por zona geográfica
-- Objetivo: Analizar la distribución de seguros por códigos postales
-- y calcular estadísticas de cobertura por área

CREATE PROCEDURE usp_CoberturaSegurosPorZona
    @codigo_postal_inicio VARCHAR(10),
    @codigo_postal_fin VARCHAR(10)
AS
BEGIN
    WITH CoberturaPorZona AS (
        SELECT 
            pd.codigo_postal,
            ps.compania,
            ps.tipo_cobertura,
            ps.estado_poliza,
            COUNT(DISTINCT ps.id_paciente) AS pacientes_con_seguro,
            COUNT(DISTINCT t.id_tratamiento) AS tratamientos_activos,
            COUNT(DISTINCT c.id_cita) AS total_citas,
            AVG(CAST(pd.latitud AS DECIMAL(10,7))) AS latitud_promedio,
            AVG(CAST(pd.longitud AS DECIMAL(10,7))) AS longitud_promedio
        FROM plan_seguro ps
        INNER JOIN paciente p ON ps.id_paciente = p.id_paciente
        INNER JOIN persona per ON p.id_persona = per.id_persona
        INNER JOIN persona_direccion pd ON per.id_persona = pd.id_persona
        LEFT JOIN tratamiento t ON p.id_paciente = t.id_paciente
        LEFT JOIN cita c ON p.id_paciente = c.id_paciente
        WHERE pd.codigo_postal BETWEEN @codigo_postal_inicio AND @codigo_postal_fin
        GROUP BY pd.codigo_postal, ps.compania, ps.tipo_cobertura, ps.estado_poliza
    )
    SELECT 
        codigo_postal,
        compania,
        tipo_cobertura,
        estado_poliza,
        pacientes_con_seguro,
        tratamientos_activos,
        total_citas,
        latitud_promedio,
        longitud_promedio,
        CASE 
            WHEN tipo_cobertura = 'PREMIUM' THEN 'Alta cobertura'
            WHEN tipo_cobertura = 'INTEGRAL' THEN 'Cobertura completa'
            WHEN tipo_cobertura = 'BASICA' THEN 'Cobertura limitada'
            WHEN tipo_cobertura = 'FAMILIAR' THEN 'Cobertura familiar'
            ELSE 'Sin especificar'
        END AS nivel_cobertura_descripcion,
        CASE 
            WHEN estado_poliza = 'ACTIVA' THEN 'Vigente'
            WHEN estado_poliza = 'VENCIDA' THEN 'Expirada'
            WHEN estado_poliza = 'SUSPENDIDA' THEN 'Suspendida'
            ELSE 'Otro'
        END AS estado_poliza_descripcion
    FROM CoberturaPorZona
    ORDER BY codigo_postal, pacientes_con_seguro DESC;
END

-- Ejecutar: EXEC usp_CoberturaSegurosPorZona '15001', '15016'

-- =====================================================
-- FIN DE LAS CONSULTAS ADICIONALES
-- ===================================================== 