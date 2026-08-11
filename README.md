# Centro de Control Operacional con SQL Server y Power BI

Este proyecto lo desarrollé para practicar un proceso completo de análisis de datos, comenzando con la creación y validación de una base de datos en SQL Server y terminando con un reporte interactivo en Power BI.

El caso representa un centro de control encargado de realizar el seguimiento de operaciones, revisar el cumplimiento del SLA e identificar operaciones vencidas o en riesgo. Para desarrollar el proyecto trabajé con 500 operaciones simuladas, por lo que no se utilizó información confidencial ni datos de una empresa real.

## Objetivo del proyecto

El objetivo principal fue construir una solución que permita organizar y analizar la información operativa de una manera clara. El reporte ayuda a responder preguntas como:

* ¿Cuántas operaciones están abiertas o cerradas?
* ¿Qué porcentaje cumple con el SLA?
* ¿Cuántas operaciones están vencidas o en riesgo?
* ¿Qué áreas y responsables tienen mayor carga de trabajo?
* ¿Cuánto tiempo demora la atención de las operaciones?
* ¿Cuál es el estado de una operación específica?

## Herramientas utilizadas

* SQL Server para crear la base de datos, las tablas y las consultas.
* SQL Server Management Studio para ejecutar y validar los scripts.
* Power BI Desktop para desarrollar el reporte.
* Power Query para preparar y cargar la información.
* DAX para crear indicadores y medidas.
* Word para documentar el desarrollo del proyecto.

## Desarrollo de la base de datos

Primero creé la base de datos `DB_GestionOperacional`. Para organizar la información utilicé un modelo estrella compuesto por una tabla principal y cuatro tablas de dimensiones:

* `Fact_Operaciones`
* `Dim_Area`
* `Dim_Responsable`
* `Dim_Estado`
* `Dim_Prioridad`

La tabla principal contiene información como el identificador de la operación, fechas de creación y cierre, área, responsable, estado, prioridad, canal de ingreso, horas de SLA y tiempo de atención.

Después cargué 500 operaciones simuladas para contar con información suficiente para realizar las consultas y construir el reporte.

## Validación de los datos

Antes de utilizar la información en Power BI, preparé consultas para comprobar la calidad de los datos. Entre las principales validaciones revisé:

* Operaciones duplicadas.
* Campos obligatorios vacíos.
* Fechas incorrectas.
* Operaciones cerradas sin fecha de cierre.
* Valores de SLA inválidos.
* Registros sin relación con las tablas de dimensiones.
* Estados y prioridades fuera de los valores permitidos.

También creé vistas SQL para facilitar el análisis y procedimientos almacenados para consultar operaciones por estado, revisar alertas y analizar el cumplimiento del SLA.

## Indicadores desarrollados

En Power BI preparé medidas para mostrar los principales resultados del centro de control:

* Total de operaciones.
* Operaciones abiertas.
* Operaciones cerradas.
* Porcentaje de cumplimiento del SLA.
* Operaciones vencidas.
* Operaciones en riesgo.
* Tiempo promedio de cierre.

Los indicadores cambian de acuerdo con los filtros seleccionados y permiten analizar la información por área, prioridad, estado, responsable y fecha.

## Páginas del reporte

El reporte está organizado en cuatro páginas:

### 1. Resumen

Presenta los principales indicadores y una visión general de la situación de las operaciones.

### 2. SLA y alertas

Permite identificar las operaciones vencidas, las que se encuentran en riesgo y el nivel de cumplimiento del SLA.

### 3. Gestión operativa

Muestra la distribución de las operaciones por área, responsable, estado y prioridad. Esta página ayuda a revisar la carga de trabajo.

### 4. Detalle

Permite buscar una operación mediante su `OperacionID` y consultar toda la información relacionada con ella.

## Estructura del repositorio

```text
Proyecto_GestionOperacional/
│
├── 1.-SQL/
│   ├── 01_Creacion_Base_Datos.sql
│   ├── 02_Insercion_Datos.sql
│   ├── 03_Consultas_Validacion.sql
│   ├── 04_Vistas_SQL.sql
│   └── 05_Stored_Procedures.sql
│
├── 2.-POWER BI/
│   ├── Dashboard_Gestion_Operacional.pbix
│   └── FONDOS/
│
└── 3.-DOCUMENTACION/
    └── Documentacion_Centro_Control_Operacional.docx
```

## Cómo revisar el proyecto

Para ejecutar la parte de SQL se deben abrir los archivos respetando el orden numérico:

1. Crear la base de datos y sus tablas.
2. Insertar los datos simulados.
3. Ejecutar las consultas de validación.
4. Crear las vistas SQL.
5. Crear los procedimientos almacenados.

Después se puede abrir el archivo `Dashboard_Gestion_Operacional.pbix` en Power BI Desktop. Si la conexión corresponde a otro equipo o servidor, será necesario actualizar el origen de datos.

## Resultado final

Al finalizar el proyecto logré conectar SQL Server con Power BI y desarrollar un reporte de cuatro páginas para controlar operaciones, SLA y alertas.

Este proyecto me permitió reforzar mis conocimientos en creación de bases de datos, relaciones entre tablas, consultas SQL, validación de información, procedimientos almacenados, modelado de datos, medidas DAX y diseño de reportes.

## Mejoras futuras

Como siguientes mejoras me gustaría:

* Automatizar la actualización de la información.
* Publicar el reporte en Power BI Service.
* Incorporar un historial de cambios por operación.
* Crear notificaciones para las operaciones próximas a vencer.
* Practicar la construcción de procesos ETL con herramientas cloud.
