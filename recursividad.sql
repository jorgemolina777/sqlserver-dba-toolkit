use SiemLog


DECLARE @nto   INT
SET @nto = 5

with exponentes( n1,n2, res)AS (
	SELECT 1 AS N1,
		   1 AS N2,
		   1 AS RES
	UNION ALL
	SELECT n1 + 1                  AS N1,
		   n2 + 1                  AS N2,
		   ( n1 + 1 ) * ( n2 + 1 ) AS RES
	FROM   exponentes
	WHERE  n1 <= @nto - 1 
)
SELECT *
FROM   exponentes 
OPTION (maxrecursion 0) 
