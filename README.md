#  Centro de Control Operacional | SQL Server + Power BI

Este proyecto nació de una idea sencilla: simular cómo podría hacerse el seguimiento de muchas operaciones desde un solo lugar.

Quería trabajar algo más completo que solo crear gráficos en Power BI. Mi objetivo fue empezar desde los datos: crear la base en SQL Server, organizar las tablas, revisar que la información estuviera correcta, preparar consultas y luego llevar todo ese trabajo a un dashboard.

El caso representa un centro de control donde se necesita saber qué está pasando con las operaciones: cuáles siguen abiertas, cuáles ya cerraron, cuáles están por vencer y cuáles necesitan atención.

Para trabajar el caso preparé **500 operaciones simuladas**. Todos los datos fueron creados únicamente para este proyecto y no pertenecen a ninguna empresa real.

---

##  Tecnologías que usé

Durante el proyecto trabajé principalmente con:

- **SQL Server**
- **SQL Server Management Studio**
- **T-SQL**
- **Power BI Desktop**
- **Power Query**
- **DAX**
- **GitHub**

Cada herramienta tuvo una función distinta dentro del proyecto. SQL Server fue la base para organizar y consultar la información, mientras que Power BI fue la parte visual donde terminé construyendo el seguimiento de las operaciones.

---

##  Vista general del dashboard

![Resumen Ejecutivo](Proyecto_GestionOperacional/2.-POWER%20BI/CAPTURAS/dashboard-resumen-ejecutivo.png)

Esta es la primera página del dashboard y también la que usaría para comenzar cualquier revisión.

La preparé pensando en una pregunta bastante simple:

**Si abro el reporte, ¿qué necesito saber primero?**

Por eso coloqué los indicadores principales en la parte superior.

En la vista general se muestran:

- **500 operaciones analizadas**
- **260 operaciones cerradas**
- **240 operaciones abiertas**
- **80 % de cumplimiento del SLA**
- **60 operaciones vencidas**
- **40 operaciones en riesgo**

Desde la misma página también puedo revisar cómo se distribuyen las operaciones por estado y por área, y cómo ha cambiado su cantidad con el paso de los meses.

Los filtros de **área** y **prioridad** me permiten concentrarme en una parte específica de la información cuando necesito revisar algo con más detalle.

---

##  ¿Qué quería resolver?

Mientras desarrollaba el proyecto traté de pensar en una situación parecida a la que podría encontrarse en un entorno de trabajo.

Imaginemos que existen cientos de operaciones y varias personas necesitan hacerles seguimiento.

Ahí empiezan a aparecer preguntas como:

- ¿Cuántas operaciones siguen abiertas?
- ¿Cuántas ya se cerraron?
- ¿Estamos cumpliendo los tiempos acordados?
- ¿Qué operaciones ya están vencidas?
- ¿Cuáles están cerca de tener problemas?
- ¿Qué área tiene más carga?
- ¿Qué responsable tiene más operaciones?
- ¿Qué casos deberían revisarse primero?
- ¿Qué pasó exactamente con una operación determinada?

Mi idea fue construir el proyecto alrededor de esas preguntas.

No quería que el dashboard quedara solamente como una colección de gráficos. Quería que cada página tuviera un propósito y que permitiera ir desde una visión general hasta el detalle de una operación.

---

##  Creación de la base de datos

El proyecto comienza en SQL Server.

Primero creé la base:

`DB_GestionOperacional`

Después organicé la información en una tabla principal y cuatro tablas de dimensiones.

### Tabla principal

`Fact_Operaciones`

Esta tabla contiene la información de cada operación, como:

- identificador;
- fechas;
- responsable;
- área;
- estado;
- prioridad;
- canal de ingreso;
- horas de SLA;
- tiempo de atención.

### Dimensiones

`Dim_Area`  
`Dim_Responsable`  
`Dim_Estado`  
`Dim_Prioridad`

Separé estos datos para no guardar toda la información repetida dentro de una sola tabla.

También quería practicar una estructura que después pudiera conectarse de manera ordenada con Power BI.

Una vez creadas las tablas y sus relaciones cargué las **500 operaciones simuladas** con las que trabajé durante todo el proyecto.

---

##  Antes de analizar, revisé los datos

Una parte que quería incluir sí o sí era la validación.

Podría haber cargado los datos directamente a Power BI y empezar a crear gráficos, pero preferí revisar primero si existían problemas en la información.

Preparé consultas SQL para buscar:

- operaciones duplicadas;
- campos obligatorios sin información;
- fechas incorrectas;
- operaciones cerradas sin fecha de cierre;
- valores de SLA incorrectos;
- registros sin relación con sus dimensiones;
- estados fuera de los valores esperados;
- prioridades fuera de los valores esperados.

Esta parte me ayudó a trabajar con una idea que considero básica en análisis de datos:

**un reporte puede verse bien, pero si los datos están mal, el análisis también estará mal.**

---

##  Trabajo realizado en SQL

SQL Server no lo usé solamente para guardar las tablas.

También preparé vistas y procedimientos almacenados para trabajar la información de una forma más ordenada.

### Vista analítica

Creé:

`vw_OperacionAnalitica`

La idea de esta vista fue reunir en una misma consulta la información que necesitaba para analizar las operaciones.

Desde ahí puedo trabajar con datos como:

- área;
- responsable;
- estado;
- prioridad;
- información del SLA.

En lugar de repetir varias uniones entre tablas cada vez que necesitaba consultar algo, podía partir de una vista ya preparada.

### Procedimientos almacenados

También creé:

`sp_ObtenerOperacionesPorEstado`

Lo preparé para consultar operaciones según su estado.

`sp_ObtenerAlertasOperacionales`

Lo usé para identificar casos que necesitan atención.

`sp_ResumenCumplimientoSLA`

Lo preparé para revisar los resultados relacionados con el cumplimiento del SLA.

Con esta parte del proyecto quise practicar SQL no solamente desde consultas `SELECT`, sino también trabajando con objetos que podrían tener sentido dentro de una base de datos operacional.

---

##  ¿Cómo pasé de SQL Server a Power BI?

Después de preparar y revisar los datos, conecté SQL Server con Power BI.

Antes de crear las visualizaciones pasé por Power Query, donde revisé la información que iba a cargar al modelo y los tipos de datos de las columnas.

Luego trabajé las relaciones del modelo y las medidas DAX necesarias para construir los indicadores.

El recorrido del proyecto quedó así:

```text
500 operaciones simuladas
          ↓
      SQL Server
          ↓
   Tablas y relaciones
          ↓
  Validación de datos
          ↓
Vistas y consultas SQL
          ↓
      Power Query
          ↓
    Modelo de datos
          ↓
         DAX
          ↓
       Power BI
          ↓
Dashboard operacional
```

Esta parte fue interesante porque pude ver cómo cada etapa depende de la anterior.

El dashboard es el resultado visible, pero detrás están las tablas, relaciones, validaciones, consultas y medidas que hacen posible el análisis.

---

##  Indicadores que trabajé

Para el dashboard preparé medidas relacionadas con el seguimiento de las operaciones.

Entre ellas están:

- Total de operaciones
- Operaciones abiertas
- Operaciones cerradas
- Cumplimiento del SLA
- Operaciones vencidas
- Operaciones en riesgo
- Operaciones pendientes
- Operaciones en proceso
- Operaciones críticas
- Tiempo de atención

Los resultados cambian según los filtros aplicados en cada página.

Esto me permite revisar, por ejemplo, solamente un área, una prioridad o un responsable sin tener que crear otro reporte.

---

#  Las cuatro páginas del dashboard

Quise dividir el dashboard en cuatro partes.

La lógica que seguí fue:

**primero entender qué está pasando → después revisar los problemas → luego ver dónde concentrar la atención → finalmente revisar un caso específico.**

---

## 1️ Resumen Ejecutivo

![Resumen Ejecutivo](Proyecto_GestionOperacional/2.-POWER%20BI/CAPTURAS/dashboard-resumen-ejecutivo.png)

Esta página responde principalmente a:

**¿Cómo estamos en este momento?**

Aquí puedo ver rápidamente los indicadores generales y tener una primera lectura de la situación.

También puedo comparar las operaciones por estado y por área.

En la parte inferior incluí la evolución mensual para tener una referencia de cómo fue cambiando el volumen de operaciones.

No quise cargar esta primera página con demasiados detalles. La idea es entrar, mirar los números principales y saber si existe algo que merece una revisión más cercana.

---

## 2️ SLA y Alertas

![SLA y Alertas](Proyecto_GestionOperacional/2.-POWER%20BI/CAPTURAS/dashboard-sla-alertas.png)

Después del resumen quería responder otra pregunta:

**¿Estamos cumpliendo los tiempos?**

Esta página se concentra en el SLA.

De las **260 operaciones cerradas**:

- **208 terminaron dentro del SLA**
- **52 terminaron fuera del SLA**

El resultado general es un **80 % de cumplimiento**.

También puedo comparar el porcentaje entre las distintas áreas.

Más abajo coloqué una tabla con las operaciones que necesitan atención.

Ahí puedo revisar:

- `OperacionID`
- estado;
- prioridad;
- área;
- responsable;
- fecha de compromiso;
- horas de SLA;
- situación del plazo;
- comentario.

Esta tabla es especialmente útil porque permite pasar del porcentaje general a los casos concretos que están generando el problema.

---

## 3️ Gestión Operativa

![Gestión Operativa](Proyecto_GestionOperacional/2.-POWER%20BI/CAPTURAS/dashboard-gestion-operativa.png)

En esta página cambié un poco el enfoque.

Ya no quería saber solamente cuántas operaciones existen, sino:

**¿Dónde debería poner atención primero?**

Actualmente el reporte muestra:

- **240 operaciones abiertas**
- **70 pendientes**
- **70 en proceso**
- **36 críticas**
- **60 vencidas**
- **40 en riesgo**

También preparé una matriz para cruzar las operaciones por **área y prioridad**.

Esto me permite detectar, por ejemplo, si un área empieza a concentrar demasiados casos de prioridad alta o crítica.

Otro punto que quise analizar fue la antigüedad de las operaciones abiertas.

Las separé en:

- 0–2 días
- 3–5 días
- 6–10 días
- 11+ días

Porque dos operaciones abiertas no necesariamente tienen la misma urgencia. Una que acaba de ingresar y otra que lleva varios días esperando deberían verse de manera distinta.

En la parte inferior derecha agregué una **cola prioritaria de atención**.

La idea es tener a la vista los casos que requieren una revisión más cercana y no depender solamente de los indicadores generales.

---

## 4️ Detalle de Operación

![Detalle de Operación](Proyecto_GestionOperacional/2.-POWER%20BI/CAPTURAS/dashboard-detalle-operacion.png)

La última página responde a una pregunta mucho más específica:

**¿Qué está pasando con esta operación?**

Aquí puedo ingresar un `OperacionID` y revisar toda su información desde una sola pantalla.

Entre los datos que puedo consultar están:

- estado;
- prioridad;
- área;
- responsable;
- tipo de operación;
- canal de ingreso;
- cargo;
- fecha de creación;
- fecha de compromiso;
- fecha de cierre;
- horas de SLA;
- comentario.

También preparé un indicador para comparar el tiempo transcurrido con el límite de SLA.

En la captura estoy revisando la operación `10284`.

La operación aparece como **cerrada**, con prioridad **alta** y dentro del SLA.

Tenía un límite de **24 horas** y registró **16 horas transcurridas**, equivalente al **67 % del tiempo disponible**.

El reporte también muestra un mensaje de acuerdo con la situación de la operación.

En este caso indica que ya está cerrada y no requiere una acción inmediata.

Esta página me gusta porque cierra el recorrido del dashboard: puedo empezar viendo 500 operaciones y terminar revisando una sola.

---

##  ¿Cómo se puede recorrer el análisis?

Una forma de leer el reporte sería esta:

Primero entro al **Resumen Ejecutivo** y veo que el cumplimiento general del SLA está en 80 %.

Después voy a **SLA y Alertas** para revisar qué áreas tienen menor cumplimiento y cuáles son los casos atrasados.

Si quiero saber dónde se está concentrando la carga, paso a **Gestión Operativa**.

Y cuando encuentro una operación que quiero revisar, voy a **Detalle de Operación** e ingreso su identificador.

Ese fue uno de los puntos que más cuidé al diseñar el reporte: que las páginas no fueran independientes, sino que siguieran una lógica de análisis.

---

##  Estructura del repositorio

Organicé el proyecto de esta manera:

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
│   │
│   ├── CAPTURAS/
│   │   ├── dashboard-resumen-ejecutivo.png
│   │   ├── dashboard-sla-alertas.png
│   │   ├── dashboard-gestion-operativa.png
│   │   └── dashboard-detalle-operacion.png
│   │
│   └── FONDOS/
│
└── 3.-DOCUMENTACION/
    └── Documentacion_Centro_Control_Operacional.docx
```

---

##  Cómo probar el proyecto

Los scripts SQL están numerados según el orden en que deben ejecutarse.

### 1. Crear la base de datos

`01_Creacion_Base_Datos.sql`

Crea la base de datos, las tablas y sus relaciones.

### 2. Cargar los datos

`02_Insercion_Datos.sql`

Carga las 500 operaciones simuladas del proyecto.

### 3. Revisar la calidad de los datos

`03_Consultas_Validacion.sql`

Contiene las consultas que preparé para detectar problemas en la información.

### 4. Crear las vistas

`04_Vistas_SQL.sql`

Crea las vistas que forman parte del análisis.

### 5. Crear los procedimientos almacenados

`05_Stored_Procedures.sql`

Crea los procedimientos almacenados del proyecto.

Después de ejecutar la parte de SQL se puede abrir:

`Dashboard_Gestion_Operacional.pbix`

desde **Power BI Desktop**.

Si se abre desde otro equipo o desde otra instancia de SQL Server, será necesario cambiar la conexión al origen de datos.

---

##  ¿Con qué me quedo de este proyecto?

Lo que más me interesaba era practicar un proyecto de datos de principio a fin.

No quería quedarme solamente en:

**“Tengo una base de datos”**

o:

**“Hice un dashboard en Power BI”.**

Quería conectar las dos partes.

Durante el proyecto pasé por:

**SQL Server → validación de datos → modelado → Power Query → DAX → Power BI → análisis**

Eso me permitió entender mejor algo que antes veía por separado: un dashboard depende mucho del trabajo que existe detrás.

Las relaciones, la calidad de los datos, las reglas del SLA y las medidas que se preparan terminan afectando directamente lo que después vemos en una gráfica o en un KPI.

---

##  Conocimientos que puse en práctica

`SQL Server` · `T-SQL` · `Modelado de Datos` · `Calidad de Datos` · `Vistas SQL` · `Stored Procedures` · `Power Query` · `DAX` · `Power BI` · `KPIs` · `SLA` · `Análisis Operacional`

---

##  ¿Qué me gustaría agregar después?

El proyecto todavía tiene espacio para seguir creciendo.

Algunas cosas que me gustaría trabajar más adelante son:

- automatizar la actualización de los datos;
- publicar el dashboard en Power BI Service;
- guardar un historial de cambios de cada operación;
- crear alertas automáticas antes de que una operación venza;
- trabajar un proceso de carga de datos más automatizado.

La idea es seguir agregando mejoras poco a poco, siempre tratando de que tengan sentido dentro del caso y no agregar herramientas solamente por tener más tecnologías en el proyecto.

---

##  Sobre los datos

Las **500 operaciones utilizadas en este proyecto son simuladas** y fueron creadas únicamente con fines de aprendizaje y demostración.

No se trabajó con información real, privada o confidencial de ninguna empresa.
