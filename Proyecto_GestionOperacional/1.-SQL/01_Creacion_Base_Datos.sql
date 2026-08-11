/*-------------------------
Creacion de base de datos
-------------------------*/
CREATE DATABASE DB_GestionOperacional;
GO

USE DB_GestionOperacional;
GO

/*DIMENSIÓN RESPONSABLE*/
CREATE TABLE dbo.Dim_Responsable(
ResponsableID INT NOT NULL,
Responsable NVARCHAR(100) NOT NULL,
Cargo NVARCHAR(100) NOT NULL,
CONSTRAINT PK_Dim_Responsable PRIMARY KEY (ResponsableID)
);
GO

/*DIMENSIÓN ÁREA*/
CREATE TABLE dbo.Dim_Area(
AreaID INT NOT NULL,
Area NVARCHAR(100) NOT NULL,
CONSTRAINT PK_Dim_Area PRIMARY KEY (AreaID),
CONSTRAINT UQ_Dim_Area_Area UNIQUE (Area)
);
GO

/*DIMENSIÓN ESTADO*/
CREATE TABLE dbo.Dim_Estado(
EstadoID INT NOT NULL,
Estado NVARCHAR(50) NOT NULL,
CONSTRAINT PK_Dim_Estado PRIMARY KEY (EstadoID),
CONSTRAINT UQ_Dim_Estado_Estado UNIQUE (Estado)
);
GO

/*DIMENSIÓN PRIORIDAD*/
CREATE TABLE dbo.Dim_Prioridad(
PrioridadID INT NOT NULL,
Prioridad NVARCHAR(50) NOT NULL,
CONSTRAINT PK_Dim_Prioridad PRIMARY KEY (PrioridadID),
CONSTRAINT UQ_Dim_Prioridad_Prioridad UNIQUE (Prioridad)
);
GO

/*HECHO OPERACIONES*/
CREATE TABLE dbo.Fact_Operaciones(
OperacionID INT NOT NULL,
FechaCreacion DATE NOT NULL,
FechaCompromiso DATE NOT NULL,
FechaCierre DATE NULL,
ResponsableID INT NOT NULL,
AreaID INT NOT NULL,
EstadoID INT NOT NULL,
PrioridadID INT NOT NULL,
TipoOperacion NVARCHAR(100) NOT NULL,
CanalIngreso NVARCHAR(50) NOT NULL,
HorasSLA INT NOT NULL,
TiempoAtencionHoras DECIMAL(10,2) NULL,
Comentario NVARCHAR(500) NULL,
CONSTRAINT PK_Fact_Operaciones PRIMARY KEY (OperacionID),
CONSTRAINT FK_Fact_Operaciones_Responsable FOREIGN KEY (ResponsableID)
REFERENCES dbo.Dim_Responsable (ResponsableID),
CONSTRAINT FK_Fact_Operaciones_Area FOREIGN KEY (AreaID)
REFERENCES dbo.Dim_Area (AreaID),
CONSTRAINT FK_Fact_Operaciones_Estado FOREIGN KEY (EstadoID)
REFERENCES dbo.Dim_Estado (EstadoID),
CONSTRAINT FK_Fact_Operaciones_Prioridad FOREIGN KEY (PrioridadID)
REFERENCES dbo.Dim_Prioridad (PrioridadID),
CONSTRAINT CK_Fact_Operaciones_HorasSLA CHECK (HorasSLA >= 0),
CONSTRAINT CK_Fact_Operaciones_TiempoAtencion
CHECK (TiempoAtencionHoras IS NULL OR TiempoAtencionHoras >= 0),
CONSTRAINT CK_Fact_Operaciones_FechaCompromiso 
CHECK (FechaCompromiso >= FechaCreacion),
CONSTRAINT CK_Fact_Operaciones_FechaCierre
CHECK (FechaCierre IS NULL OR FechaCierre >= FechaCreacion)
);
GO