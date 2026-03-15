ALTER FUNCTION [dbo].[Ufn_siem_asueto]
(
  @Suc           SMALLINT,
  @TrabajaSabado CHAR(1),
  @FechaC        DATETIME
)
RETURNS DATETIME
AS
  BEGIN
      --SET DATEFIRST 1; -- lunes primer dia
      DECLARE @FechaReturn DATETIME,
              @Para_polF   SMALLINT,
              @HayAsueto   BIT = 0

      SELECT @Para_polF = p.Para_PolFe
      FROM   Parametr P (nolock)

      SET @FechaReturn = @FechaC

      --IF Isnull((SELECT TOP 1 1
      --           FROM   ASUETO Asu (nolock)
      --           WHERE  isnull(asu.Fer_Fijo,'N') = 'S'
      --                  AND asu.Fer_fecha = @FechaC
      --                  AND ( Asu.Suc_codigo = @Suc
      --                         OR Asu.Suc_codigo = 0 )--
      --          ), 0) = 1
      --  SELECT @FechaReturn = Dateadd(DAY, @Para_polF, @FechaReturn),
      --         @HayAsueto = 1
      --IF Isnull((SELECT TOP 1 1
      --           FROM   ASUETO Asu (nolock)
      --           WHERE  isnull(asu.Fer_Fijo,'N') != 'S'
      --                  AND Datepart(DAY, asu.Fer_fecha) = Datepart(day, @FechaReturn)
      --                  AND Datepart(MONTH, asu.Fer_fecha) = Datepart(MONTH, @FechaReturn)
      --                  AND ( Asu.Suc_codigo = @Suc
      --                         OR Asu.Suc_codigo = 0 )--
      --          ), 0) = 1
      --  SELECT @FechaReturn = Dateadd(DAY, @Para_polF, @FechaC),
      --         @HayAsueto = 1
      IF Isnull((SELECT TOP 1 1
                 FROM   ASUETO asu (nolock)
                 WHERE  ( asu.Suc_codigo = @suc
                           OR asu.Suc_codigo = 0 )
                        AND ( ( Isnull(asu.Fer_Fijo, 'N') = 'N'
                                AND asu.Fer_fecha = @FechaReturn )
                               OR ( Isnull(asu.Fer_Fijo, 'N') = 'S'
                                    AND Datepart(day, asu.Fer_fecha) = Datepart(day, @FechaReturn)
                                    AND Datepart(MONTH, asu.Fer_fecha) = Datepart(MONTH, @FechaReturn) ) )), 0) = 1
        BEGIN
            SELECT @FechaReturn = Dateadd(DAY, @Para_polF, @FechaReturn),
                   @HayAsueto = 1
        END

      IF @HayAsueto = 1
        SET @FechaReturn = [dbo].[Ufn_siem_asueto](@Suc, @TrabajaSabado, @FechaReturn)

      IF Datename(dw, @FechaReturn) = 'Saturday'
         AND @TrabajaSabado = 'N'-- si es sabado
        SELECT @FechaReturn = Dateadd(DAY, @Para_polF, @FechaReturn)

      IF Datename(dw, @FechaReturn) = 'Sunday'
        SELECT @FechaReturn = Dateadd(DAY, @Para_polF, @FechaReturn)

      RETURN @FechaReturn
  END

GO 
