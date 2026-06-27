/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Script: 05_Indices_Optimizacion.sql
   Base de datos: TiendaOnline
   Objetivo: Crear índices para optimizar las consultas y mostrar
             el análisis del plan de ejecución.
   ============================================================ */

USE TiendaOnline;
GO

/* 
   Optimización 1: Consultas que agrupan y filtran pedidos 
   (Clientes con más compras & Ingresos por mes)
*/
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Pedidos_Estado_Cliente')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Pedidos_Estado_Cliente
    ON Pedidos(Estado, ClienteID)
    INCLUDE (Total, FechaPedido);
    PRINT 'Índice IX_Pedidos_Estado_Cliente creado exitosamente.';
END
GO

/* 
   Optimización 2: Búsqueda rápida de productos sin stock 
   (Productos sin inventario)
*/
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Inventario_Stock')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Inventario_Stock
    ON Inventario(Stock)
    INCLUDE (ProductoID);
    PRINT 'Índice IX_Inventario_Stock creado exitosamente.';
END
GO

/* 
   Optimización 3: Optimizar Joins de ventas por producto
   (Productos más vendidos)
*/
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_DetallesPedido_Producto')
BEGIN
    CREATE NONCLUSTERED INDEX IX_DetallesPedido_Producto
    ON Detalles_Pedido(ProductoID)
    INCLUDE (PedidoID, Cantidad, PrecioUnitario);
    PRINT 'Índice IX_DetallesPedido_Producto creado exitosamente.';
END
GO

/* 
   Optimización 4: Optimizar búsqueda de productos por categoría
   (Búsqueda con JSON y agrupaciones varias)
*/
IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = N'IX_Productos_Categoria')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Productos_Categoria
    ON Productos(CategoriaID)
    INCLUDE (Nombre, Precio, ProveedorID);
    PRINT 'Índice IX_Productos_Categoria creado exitosamente.';
END
GO
