use master
----------------------------------------------------
---- paso 01 -- le quita el full recovery
-----------------------------------------------------
DECLARE @DB_NAME       VARCHAR(100),
        @FILE_LOG_NAME VARCHAR(100),
        @SQLSCRIPT     VARCHAR(MAX);
        
DECLARE CUR_DB CURSOR FOR -- Cursor 
  SELECT Rtrim(Ltrim(DB.NAME)) AS [DB_NAME],
         Rtrim(Ltrim(FL.NAME)) AS [FILE_LOG_NAME]
  FROM   SYS.DATABASES DB(NOLOCK)
         INNER JOIN SYS.MASTER_FILES FL (NOLOCK)
                 ON FL.DATABASE_ID = DB.DATABASE_ID
  WHERE  DB.NAME NOT IN ( 'MASTER', 'TEMPDB', 'MODEL', 'MSDB',
                          'ReportServer', 'ReportServerTempDB' ) -- No se incluyen estas DB's que solo internas de SQL SERVER
     AND DB.STATE               = 0 -- solo DB en linea
     AND FL.TYPE                = 1 -- Solo file de LOG
     AND DB.recovery_model_desc = 'FULL' -- recovery model FULL
  ORDER  BY DB.NAME;

OPEN CUR_DB;

FETCH NEXT FROM CUR_DB INTO @DB_NAME, @FILE_LOG_NAME;

WHILE @@FETCH_STATUS = 0 -- se inicia el cursor
  BEGIN
      --inicio: SE COLOCA LO QUE SE REPETIRA
      SET @SQLSCRIPT = '';
      SET @SQLSCRIPT = 'ALTER DATABASE [' + @DB_NAME + '] SET RECOVERY SIMPLE WITH NO_WAIT '; -- Se realiza el cambio de pasar la base de datos de recovery full a simple

      PRINT ( @SQLSCRIPT ) -- envia a pantalla la sentencia a ejecutar

      EXEC (@SQLSCRIPT) -- ejecuta el script
      --Fin:SE COLOCA LO QUE SE REPETIRA
      FETCH NEXT FROM CUR_DB INTO @DB_NAME, @FILE_LOG_NAME;
  END;

CLOSE CUR_DB; -- Se cierra el cursor
DEALLOCATE CUR_DB; -- Liberamos memoria
----------------------------------------------------
---- paso 02 -- se hace el SHRINKFILE 
-----------------------------------------------------

DECLARE CUR_DB CURSOR FOR -- Cursor 
  SELECT Rtrim(Ltrim(DB.NAME)) AS [DB_NAME],
         Rtrim(Ltrim(FL.NAME)) AS [FILE_LOG_NAME]
  FROM   SYS.DATABASES DB(NOLOCK)
         INNER JOIN SYS.MASTER_FILES FL (NOLOCK)
                 ON FL.DATABASE_ID = DB.DATABASE_ID
  WHERE  DB.NAME NOT IN ( 'MASTER', 'TEMPDB', 'MODEL', 'MSDB',
                          'ReportServer', 'ReportServerTempDB' ) -- No se incluyen estas DB's que solo internas de SQL SERVER
     AND DB.STATE = 0 -- solo DB en linea
     AND FL.TYPE  = 1 -- Solo file de LOG
  ORDER  BY DB.NAME;

OPEN CUR_DB;

FETCH NEXT FROM CUR_DB INTO @DB_NAME, @FILE_LOG_NAME;

WHILE @@FETCH_STATUS = 0 -- se inicia el cursor
  BEGIN
      --inicio: SE COLOCA LO QUE SE REPETIRA
      SET @SQLSCRIPT = '';
      SET @SQLSCRIPT = @SQLSCRIPT + 'USE [' + @DB_NAME + '] ' + Char(13) -- Se elige la base de datos
      SET @SQLSCRIPT = @SQLSCRIPT + 'DBCC SHRINKFILE (N''' + @FILE_LOG_NAME + ''', 0)' + Char(13) -- Se realiza el SHRINKFILE al file del log de dicha base de datos

      PRINT ( @SQLSCRIPT ) -- envia a pantalla la sentencia a ejecutar

      EXEC (@SQLSCRIPT) -- ejecuta el script
      --Fin:SE COLOCA LO QUE SE REPETIRA
      FETCH NEXT FROM CUR_DB INTO @DB_NAME, @FILE_LOG_NAME;
  END;

CLOSE CUR_DB; -- Se cierra el cursor
DEALLOCATE CUR_DB; -- Liberamos memoria

