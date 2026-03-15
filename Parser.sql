

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

DECLARE @STRING  VARCHAR(MAX),
        @SEARCH  VARCHAR(MAX),
        @RETORNA VARCHAR(MAX)

SELECT @STRING = '(8001,8002,9006)(9005,9006)(3001,3002,3003)',
       @SEARCH = '8002',
       @RETORNA = ''

SET @STRING = '(' + @STRING + ')'

DECLARE @ENDPOSITION   INT,-- variables a utilizar en el parser
        @STARTPOSITION INT,
        @LEN           INT,
        @TMP           VARCHAR(MAX)

SET @STARTPOSITION = Patindex('%' + @SEARCH + '%', @STRING) -- Se busca la cadena, y su posicion inicial
IF @STARTPOSITION > 0 -- Si la encontro
  BEGIN
      SET @ENDPOSITION = Isnull(Charindex(')', @STRING, @STARTPOSITION), 0) -- Se buscar el caracter final apartir de su posicion inicial
      SET @TMP=Substring(@STRING, 1, @ENDPOSITION - 1) -- Se recorta la cadena de inicio hasta la posicion final
      SET @LEN=Len(@TMP) -- Cantidad de caracteres en cadena recortada
      SET @STARTPOSITION = @LEN - Charindex('(', Reverse(@TMP)) + 2 -- Se busca posicion inicial, buscando el caracter de inicio revirtiendo la cadena
      SET @LEN = @ENDPOSITION - @STARTPOSITION

      IF @LEN <= 0 -- Si existen cantidad de caracteres a recortar
        SET @LEN = ( Len(@STRING) + 1 ) - @STARTPOSITION

      SET @RETORNA = Substring(@TMP, @STARTPOSITION, @LEN) -- se toma el resultado cortando desde el inicio hasta la cantidad de caracteres
  END

SELECT @RETORNA AS RETORNA


