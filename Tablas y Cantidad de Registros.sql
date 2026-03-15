SELECT X.[NAME]                                                                                                    AS [TABLE],
       'select top 5 ''' + X.[NAME] + ''' as tablaname, * ' + Char(13) + ' from  ' + X.[NAME] + ' t (nolock)' + ';'AS [SELECT],
       'truncate table ' + X.[NAME] + ';'                                                                          AS [TRUNCATE],
       'Drop Table ' + X.[NAME] + ';'                                                                              AS [DROP],
       'DBCC CHECKTABLE (' + X.[NAME] + ');'                                                                       AS [CHECKTABLE],
       Len(X.[NAME])                                                                                               AS [LEN TABLE],
       X.[ROWS]                                                                                                    AS [ROWS]
FROM   (SELECT Cast(Object_name(ID) AS VARCHAR( 50 )) AS [NAME],
               Sum(CASE
                     WHEN INDID < 2 THEN
                       CONVERT(BIGINT, [ROWS])
                   END)                               AS [ROWS]
        FROM   SYSINDEXES WITH (NOLOCK)
        WHERE  SYSINDEXES.INDID IN ( 0, 1, 255 )
           AND SYSINDEXES.ID              > 100
           AND Object_name(SYSINDEXES.ID) <> 'dtproperties'
        GROUP  BY
         SYSINDEXES.ID WITH ROLLUP) AS X
WHERE  X.[NAME] IS NOT NULL
   AND X.ROWS        >= 0
   AND Len(X.[NAME]) > 8
ORDER  BY X.[ROWS] DESC 
