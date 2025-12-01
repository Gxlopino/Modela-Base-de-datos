-- ######################################
-- 1. CREACIÓN DE TABLAS USANDO IDENTITY
-- ######################################

-- Tabla Categoria
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria]') AND type in (N'U'))
BEGIN
    CREATE TABLE Categoria (
        id_categoria NUMERIC(10) IDENTITY(1,1) NOT NULL,
        nombre VARCHAR(100) NOT NULL CONSTRAINT UQ_Categoria_Nombre UNIQUE
    );
END
GO

-- Tabla Ingredientes
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ingredientes]') AND type in (N'U'))
BEGIN
    CREATE TABLE Ingredientes (
        id_ingrediente NUMERIC(10) IDENTITY(1,1) NOT NULL,
        tipo_ingrediente VARCHAR(100) NOT NULL,
        nombre VARCHAR(100) NOT NULL CONSTRAINT UQ_Ingrediente_Nombre UNIQUE
    );
END
GO

-- Tabla Marca
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marca]') AND type in (N'U'))
BEGIN
    CREATE TABLE Marca (
        id_marca NUMERIC(10) IDENTITY(1,1) NOT NULL,
        nombre VARCHAR(100) NOT NULL CONSTRAINT UQ_Marca_Nombre UNIQUE
    );
END
GO

-- Tabla Productos
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Productos]') AND type in (N'U'))
BEGIN
    CREATE TABLE Productos (
        id_producto NUMERIC(10) IDENTITY(1,1) NOT NULL,
        codigo_barras NUMERIC(20) DEFAULT (NEXT VALUE FOR Seq_CodigoBarras) CONSTRAINT UQ_Producto_Codigo UNIQUE,      
        nombre VARCHAR(100) NOT NULL,
        id_categoria NUMERIC(10) NOT NULL,
        id_marca NUMERIC(10) NOT NULL,     
    );
END
GO

-- Tabla Usuarios
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuarios]') AND type in (N'U'))
BEGIN
    CREATE TABLE Usuarios (
        id_usuario NUMERIC(10) IDENTITY(1,1) NOT NULL,
        nombres_apellidos VARCHAR(200) NOT NULL,
        objetivo_salud VARCHAR(100) NOT NULL,
		sexo CHAR(1) NOT NULL,
		fecha_nacimiento DATE NOT NULL,
		correo VARCHAR(100) NOT NULL CONSTRAINT UQ_Usuario_Correo UNIQUE,
		CONSTRAINT CK_Usuarios_Sexo CHECK (sexo IN ('M', 'F'))
    );
END
GO

-- Tabla Valor_Nutricional
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Valor_Nutricional]') AND type in (N'U'))
BEGIN
    CREATE TABLE Valor_Nutricional (
    id_valor NUMERIC(10) IDENTITY(1,1) NOT NULL, 
    energia NUMERIC(8,2) NOT NULL DEFAULT 0,
    proteinas NUMERIC(8,2) NOT NULL DEFAULT 0,
    fibra NUMERIC(8,2) NOT NULL DEFAULT 0,
    porcion NUMERIC(5) NOT NULL DEFAULT 0,
    unidad VARCHAR(10) NOT NULL,       
    azucares NUMERIC(8,2) NOT NULL DEFAULT 0,
    calorias NUMERIC(8,2) NOT NULL DEFAULT 0,
    grasas NUMERIC(8,2) NOT NULL DEFAULT 0,
    sodio NUMERIC(8,2) NOT NULL DEFAULT 0,
    id_producto NUMERIC(10) NOT NULL
);
END
GO

-- Tabla Recomendaciones
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recomendaciones]') AND type in (N'U'))
BEGIN
    CREATE TABLE Recomendaciones (
        id_recomendacion NUMERIC(10) IDENTITY(1,1) NOT NULL,
        motivo VARCHAR(100) NOT NULL,
        puntaje VARCHAR(10) NOT NULL,
        fecha DATETIME NOT NULL DEFAULT GETDATE(),
        id_usuario NUMERIC(10) NOT NULL,
        comentario VARCHAR(100) NULL
    );
END
GO

-- TABLAS INTERMEDIAS 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Ingredientes]') AND type in (N'U'))
BEGIN
    CREATE TABLE Producto_Ingredientes (      
        id_producto NUMERIC(10) NOT NULL,
        id_ingrediente NUMERIC(10) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Recomendaciones]') AND type in (N'U'))
BEGIN
    CREATE TABLE Producto_Recomendaciones (
        id_producto NUMERIC(10) NOT NULL,
        id_recomendacion NUMERIC(10) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Producto_Usuarios]') AND type in (N'U'))
BEGIN
    CREATE TABLE Producto_Usuarios (
        id_producto NUMERIC(10) NOT NULL,
        id_usuario NUMERIC(10) NOT NULL,
        cantidad NUMERIC(10) NOT NULL DEFAULT 1,
        fecha_hora DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_Ingredientes]') AND type in (N'U'))
BEGIN
    CREATE TABLE Usuario_Ingredientes (
        id_usuario NUMERIC(10) NOT NULL,
        id_ingrediente NUMERIC(10) NOT NULL,
        observaciones VARCHAR(200) NULL,
        severidad VARCHAR(100) NOT NULL
    );
END
GO

-- ######################################
-- 2. DEFINICIÓN DE CLAVES PRIMARIAS (PK)
-- ######################################
-- 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Categoria_PK')
    ALTER TABLE Categoria ADD CONSTRAINT Categoria_PK PRIMARY KEY CLUSTERED (id_categoria);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Ingredientes_PK')
    ALTER TABLE Ingredientes ADD CONSTRAINT Ingredientes_PK PRIMARY KEY CLUSTERED (id_ingrediente);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Marca_PK')
    ALTER TABLE Marca ADD CONSTRAINT Marca_PK PRIMARY KEY CLUSTERED (id_marca);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Producto_Ingredientes_PK')
    ALTER TABLE Producto_Ingredientes ADD CONSTRAINT Producto_Ingredientes_PK PRIMARY KEY CLUSTERED (id_producto, id_ingrediente);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Producto_Recomendaciones_PK')
    ALTER TABLE Producto_Recomendaciones ADD CONSTRAINT Producto_Recomendaciones_PK PRIMARY KEY CLUSTERED (id_producto, id_recomendacion);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Producto_Usuarios_PK')
    ALTER TABLE Producto_Usuarios ADD CONSTRAINT Producto_Usuarios_PK PRIMARY KEY CLUSTERED (id_producto, id_usuario); 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Productos_PK')
    ALTER TABLE Productos ADD CONSTRAINT Productos_PK PRIMARY KEY CLUSTERED (id_producto);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Recomendaciones_PK')
    ALTER TABLE Recomendaciones ADD CONSTRAINT Recomendaciones_PK PRIMARY KEY CLUSTERED (id_recomendacion);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Usuario_Ingredientes_PK')
    ALTER TABLE Usuario_Ingredientes ADD CONSTRAINT Usuario_Ingredientes_PK PRIMARY KEY CLUSTERED (id_usuario, id_ingrediente);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Usuarios_PK')
    ALTER TABLE Usuarios ADD CONSTRAINT Usuarios_PK PRIMARY KEY CLUSTERED (id_usuario);
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Valor_Nutricional_PK')
    ALTER TABLE Valor_Nutricional ADD CONSTRAINT Valor_Nutricional_PK PRIMARY KEY CLUSTERED (id_valor);
GO

-- ######################################
-- 3. DEFINICIÓN DE ÍNDICES ADICIONALES Y FKs
-- ######################################
--

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'Valor_Nutricional_UQ_IDX')
    CREATE UNIQUE NONCLUSTERED INDEX Valor_Nutricional_UQ_IDX ON Valor_Nutricional (id_producto);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PI_Prod')
    ALTER TABLE Producto_Ingredientes ADD CONSTRAINT FK_PI_Prod FOREIGN KEY (id_producto) REFERENCES Productos(id_producto);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PI_Ingr')
    ALTER TABLE Producto_Ingredientes ADD CONSTRAINT FK_PI_Ingr FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PR_Prod')
    ALTER TABLE Producto_Recomendaciones ADD CONSTRAINT FK_PR_Prod FOREIGN KEY (id_producto) REFERENCES Productos(id_producto);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PR_Recom')
    ALTER TABLE Producto_Recomendaciones ADD CONSTRAINT FK_PR_Recom FOREIGN KEY (id_recomendacion) REFERENCES Recomendaciones(id_recomendacion);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PU_Prod')
    ALTER TABLE Producto_Usuarios ADD CONSTRAINT FK_PU_Prod FOREIGN KEY (id_producto) REFERENCES Productos(id_producto);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PU_Usr')
    ALTER TABLE Producto_Usuarios ADD CONSTRAINT FK_PU_Usr FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Prod_Cat')
    ALTER TABLE Productos ADD CONSTRAINT FK_Prod_Cat FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Prod_Marc')
    ALTER TABLE Productos ADD CONSTRAINT FK_Prod_Marc FOREIGN KEY (id_marca) REFERENCES Marca(id_marca);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Recom_Usr')
    ALTER TABLE Recomendaciones ADD CONSTRAINT FK_Recom_Usr FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_UI_Usr')
    ALTER TABLE Usuario_Ingredientes ADD CONSTRAINT FK_UI_Usr FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_UI_Ingr')
    ALTER TABLE Usuario_Ingredientes ADD CONSTRAINT FK_UI_Ingr FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente);
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_VN_Prod')
    ALTER TABLE Valor_Nutricional ADD CONSTRAINT FK_VN_Prod FOREIGN KEY (id_producto) REFERENCES Productos(id_producto);
GO