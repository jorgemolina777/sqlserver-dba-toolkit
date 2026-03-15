USE master

IF EXISTS
   (SELECT *
    FROM   master.sys.objects (nolock)
    WHERE  NAME = 'sp_blocked')
  DROP PROCEDURE sp_blocked

go

CREATE PROCEDURE dbo.Sp_blocked
  @SPID INT
AS
    CREATE TABLE #Blocked
      (
         spid INT
      )

    INSERT INTO #Blocked
    (
      spid
    )
    VALUES
    (
      @SPID
    )
    WHILE @@ROWCOUNT <> 0
      BEGIN
          INSERT INTO #Blocked
          (
            spid
          )
            SELECT spid
            FROM   master.sys.sysprocesses (nolock)
            WHERE  blocked IN
                   (SELECT spid
                    FROM   #Blocked)
                   AND spid NOT IN (SELECT spid
                                    FROM   #Blocked)
      END

    DELETE FROM #Blocked
    WHERE  spid = @SPID

    DELETE FROM #Blocked
    WHERE  spid IS NULL

    IF EXISTS
       (SELECT *
        FROM   #Blocked)
      BEGIN
          SELECT *
          FROM   master.sys.sysprocesses
          WHERE  spid IN
                 (SELECT spid
                  FROM   #blocked)
      END
    ELSE
      BEGIN
          SELECT 'No Processes are being blocked by spid ' + CONVERT(VARCHAR(20), @SPID) + '.' AS 'System Message'
      END

    DROP TABLE #Blocked

go

PRINT 'sp_blocked created.'

USE master

PRINT 'Creating sp_who3'

IF EXISTS
   (SELECT *
    FROM   sys.objects (nolock)
    WHERE  NAME = 'sp_who3')
  DROP PROCEDURE [dbo].[sp_who3]

GO

SET QUOTED_IDENTIFIER ON

GO

SET ANSI_NULLS ON

GO

CREATE PROCEDURE Sp_who3
  @SPID SYSNAME = NULL
AS
    /*
    Date Creator Action
    2007.02.15 mrdenny Birth
    2007.05.18 mrdenny Correct Full Query Text
    2007.10.08 mrdenny Added Waiting Statement to Full Query RecordSet
    */
    DECLARE @SPID_I INT
    DECLARE @SPID_ONLY BIT

    SET NOCOUNT ON

    IF @SPID IS NULL
      BEGIN
          EXEC Sp_who2
      END
    ELSE
      BEGIN
          SET @SPID_ONLY = 1

          IF Lower(Cast(@SPID AS VARCHAR( 10 ))) = 'active'
            BEGIN
                SET @SPID_ONLY = 0

                EXEC Sp_who2 'active'
            END

          IF Lower(Cast(@SPID AS VARCHAR( 10 ))) = 'blocked'
              OR ( Isnumeric(@SPID) = 1
                   AND @SPID < 0 )
            BEGIN
                DECLARE @BLOCKED TABLE
                  (
                     spid    INT,
                     blocked INT
                  )

                INSERT INTO @BLOCKED
                  SELECT spid,
                         blocked
                  FROM   sys.sysprocesses (nolock)
                  WHERE  blocked <> 0

                INSERT INTO @BLOCKED
                  SELECT spid,
                         blocked
                  FROM   sys.sysprocesses (nolock)
                  WHERE  spid IN
                         (SELECT blocked
                          FROM   @BLOCKED)

                SET @SPID_ONLY = 0

                SELECT syspro.spid         AS 'SPID',
                       syspro.status       AS 'status',
                       syspro.loginame     AS 'Login',
                       syspro.hostname     AS 'HostName',
                       syspro.blocked      AS 'BlkBy',
                       DB.NAME             AS 'DBName',
                       syspro.cmd          AS 'Command',
                       syspro.cpu          AS 'CPUTime',
                       syspro.physical_io  AS 'DiskIO',
                       syspro.last_batch   AS 'LastBatch',
                       syspro.program_name AS 'ProgramName',
                       syspro.spid         AS 'SPID'
                FROM   sys.sysprocesses syspro (nolock)
                       LEFT OUTER JOIN sys.databases DB (nolock)
                                    ON syspro.dbid = DB.database_id
                WHERE  spid IN
                       (SELECT spid
                        FROM   @BLOCKED)
            END

          IF @SPID_ONLY = 1
            BEGIN
                DECLARE @SQL_HANDLE VARBINARY(64)
                DECLARE @STMT_START INT
                DECLARE @STMT_END INT

                SET @SPID_I = @SPID

                SELECT @SQL_HANDLE = sql_handle,
                       @STMT_START = stmt_start,
                       @STMT_END = stmt_end
                FROM   sys.sysprocesses
                WHERE  spid = @SPID_I

                EXEC Sp_who @SPID_I

                EXEC Sp_who2 @SPID_I

                DBCC inputbuffer (@SPID_I)

                /*Start Get Output Buffer*/
                SELECT text AS 'Full Query',
                       CASE
                         WHEN @STMT_START < 0 THEN
                           Substring(text, @STMT_START / 2, ( @STMT_END / 2 ) - ( @STMT_START / 2 ))
                         ELSE
                           NULL
                       END  AS 'Current Command'
                FROM   sys.Dm_exec_sql_text(@SQL_HANDLE)

                /*End Get Output Buffer*/
                SELECT *
                FROM   master.sys.sysprocesses (nolock)
                WHERE  spid = @SPID_I

                EXEC Sp_blocked @SPID_I

                EXEC Sp_lock @SPID_I
            END
      END 
