-- =============================================
-- 1. COMPLETAR CATÁLOGOS (Marcas, Categorías, Ingredientes)
-- =============================================

-- MARCAS (15 registros)
INSERT INTO Marca (nombre) VALUES 
('Gloria'), ('Nestlé'), ('San Fernando'), ('Alicorp'), 
('Union'), ('Nature Valley'), ('Laive'), ('Bimbo'), 
('Pringles'), ('Coca-Cola'), ('Inca Kola'), ('Winter'), 
('Donofrio'), ('Frugos'), ('Lay''s');

-- CATEGORIAS (15 registros)
INSERT INTO Categoria (nombre) VALUES 
('Lácteos'), ('Cereales'), ('Bebidas'), ('Snacks'), 
('Panadería'), ('Frutas Secas'), ('Golosinas'), ('Embutidos'), 
('Congelados'), ('Salsas'), ('Pastas'), ('Postres'), 
('Bebidas Alc.'), ('Suplementos'), ('Harinas');

-- INGREDIENTES (15 registros)
INSERT INTO Ingredientes (tipo_ingrediente, nombre) VALUES 
('Alérgeno', 'Maní'),
('Alérgeno', 'Gluten'),
('Alérgeno', 'Lactosa'),
('Alérgeno', 'Soja'),
('Alérgeno', 'Mariscos'),
('Conservante', 'Tartrazina'),
('Aditivo', 'Azúcar Añadida'),
('Base', 'Harina de Trigo'),
('Base', 'Leche Descremada'),
('Conservante', 'Sorbato de Potasio'),
('Colorante', 'Rojo 40'),
('Edulcorante', 'Aspartamo'),
('Base', 'Harina de Maíz'),
('Base', 'Aceite de Palma'),
('Alérgeno', 'Huevo');

-- USUARIOS (15 registros)
INSERT INTO Usuarios (nombres_apellidos, objetivo_salud, sexo, fecha_nacimiento, correo) VALUES 
('Carlos Pérez', 'Bajar de peso', 'M', '1990-05-15', 'carlos@mail.com'),
('María López', 'Ganar masa', 'F', '1995-08-22', 'maria@mail.com'),
('Jorge Ramirez', 'Mantener', 'M', '1988-12-01', 'jorge@mail.com'),
('Ana Torres', 'Reducir azúcar', 'F', '2000-03-10', 'ana@mail.com'),
('Luis Gomez', 'Sin alérgenos', 'M', '1992-07-30', 'luis@mail.com'),
('Pedro Castillo', 'Subir peso', 'M', '1985-01-20', 'pedro@mail.com'),
('Lucia Mendez', 'Vida sana', 'F', '1998-11-12', 'lucia@mail.com'),
('Roberto Gomez', 'Diabetes', 'M', '1970-04-05', 'roberto@mail.com'),
('Fernanda Paz', 'Celíaca', 'F', '2001-09-30', 'fer@mail.com'),
('Diego Luna', 'Alergias', 'M', '1993-02-14', 'diego@mail.com'),
('Sofia Vergara', 'Fitness', 'F', '1980-07-10', 'sofia@mail.com'),
('Miguel Grau', 'Mantener', 'M', '1975-10-08', 'miguel@mail.com'),
('Rosa Parks', 'Colesterol', 'F', '1960-02-04', 'rosa@mail.com'),
('Bruce Wayne', 'Rendimiento', 'M', '1988-03-30', 'bruce@mail.com'),
('Diana Prince', 'Vegana', 'F', '1990-06-15', 'diana@mail.com');

-- PRODUCTOS (15 registros)
INSERT INTO Productos (nombre, id_categoria, id_marca, precio, stock) VALUES
('Leche Entera UHT', 1, 1, 4.80, 100),
('Yogurt de Fresa', 1, 7, 2.50, 50),
('Pan Integral', 5, 5, 6.00, 40),
('Galletas Casino', 4, 4, 1.50, 200),
('Gaseosa 500ml', 3, 10, 3.00, 80),
('Avena Clásica', 2, 6, 3.80, 60),
('Cerveza Pilsen', 13, 4, 4.50, 120),
('Jamón de Pavo', 8, 3, 12.50, 15),
('Helado Tricolor', 12, 13, 16.90, 10),
('Barra de Cereal', 6, 6, 3.20, 90),
('Mantequilla Sal', 1, 1, 6.50, 25),
('Papas Ondas', 4, 9, 3.50, 50),
('Nectar Durazno', 3, 14, 2.20, 45),
('Fideos Spaguetti', 11, 4, 4.20, 30),
('Chocolate Sublime', 7, 2, 2.50, 150);

-- VALOR NUTRICIONAL (15 registros)
INSERT INTO Valor_Nutricional (id_producto, energia, proteinas, fibra, porcion, unidad, azucares, calorias, grasas, sodio) VALUES
(1, 150, 8.0, 0.0, 200, 'ml', 10.0, 120, 6.0, 100),   
(2, 140, 6.0, 0.5, 200, 'ml', 18.0, 110, 4.0, 80),    
(3, 250, 9.0, 5.0, 100, 'g', 2.0, 240, 3.0, 300),    
(4, 480, 5.0, 1.0, 50, 'g', 25.0, 450, 20.0, 150),   
(5, 200, 0.0, 0.0, 500, 'ml', 50.0, 200, 0.0, 20),    
(6, 350, 12.0, 10.0, 100, 'g', 1.0, 360, 5.0, 5),    
(7, 180, 1.0, 0.0, 355, 'ml', 12.0, 150, 0.0, 10),    
(8, 120, 18.0, 0.0, 100, 'g', 1.0, 110, 3.0, 800),   
(9, 220, 4.0, 0.0, 100, 'g', 22.0, 210, 12.0, 90),    
(10, 190, 3.0, 4.0, 40, 'g', 10.0, 180, 8.0, 140),   
(11, 720, 1.0, 0.0, 100, 'g', 0.0, 710, 80.0, 600),  
(12, 540, 6.0, 3.0, 100, 'g', 1.0, 530, 35.0, 500),  
(13, 160, 0.5, 1.0, 250, 'ml', 30.0, 150, 0.0, 30),   
(14, 360, 11.0, 2.0, 100, 'g', 2.0, 350, 1.5, 10),    
(15, 550, 8.0, 4.0, 100, 'g', 45.0, 540, 30.0, 80);  

-- RECOMENDACIONES (15 registros)
INSERT INTO Recomendaciones (motivo, puntaje, fecha, id_usuario, comentario) VALUES 
('Calorías', 2, GETDATE(), 1, 'Muy rico, pero tiene demasiadas calorías para mi plan de pérdida de peso.'),
('Digestión', 1, GETDATE(), 2, 'Me cayó pésimo al estómago, definitivamente tiene trazas de lácteos.'),
('Seguridad', 5, GETDATE(), 3, 'Etiquetado muy claro sobre trazas de mariscos, me siento seguro consumiéndolo.'),
('Engañoso', 2, GETDATE(), 4, 'Dice ser bajo en azúcar pero me generó mucha ansiedad, muy dulce.'),
('Reacción', 1, GETDATE(), 5, 'Cuidado, sentí picazón leve, posible contaminación cruzada de gluten.'),
('Energía', 4, GETDATE(), 6, 'Buena fuente de energía para entrenar, aunque prefiero evitar los frutos secos.'),
('Procesado', 2, GETDATE(), 7, 'Muchos ingredientes impronunciables, no encaja con mi dieta limpia.'),
('Apto Diabetes', 5, GETDATE(), 8, 'Excelente, medí mi glucosa después de comerlo y se mantuvo estable.'),
('Certificado', 5, GETDATE(), 9, 'Por fin un snack que realmente es Gluten Free y sin lácteos, me sentí bien.'),
('Químicos', 2, GETDATE(), 10, 'El sabor es muy artificial y me dio dolor de cabeza al poco tiempo.'),
('Natural', 5, GETDATE(), 11, 'Me encanta que no usen colorantes rojos artificiales, ideal para mi pre-entreno.'),
('Sabor', 3, GETDATE(), 12, 'El sabor residual del edulcorante es muy fuerte, prefiero lo natural.'),
('Grasoso', 1, GETDATE(), 13, 'Demasiada grasa saturada, tuve que dejarlo por mi colesterol.'),
('Calidad', 4, GETDATE(), 14, 'Buenos macros para rendir en el deporte, sin aceites de relleno.'),
('No Vegano', 1, GETDATE(), 15, 'Contiene albúmina de huevo en los ingredientes, no es apto vegano.');

-- =============================================
-- TABLAS INTERMEDIAS 
-- Aquí SÍ ponemos los IDs manualmente, pero referencian a los que se crearon arriba (del 1 al 15).
-- =============================================
INSERT INTO Producto_Ingredientes (id_producto, id_ingrediente) VALUES
(1, 3), (2, 3), (3, 2), (4, 2), (5, 7), 
(6, 2), (7, 2), (8, 6), (9, 3), (10, 1), 
(11, 3), (12, 6), (13, 1), (14, 2), (15, 1);

INSERT INTO Usuario_Ingredientes (id_usuario, id_ingrediente, observaciones, severidad) VALUES
(1, 1, 'Alta densidad calórica, dificulta el déficit calórico necesario.', 'Alta'),
(2, 3, 'Inflamación intestinal impide la ingesta de grandes volúmenes de comida.', 'Media'),
(3, 5, 'Alergia alimentaria estricta.', 'Alta'),
(4, 2, 'Evita harinas refinadas para controlar picos de insulina y ansiedad por dulce.', 'Media'),
(5, 2, 'Protocolo de eliminación total de alérgenos inflamatorios.', 'Alta'),
(6, 1, 'Alergia severa impide usar mantequilla de maní como fuente de calorías.', 'Alta'),
(7, 7, 'Incompatible con estilo de vida Clean Eating y salud metabólica.', 'Baja'),
(8, 8, 'Alto índice glucémico, riesgo alto de hiperglucemia postprandial.', 'Alta'),
(9, 9, 'Intolerancia secundaria a lácteos debido a daño en vellosidades intestinales.', 'Media'),
(10, 10, 'Historial de dermatitis atópica reactiva a conservantes químicos.', 'Media'),
(11, 11, 'Evita aditivos sintéticos para optimizar desintoxicación y rendimiento.', 'Baja'),
(12, 12, 'Preferencia personal: evita químicos en su dieta de mantenimiento.', 'Baja'),
(13, 13, 'Control de carbohidratos simples para reducir triglicéridos asociados al colesterol.', 'Media'),
(14, 14, 'Grasas saturadas de baja calidad afectan la salud arterial y recuperación.', 'Alta'),
(15, 15, 'Restricción ética total de productos de origen animal.', 'Alta');

INSERT INTO Producto_Recomendaciones (id_producto, id_recomendacion) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15);

INSERT INTO Producto_Usuarios (id_producto, id_usuario, cantidad, fecha_hora) VALUES
(1, 1, 2, GETDATE()),
(2, 2, 1, GETDATE()),
(3, 3, 5, GETDATE()),
(4, 4, 1, GETDATE()),
(5, 5, 2, GETDATE()),
(6, 6, 1, GETDATE()),
(7, 7, 6, GETDATE()),
(8, 8, 1, GETDATE()),
(9, 9, 2, GETDATE()),
(10, 10, 10, GETDATE()),
(11, 11, 1, GETDATE()),
(12, 12, 2, GETDATE()),
(13, 13, 1, GETDATE()),
(14, 14, 3, GETDATE()),
(15, 15, 1, GETDATE());
GO