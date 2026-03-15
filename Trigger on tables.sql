--USE FNic_Raul_Cartera_20160731

SELECT Object_name(tr.parent_id)              AS [TABLA NOMBRE],
       tr.NAME                                AS [TRIGGER NAME],
       CASE
         WHEN tr.is_disabled = 1 THEN
           'Deshabilitado'
         ELSE
           'Habilitado'
       END                                    AS [ESTADO],
       tr.create_date                         AS [FECHA CREACIÓN],
       tr.modify_date                         AS [FECHA MODIFICACIÓN],
       'DROP TRIGGER [dbo].[' + tr.NAME + '];' AS [DROP],
       CASE
         WHEN tr.is_disabled = 1 THEN
           'ENABLE TRIGGER [dbo].[' + tr.NAME + '] ON [dbo].' + Quotename(Object_name(tr.parent_id))+ ';'
         ELSE
           'DISABLE TRIGGER [dbo].[' + tr.NAME + '] ON [dbo].' + Quotename(Object_name(tr.parent_id))+ ';'
       END                                    AS [HABILITAR]
FROM   sys.triggers tr (nolock)
ORDER  BY tr.is_disabled ASC,
          Object_name(tr.parent_id),
          tr.NAME 
