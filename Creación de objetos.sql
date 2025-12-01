-- ########################################################
-- 0. PRE-REQUISITOS (Columnas y Tablas de Auditoría)
-- ########################################################

-- Agregar columna 'precio' a Productos si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'Productos') AND name = 'precio')
BEGIN
    ALTER TABLE Productos ADD precio NUMERIC(10,2) DEFAULT 0;
END
GO

-- Agregar columna 'stock' a Productos si no existe
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'Productos') AND name = 'stock')
BEGIN
    ALTER TABLE Productos ADD stock NUMERIC(10) DEFAULT 0;
END
GO

--Preguntarle al profe acerca de esta tabla y sobre el procedimiento alamacenado que se repite con el trigger :) -- 
-- Crear tabla de Auditoría si no existe
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Auditoria_Precios') AND type in (N'U'))
BEGIN
    CREATE TABLE Auditoria_Precios (
        id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
        id_producto NUMERIC(10),
        precio_anterior NUMERIC(10,2),
        precio_nuevo NUMERIC(10,2),
        usuario_modificador VARCHAR(100),
        fecha_cambio DATETIME DEFAULT GETDATE()	
    );
END
GO

-- Conectar con la tabla Productos
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Auditoria_Producto')
ALTER TABLE Auditoria_Precios ADD CONSTRAINT FK_Auditoria_Producto FOREIGN KEY (id_producto) REFERENCES Productos (id_producto);
GO

-- ########################################################
-- 1. SECUENCIA (Sequence)
-- ########################################################
IF NOT EXISTS (SELECT * FROM sys.sequences WHERE name = 'Seq_CodigoBarras')
    CREATE SEQUENCE Seq_CodigoBarras 
    START WITH 775001 
    INCREMENT BY 1;
GO

-- ########################################################
-- 2. PROCEDIMIENTO ALMACENADO (Stored Procedure)
-- ########################################################

CREATE OR ALTER PROCEDURE sp_DiagnosticoProductoUsuario
(
    @id_usuario NUMERIC(10),
    @id_producto NUMERIC(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE 
        @alergia VARCHAR(200),
        @azucares NUMERIC(10,2),
        @calorias NUMERIC(10,2),
        @objetivo VARCHAR(200);

    SELECT @alergia = dbo.fn_VerificarAlergia(@id_usuario, @id_producto);

    SELECT 
        @azucares = azucares,
        @calorias = calorias
    FROM Valor_Nutricional
    WHERE id_producto = @id_producto;

    SELECT @objetivo = objetivo_salud 
    FROM Usuarios 
    WHERE id_usuario = @id_usuario;

    SELECT 
        @id_usuario AS usuario,
        @id_producto AS producto,
        @objetivo AS objetivo_usuario,
        @azucares AS gramos_azucar,
        @calorias AS total_calorias,
        @alergia AS alergia_detectada,
        CASE 
            WHEN @alergia IS NOT NULL THEN 'NO APTO (Alergia detectada)'
            WHEN @objetivo LIKE '%azúcar%' AND @azucares > 15 THEN 'NO APTO (Mucho azúcar)'
            WHEN @calorias > 300 THEN 'CUIDADO (Alto en calorías)'
            ELSE 'APTO'
        END AS diagnostico_final;
END;
GO

CREATE OR ALTER PROCEDURE sp_RecomendarAlternativas
(
    @id_producto NUMERIC(10)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @categoria NUMERIC(10);

    SELECT @categoria = id_categoria 
    FROM Productos 
    WHERE id_producto = @id_producto;

    SELECT TOP 5 
        p.id_producto,
        p.nombre,
        vn.azucares,
        vn.calorias
    FROM Productos p
    INNER JOIN Valor_Nutricional vn ON vn.id_producto = p.id_producto
    WHERE p.id_categoria = @categoria
      AND p.id_producto <> @id_producto
    ORDER BY vn.azucares ASC, vn.calorias ASC;
END;
GO

-- ########################################################
-- 3. FUNCIÓN (Function)
-- ########################################################

CREATE OR ALTER FUNCTION fn_CalcularCaloriasConsumo
(
    @id_producto NUMERIC(10),
    @cantidad_consumida NUMERIC(10)
)
RETURNS NUMERIC(10,2)
AS
BEGIN
    DECLARE @total_calorias NUMERIC(10,2);
    DECLARE @calorias_unidad NUMERIC(10,2);

    SELECT @calorias_unidad = calorias 
    FROM Valor_Nutricional 
    WHERE id_producto = @id_producto;

    SET @total_calorias = ISNULL(@calorias_unidad, 0) * @cantidad_consumida;

    RETURN @total_calorias;
END;
GO

CREATE OR ALTER FUNCTION fn_VerificarAlergia
(
    @id_usuario NUMERIC(10),
    @id_producto NUMERIC(10)
)
RETURNS VARCHAR(200) -- Devuelve el nombre del ingrediente peligroso o NULL si es seguro
AS
BEGIN
    DECLARE @alerta VARCHAR(200);
    SELECT TOP 1 @alerta = i.nombre
    FROM Producto_Ingredientes pi
    INNER JOIN Usuario_Ingredientes ui ON pi.id_ingrediente = ui.id_ingrediente
    INNER JOIN Ingredientes i ON i.id_ingrediente = pi.id_ingrediente
    WHERE pi.id_producto = @id_producto 
      AND ui.id_usuario = @id_usuario;
    RETURN @alerta;
END;
GO

-- ########################################################
-- 4. TRIGGER (Disparador)
-- ########################################################

CREATE OR ALTER TRIGGER TR_DescontarStock
ON Producto_Usuarios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE p
    SET p.stock = p.stock - i.cantidad
    FROM Productos p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;
    IF EXISTS (SELECT 1 FROM Productos WHERE stock < 0)
    BEGIN
        PRINT 'ADVERTENCIA: Stock negativo detectado.';
    END
END;
GO	

CREATE OR ALTER TRIGGER TR_Auditoria_CambioPrecio
ON Productos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	   IF UPDATE(precio) 
    BEGIN
        INSERT INTO Auditoria_Precios (
            id_producto, 
            precio_anterior, 
            precio_nuevo, 
            usuario_modificador, 
            fecha_cambio
        )
        SELECT 
            i.id_producto,
            d.precio,          
            i.precio,          
            SYSTEM_USER,
            GETDATE()
        FROM 
            inserted i 
        JOIN 
            deleted d ON i.id_producto = d.id_producto 
        WHERE 
            d.precio <> i.precio; 
    END
END
GO

-- ########################################################
-- %. VIEW (Vistas)
-- ########################################################

CREATE OR ALTER VIEW v_DiagnosticoProductoUsuario
AS
SELECT 
    u.id_usuario,
    u.nombres_apellidos AS nombre_usuario,
    p.id_producto,
    p.nombre AS nombre_producto,
    u.objetivo_salud AS objetivo_usuario,
    ISNULL(vn.azucares, 0) AS gramos_azucar,
    ISNULL(vn.calorias, 0) AS total_calorias,
    ISNULL(dbo.fn_VerificarAlergia(u.id_usuario, p.id_producto), 'Alergia no encontrada') AS alergia_detectada,
    CASE 
        WHEN dbo.fn_VerificarAlergia(u.id_usuario, p.id_producto) IS NOT NULL 
            THEN 'NO APTO (Alergia detectada)'
        WHEN u.objetivo_salud LIKE '%azúcar%' AND ISNULL(vn.azucares, 0) > 15 
            THEN 'NO APTO (Mucho azúcar)'
        WHEN ISNULL(vn.calorias, 0) > 300 
            THEN 'CUIDADO (Alto en calorías)'
        ELSE 'APTO'
    END AS diagnostico_final

FROM Usuarios u
CROSS JOIN Productos p 
LEFT JOIN Valor_Nutricional vn ON p.id_producto = vn.id_producto;
GO

CREATE OR ALTER VIEW v_RecomendacionAlternativas
AS
SELECT 
    u.id_usuario,
    u.objetivo_salud,

    p_origen.id_producto AS id_producto_actual,
    p_origen.nombre AS nombre_producto_actual,

    p_alt.id_producto AS id_producto_sugerido,
    p_alt.nombre AS nombre_sugerido,
    vn.azucares,
    vn.calorias,

    ROW_NUMBER() OVER (
        PARTITION BY u.id_usuario, p_origen.id_producto 
        ORDER BY 
            CASE 
                WHEN u.objetivo_salud LIKE '%azúcar%' OR u.objetivo_salud LIKE '%diabetes%' 
                    THEN vn.azucares
                WHEN u.objetivo_salud LIKE '%peso%' OR u.objetivo_salud LIKE '%calorías%' 
                    THEN vn.calorias
                ELSE vn.azucares 
            END ASC
    ) AS ranking

FROM Usuarios u
CROSS JOIN Productos p_origen 
INNER JOIN Productos p_alt ON p_origen.id_categoria = p_alt.id_categoria
INNER JOIN Valor_Nutricional vn ON p_alt.id_producto = vn.id_producto
WHERE p_origen.id_producto <> p_alt.id_producto 
GO

CREATE OR ALTER VIEW v_RecomendacionAlternativas
AS
SELECT 
    u.id_usuario,
    u.nombres_apellidos AS nombre_usuario,
    p1.id_producto AS id_producto_origen,
    p1.nombre AS nombre_original,
    p2.id_producto AS id_producto_sugerido,
    p2.nombre AS nombre_sugerido,
    vn.azucares,
    vn.calorias,
    ROW_NUMBER() OVER (
        PARTITION BY u.id_usuario, p1.id_producto 
        ORDER BY vn.azucares ASC
    ) AS ranking_azucar,

    ROW_NUMBER() OVER (
        PARTITION BY u.id_usuario, p1.id_producto 
        ORDER BY vn.calorias ASC
    ) AS ranking_calorias

FROM Usuarios u
CROSS JOIN Productos p1 
INNER JOIN Productos p2 ON p1.id_categoria = p2.id_categoria AND p1.id_producto <> p2.id_producto
INNER JOIN Valor_Nutricional vn ON p2.id_producto = vn.id_producto;
GO