
/*
	FSLA, 2012-12-07
	Version 1.0
	Script que configura lo necesario para poder crear archivos de text desde el módulo de FNic_CC_SIBOIF, por medio de SQL.
	FINCA Nicaragua
	----------------------------------------------------------------------------------------------------------------
	Uso:	En cada linea donde se encuentra la palabra FNic_CC_SIBOIF, se debe cambiar por el nombre de la BD bajo la cual
			se encuentra la Base de Datos del módulo de FNic_CC_SIBOIF
			
*/
/*
	Activa la opción de XP_CMDShell para generar archivos planos
*/
Use		FNic_CC_SIBOIF
GO
DROP SCHEMA [Txt_CmdUser]
GO
USE [FNic_CC_SIBOIF]
GO
DROP USER [Txt_CmdUser]
go
EXEC [FNic_CC_SIBOIF].dbo.sp_changedbowner @loginame = N'SA', @map = false;
EXEC dbo.sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC dbo.sp_configure 'xp_cmdshell', 1;
RECONFIGURE ;
----------------------------------------------------------------------------------

--1. Activar el trustwhorty en la base de datos de FNic_CC_SIBOIF
Alter database FNic_CC_SIBOIF Set TRUSTWORTHY On;
GO
--2. Crear el usuario Txt_CmdUser en el servidor de SQL Server.
--Server > Security > Logins > New Login > Txt_CmdUser
Create Login [Txt_CmdUser] 
With PassWord = 'Txt_CmdUser', Default_Database = FNic_CC_SIBOIF, Check_Expiration = Off, Check_Policy = Off
Go
-- Recordar que a este usuario se le debe de configurar Password never expires así como asignarle permisos de SysAdmin.

--3. Autorizarle permisos de owner al usuario Txt_CmdUser en la base de datos de FNic_CC_SIBOIF.

EXEC dbo.sp_grantdbaccess @loginame = 'Txt_CmdUser', @name_in_db = 'Txt_CmdUser' 
EXEC sp_addrolemember N'db_owner', 'Txt_CmdUser' 
GO

--4. Si el owner de FNic_CC_SIBOIF es diferente a SA, cambiar dichos permisos para que su propietario sea SA.
        --Database Properties > Files > Owner > SA

--Habilita opcion de xp_cmdshell (para generar archivos de texto desde sql
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

EXEC sp_configure 'xp_cmdshell', 1;
GO
RECONFIGURE;
GO