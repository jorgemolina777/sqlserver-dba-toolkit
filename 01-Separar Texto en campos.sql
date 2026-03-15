DECLARE @STRCADENA  VARCHAR(255),
        @STRVALOR   VARCHAR(6),
        @INTBANDERA BIT,
        @INTTAMANO  SMALLINT,
        @CHAR       CHAR(1)

SELECT @STRCADENA = '111,215,19,8,202,99,2341,12,236',
       @CHAR = ',',
       @INTBANDERA = 0

WHILE @INTBANDERA = 0
  BEGIN
      BEGIN TRY
          SET @STRVALOR = RIGHT(LEFT(@STRCADENA, Charindex(@CHAR, @STRCADENA, 1) - 1), Charindex(@CHAR, @STRCADENA, 1) - 1)

          PRINT @STRVALOR /* En esta variable se guarda un número */
          SET @INTTAMANO = Len(@STRVALOR)
          SET @STRCADENA = Substring(@STRCADENA, @INTTAMANO + 2, Len(@STRCADENA))
      END TRY

      BEGIN CATCH
          PRINT @STRCADENA

          SET @INTBANDERA = 1
      END CATCH
  END 
