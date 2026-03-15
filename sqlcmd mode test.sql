--EXEC dbo.sp_configure 'show advanced options', 1
--RECONFIGURE
--EXEC dbo.sp_configure 'xp_cmdshell', 1
--RECONFIGURE 
--SET NOCOUNT ON
--SET ANSI_WARNINGS OFF
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF

DECLARE @SCRIPT VARCHAR(999)

SET @SCRIPT = 'sqlcmd -S GTSSCSVRTDB03\SQL2005 -U siem -P siem'

EXEC MASTER..Xp_cmdshell @SCRIPT;

SELECT @@SERVERNAME

go

--EXEC dbo.sp_configure 'show advanced options', 1
--RECONFIGURE
--EXEC dbo.sp_configure 'xp_cmdshell', 1
--RECONFIGURE 

SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF

DECLARE @SCRIPT VARCHAR(999)

SET @SCRIPT = 'sqlcmd -S GTSSCSVRTDB02\SQL2005 -U siem -P siem'

EXEC MASTER..Xp_cmdshell ':connect GTSSCSVRTDB03\SQL2005 -U siem -P siem'

SELECT @@SERVERNAME 
