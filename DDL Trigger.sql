--====================================
--  Create database trigger template 
--====================================
USE FNic_Performance_Cart

GO

IF EXISTS
   (SELECT TOP 1 1
    FROM   sys.triggers tr (nolock)
    WHERE  tr.NAME = N'ust_SIEM_delete_trigger_DTA')
  DROP TRIGGER ust_SIEM_delete_trigger_DTA ON DATABASE

GO

CREATE TRIGGER ust_SIEM_delete_trigger_DTA
ON DATABASE
FOR CREATE_INDEX
AS
  BEGIN
      DECLARE @ed XML

      SET @ed = EVENTDATA()

      SELECT GetDate()                                                       AS [Date],
             @ed.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(256)')  AS [DataBase Name],
             @ed.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)')    AS [Event Type],
             @ed.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(256)')    AS [Object Name],
             @ed.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)') AS [TSQLCommand],
             @ed.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(256)')     AS [LoginName]

      IF @ed.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(256)') LIKE '%_dta_%'
        BEGIN
			print 'RollBack  '
            ROLLBACK
        END
  END

GO 
