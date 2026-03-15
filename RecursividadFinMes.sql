IF NOT Object_id('DBO.todosMeses')IS NULL
  DROP TABLE dbo.todosMeses;

WITH Calcular(InicioMes, FinMes)
     AS (SELECT Dateadd(month, Datediff(month, 0, Dateadd(year, -2, Getdate())), 0)              AS INICIOMES,
                Dateadd(s, -1, Dateadd(mm, Datediff(m, 0, Dateadd(year, -2, Getdate())) + 1, 0)) AS FINMES
         UNION ALL
         SELECT Dateadd(month, Datediff(month, 0, Dateadd(month, 1, INICIOMES)), 0)              AS INICIOMES,
                Dateadd(s, -1, Dateadd(mm, Datediff(m, 0, Dateadd(month, 1, INICIOMES)) + 1, 0)) AS FINMES
         FROM   Calcular
         WHERE  InicioMes < Dateadd(year, +2, Getdate()))
SELECT *
INTO
  dbo.todosMeses
FROM   Calcular
OPTION(maxrecursion 0);

SELECT t.InicioMes                                                                                                                                AS INICIOMES,
       Replace(Str(CONVERT(VARCHAR(2), Datepart(MONTH, t.InicioMes)), 2), Space(1), '0') + '-' + CONVERT(VARCHAR(4), Datepart(year, t.InicioMes)) AS INICIO_MES_LABEL,
       t.FinMes                                                                                                                                   AS FINMES,
       Replace(Str(CONVERT(VARCHAR(2), Datepart(MONTH, t.FinMes)), 2), Space(1), '0') + '-' + CONVERT(VARCHAR(4), Datepart(year, t.FinMes))       AS FIN_MES_LABEL
FROM   dbo.todosMeses t (NOLOCK) 
