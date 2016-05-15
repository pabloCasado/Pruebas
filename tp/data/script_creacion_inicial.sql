USE GD1C2016;
GO

IF OBJECT_ID('HARDCOR.Oferta','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Oferta;
    END;

IF OBJECT_ID('HARDCOR.Compra','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Compra;
    END;

IF OBJECT_ID('HARDCOR.Calificacion','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Calificacion;
    END;

IF OBJECT_ID('HARDCOR.Detalle','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Detalle;
    END;

IF OBJECT_ID('HARDCOR.Factura','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Factura;
    END;

IF OBJECT_ID('HARDCOR.Publicacion','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Publicacion;
    END;

IF OBJECT_ID('HARDCOR.Visibilidad','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Visibilidad;
    END;

IF OBJECT_ID('HARDCOR.RubroXempresa','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.RubroXempresa;
    END;

IF OBJECT_ID('HARDCOR.Empresa','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Empresa;
    END;

IF OBJECT_ID('HARDCOR.Rubro','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Rubro;
    END;

IF OBJECT_ID('HARDCOR.Cliente','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Cliente;
    END;

IF OBJECT_ID('HARDCOR.Contacto','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Contacto;
    END;

IF OBJECT_ID('HARDCOR.RolXus','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.RolXus;
    END;


IF OBJECT_ID('HARDCOR.Usuario','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Usuario;
    END;

IF OBJECT_ID('HARDCOR.RolXfunc','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.RolXfunc;
    END;

IF OBJECT_ID('HARDCOR.Funcionalidad','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Funcionalidad;
    END;

IF OBJECT_ID('HARDCOR.Rol','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Rol;
    END;

IF OBJECT_ID('HARDCOR.Inconsistencias','U') IS NOT NULL
    BEGIN
        DROP TABLE HARDCOR.Inconsistencias;
    END;

IF (OBJECT_ID ('HARDCOR.alta_rol') IS NOT NULL)  
	DROP PROCEDURE HARDCOR.alta_rol
GO
IF (OBJECT_ID ('HARDCOR.tr_calificacion_af_ins') IS NOT NULL)  
	DROP TRIGGER HARDCOR.tr_calificacion_af_ins
GO

IF (OBJECT_ID ('HARDCOR.tr_visibilidad_af_ins') IS NOT NULL)  
	DROP TRIGGER HARDCOR.tr_visibilidad_af_ins
GO

IF (OBJECT_ID ('HARDCOR.mod_rol') IS NOT NULL)  
	DROP PROCEDURE HARDCOR.mod_rol
GO

IF (OBJECT_ID ('HARDCOR.baja_rol') IS NOT NULL)  
	DROP PROCEDURE HARDCOR.baja_rol
GO

IF (OBJECT_ID ('HARDCOR.loggin') IS NOT NULL)  
	DROP PROCEDURE HARDCOR.loggin
GO

 if exists (select SCHEMA_NAME from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME = 'HARDCOR')
 drop schema HARDCOR 
 GO

CREATE SCHEMA HARDCOR AUTHORIZATION gd; 
GO

CREATE TABLE HARDCOR.Rol( 
	cod_rol TINYINT IDENTITY PRIMARY KEY,
    nombre NVARCHAR(225),
    habilitado BIT);
GO

CREATE TABLE HARDCOR.Funcionalidad( 
    cod_fun TINYINT IDENTITY PRIMARY KEY,
    descripcion NVARCHAR(225));
GO

CREATE TABLE HARDCOR.RolXfunc( 
    cod_rol TINYINT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Rol(cod_rol),
    cod_fun TINYINT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Funcionalidad(cod_fun),
	PRIMARY KEY (cod_rol, cod_fun));
GO

CREATE TABLE HARDCOR.Usuario( 
    cod_us INT IDENTITY PRIMARY KEY,
    username NVARCHAR(225) UNIQUE,
    pass_word VARBINARY(225),
    habilitado BIT,
    intentos TINYINT);
GO

CREATE TABLE HARDCOR.RolXus( 
    cod_rol TINYINT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Rol(cod_rol),
    cod_us INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Usuario(cod_us),
	PRIMARY KEY (cod_rol, cod_us));
GO

CREATE TABLE HARDCOR.Contacto( 
    cod_contacto INT IDENTITY PRIMARY KEY,
    mail NVARCHAR(50) UNIQUE,
    cod_postal NVARCHAR(50),
    dom_calle NVARCHAR(100),
    nro_piso NUMERIC(18,0),
    nro_dpto NVARCHAR(50),
    nro_calle NUMERIC(18,0),
	localidad NVARCHAR(225),
	nro_tel CHAR(8));
GO

CREATE TABLE HARDCOR.Cliente( 
    cod_us INT PRIMARY KEY REFERENCES HARDCOR.Usuario(cod_us),
    cod_contacto INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Contacto(cod_contacto),
    cli_nombre NVARCHAR(225),
    cli_apellido NVARCHAR(225),
    cli_dni NUMERIC(18,0) UNIQUE,
    cli_fecha_nac DATETIME,
    cli_fecha_alta DATETIME,
    cli_calificacion NUMERIC(18,2),
    cli_ventas INT,
    cli_tipo_doc nvarchar(225));
GO

CREATE TABLE HARDCOR.Rubro( 
    cod_rubro INT IDENTITY PRIMARY KEY,
    rubro_desc_corta NVARCHAR(225),
	rubro_desc_larga NVARCHAR(225));
GO

CREATE TABLE HARDCOR.Empresa( 
    cod_us INT PRIMARY KEY REFERENCES HARDCOR.Usuario(cod_us),
    cod_contacto INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Contacto(cod_contacto),
    rubro_ppal nvarchar(225),
    emp_razon_soc NVARCHAR(225) UNIQUE,
    emp_fecha_creacion DATETIME,
    emp_cuit NVARCHAR(50) UNIQUE,
    emp_ciudad NVARCHAR(225),
    emp_calificacion NUMERIC(18,2),
    emp_ventas INT,
    emp_nom_contacto nvarchar(225));
GO

CREATE TABLE HARDCOR.RubroXempresa( 
    cod_rubro INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Rubro(cod_rubro),
    cod_emp INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Empresa(cod_us));
GO

CREATE TABLE HARDCOR.Visibilidad( 
    cod_visi NUMERIC(18,0) PRIMARY KEY,
    visi_desc NVARCHAR(225),
    comision_pub NUMERIC(18,2),
    comision_vta NUMERIC(18,2),
    comision_envio NUMERIC(18,2));
GO

CREATE TABLE HARDCOR.Publicacion( 
    cod_pub NUMERIC(18,0) PRIMARY KEY,
    cod_us INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Usuario(cod_us),
    cod_rubro INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Rubro(cod_rubro),
    cod_visi NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Visibilidad(cod_visi),
    descripcion NVARCHAR(225),
    stock NUMERIC(18,0),
    fecha_ini DATETIME,
    fecha_fin DATETIME,
    precio NUMERIC(18,2),
    costo NUMERIC(18,2),
    estado NVARCHAR(225),
    preg_habilitadas BIT,
    tipo NVARCHAR(225));
GO

CREATE TABLE HARDCOR.Factura( 
    nro_fact NUMERIC PRIMARY KEY,
    cod_pub NUMERIC(18) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Publicacion(cod_pub),
    cod_us INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Usuario(cod_us),
    fecha DATETIME,
    total NUMERIC(18,2),
    forma_pago NVARCHAR(225));
GO

CREATE TABLE HARDCOR.Detalle( 
    cod_det INT IDENTITY PRIMARY KEY,
    nro_fact NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Factura(nro_fact),
    item_desc NVARCHAR(225),
    cantidad NUMERIC(18,0),
    importe NUMERIC(18,2));
GO

/*segun el enunciado, las estrellas van del 1 al 5, pero en la tabla llegan hasta 10*/
CREATE TABLE HARDCOR.Calificacion( 
    cod_calif NUMERIC(18,0) PRIMARY KEY,
    calif_desc NVARCHAR(225),
    calif_estrellas NUMERIC(18,0) CHECK (calif_estrellas > 0 AND calif_estrellas < 11));
GO

CREATE TABLE HARDCOR.Compra( 
    cod_compra INT IDENTITY PRIMARY KEY,
    cod_pub NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Publicacion(cod_pub),
    cod_us INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Usuario(cod_us),
    cod_calif NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Calificacion(cod_calif),
    fecha_compra DATETIME,
    cantidad NUMERIC(18,0),
    monto_compra NUMERIC(18,2));
GO

CREATE TABLE HARDCOR.Oferta( 
    cod_of INT IDENTITY PRIMARY KEY,
    cod_pub NUMERIC(18,0) NOT NULL FOREIGN KEY REFERENCES HARDCOR.Publicacion(cod_pub),
    cod_us INT NOT NULL FOREIGN KEY REFERENCES HARDCOR.Usuario(cod_us),
    monto_of NUMERIC(18,2),
    fecha_of DATETIME);
GO

CREATE INDEX HARDCOR ON HARDCOR.Contacto (mail);
GO

CREATE INDEX I_Cliente ON HARDCOR.Cliente (cli_nombre, cli_apellido);
GO

CREATE UNIQUE INDEX I_Empresa ON HARDCOR.Empresa (emp_razon_soc, emp_cuit);
GO

CREATE INDEX I_Publicacion ON HARDCOR.Publicacion (cod_rubro, descripcion);
GO

SELECT * INTO HARDCOR.Inconsistencias FROM gd_esquema.Maestra WHERE 1 = 2
GO

INSERT INTO HARDCOR.Rol (nombre, habilitado) 
VALUES ('Administrador general', 1);
GO

INSERT INTO HARDCOR.Rol (nombre, habilitado) 
VALUES ('Administrador', 1);
GO

INSERT INTO HARDCOR.Rol (nombre, habilitado) 
VALUES ('Empresa', 1);
GO

INSERT INTO HARDCOR.Rol (nombre, habilitado) 
VALUES ('Cliente', 1);
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('ABM Rol');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('ABM Usuarios');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('ABM Rubro');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('ABM Visibilidad publicacion');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Generar publicacion');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Comprar/Ofertar');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Historial cliente');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Calificar vendedor');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Consulta factuaras realizadas al vendedor');
GO

INSERT INTO HARDCOR.Funcionalidad(descripcion) 
VALUES ('Listado estadistico');
GO

INSERT INTO HARDCOR.RolXfunc(cod_rol, cod_fun) 
SELECT 1, f.cod_fun FROM HARDCOR.Funcionalidad f
GO

INSERT INTO HARDCOR.RolXfunc(cod_rol, cod_fun) 
SELECT 2, f.cod_fun FROM HARDCOR.Funcionalidad f WHERE f.cod_fun < 5 OR f.cod_fun = 9 OR f.cod_fun = 10
GO

INSERT INTO HARDCOR.RolXfunc(cod_rol, cod_fun) 
SELECT 3, f.cod_fun FROM HARDCOR.Funcionalidad f WHERE f.cod_fun = 5
GO

INSERT INTO HARDCOR.RolXfunc(cod_rol, cod_fun) 
SELECT 4, f.cod_fun FROM HARDCOR.Funcionalidad f WHERE f.cod_fun > 4 AND f.cod_fun < 9
GO

INSERT INTO HARDCOR.Contacto(mail, cod_postal, dom_calle, nro_piso, nro_dpto, nro_calle) 
SELECT DISTINCT m.Cli_Mail, m.Cli_Cod_Postal, m.Cli_Dom_Calle, m.Cli_Piso, m.Cli_Depto, m.Cli_Nro_Calle 
FROM gd_esquema.Maestra m WHERE m.Cli_Mail IS NOT NULL
GO

INSERT INTO HARDCOR.Contacto(mail, cod_postal, dom_calle, nro_piso, nro_dpto, nro_calle) 
SELECT DISTINCT m.Publ_Empresa_Mail, m.Publ_Empresa_Cod_Postal, m.Publ_Empresa_Dom_Calle, m.Publ_Empresa_Piso, 
m.Publ_Empresa_Depto, m.Publ_Empresa_Nro_Calle FROM gd_esquema.Maestra m WHERE m.Publ_Empresa_Mail IS NOT NULL
GO


DECLARE @hash VARBINARY(225)
SELECT @hash = HASHBYTES('SHA2_256', 'w23e');

INSERT INTO HARDCOR.Usuario(username, pass_word, habilitado, intentos) 
SELECT DISTINCT m.Cli_Dni, @hash, 1, 0 FROM gd_esquema.Maestra m WHERE m.Cli_Dni IS NOT NULL 
ORDER BY m.Cli_Dni

INSERT INTO HARDCOR.Usuario(username, pass_word, habilitado, intentos) 
SELECT DISTINCT m.Publ_Empresa_Cuit, @hash, 1, 0 
FROM gd_esquema.Maestra m WHERE m.Publ_Empresa_Razon_Social IS NOT NULL ORDER BY m.Publ_Empresa_Cuit
GO

INSERT INTO HARDCOR.RolXus(cod_rol, cod_us) 
SELECT 3, u.cod_us FROM HARDCOR.Usuario u WHERE u.cod_us IN (select e.cod_us from HARDCOR.Empresa e)  
GO

INSERT INTO HARDCOR.RolXus(cod_rol, cod_us) 
SELECT 4, u.cod_us FROM HARDCOR.Usuario u WHERE u.cod_us IN (select c.cod_us from HARDCOR.Cliente c)  
GO

--Sacar getdate
INSERT INTO HARDCOR.Cliente(cod_us, cod_contacto, cli_nombre, cli_apellido, cli_dni, cli_fecha_nac, cli_fecha_alta) 
SELECT DISTINCT u.cod_us, c.cod_contacto, m.Cli_Nombre, m.Cli_Apeliido, m.Cli_Dni, m.cli_fecha_nac, GETDATE()
FROM gd_esquema.Maestra m, HARDCOR.Usuario u, HARDCOR.Contacto c 
WHERE u.username = (SELECT CAST(m.Cli_Dni AS NVARCHAR(225))) AND c.mail = m.Cli_Mail 
GO

INSERT INTO HARDCOR.Rubro(rubro_desc_corta, rubro_desc_larga) 
SELECT DISTINCT m.Publicacion_Rubro_Descripcion, m.Publicacion_Rubro_Descripcion FROM gd_esquema.Maestra m
GO

INSERT INTO HARDCOR.Empresa(cod_us, cod_contacto, emp_razon_soc, emp_fecha_creacion, emp_cuit) 
SELECT DISTINCT u.cod_us, c.cod_contacto, m.Publ_Empresa_Razon_Social, m.Publ_Empresa_Fecha_Creacion, 
				m.Publ_Empresa_Cuit FROM gd_esquema.Maestra m, HARDCOR.Usuario u, HARDCOR.Contacto c
WHERE m.Publ_Empresa_Razon_Social = u.username AND c.mail = m.Publ_Empresa_Mail
GO

INSERT INTO HARDCOR.Calificacion(cod_calif, calif_estrellas, calif_desc) 
SELECT DISTINCT m.Calificacion_Codigo, m.Calificacion_Cant_Estrellas, m.Calificacion_Descripcion 
FROM gd_esquema.Maestra m WHERE m.Calificacion_Codigo IS NOT NULL
GO

INSERT INTO HARDCOR.Visibilidad(cod_visi, visi_desc, comision_pub, comision_vta, comision_envio) 
SELECT DISTINCT m.Publicacion_Visibilidad_Cod, m.Publicacion_Visibilidad_Desc, 
				m.Publicacion_Visibilidad_Precio, m.Publicacion_Visibilidad_Porcentaje, 0.05 
FROM gd_esquema.Maestra m
GO

INSERT INTO HARDCOR.Publicacion (cod_pub, cod_us, cod_rubro, cod_visi, descripcion, stock, fecha_ini, 
						fecha_fin, precio, estado, preg_habilitadas, tipo)
SELECT DISTINCT m.Publicacion_Cod, u.cod_us, r.cod_rubro, v.cod_visi, m.Publicacion_Descripcion, 
				m.Publicacion_Stock, m.Publicacion_Fecha, m.Publicacion_Fecha_Venc, m.Publicacion_Precio, 
				m.Publicacion_Estado, 1, m.Publicacion_Tipo  
FROM gd_esquema.Maestra m, HARDCOR.Usuario u, HARDCOR.Rubro r, HARDCOR.Visibilidad v
WHERE (u.username = (SELECT CAST(m.Publ_Cli_Dni AS NVARCHAR(225))) OR u.username = m.Publ_Empresa_Cuit) 
	  AND r.rubro_desc_corta = m.Publicacion_Rubro_Descripcion AND v.cod_visi = m.Publicacion_Visibilidad_Cod
GO

INSERT INTO HARDCOR.Factura(nro_fact, cod_pub, cod_us, fecha, total, forma_pago)
SELECT DISTINCT m.Factura_Nro, p.cod_pub, p.cod_us, m.Factura_Fecha, m.Factura_Total, m.Forma_Pago_Desc  
FROM gd_esquema.Maestra m, HARDCOR.Publicacion p WHERE p.cod_pub = m.Publicacion_Cod AND m.Factura_Nro IS NOT NULL
GO 

INSERT INTO HARDCOR.Detalle(nro_fact, item_desc, cantidad, importe)
SELECT DISTINCT f.nro_fact, (SELECT CAST(v.cod_visi AS NVARCHAR(225))), 1, m.Item_Factura_Monto  
FROM gd_esquema.Maestra m, HARDCOR.Factura f, HARDCOR.Visibilidad v 
WHERE m.Factura_Nro = f.nro_fact AND m.Item_Factura_Monto = v.comision_pub
UNION ALL
SELECT DISTINCT f.nro_fact, 'Venta producto', m.Item_Factura_Cantidad, m.Item_Factura_Monto  
FROM gd_esquema.Maestra m, HARDCOR.Factura f WHERE m.Factura_Nro = f.nro_fact ORDER BY nro_fact
GO

INSERT INTO HARDCOR.Compra(cod_pub, cod_us, cod_calif, fecha_compra, cantidad, monto_compra)
SELECT DISTINCT f.cod_pub, f.cod_us, c.cod_calif, m.Compra_Fecha, m.Compra_Cantidad, f.total  
FROM gd_esquema.Maestra m, HARDCOR.Calificacion c, HARDCOR.Factura f 
WHERE f.cod_pub = m.Publicacion_Cod AND c.cod_calif = m.Calificacion_Codigo ORDER BY f.cod_pub
GO 

INSERT INTO HARDCOR.Oferta(cod_pub, cod_us, monto_of, fecha_of)
SELECT DISTINCT p.cod_pub, p.cod_us, m.Oferta_Monto, m.Oferta_Fecha 
FROM gd_esquema.Maestra m, HARDCOR.Publicacion p 
WHERE p.cod_pub = m.Publicacion_Cod AND m.Oferta_Monto IS NOT NULL ORDER BY p.cod_pub
GO 

/*ACLARAR ESTO EN LA ESTRATEGIA*/
CREATE TRIGGER HARDCOR.tr_calificacion_af_ins
ON HARDCOR.Calificacion
AFTER INSERT
AS BEGIN
	UPDATE HARDCOR.Calificacion SET calif_desc = 'Sin descripcion' WHERE calif_desc = ''
END
GO

CREATE TRIGGER HARDCOR.tr_visibilidad_af_ins
ON HARDCOR.Visibilidad
AFTER INSERT
AS BEGIN
	UPDATE HARDCOR.Visibilidad SET comision_envio = 0 WHERE visi_desc = 'Gratis'
END
GO


CREATE PROCEDURE HARDCOR.alta_rol (@rol NVARCHAR(225), @ABM_Rol BIT, @ABM_Usuario BIT, @ABM_Rubro BIT, 
						  @ABM_Visibilidad BIT, @Generar_publ BIT, @Compra_oferta BIT, @Historial BIT, 
						  @Calificar BIT, @Consulta_factura BIT, @Listados BIT)
AS BEGIN

	DECLARE @cod_rol INT

	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO HARDCOR.Rol
			VALUES(@rol, 1)

			SET @cod_rol = (SELECT r.cod_rol FROM HARDCOR.Rol r WHERE r.nombre = @rol)

			IF @ABM_Rol = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 1)
			END

			IF @ABM_Usuario = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 2)
			END

			IF @ABM_Rubro = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 3)
			END

			IF @ABM_Visibilidad = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 4)
			END

			IF @Generar_publ = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 5)
			END

			IF @Compra_oferta = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 6)
			END

			IF @Historial = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 7)
			END
  
			IF @Calificar = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 8)
			END

			IF @Consulta_factura = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 9)
			END

			IF @Listados = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 10)
			END
		
		COMMIT TRANSACTION
	END TRY	

	BEGIN CATCH
		ROLLBACK TRANSACTION

		IF EXISTS (SELECT * FROM HARDCOR.Rol r WHERE r.nombre = @rol)
		BEGIN
			PRINT 'El Rol ingresado ya existe'
			RETURN -1	
		END  	
	END CATCH

	RETURN 1
END   
GO


CREATE PROCEDURE HARDCOR.mod_rol (@rol NVARCHAR(225), @nuevo_rol NVARCHAR(225), @habilitado BIT,
						  @ABM_Rol BIT, @ABM_Usuario BIT, @ABM_Rubro BIT, @ABM_Visibilidad BIT, 
						  @Generar_publ BIT, @Compra_oferta BIT, @Historial BIT, @Calificar BIT, 
						  @Consulta_factura BIT, @Listados BIT)
AS BEGIN 

	DECLARE @cod_rol INT

	BEGIN TRY
		BEGIN TRANSACTION
			SET @cod_rol = (SELECT r.cod_rol FROM HARDCOR.Rol r WHERE r.nombre = @rol)
	
			IF (@habilitado = 0 AND 0 = (SELECT r.habilitado FROM HARDCOR.Rol r WHERE r.cod_rol = @cod_rol)) OR @habilitado = 1
			BEGIN
				UPDATE HARDCOR.Rol SET habilitado = @habilitado WHERE HARDCOR.Rol.cod_rol = @cod_rol
			END

			UPDATE HARDCOR.Rol SET nombre = @nuevo_rol WHERE HARDCOR.Rol.cod_rol = @cod_rol

			IF @ABM_Rol = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 1)
			END

			IF @ABM_Usuario = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 2)
			END

			IF @ABM_Rubro = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 3)
			END

			IF @ABM_Visibilidad = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 4)
			END

			IF @Generar_publ = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 5)
			END

			IF @Compra_oferta = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 6)
			END

			IF @Historial = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 7)
			END
  
			IF @Calificar = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 8)
			END

			IF @Consulta_factura = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 9)
			END

			IF @Listados = 1 
			BEGIN
				INSERT INTO HARDCOR.RolXfunc
				VALUES(@cod_rol, 10)
			END
		COMMIT TRANSACTION					
	END TRY
		
	BEGIN CATCH
		IF NOT EXISTS (SELECT * FROM HARDCOR.Rol r WHERE r.nombre = @rol)
		BEGIN			
			PRINT 'El Rol que se quiere modificar no existe'
			RETURN -1
		END
		
		IF @habilitado > 1 
		BEGIN
			PRINT 'El campo de habilitado solo puede modificarse con el valor 1'
			RETURN -2
		END
		
		IF @habilitado = 0 AND @habilitado <> (SELECT r.habilitado FROM HARDCOR.Rol r WHERE r.cod_rol = @cod_rol)  
		BEGIN
			PRINT 'No se puede dar de baja un rol desde modificar rol'
			RETURN -3
		END			
	END CATCH
	RETURN 1
END      
GO

CREATE PROCEDURE HARDCOR.baja_rol (@rol NVARCHAR(225))
AS BEGIN
  	DECLARE @cod_rol TINYINT

	BEGIN TRY
		BEGIN TRANSACTION
			SET @cod_rol = (SELECT r.cod_rol FROM HARDCOR.Rol r WHERE r.nombre = @rol)

			UPDATE HARDCOR.Rol SET habilitado = 0 WHERE cod_rol = @cod_rol

			UPDATE HARDCOR.Usuario SET habilitado = 0 WHERE cod_us IN 
			(SELECT u.cod_us FROM HARDCOR.Usuario u, HARDCOR.RolXus r WHERE r.cod_rol = @cod_rol AND r.cod_us = u.cod_us) 
		
			DELETE FROM HARDCOR.RolXfunc WHERE HARDCOR.RolXfunc.cod_rol = @rol
			DELETE FROM HARDCOR.RolXus WHERE HARDCOR.RolXus.cod_rol = @rol  
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF NOT EXISTS (SELECT * FROM HARDCOR.Rol r WHERE r.nombre = @rol )
		BEGIN
			PRINT 'El Rol que se quiere inhabilitar no existe'
			RETURN -1
		END	
	END CATCH
		
	RETURN 1
END     
GO

CREATE PROCEDURE HARDCOR.loggin (@userName NVARCHAR(225), @password NVARCHAR(225))
AS BEGIN
	DECLARE @pw NVARCHAR(225)
	DECLARE @intentos TINYINT
	DECLARE @hash VARBINARY(225)
	
	BEGIN TRY
		SELECT @hash = HASHBYTES('SHA2_256', @password);
		SELECT @pw = u.pass_word FROM HARDCOR.Usuario u WHERE u.username = @UserName AND u.habilitado = 1
		
		IF @pw = @hash
		BEGIN
			PRINT 'acceso correcto'
			UPDATE HARDCOR.Usuario SET intentos = 0 WHERE username = @userName
		END
	END TRY
	
	BEGIN CATCH
		IF NOT EXISTS (SELECT * FROM HARDCOR.Usuario u WHERE u.username = @userName)
		BEGIN 
			PRINT 'el usuario no existe'
			RETURN -1
		END 
		ELSE
			IF 0 = (SELECT u.habilitado FROM HARDCOR.Usuario u WHERE u.username = @userName)
			BEGIN	
				PRINT 'el usuario esta inhabilitado'
				RETURN -2
			END
			
			IF @pw <> @hash
			BEGIN
				PRINT 'El usuario o contraseña es incorrecta'
				UPDATE HARDCOR.Usuario SET intentos = intentos + 1 WHERE username = @userName
				SELECT @intentos = u.intentos FROM HARDCOR.Usuario u WHERE u.username = @userName	
				
				IF @intentos = 3
				BEGIN
					UPDATE HARDCOR.Usuario SET habilitado = 0 WHERE username = @userName
					UPDATE HARDCOR.Usuario SET intentos = 0 WHERE username = @userName
				END

				RETURN -3
			END
	END CATCH
		 
	RETURN 1
END
GO