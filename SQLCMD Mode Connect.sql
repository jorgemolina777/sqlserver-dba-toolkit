SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
/*
Este código sirver para poder hacer cambiarse de servidor desde el query 
la instrucción 

- :connect GTSSCSVRTDB03\SQL2005 -U siem -P siem
donde se conecta por autentifiación de sql

y 

- :connect GTSSCSVRTDB03\SQL2005
se conecta por autentificacion windows

Para poder hacer funcionar esto se debe activar el sqlcmd mode
Menu --> Query -->  SQLCmd Mode

*/
go

:connect GTSSCSVRTDB03\SQL2005 -U siem -P siem

SELECT @@SERVERNAME
select p.para_insti from fnic_maxima_mae_cart..parametr p(NOLOCK)
go

:connect GTSSCSVRTDB02\SQL2005 -U siem -P siem

SELECT @@SERVERNAME 
select p.para_insti from FGuate_Cartera_22Dic15..parametr p(NOLOCK)
go

:connect GTSSCSVRTDB03\SQL2005 -U siem -P siem

SELECT @@SERVERNAME
select p.para_insti from fnic_maxima_mae_cart..parametr p(NOLOCK)