# 🛠️ SQL Server DBA Toolkit

> Colección de scripts T-SQL para administración, monitoreo y mantenimiento de SQL Server, construida a partir de más de 18 años de experiencia en entornos de producción.

> *Collection of T-SQL scripts for SQL Server administration, monitoring and maintenance, built from 18+ years of production experience.*

![SQL Server](https://img.shields.io/badge/SQL%20Server-2008--2019-CC2927?style=flat&logo=microsoftsqlserver)
![T-SQL](https://img.shields.io/badge/Language-T--SQL-blue?style=flat)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

---

## 📂 Contenido por categoría / Scripts by category

### 🔍 Monitoreo de actividad / Activity Monitoring

Scripts para identificar qué está ejecutando SQL Server en tiempo real — procesos bloqueados, queries activas, conexiones y esperas.

| Script | Descripción |
|--------|-------------|
| `SP_WHO.sql` | Versión mejorada de sp_who — muestra procesos activos con detalle de base de datos y estado |
| `SP_WHO2.sql` | Versión extendida con información adicional de bloqueos y esperas |
| `sp_who3.sql` | Versión personalizada con filtros adicionales para producción |
| `who_is_active_v10_00.sql` | Implementación de Adam Machanic's sp_WhoIsActive — el estándar de la industria para monitoreo en tiempo real |

---

### 💾 Backup & Restore

Scripts para gestión completa del ciclo de backup y restauración.

| Script | Descripción |
|--------|-------------|
| `BACKUP SCRIPTS.sql` | Scripts de backup completo, diferencial y de log de transacciones |
| `25-Get backup history.sql` | Consulta el historial de backups desde msdb — útil para verificar que los backups automáticos están corriendo correctamente |
| `Restore Script.sql` | Script de restauración con opciones NORECOVERY / RECOVERY para restauraciones en múltiples pasos |

---

### 📊 Información de bases de datos / Database Information

Scripts de diagnóstico y reporte de estado general de las bases de datos.

| Script | Descripción |
|--------|-------------|
| `02-Tamaño de bases de datos.sql` | Reporte de tamaño de todas las BDs del servidor: datos, log y espacio libre |
| `DB_INFO.sql` | Información detallada de configuración de cada base de datos |
| `DataBase Info.sql` | Vista consolidada de estado, recovery model, collation y propiedades |
| `Tablas y Cantidad de Registros.sql` | Inventario de tablas con conteo de registros — útil para estimaciones de crecimiento |

---

### 🔧 Mantenimiento / Maintenance

Scripts para mantenimiento preventivo y correctivo de bases de datos.

| Script | Descripción |
|--------|-------------|
| `Index Rebuild and Statistics Update.sql` | Rebuild y reorganize de índices según nivel de fragmentación + actualización de estadísticas |
| `Estadisticas a BDs.sql` | Actualización de estadísticas en todas las tablas de una base de datos |
| `DB SHRINKFILE AUTOMATICO.sql` | Reducción controlada de archivos de base de datos — usar con criterio en producción |

---

### 🔐 Seguridad / Security

| Script | Descripción |
|--------|-------------|
| `BCP permisos.sql` | Configuración de permisos necesarios para uso de BCP (Bulk Copy Program) |
| `DDL Trigger.sql` | Trigger DDL para auditoría de cambios estructurales en la base de datos (CREATE, ALTER, DROP) |
| `Trigger on tables.sql` | Trigger DML para auditoría de cambios de datos en tablas específicas |

---

### 🖥️ Administración del servidor / Server Administration

| Script | Descripción |
|--------|-------------|
| `SQL Change Server Name.sql` | Procedimiento para cambiar el nombre del servidor en SQL Server después de renombrar el equipo |
| `SQLCMD Mode Connect.sql` | Scripts de conexión en modo SQLCMD para automatización y scripting |
| `sqlcmd mode test.sql` | Pruebas de conectividad y variables en modo SQLCMD |

---

### 🔄 Patrones T-SQL / T-SQL Patterns

Scripts de referencia para patrones avanzados de T-SQL reutilizables.

| Script | Descripción |
|--------|-------------|
| `recursividad.sql` | CTE recursivas — estructura base y casos de uso comunes |
| `RecursividadFinMes.sql` | CTE recursiva para generación de calendario / fechas fin de mes |
| `ultimo dia del mes.sql` | Función para calcular el último día de un mes dado |
| `tryCath.sql` | Manejo estructurado de errores con TRY/CATCH y RAISERROR |
| `sp return value.sql` | Manejo correcto de valores de retorno en stored procedures |
| `compute.sql` | Ejemplos de cálculos y agregaciones en T-SQL |

---

### 📝 Manipulación de strings / String Manipulation

| Script | Descripción |
|--------|-------------|
| `01-Separar Texto en campos.sql` | Separar un string delimitado en columnas individuales |
| `02-Funcion separar string en registros.sql` | Función para convertir string delimitado en tabla de registros (split function) |
| `Parser.sql` | Parser genérico para procesamiento de texto estructurado |

---

### 📅 Funciones de fecha / Date Functions

| Script | Descripción |
|--------|-------------|
| `uFn_Siem_Asuetos.sql` | Función que retorna si una fecha es día de asueto en Guatemala — útil para cálculos de días hábiles |

---

## 🚀 Cómo usar estos scripts / How to use

1. **Cloná el repositorio**
```bash
git clone https://github.com/jorgemolina777/sqlserver-dba-toolkit.git
```

2. **Abrí el script en SSMS** (SQL Server Management Studio)

3. **Revisá los parámetros** — la mayoría tienen variables configurables al inicio del script

4. **Ejecutá en un ambiente de prueba primero** — algunos scripts modifican configuraciones del servidor

> ⚠️ **Importante:** Siempre probá en un ambiente no productivo antes de ejecutar en producción. Scripts como `DB SHRINKFILE AUTOMATICO.sql` deben usarse con criterio.

---

## 🎯 Casos de uso principales / Main use cases

**¿La base de datos está lenta?**
→ Empezá con `who_is_active_v10_00.sql` para ver qué está corriendo, luego `SP_WHO2.sql` para detectar bloqueos.

**¿Necesitás verificar los backups?**
→ Usá `25-Get backup history.sql` para revisar el historial y confirmar que corrieron correctamente.

**¿Los índices están fragmentados?**
→ `Index Rebuild and Statistics Update.sql` evalúa la fragmentación y ejecuta rebuild o reorganize según el umbral.

**¿Necesitás auditar cambios en la BD?**
→ `DDL Trigger.sql` captura CREATE/ALTER/DROP. `Trigger on tables.sql` audita cambios de datos.

---

## 📋 Compatibilidad / Compatibility

| SQL Server | Compatibilidad |
|------------|---------------|
| 2008 R2 | ✅ La mayoría de scripts |
| 2012 – 2016 | ✅ Completa |
| 2017 – 2019 | ✅ Completa |
| Azure SQL | ⚠️ Parcial — algunos scripts usan DMVs no disponibles en Azure |

---

## 📁 Próximos scripts / Coming soon

- [ ] Script de diagnóstico de wait statistics
- [ ] Health check completo del servidor (jobs fallidos, backups vencidos, índices fragmentados)
- [ ] Monitoreo de crecimiento de bases de datos
- [ ] Scripts de migración entre versiones de SQL Server

---

## 👤 Autor / Author

**Jorge Alejandro Molina Carrera**
DBA Senior · SQL Server Expert · 18+ años en producción · Guatemala 🇬🇹

Administro actualmente 32 bases de datos en producción en 5 motores distintos (SQL Server, DB2, MySQL, Sybase, SSAS).

[![LinkedIn](https://img.shields.io/badge/LinkedIn-jorgemolina777-0077B5?style=flat&logo=linkedin)](https://linkedin.com/in/jorgemolina777)
[![GitHub](https://img.shields.io/badge/GitHub-jorgemolina777-181717?style=flat&logo=github)](https://github.com/jorgemolina777)

---

## 📄 Licencia / License

MIT — Libre para usar, modificar y distribuir. Si te fue útil, un ⭐ ayuda a que otros lo encuentren.

*MIT — Free to use, modify and distribute. If it was useful, a ⭐ helps others find it.*
