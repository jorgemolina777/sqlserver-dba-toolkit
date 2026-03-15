CREATE FUNCTION [dbo].[Splitstring]
(
  @LIST  NVARCHAR(MAX),
  @DELIM VARCHAR(255)
)
RETURNS TABLE
AS
    RETURN
      (SELECT [Value]
       FROM   (SELECT [VALUE] = Ltrim(Rtrim(Substring(@LIST, [Number], Charindex(@DELIM, @LIST + @DELIM, [Number]) - [Number])))
               FROM   (SELECT NUMBER = Row_number()
                                         OVER (
                                           ORDER BY NAME)
                       FROM   sys.all_objects) AS x
               WHERE  Number                                         <= Len(@LIST)
                  AND Substring(@DELIM + @LIST, [Number], Len(@DELIM)) = @DELIM) AS y); 
