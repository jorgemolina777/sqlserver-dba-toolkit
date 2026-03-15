USE FNic_AMelgar_Mae_L_Cart

SELECT s.Suc_codigo,
       s.Suc_nombre,
       s.Suc_Montot,
       s.Reg_codigo
FROM   sucursal s (NOLOCK)
order by s.Reg_codigo
COMPUTE sum( s.Suc_Montot), AVG(s.Suc_Montot), min(s.Suc_Montot), max(s.Suc_Montot) by s.Reg_codigo
