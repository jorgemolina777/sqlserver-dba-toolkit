use master 
go
DECLARE @SCRIPT      VARCHAR(MAX),
        @DB          VARCHAR(100),
        @HORA        VARCHAR(150),
        @DESCRIPCION VARCHAR(150),
        @PATH        VARCHAR(150)

SELECT @DESCRIPCION = 'Configuración completa ',
       @HORA = Rtrim(Ltrim(CONVERT(VARCHAR(50), Getdate(), 20))),
       @PATH = 'D:\Datos\QA\Noelia.Baltodano\Dol\Back\';

-------------
SET @DB = 'FNic_QA_Dol_Caja';
SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 100'

EXEC (@SCRIPT)

PRINT '-------------------------'

-----------------------------------
----------------------------------
SET @DB = 'FNic_QA_Dol_Cart3'
SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
		TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
	 NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 100'

EXEC (@SCRIPT)

PRINT '-------------------------'

-------------------------------------
------------------------------------
SET @DB = 'FNic_QA_Dol_SisF3'
SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 100'

EXEC (@SCRIPT)

PRINT '-------------------------'

-------------------------------------
------------------------------------
--SET @DB = 'FNic_Perfomance_PxP'
--SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
--	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
--	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 50'

--EXEC (@SCRIPT)

--PRINT '-------------------------' 
 

-------------------------------------
------------------------------------

--SET @DB = 'FNic_Perfomance_SIBOIF'
--SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
--	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
--	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 50'

--EXEC (@SCRIPT)


-------------------------------------
------------------------------------

--SET @DB = 'FNic_Perfomance_SistF'
--SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
--	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
--	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD,COMPRESSION,  STATS = 50'

--EXEC (@SCRIPT)

-------------------------------------
------------------------------------

--SET @DB = 'FNic_Perfomance_UI'
--SET @SCRIPT = 'BACKUP DATABASE [' + @DB + '] 
--	TO  DISK = N''' + @PATH + @DB + '.bk'' WITH NOFORMAT, NOINIT,  
--	NAME = N''' + @DB + '_' + @DESCRIPCION + '_' + @HORA + ' - Full'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 50'

--EXEC (@SCRIPT)
