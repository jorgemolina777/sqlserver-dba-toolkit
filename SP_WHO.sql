USE master

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

-- Creo la tabla temporaria donde guardaré la salida del sp_who  
IF NOT Object_id('tempdb.dbo.#sp_who2') IS NULL
  DROP TABLE DBO.#SP_WHO2

CREATE TABLE #SP_WHO2
  (
     SPID        INT,
     STATUS      VARCHAR( 1000 ) NULL,
     LOGIN       SYSNAME NULL,
     HOSTNAME    SYSNAME NULL,
     BLKBY       SYSNAME NULL,
     DBNAME      SYSNAME NULL,
     COMMAND     VARCHAR( 1000 ) NULL,
     CPUTIME     INT NULL,
     DISKIO      INT NULL,
     LASTBATCH   VARCHAR( 1000 ) NULL,
     PROGRAMNAME VARCHAR( 1000 ) NULL,
     SPID2       INT,
     REQUESTID   INT
  )

GO

DECLARE @I BIGINT

SET @I = 0

WHILE ( @I <= 0 )
  BEGIN
      -- Inserto los valores  
      TRUNCATE TABLE #SP_WHO2

      INSERT INTO #SP_WHO2
      EXEC Sp_who2

      --GO
      SELECT p.SPID,
             'kill ' + CONVERT(VARCHAR(4), P.SPID)                   AS [KILL],
             'dbcc inputbuffer(' + CONVERT(VARCHAR(4), P.SPID) + ')' AS SCRIPT,
             p.STATUS,
             P.LOGIN,
             p.HOSTNAME,
             p.BLKBY,
             p.DBNAME,
             P.COMMAND,
             p.PROGRAMNAME,
             P.CPUTIME,
             P.DISKIO,
             P.LASTBATCH
      FROM   #SP_WHO2 P --(nolock)
      WHERE  P.BLKBY != '  .  '
      UNION ALL
      SELECT p.SPID,
             'kill ' + CONVERT(VARCHAR(4), P.SPID)                   AS [KILL],
             'dbcc inputbuffer(' + CONVERT(VARCHAR(4), P.SPID) + ')' AS SCRIPT,
             p.STATUS,
             P.LOGIN,
             p.HOSTNAME,
             p.BLKBY,
             p.DBNAME,
             P.COMMAND,
             p.PROGRAMNAME,
             P.CPUTIME,
             P.DISKIO,
             P.LASTBATCH
      FROM   #SP_WHO2 P --(nolock) 
      WHERE  EXISTS
             (SELECT TOP 1 1
              FROM   #SP_WHO2 B --(nolock)
              WHERE  p.SPID  = b.BLKBY
                 AND b.BLKBY != '  .  ')
      ORDER  BY DISKIO DESC

      DECLARE @BLK   INT,
              @BLKBY INT

      SELECT @BLK = 0,
             @BLKBY = 0

      SELECT TOP 1 @BLK = P.SPID
      FROM   #SP_WHO2 P --(nolock)
      WHERE  P.BLKBY != '  .  '

      SELECT TOP 1 @BLKBY = P.SPID
      FROM   #SP_WHO2 P --(nolock) 
      WHERE  EXISTS
             (SELECT TOP 1 1
              FROM   #SP_WHO2 B --(nolock)
              WHERE  p.SPID  = b.BLKBY
                 AND b.BLKBY != '  .  ');

      IF @BLK > 0
         AND @BLKBY > 0
        BEGIN
        SELECT @BLK
            DBCC inputbuffer(@BLK)		
SELECT @BLKBY
            DBCC inputbuffer(@BLKBY)
        END

      SET @I = @I + 1
  END

GO


