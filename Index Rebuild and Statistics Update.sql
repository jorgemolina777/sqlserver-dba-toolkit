DECLARE @TABLENAME             VARCHAR(255),
        @IDX_NAME              VARCHAR(255),
        @IDX_TYPE              VARCHAR(255),
        @SQL                   NVARCHAR(500),
        @IDX_AVG_FRAGMENTATION DECIMAL(10, 6),
        @DB_NAME               VARCHAR(255),
        @NEW_CMPTLEVEL         INT,
        @FILLFACTOR            INT

SELECT @FILLFACTOR = 80,
       @NEW_CMPTLEVEL = 90,
       @DB_NAME = Db_name(Db_id())

EXEC dbo.Sp_dbcmptlevel @DB_NAME,@NEW_CMPTLEVEL -- Se pasa la base de datos a compatibilidad 90 para que se pueda utilizar las siguientes instruicciones 
DECLARE tablecursor CURSOR FOR
  SELECT Quotename( sch.NAME) + Char(46) + Quotename( Object_name(ips.object_id)) AS TABLE_NAME,
         Round(Avg(ips.avg_fragmentation_in_percent), 2)                          AS IDX_AVG_FRAGMENTATION-- Fragmentacion por tabla
  FROM   sys.indexes i (NOLOCK)
         INNER JOIN sys.Dm_db_index_physical_stats(Db_id(), NULL, NULL, NULL, NULL) ips -- LIMITED,'DETAILED' --Funcion solo para compatabilidad 90
                 ON i.object_id = ips.object_id
         INNER JOIN sys.tables tbl (NOLOCK)
                 ON tbl.object_id = ips.object_id
         INNER JOIN sys.schemas sch (NOLOCK)
                 ON sch.schema_id = tbl.schema_id
  WHERE  avg_fragmentation_in_percent > 80 -- Por indice que solo tenga fracmentacion mayor a 5
     AND ips.index_id                 > 0
  GROUP  BY
    Quotename( sch.NAME) + Char(46) + Quotename( Object_name(ips.object_id))
  HAVING Round(Avg(ips.avg_fragmentation_in_percent), 2) > 20 -- Por tabla que solo tenga fragmentacion mayor a 20
  ORDER  BY 2 DESC

OPEN tablecursor

FETCH next FROM tablecursor INTO @TABLENAME, @IDX_AVG_FRAGMENTATION

WHILE @@FETCH_STATUS = 0
  BEGIN
      IF @IDX_AVG_FRAGMENTATION > 30 -- Solamente se hace un rebuild de los index de la tabla si tiene una fracmentacion mayor a 30
		BEGIN			
			SET @SQL = 'ALTER INDEX ALL ON ' + @TABLENAME + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3), @FILLFACTOR) + ')'
        END
      ELSE -- Si esta entre 20 y 30 solo se reorganiza
		BEGIN			
			SET @SQL = 'ALTER INDEX ALL ON ' + @TABLENAME + ' REORGANIZE';
		END
		
	  PRINT 'FRAGMENTATION = ' + CONVERT(VARCHAR(16),@IDX_AVG_FRAGMENTATION	)
      PRINT @SQL

      EXEC (@SQL)

      SET @SQL = 'UPDATE STATISTICS ' + @TABLENAME + ' WITH FULLSCAN'-- Se actualizan las estadisticas de la tabla
      PRINT @SQL

      EXEC (@SQL)

      FETCH next FROM tablecursor INTO @TABLENAME, @IDX_AVG_FRAGMENTATION
  END

CLOSE tablecursor

DEALLOCATE tablecursor

SET @NEW_CMPTLEVEL = 90

EXEC dbo.Sp_dbcmptlevel @DB_NAME,@NEW_CMPTLEVEL -- Se regrasa la compatibilidad a 70

