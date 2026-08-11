/*USAR LA BASE DE DATOS*/
USE DB_GestionOperacional;
GO

/*VERIFICAR LA CANTIDAD DE REGISTROS DE CADA TABLA*/
SELECT
(SELECT COUNT(*) FROM Dim_Area) AS TotalAreas,
(SELECT COUNT(*) FROM Dim_Responsable) AS TotalResponsables,
(SELECT COUNT(*) FROM Dim_Estado) AS TotalEstados,
(SELECT COUNT(*) FROM Dim_Prioridad) AS TotalPrioridades,
(SELECT COUNT(*) FROM Fact_Operaciones) AS TotalOperaciones;

/*VALIDAR QUE NO EXISTAN OPERACIONES DUPLICADAS*/
SELECT OperacionID,COUNT(*) AS Cantidad
FROM Fact_Operaciones
GROUP BY OperacionID
HAVING COUNT(*) > 1;

/*VALIDAR QUE LOS CAMPOS IMPORTANTES NO ESTÉN VACÍOS*/
SELECT *
FROM Fact_Operaciones
WHERE TipoOperacion IS NULL OR LTRIM(RTRIM(TipoOperacion)) = N''
OR CanalIngreso IS NULL OR LTRIM(RTRIM(CanalIngreso)) = N'';

/*VALIDAR QUE EL TIPO DE OPERACIÓN Y EL CANAL TENGAN DATOS PERMITIDOS*/
SELECT *
FROM Fact_Operaciones
WHERE TipoOperacion NOT IN (N'Incidencia', N'Solicitud', N'Mejora')
OR CanalIngreso NOT IN (N'Sistema', N'Correo', N'Manual');

/*VALIDAR QUE LAS FECHAS TENGAN UN ORDEN CORRECTO*/
DECLARE @FechaCorte DATE = '2026-07-16';

SELECT OperacionID,FechaCreacion,FechaCompromiso,FechaCierre
FROM Fact_Operaciones
WHERE FechaCompromiso < FechaCreacion
OR (FechaCierre IS NOT NULL AND FechaCierre < FechaCreacion)
OR FechaCreacion > @FechaCorte;
GO

/*VALIDAR QUE EL ESTADO COINCIDA CON LOS DATOS DE CIERRE*/
SELECT OperacionID,EstadoID,FechaCierre,TiempoAtencionHoras
FROM Fact_Operaciones
WHERE (EstadoID = 3 AND FechaCierre IS NULL)
OR (EstadoID = 3 AND TiempoAtencionHoras IS NULL)
OR (EstadoID <> 3 AND FechaCierre IS NOT NULL)
OR (EstadoID <> 3 AND TiempoAtencionHoras IS NOT NULL);

/*VALIDAR QUE EL ESTADO COINCIDA CON LA FECHA DE COMPROMISO*/
DECLARE @FechaCorte DATE = '2026-07-16';

SELECT OperacionID,EstadoID,FechaCompromiso,FechaCierre
FROM Fact_Operaciones
WHERE (EstadoID = 4 AND NOT 
(FechaCompromiso < @FechaCorte AND FechaCierre IS NULL))
OR (EstadoID = 5 AND NOT 
(FechaCompromiso BETWEEN @FechaCorte AND DATEADD(DAY, 2, @FechaCorte)
AND FechaCierre IS NULL)) 
OR (EstadoID IN (1,2) AND FechaCompromiso < @FechaCorte 
AND FechaCierre IS NULL);
GO

/*VALIDAR QUE LAS HORAS SLA COINCIDAN CON LA PRIORIDAD*/
SELECT OperacionID,PrioridadID,HorasSLA
FROM Fact_Operaciones
WHERE
(PrioridadID = 1 AND HorasSLA <> 72) OR
(PrioridadID = 2 AND HorasSLA <> 48) OR
(PrioridadID = 3 AND HorasSLA <> 24) OR
(PrioridadID = 4 AND HorasSLA <> 8);

/*VALIDAR QUE LAS HORAS SEAN MAYORES A CERO*/
SELECT OperacionID,HorasSLA,TiempoAtencionHoras
FROM Fact_Operaciones
WHERE HorasSLA <= 0
OR (TiempoAtencionHoras IS NOT NULL AND TiempoAtencionHoras <= 0);

/*VALIDAR QUE EL TIEMPO Y LA FECHA DE CIERRE COINCIDAN CON EL SLA*/
SELECT OperacionID,FechaCompromiso,FechaCierre,HorasSLA,TiempoAtencionHoras
FROM Fact_Operaciones
WHERE EstadoID = 3
AND ((TiempoAtencionHoras <= HorasSLA AND FechaCierre > FechaCompromiso)
OR (TiempoAtencionHoras > HorasSLA AND FechaCierre <= FechaCompromiso));

/*VALIDAR QUE TODAS LAS OPERACIONES TENGAN DATOS RELACIONADOS*/
SELECT FO.OperacionID,FO.ResponsableID,FO.AreaID,FO.EstadoID,FO.PrioridadID
FROM Fact_Operaciones AS FO
LEFT JOIN Dim_Responsable AS DR
ON FO.ResponsableID = DR.ResponsableID
LEFT JOIN Dim_Area AS DA
ON FO.AreaID = DA.AreaID
LEFT JOIN Dim_Estado AS DE
ON FO.EstadoID = DE.EstadoID
LEFT JOIN Dim_Prioridad AS DP
ON FO.PrioridadID = DP.PrioridadID
WHERE DR.ResponsableID IS NULL
OR DA.AreaID IS NULL
OR DE.EstadoID IS NULL
OR DP.PrioridadID IS NULL;

/*REVISAR LA CANTIDAD DE OPERACIONES POR ESTADO*/
SELECT DE.Estado,COUNT(*) AS CantidadOperaciones
FROM Fact_Operaciones AS FO
INNER JOIN Dim_Estado AS DE
ON FO.EstadoID = DE.EstadoID
GROUP BY DE.Estado
ORDER BY CantidadOperaciones DESC;

/*REVISAR LA CANTIDAD DE OPERACIONES POR PRIORIDAD*/
SELECT DP.Prioridad,COUNT(*) AS CantidadOperaciones
FROM Fact_Operaciones AS FO
INNER JOIN Dim_Prioridad AS DP
ON FO.PrioridadID = DP.PrioridadID
GROUP BY DP.Prioridad
ORDER BY CantidadOperaciones DESC;

/*REVISAR LA CANTIDAD DE OPERACIONES POR ÁREA*/
SELECT DA.Area,COUNT(*) AS CantidadOperaciones
FROM Fact_Operaciones AS FO
INNER JOIN Dim_Area AS DA
ON FO.AreaID = DA.AreaID
GROUP BY DA.Area
ORDER BY CantidadOperaciones DESC;

/*CALCULAR EL PORCENTAJE DE OPERACIONES DENTRO Y FUERA DEL SLA*/
SELECT
CASE
WHEN TiempoAtencionHoras <= HorasSLA THEN N'Dentro del SLA'
ELSE N'Fuera del SLA'
END AS CumplimientoSLA,
COUNT(*) AS CantidadOperaciones,
CAST(COUNT(*) * 100.0/SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) AS Porcentaje
FROM Fact_Operaciones
WHERE EstadoID = 3
GROUP BY
CASE
WHEN TiempoAtencionHoras <= HorasSLA THEN N'Dentro del SLA'
ELSE N'Fuera del SLA'
END;