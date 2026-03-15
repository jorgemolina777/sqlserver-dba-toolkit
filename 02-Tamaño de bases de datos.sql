USE master

SELECT Db_name(db.database_id)                                                                                   DatabaseName
       ,( Cast(mfrows.RowSize AS FLOAT) * 8 ) / 1024                                                             RowSizeMB
       ,( Cast(mflog.LogSize AS FLOAT) * 8 ) / 1024                                                              LogSizeMB
       ,( Cast(mfrows.RowSize AS FLOAT) * 8 ) / 1024 + ( Cast(mflog.LogSize AS FLOAT) * 8 ) / 1024               DBSizeMB
       ,( Cast(mfrows.RowSize AS FLOAT) * 8 ) / 1024 / 1024 + ( Cast(mflog.LogSize AS FLOAT) * 8 ) / 1024 / 1024 DBSizeGB
  --,(CAST(mfstream.StreamSize AS FLOAT)*8)/1024 StreamSizeMB,     
  --(CAST(mftext.TextIndexSize AS FLOAT)*8)/1024 TextIndexSizeMB 
  , pfile.physical_name
  , db.name
  FROM sys.databases db
       LEFT JOIN (SELECT database_id
                         ,Sum(size) RowSize
                    FROM sys.master_files
                   WHERE type = 0
                   GROUP BY database_id
                            ,type) mfrows
              ON mfrows.database_id = db.database_id
       LEFT JOIN (SELECT database_id
                         ,Sum(size) LogSize
                    FROM sys.master_files
                   WHERE type = 1
                   GROUP BY database_id
                            ,type) mflog
              ON mflog.database_id = db.database_id
       LEFT JOIN (SELECT database_id
                         ,Sum(size) StreamSize
                    FROM sys.master_files
                   WHERE type = 2
                   GROUP BY database_id
                            ,type) mfstream
              ON mfstream.database_id = db.database_id
       LEFT JOIN (SELECT database_id
                         ,Sum(size) TextIndexSize
                    FROM sys.master_files
                   WHERE type = 4
                   GROUP BY database_id
                            ,type) mftext
              ON mftext.database_id = db.database_id
       LEFT JOIN (SELECT database_id
                         ,physical_name
                    FROM sys.master_files
                    where file_id=2) pfile
              ON pfile.database_id = db.database_id
 --ORDER BY 4 DESC
 ORDER BY 3 DESC

--SELECT database_id
--                         ,physical_name
--                         ,*
--                    FROM sys.master_files


EXEC master..xp_fixeddrives