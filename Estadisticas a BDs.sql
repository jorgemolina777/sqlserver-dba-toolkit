IF NOT Object_id('dbo.FSLA_usp_Regenerate_Indexes_And_Statistics') IS NULL
  DROP PROCEDURE dbo.fsla_usp_regenerate_indexes_and_statistics

go

CREATE PROCEDURE dbo.Fsla_usp_regenerate_indexes_and_statistics
(
  @OPTIDX INT = 0
)
AS
/* 
General Information--------------------------------------------------------------- 
	Name ....... :	FSLA_usp_Regenerate_Indexes_And_Statistics
	Project .... :	LA / Database Administration
	Created .... :	20121210
	Modified.... :	20121210
	Author ..... :	Jorge Daniel Mejia 
	Description  :	Stored Procedure to update, rebuild or 
					reorganize indexes and statistics in a database
---------------------------------------------------------------------------------- 

Parameters------------------------------------------------------------- 
	  
	@OptIdx	= 0 for Index Reorganize, 1 for Index rebuild(Weekend process)
---------------------------------------------------------------------------------- 
*/
    --Index Rebuild
    DECLARE @TABLENAME  VARCHAR(255),
            @SQL        VARCHAR(500),
            @FILLFACTOR INT

    SET @FILLFACTOR = 90

    DECLARE tablecursor CURSOR FOR
   

    SELECT tab.NAME AS TABLE_NAME
    FROM   sys.tables tab (nolock)
    order by tab.name

    OPEN tablecursor

    FETCH next FROM tablecursor INTO @TABLENAME

    WHILE @@FETCH_STATUS = 0
      BEGIN
          IF @OPTIDX = 0
            SET @SQL = 'alter index all on [' + @TABLENAME + '] reorganize;'
          ELSE
            SET @SQL = 'alter index all on [' + @TABLENAME + '] rebuild with (fillfactor = ' + CONVERT(VARCHAR(3), @FILLFACTOR) + ');'

          EXEC (@SQL)

          SET @SQL = 'update statistics [' + @TABLENAME + '] with fullscan'

          EXEC (@SQL)

          FETCH next FROM tablecursor INTO @TABLENAME
      END

    CLOSE tablecursor

    DEALLOCATE tablecursor 
