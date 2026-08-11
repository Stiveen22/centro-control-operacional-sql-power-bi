/*USAR LA BASE DE DATOS*/
USE DB_GestionOperacional;
GO

/*CREAR UNA VISTA PARA TENER EL DETALLE DE LAS OPERACIONES*/
CREATE OR ALTER VIEW dbo.vw_OperacionAnalitica
AS
SELECT
FO.OperacionID,
FO.FechaCreacion,
FO.FechaCompromiso,
FO.FechaCierre,
FO.ResponsableID,
DR.Responsable,
DR.Cargo,
FO.AreaID,
DA.Area,
FO.EstadoID,
DE.Estado,
FO.PrioridadID,
DP.Prioridad,
FO.TipoOperacion,
FO.CanalIngreso,
FO.HorasSLA,
FO.TiempoAtencionHoras,
CASE
WHEN FO.EstadoID <> 3 THEN N'Pendiente de cierre'
WHEN FO.TiempoAtencionHoras <= FO.HorasSLA THEN N'Dentro del SLA'
ELSE N'Fuera del SLA'
END AS CumplimientoSLA,
FO.Comentario
FROM dbo.Fact_Operaciones AS FO
INNER JOIN dbo.Dim_Responsable AS DR
ON FO.ResponsableID = DR.ResponsableID
INNER JOIN dbo.Dim_Area AS DA
ON FO.AreaID = DA.AreaID
INNER JOIN dbo.Dim_Estado AS DE
ON FO.EstadoID = DE.EstadoID
INNER JOIN dbo.Dim_Prioridad AS DP
ON FO.PrioridadID = DP.PrioridadID;
GO

/*REVISAR LOS DATOS DE LA VISTA*/
SELECT *
FROM dbo.vw_OperacionAnalitica;
