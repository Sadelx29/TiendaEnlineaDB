/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Script: 04_Consultas_Complejas.sql
   ============================================================ */

USE TiendaOnline;
GO

/*Clientes con más compras*/
/*==========================
Muestra cada cliente con el número de pedidos realizados y el total
gastado, ordenado de mayor a menor gasto. Excluye pedidos cancelados.
============================*/
SELECT 
    C.ClienteID,
    C.Nombre,
    C.Email,
    COUNT(P.PedidoID) AS TotalPedidos,
    SUM(P.Total) AS TotalGastado
FROM Clientes C
INNER JOIN Pedidos P ON C.ClienteID = P.ClienteID
WHERE P.Estado != 'Cancelado'
GROUP BY C.ClienteID, C.Nombre, C.Email
ORDER BY TotalGastado DESC;
GO

/*Productos sin inventario*/
/*==========================
Lista los productos con stock en cero, incluyendo
su categoría y proveedor para facilitar la reposición.
============================*/
SELECT 
    P.ProductoID,
    P.Nombre,
    P.Precio,
    C.NombreCategoria,
    PR.NombreProveedor,
    I.Stock
FROM Productos P
INNER JOIN Inventario I ON P.ProductoID   = I.ProductoID
INNER JOIN Categorias C ON P.CategoriaID  = C.CategoriaID
INNER JOIN Proveedores PR ON P.ProveedorID  = PR.ProveedorID
WHERE I.Stock = 0
ORDER BY C.NombreCategoria;
GO

/*Ingresos por mes*/
/*==========================
Agrupa los ingresos por año y mes, mostrando el total de pedidos, los ingresos generados
y el promedio por pedido. Excluye pedidos cancelados y pendientes.
============================*/
SELECT 
    YEAR(FechaPedido) AS Anio,
    MONTH(FechaPedido) AS Mes,
    DATENAME(MONTH, FechaPedido) AS NombreMes,
    COUNT(PedidoID) AS TotalPedidos,
    SUM(Total) AS IngresoTotal,
    AVG(Total) AS PromedioporPedido
FROM Pedidos
WHERE Estado NOT IN ('Cancelado', 'Pendiente')
GROUP BY 
    YEAR(FechaPedido), 
    MONTH(FechaPedido), 
    DATENAME(MONTH, FechaPedido)
ORDER BY Anio, Mes;
GO

/*Productos más vendidos*/
/*==========================
Muestra los productos ordenados por unidades vendidas, 
junto con el ingreso total que ha generado cada uno.
============================*/
SELECT 
    P.ProductoID,
    P.Nombre,
    C.NombreCategoria,
    P.Precio,
    SUM(DP.Cantidad) AS UnidadesVendidas,
    SUM(DP.Cantidad * DP.PrecioUnitario) AS IngresoGenerado
FROM Productos P
INNER JOIN Detalles_Pedido DP ON P.ProductoID  = DP.ProductoID
INNER JOIN Pedidos PD ON DP.PedidoID   = PD.PedidoID
INNER JOIN Categorias C ON P.CategoriaID = C.CategoriaID
WHERE PD.Estado NOT IN ('Cancelado')
GROUP BY P.ProductoID, P.Nombre, C.NombreCategoria, P.Precio
ORDER BY UnidadesVendidas DESC;
GO

/*Búsqueda con JSON*/
/*==========================
Extrae los atributos almacenados en el campo JSON Caracteristicas, específicamente la marca 
y la RAM de cada producto, combinándolos con su categoría y stock disponible.
============================*/
SELECT 
    P.ProductoID,
    P.Nombre,
    P.Precio,
    C.NombreCategoria,
    JSON_VALUE(P.Caracteristicas, '$.Marca') AS Marca,
    JSON_VALUE(P.Caracteristicas, '$.RAM') AS RAM,
    I.Stock
FROM Productos P
INNER JOIN Categorias C  ON P.CategoriaID = C.CategoriaID
INNER JOIN Inventario I  ON P.ProductoID  = I.ProductoID
WHERE 
    P.Caracteristicas IS NOT NULL
    AND ISJSON(P.Caracteristicas) = 1
ORDER BY C.NombreCategoria, P.Nombre;
GO
