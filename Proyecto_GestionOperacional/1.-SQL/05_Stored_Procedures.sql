/*USAR LA BASE DE DATOS*/
USE DB_GestionOperacional;
GO

/*CREAR PROCEDIMIENTO PARA CONSULTAR OPERACIONES POR ESTADO*/
CREATE OR ALTER PROCEDURE dbo.sp_ObtenerOperacionesPorEstado
@EstadoID INT
AS
BEGIN
SET NOCOUNT ON;

SELECT
OperacionID,
FechaCreacion,
FechaCompromiso,
FechaCierre,
Responsable,
Cargo,
Area,
Estado,
Prioridad,
TipoOperacion,
CanalIngreso,
HorasSLA,
TiempoAtencionHoras,
CumplimientoSLA,
Comentario
FROM dbo.vw_OperacionAnalitica
WHERE EstadoID = @EstadoID
ORDER BY FechaCompromiso ASC;
END;
GO

/*CREAR PROCEDIMIENTO PARA REVISAR LAS OPERACIONES CON ALERTA*/
CREATE OR ALTER PROCEDURE dbo.sp_ObtenerAlertasOperacionales
@FechaCorte DATE
AS
BEGIN
SET NOCOUNT ON;

SELECT
OperacionID,
Responsable,
Cargo,
Area,
Estado,
Prioridad,
FechaCreacion,
FechaCompromiso,
FechaCierre,
HorasSLA,
Comentario,
CASE
WHEN EstadoID = 4 THEN N'OPERACIÓN VENCIDA'
WHEN EstadoID = 5 THEN N'OPERACIÓN EN RIESGO'
WHEN EstadoID IN (1,2) AND FechaCompromiso < @FechaCorte
THEN N'FECHA DE COMPROMISO VENCIDA'
WHEN EstadoID IN (1,2) AND FechaCompromiso BETWEEN @FechaCorte
AND DATEADD(DAY, 2, @FechaCorte)
THEN N'PRÓXIMA A VENCER'
END AS TipoAlerta
FROM dbo.vw_OperacionAnalitica
WHERE FechaCierre IS NULL
AND (
EstadoID IN (4,5)
OR (EstadoID IN (1,2) AND FechaCompromiso < @FechaCorte)
OR (EstadoID IN (1,2) AND FechaCompromiso BETWEEN @FechaCorte
AND DATEADD(DAY, 2, @FechaCorte))
)
ORDER BY PrioridadID DESC,FechaCompromiso ASC;
END;
GO

/*CREAR PROCEDIMIENTO PARA CALCULAR EL CUMPLIMIENTO DEL SLA*/
CREATE OR ALTER PROCEDURE dbo.sp_ResumenCumplimientoSLA
AS
BEGIN
SET NOCOUNT ON;

SELECT
CASE
WHEN TiempoAtencionHoras <= HorasSLA THEN N'Dentro del SLA'
ELSE N'Fuera del SLA'
END AS CumplimientoSLA,
COUNT(*) AS CantidadOperaciones,
CAST(COUNT(*) * 100.0/SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) AS Porcentaje
FROM dbo.Fact_Operaciones
WHERE EstadoID = 3
GROUP BY
CASE
WHEN TiempoAtencionHoras <= HorasSLA THEN N'Dentro del SLA'
ELSE N'Fuera del SLA'
END;
END;
GO

/*PROBAR OPERACIONES PENDIENTES*/
EXEC dbo.sp_ObtenerOperacionesPorEstado
@EstadoID = 1;

/*PROBAR OPERACIONES EN PROCESO*/
EXEC dbo.sp_ObtenerOperacionesPorEstado
@EstadoID = 2;

/*PROBAR OPERACIONES CERRADAS*/
EXEC dbo.sp_ObtenerOperacionesPorEstado
@EstadoID = 3;

/*PROBAR OPERACIONES VENCIDAS*/
EXEC dbo.sp_ObtenerOperacionesPorEstado
@EstadoID = 4;

/*PROBAR OPERACIONES EN RIESGO*/
EXEC dbo.sp_ObtenerOperacionesPorEstado
@EstadoID = 5;

/*PROBAR LAS ALERTAS OPERACIONALES*/
EXEC dbo.sp_ObtenerAlertasOperacionales
@FechaCorte = '2026-07-16';

/*PROBAR EL RESUMEN DEL SLA*/
EXEC dbo.sp_ResumenCumplimientoSLA;
