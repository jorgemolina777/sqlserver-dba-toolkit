USE RSETIQUE

/*
DECLARE @OBJ_COD     VARCHAR(20),
        @CORRELATIVO INT,
        @IDIOM_COD   INT,
        @ETIQUETA    VARCHAR(100)

SELECT @OBJ_COD = 'GENERAL',
       @CORRELATIVO = 1,
       @IDIOM_COD = 1

EXEC Siem_sp_return_label @OBJ_COD,
                          @CORRELATIVO,
                          @IDIOM_COD,
                          @ETIQUETA OUTPUT

SELECT @ETIQUETA  as resultado


*/
IF EXISTS
   (SELECT ID
    FROM   SYSOBJECTS (NOLOCK)
    WHERE  ID = Object_id(N'[SIEM_SP_RETURN_LABEL]')
           AND Objectproperty(ID, N'ISPROCEDURE') = 1)
  BEGIN
      DROP PROCEDURE [SIEM_SP_RETURN_LABEL]
  END

GO

CREATE PROCEDURE Siem_sp_return_label
(
  @OBJ_COD     VARCHAR(20) = NULL,
  @CORRELATIVO INT = 0,
  @IDIOM_COD   INT = 1,
  @ETIQUETA    VARCHAR(100) = NULL OUTPUT
)
AS
  /*  
  DATOS GENERALES_____________________________________________________________________
  NOMBRE  ______ : SIEM_SP_RETURN_LABEL  
  PROYECTO _____ : 
  CREADO _______ : 
  ULT. MODI_____ :  
  AUTOR ________ :    
  DESCRIPCIÓN___ :  
  _____________________________________________________________________________________
  PARAMETROS REQUERIDOS________________________________________________________________
  _____________________________________________________________________________________
    ___________________________________________________________________________________
  */
  BEGIN
      SET NOCOUNT ON

      --DECLARE @ETIQUETA VARCHAR(100)
      SELECT @ETIQUETA = Rtrim(Ltrim( Isnull(ING.ETIQUETA, 'VACIO')))
      FROM   INGRESO1 ING(NOLOCK)
      WHERE  ING.SISTEMA = 1
             AND ING.MODULO = 1
             AND ING.OBJCOD = @OBJ_COD
             AND ING.CORRELATIV = @CORRELATIVO
             AND ING.IDIOMCOD = @IDIOM_COD
  END
--RETURN @ETIQUETA
