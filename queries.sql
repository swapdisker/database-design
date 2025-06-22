/*
CREATE PROCEDURE usp_EspecialistaMenosCitasPorAnio
    @anio INT
AS
BEGIN
    -- CTE para obtener el conteo de citas por especialista
    WITH CitasPorEspecialista AS (
        SELECT 
            e.id_especialista,
            p.nombre AS nombre_especialista,
            p.apellido1 AS apellido_especialista,
            COUNT(c.id_cita) AS total_citas
        FROM cita AS c
        INNER JOIN especialista AS e ON c.id_especialista = e.id_especialista
        INNER JOIN persona AS p ON e.id_persona = p.id_persona
        WHERE YEAR(c.fecha) = @anio
        GROUP BY e.id_especialista, p.nombre, p.apellido1
    )
    SELECT *
    FROM CitasPorEspecialista
    WHERE total_citas = (SELECT MIN(total_citas) FROM CitasPorEspecialista);
END

exec usp_EspecialistaMenosCitasPorAnio 2025
*/


/*
CREATE PROCEDURE usp_EspecialistaMasCitasPorAnio
    @anio INT
AS
BEGIN
    -- CTE para obtener la cantidad de citas por especialista en ese año
    WITH CitasPorEspecialista AS (
        SELECT 
            e.id_especialista,
            p.nombre AS nombre_especialista,
            p.apellido1 AS apellido_especialista,
            COUNT(c.id_cita) AS total_citas
        FROM cita AS c
        INNER JOIN especialista AS e ON c.id_especialista = e.id_especialista
        INNER JOIN persona AS p ON e.id_persona = p.id_persona
        WHERE YEAR(c.fecha) = @anio
        GROUP BY e.id_especialista, p.nombre, p.apellido1
    )
    SELECT *
    FROM CitasPorEspecialista
    WHERE total_citas = (SELECT MAX(total_citas) FROM CitasPorEspecialista);
END

exec usp_EspecialistaMasCitasPorAnio 2025


*/

/*
CREATE PROCEDURE usp_PacienteMasCitasPorDireccion
    @direccion VARCHAR(255)
AS
BEGIN
    WITH CitasPorPaciente AS (
        SELECT 
            p.id_paciente,
            per.nombre AS nombre_paciente,
            per.apellido1 AS apellido_paciente,
            COUNT(c.id_cita) AS total_citas
        FROM cita AS c
        INNER JOIN paciente AS p ON c.id_paciente = p.id_paciente
        INNER JOIN persona AS per ON p.id_persona = per.id_persona
        INNER JOIN persona_direccion AS dir ON per.id_persona = dir.id_persona
        WHERE dir.direccion LIKE '%' + @direccion + '%'
        GROUP BY p.id_paciente, per.nombre, per.apellido1
    )
    SELECT *
    FROM CitasPorPaciente
    WHERE total_citas = (SELECT MAX(total_citas) FROM CitasPorPaciente);
END

exec usp_PacienteMasCitasPorDireccion 'Calle Falsa 3 #123'
*/

/*
CREATE PROCEDURE usp_EspecialistaMenosCitasPorEstado
    @estado VARCHAR(15)  -- Por ejemplo: 'PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'ATENDIDA'
AS
BEGIN
    WITH CitasPorEspecialista AS (
        SELECT 
            e.id_especialista,
            p.nombre AS nombre_especialista,
            p.apellido1 AS apellido_especialista,
            COUNT(c.id_cita) AS total_citas
        FROM cita AS c
        INNER JOIN especialista AS e ON c.id_especialista = e.id_especialista
        INNER JOIN persona AS p ON e.id_persona = p.id_persona
        WHERE c.estado = @estado
        GROUP BY e.id_especialista, p.nombre, p.apellido1
    )
    SELECT *
    FROM CitasPorEspecialista
    WHERE total_citas = (SELECT MIN(total_citas) FROM CitasPorEspecialista);
END

exec usp_EspecialistaMenosCitasPorEstado 'ATENDIDA'
*/

CREATE PROCEDURE usp_DetallesPorTratamiento
    @id_tratamiento INT
AS
BEGIN
    SELECT 
        t.id_tratamiento,
        p.nombre AS nombre_paciente,
        p.apellido1 AS apellido_paciente,
        esp.nombre AS nombre_especialista,
        esp.apellido1 AS apellido_especialista,
        t.estado,
        t.duracion_dias,
        t.fecha_inicio,
        t.fecha_fin
    FROM tratamiento AS t
    INNER JOIN paciente AS pac ON t.id_paciente = pac.id_paciente
    INNER JOIN persona AS p ON pac.id_persona = p.id_persona
    INNER JOIN especialista AS e ON t.id_especialista = e.id_especialista
    INNER JOIN persona AS esp ON e.id_persona = esp.id_persona
    WHERE t.id_tratamiento = @id_tratamiento;
END


exec usp_DetallesPorTratamiento 147
