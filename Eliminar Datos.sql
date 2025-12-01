-- 1. Primero borramos las tablas que conectan muchos a muchos o dependen de otras
DROP TABLE IF EXISTS dbo.Auditoria_Precios;
DROP TABLE IF EXISTS dbo.Valor_Nutricional;
DROP TABLE IF EXISTS dbo.Producto_Ingredientes;
DROP TABLE IF EXISTS dbo.Usuario_Ingredientes;
DROP TABLE IF EXISTS dbo.Producto_Recomendaciones;
DROP TABLE IF EXISTS dbo.Producto_Usuarios;

-- 2. Ahora borramos la tabla principal de hechos (que usaba las anteriores)
DROP TABLE IF EXISTS dbo.Productos;

-- 3. Finalmente borramos las tablas independientes (catálogos y usuarios)
DROP TABLE IF EXISTS dbo.Recomendaciones;
DROP TABLE IF EXISTS dbo.Ingredientes;
DROP TABLE IF EXISTS dbo.Usuarios;
DROP TABLE IF EXISTS dbo.Marca;
DROP TABLE IF EXISTS dbo.Categoria;

PRINT 'Todas las tablas han sido eliminadas correctamente.';

-- Reiniciar contador a 1, si se elimina las tablas
ALTER SEQUENCE Seq_CodigoBarras RESTART WITH 775001;
GO