SELECT 
    p.nombre AS Nombre_Producto,
	pu.cantidad,
    vn.calorias AS Calorias_Por_Unidad,
    dbo.fn_CalcularCaloriasConsumo(p.id_producto, pu.cantidad) AS Total_Calorias
FROM Productos p
JOIN Valor_Nutricional vn ON p.id_producto = vn.id_producto
join Producto_Usuarios pu on p.id_producto=pu.id_producto;

DECLARE @IdUsuario INT = 4; 

SELECT 
	
    p.id_producto,
    p.nombre AS Nombre_Producto,
    dbo.fn_VerificarAlergia(@IdUsuario, p.id_producto) AS Alerta_Alergia,
    CASE 
        WHEN dbo.fn_VerificarAlergia(@IdUsuario, p.id_producto) IS NOT NULL 
        THEN 'PELIGRO: Contiene ' + dbo.fn_VerificarAlergia(@IdUsuario, p.id_producto)
        ELSE 'Seguro para consumo'
    END AS Estado
FROM Productos p;

DECLARE @MiUsuario NUMERIC(10) = 1;   
DECLARE @MiProducto NUMERIC(10) = 1; 

EXEC sp_DiagnosticoProductoUsuario 
    @id_usuario = @MiUsuario, 
    @id_producto = @MiProducto;

EXEC sp_RecomendarAlternativas 
    @id_producto = @MiProducto;

SELECT * FROM v_DiagnosticoProductoUsuario;

SELECT * FROM v_RecomendacionAlternativas  
WHERE id_usuario = 1 
  AND id_producto_origen = 1; 