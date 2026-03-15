USE master;
SET nocount ON;
SET ANSI_WARNINGS OFF;

DECLARE @SCRIPT             NVARCHAR(MAX),
        @DB_TO_RESTORE      VARCHAR(100),
        @PATH_FINAL         VARCHAR(150),
        @DB_FINAL           VARCHAR(100),
        @LOGICALNAMEPRIMARY VARCHAR(100),
        @LOGICALNAMELOG     VARCHAR(100)

SELECT @DB_TO_RESTORE = 'D:\Datos\Jorge.Molina\Datas\Cartera_ 20180212_0402.bak',
       @PATH_FINAL = 'D:\Datos\Jorge.Molina\Datas\',
       @DB_FINAL = 'FNic_Completa_JMolina_Cart',
       @LOGICALNAMEPRIMARY = '',
       @LOGICALNAMELOG ='';

DECLARE @FILELISTTABLE TABLE
        (
           LogicalName          NVARCHAR( 128 ),
           PhysicalName         NVARCHAR( 260 ),
           [Type]               CHAR( 1 ),
           FileGroupName        NVARCHAR( 128 ),
           Size                 NUMERIC( 20, 0 ),
           MaxSize              NUMERIC( 20, 0 ),
           FileID               BIGINT,
           CreateLSN            NUMERIC( 25, 0 ),
           DropLSN              NUMERIC( 25, 0 ),
           UniqueID             UNIQUEIDENTIFIER,
           ReadOnlyLSN          NUMERIC( 25, 0 ),
           ReadWriteLSN         NUMERIC( 25, 0 ),
           BackupSizeInBytes    BIGINT,
           SourceBlockSize      INT,
           FileGroupID          INT,
           LogGroupGUID         UNIQUEIDENTIFIER,
           DifferentialBaseLSN  NUMERIC( 25, 0 ),
           DifferentialBaseGUID UNIQUEIDENTIFIER,
           IsReadOnl            BIT,
           IsPresent            BIT
			,TDEThumbprint        VARBINARY(32)-- Add to SQL2008R2
     )
     
INSERT INTO @FILELISTTABLE
EXEC( 'restore filelistonly from disk = ''' + @DB_TO_RESTORE + '''') 


SELECT  @LOGICALNAMELOG = LogicalName
FROM   @FILELISTTABLE t
WHERE  t.Type = 'L';

SELECT @LOGICALNAMEPRIMARY = LogicalName
FROM   @FILELISTTABLE t
WHERE  t.Type = 'D';



SET @SCRIPT ='IF ( EXISTS
     (SELECT d.name
      FROM   master.dbo.sysdatabases d (NOLOCK)
      WHERE  ( [NAME] = ''' + @DB_FINAL + '''
            OR NAME             = ''' + @DB_FINAL + ''' )) )
       BEGIN
			EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N''' + @DB_FINAL + '''
			ALTER DATABASE [' + @DB_FINAL + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
			DROP DATABASE ' + @DB_FINAL + '
		END' + Char(13);

--PRINT @SCRIPT;

EXEC (@SCRIPT)
SET @SCRIPT ='RESTORE DATABASE ' + @DB_FINAL + ' FROM DISK = ''' + @DB_TO_RESTORE + '''
		WITH
			FILE = 1, 
			MOVE ''' + @LOGICALNAMEPRIMARY + ''' TO  ''' + @PATH_FINAL + @DB_FINAL + '_Data.mdf'',
			MOVE ''' + @LOGICALNAMELOG + ''' TO  ''' + @PATH_FINAL + @DB_FINAL + '_log.ldf'' ,
			NOUNLOAD, REPLACE, STATS = 100;' + Char(13);

--PRINT @SCRIPT;
EXEC (@SCRIPT) 

