/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Participante 2: Seguridad y Carga de Datos
   Script: 03_Insertar_Datos.sql
   Base de datos: TiendaOnline
   ============================================================ */

USE TiendaOnline;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    /* ==========================
       Clientes
       ========================== */
    INSERT INTO Clientes (Nombre, Email, Telefono)
    VALUES
    ('Juan Perez','juan@email.com','8091111111'),
    ('Maria Gomez','maria@email.com','8092222222'),
    ('Carlos Rodriguez','carlos@email.com','8093333333'),
    ('Ana Martinez','ana@email.com','8094444444'),
    ('Luis Fernandez','luis@email.com','8095555555');

    /* ==========================
       Categorías
       ========================== */
    INSERT INTO Categorias (NombreCategoria)
    VALUES ('Laptops'), ('Accesorios'), ('Monitores'), ('Almacenamiento'), ('Tablets');

    /* ==========================
       Proveedores
       ========================== */
    INSERT INTO Proveedores (NombreProveedor,Telefono,Email,Direccion)
    VALUES
    ('Tech Solutions','8091111111','ventas@tech.com','Santo Domingo'),
    ('PC World','8092222222','contacto@pcworld.com','Santiago'),
    ('Global Hardware','8093333333','info@global.com','La Vega'),
    ('Digital Store','8094444444','ventas@digital.com','San Cristobal'),
    ('Electro Import','8095555555','info@electro.com','Santo Domingo');

    /* ==========================
       Productos
       ========================== */
    INSERT INTO Productos (CategoriaID,ProveedorID,Nombre,Descripcion,Precio,Caracteristicas)
    VALUES
    (1,1,'Laptop HP','Laptop empresarial',850.00,'{"Marca":"HP","RAM":"16GB"}'),
    (1,2,'Laptop Dell','Laptop profesional',950.00,'{"Marca":"Dell","RAM":"16GB"}'),
    (2,1,'Mouse Logitech','Mouse USB',25.00,'{"Marca":"Logitech"}'),
    (2,1,'Teclado Redragon','Teclado mecanico',60.00,'{"Marca":"Redragon"}'),
    (3,3,'Monitor Samsung','24 pulgadas',220.00,'{"Marca":"Samsung"}'),
    (3,3,'Monitor LG','27 pulgadas',280.00,'{"Marca":"LG"}'),
    (4,4,'SSD Kingston','1TB SSD',120.00,'{"Marca":"Kingston"}'),
    (4,4,'Memoria RAM Corsair','16GB DDR4',90.00,'{"Marca":"Corsair"}'),
    (5,5,'Tablet Lenovo','Tablet Android',300.00,'{"Marca":"Lenovo"}'),
    (2,1,'Webcam Logitech','HD Webcam',55.00,'{"Marca":"Logitech"}');

    /* ==========================
       Inventario
       ========================== */
    INSERT INTO Inventario (ProductoID,Stock)
    VALUES (1,15), (2,12), (3,50), (4,25), (5,10), (6,8), (7,20), (8,18), (9,9), (10,0);

    /* ==========================
       Pedidos
       ========================== */
    INSERT INTO Pedidos (ClienteID,Estado,Total)
    VALUES
    (1,'Entregado',875), (2,'Entregado',975), (3,'Enviado',245), (4,'Pendiente',325),
    (5,'Procesando',120), (1,'Entregado',55), (2,'Enviado',220), (3,'Entregado',90);

    /* ==========================
       Detalles del Pedido
       ========================== */
    INSERT INTO Detalles_Pedido (PedidoID,ProductoID,Cantidad,PrecioUnitario)
    VALUES
    (1,1,1,850), (1,3,1,25), (2,2,1,950), (2,3,1,25), (3,5,1,220), (3,3,1,25),
    (4,9,1,300), (4,3,1,25);

    COMMIT TRANSACTION;
    PRINT 'Datos insertados correctamente.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error durante la inserción de datos.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

/* ============================================================
   Verificación de la carga de datos
   ============================================================ */
SELECT COUNT(*) AS TotalClientes FROM Clientes;
SELECT COUNT(*) AS TotalCategorias FROM Categorias;
SELECT COUNT(*) AS TotalProveedores FROM Proveedores;
SELECT COUNT(*) AS TotalProductos FROM Productos;
SELECT COUNT(*) AS TotalInventario FROM Inventario;
SELECT COUNT(*) AS TotalPedidos FROM Pedidos;
SELECT COUNT(*) AS TotalDetallesPedido FROM Detalles_Pedido;
GO
