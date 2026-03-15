BEGIN TRY
    BEGIN TRAN

    SET NOCOUNT ON

    --> querys a ejecutar
    
    
    --< Querys a ejecutar
    COMMIT TRAN
END TRY

BEGIN CATCH
    SELECT ERROR_NUMBER()    AS ERRORNUMBER,
           ERROR_SEVERITY()  AS ERRORSEVERITY,
           ERROR_STATE()     AS ERRORSTATE,
           ERROR_PROCEDURE() AS ERRORPROCEDURE,
           ERROR_LINE()      AS ERRORLINE,
           ERROR_MESSAGE()   AS ERRORMESSAGE;

    ROLLBACK TRAN
END CATCH 
