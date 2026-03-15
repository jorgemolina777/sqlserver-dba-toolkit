use master
SELECT @@SERVERNAME                  AS [SERVER],
       db.database_id                AS [ID],
       db.NAME                       AS [NAME],
       Suser_sname(DB.owner_sid)     AS [OWNER],
       db.compatibility_level        AS [COMPATIBILITY LEVEL],
       DB.recovery_model_desc        AS [RECOVERY MODEL],
       Sum(CASE
             WHEN FL.TYPE = 0 THEN
               fl.size * 8. / 1024
             ELSE
               0
           END)                      AS [MDF_SIZE_MB],
       Sum(CASE
             WHEN FL.TYPE = 1 THEN
               fl.size * 8. / 1024
             ELSE
               0
           END)                      AS [LDF_SIZE_MB],
       db.create_date                AS [CREATE],
       CASE
         WHEN Max(sp.last_user_update) IS NOT NULL THEN
           Max(sp.last_user_update)
         --WHEN Max(sp.last_user_scan)IS NOT NULL THEN
          -- Max(sp.last_user_scan)
         --WHEN Max(sp.last_user_seek)IS NOT NULL THEN
          -- Max(sp.last_user_seek)
         --WHEN Max(sp.last_user_lookup) IS NOT NULL THEN
           --Max(sp.last_user_lookup)
         ELSE
          db.create_date  
       END                           [LAST ACCESS],
       Getdate()                     AS [TODAY],
       Datediff(DAY, CASE
                       WHEN Max(sp.last_user_update) IS NOT NULL THEN
                         Max(sp.last_user_update)
                       --WHEN Max(sp.last_user_scan)IS NOT NULL THEN
                       --  Max(sp.last_user_scan)
                       --WHEN Max(sp.last_user_seek)IS NOT NULL THEN
                       --  Max(sp.last_user_seek)
                       --WHEN Max(sp.last_user_lookup) IS NOT NULL THEN
                       --  Max(sp.last_user_lookup)
                       ELSE
                        db.create_date  
                     END, Getdate()) AS [DAYS WITOUT USE],
       Max(CASE
             WHEN FL.TYPE = 0 THEN -- mdf
               fl.physical_name
             ELSE
               NULL
           END)                      AS [FILE]
FROM   sys.databases db (NOLOCK)
       LEFT OUTER JOIN sys.dm_db_index_usage_stats sp
                    ON db.database_id = sp.database_id
       LEFT OUTER JOIN sys.master_files fl (nolock)
                    ON fl.database_id = db.database_id
WHERE  DB.NAME NOT IN ( 'MASTER', 'TEMPDB', 'MODEL', 'MSDB',
                        'ReportServer', 'ReportServerTempDB' )
   AND DB.STATE = 0 -- solo DB en linea
GROUP  BY
  db.database_id,
  db.NAME,
  DB.owner_sid,
  db.compatibility_level,
  db.create_date,
  DB.recovery_model_desc
ORDER  BY   Datediff(DAY, CASE
                       WHEN Max(sp.last_user_update) IS NOT NULL THEN
                         Max(sp.last_user_update)
                       --WHEN Max(sp.last_user_scan)IS NOT NULL THEN
                       --  Max(sp.last_user_scan)
                       --WHEN Max(sp.last_user_seek)IS NOT NULL THEN
                       --  Max(sp.last_user_seek)
                       --WHEN Max(sp.last_user_lookup) IS NOT NULL THEN
                       --  Max(sp.last_user_lookup)
                       ELSE
                        db.create_date  
                     END, Getdate())DESC 
