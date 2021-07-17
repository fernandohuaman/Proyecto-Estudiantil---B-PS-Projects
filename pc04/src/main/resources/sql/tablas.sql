DROP TABLE IF EXISTS USUARIO CASCADE;
DROP TABLE IF EXISTS EMPLEADO CASCADE;
DROP TABLE IF EXISTS EMPRESACLIENTE CASCADE;
DROP TABLE IF EXISTS REPEMPRESA CASCADE;
DROP TABLE IF EXISTS PROYECTO CASCADE;
DROP TABLE IF EXISTS STAFF_PROYECTO CASCADE;
DROP TABLE IF EXISTS TIPOACTIVIDAD CASCADE;
DROP TABLE IF EXISTS ACTIVIDAD CASCADE;
DROP TABLE IF EXISTS INFORME CASCADE;
DROP TABLE IF EXISTS OBSERVACION CASCADE;
DROP TABLE IF EXISTS COMENTARIO CASCADE;
DROP SEQUENCE IF EXISTS OBS_ID;
CREATE TABLE USUARIO (
    USERNAME VARCHAR(20) NOT NULL,
    CONTRASENIA VARCHAR(20) NOT NULL,
    ROL VARCHAR(25) NOT NULL,
    PRIMARY KEY (USERNAME)
);
CREATE TABLE EMPLEADO (
    DNI VARCHAR(8) NOT NULL,
    FECHA_NACIMIENTO DATE,
    PRIM_NOMBRE VARCHAR(25),
    PRIM_APELLIDO VARCHAR(25),
    SEG_APELLIDO VARCHAR(25),
    CORREO VARCHAR(64) UNIQUE,
    TELEFONO VARCHAR(12),
    FECHA_CONTRATACION DATE NOT NULL,
    USERNAME VARCHAR(20) NOT NULL,
    DNI_SUPERV VARCHAR(8),
    PRIMARY KEY (DNI),
    FOREIGN KEY (USERNAME) REFERENCES USUARIO(USERNAME),
    FOREIGN KEY (DNI_SUPERV) REFERENCES EMPLEADO(DNI)
);
CREATE TABLE EMPRESACLIENTE (
    RUC VARCHAR(11) NOT NULL,
    RAZON_SOCIAL VARCHAR(60),
    NRO_PROY_CONTRATADOS NUMERIC(2),
    NRO_PROY_ACTIVOS NUMERIC(2),
    PRIMARY KEY (RUC)
);
CREATE TABLE REPEMPRESA (
    DNI VARCHAR(8) NOT NULL,
    PRIM_NOMBRE VARCHAR(25),
    PRIM_APELLIDO VARCHAR(25),
    SEG_APELLIDO VARCHAR(25),
    CORREO VARCHAR(64) UNIQUE,
    TELEFONO VARCHAR(12),
    USERNAME VARCHAR(20) NOT NULL,
    RUC_EMPRESA VARCHAR(11) NOT NULL,
    PRIMARY KEY (DNI),
    FOREIGN KEY (USERNAME) REFERENCES USUARIO(USERNAME),
    FOREIGN KEY (RUC_EMPRESA) REFERENCES EMPRESACLIENTE(RUC)
);
CREATE TABLE PROYECTO (
    CODIGO VARCHAR(23) NOT NULL,
    NOMBRE VARCHAR(40) NOT NULL,
    ESTADO VARCHAR(13) NOT NULL,
    FECHA_INICIO_PROGRAM DATE NOT NULL,
    FECHA_ENTREGA_PROGRAM DATE NOT NULL,
    FECHA_INICIO_REAL DATE,
    FECHA_ENTREGA_REAL DATE,
    DNI_REPCLIENTE VARCHAR(8) NOT NULL,
    PRIMARY KEY (CODIGO),
    FOREIGN KEY (DNI_REPCLIENTE) REFERENCES REPEMPRESA(DNI)
);
CREATE TABLE STAFF_PROYECTO (
    DNI_EMPLEADO VARCHAR(8) NOT NULL,
    CODIGO_PROY VARCHAR(23) NOT NULL,
    ROL_PROY VARCHAR(15) NOT NULL,
    FECHA_INICIO_VIGENCIA TIMESTAMP NOT NULL,
    FECHA_FIN_VIGENCIA TIMESTAMP NULL,
    PRIMARY KEY (DNI_EMPLEADO, CODIGO_PROY),
    FOREIGN KEY (DNI_EMPLEADO) REFERENCES EMPLEADO(DNI),
    FOREIGN KEY (CODIGO_PROY) REFERENCES PROYECTO(CODIGO)
);
CREATE TABLE TIPOACTIVIDAD(
    CODIGO VARCHAR(32) NOT NULL,
    NOMBRE VARCHAR(32) NOT NULL,
    DESCRIPCION VARCHAR(128),
    DOC_REFERENCIA VARCHAR(32),
    FREC_INSPECCION NUMERIC(2),
    TIPO_VERIFICACION VARCHAR(32) NOT NULL,
    TIPO_INSPECCION VARCHAR(32) NOT NULL,
    PUNTO_INSPECCION VARCHAR(32) NOT NULL,
    PRIMARY KEY(CODIGO)
);
CREATE TABLE ACTIVIDAD (
    CODIGO VARCHAR(32) NOT NULL,
    CODIGO_TIPO VARCHAR(32) NOT NULL,
    ESTADO VARCHAR(13) NOT NULL,
    FECHA_INICIO_PROGRAM TIMESTAMP NOT NULL,
    FECHA_FIN_PROGRAM TIMESTAMP NOT NULL,
    FECHA_INICIO_REAL TIMESTAMP,
    FECHA_FIN_REAL TIMESTAMP,
    CODIGO_PROY VARCHAR(23) NOT NULL,
    PRIMARY KEY(CODIGO, CODIGO_TIPO),
    FOREIGN KEY(CODIGO_PROY) REFERENCES PROYECTO(CODIGO),
    FOREIGN KEY (CODIGO_TIPO) REFERENCES TIPOACTIVIDAD(CODIGO)
);
CREATE TABLE INFORME (
    CODIGO VARCHAR(14) NOT NULL,
    NOMBRE VARCHAR(32) NOT NULL,
    FECHA TIMESTAMP NOT NULL,
    URL_PDF VARCHAR(2083),
	URL_PLANO VARCHAR(2083),
	RESUMEN VARCHAR(1000),
	NORMA_REF VARCHAR(20),
    CODIGO_ACT VARCHAR(32) NOT NULL,
    CODIGO_TIPO_ACT VARCHAR(32) NOT NULL,
    DNI_EMPLEADO VARCHAR(8) NOT NULL,
    PRIMARY KEY (CODIGO),
	FOREIGN KEY (DNI_EMPLEADO) REFERENCES EMPLEADO(DNI),
    FOREIGN KEY (CODIGO_ACT,CODIGO_TIPO_ACT) REFERENCES ACTIVIDAD(CODIGO,CODIGO_TIPO)
);
CREATE TABLE OBSERVACION (
    ID NUMERIC NOT NULL,
    CONTENIDO VARCHAR(8000) NOT NULL,
    ESTADO VARCHAR(15) NOT NULL,
    FECHA_CREAC TIMESTAMP NOT NULL,
    FECHA_LEV TIMESTAMP,
    CODIGO_INF VARCHAR(14) NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (CODIGO_INF) REFERENCES INFORME(CODIGO)
);
CREATE TABLE COMENTARIO (
    ORDEN NUMERIC NOT NULL,
    FECHA TIMESTAMP NOT NULL,
    CONTENIDO VARCHAR(8000) NOT NULL,
    USERNAME VARCHAR(20) NOT NULL,
    ID_OBSERVACION NUMERIC NOT NULL,
    PRIMARY KEY(ORDEN, ID_OBSERVACION),
    FOREIGN KEY (ID_OBSERVACION) REFERENCES OBSERVACION(ID),
    FOREIGN KEY (USERNAME) REFERENCES USUARIO(USERNAME)
);