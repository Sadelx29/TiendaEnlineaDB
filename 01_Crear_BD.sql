/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Participante 1: Diseño e Implementación de la Base de Datos
   Script: 01_Crear_BD.sql
   Base de datos: TiendaOnline
   ============================================================ */

-- Crear la base de datos
IF DB_ID('TiendaOnline') IS NOT NULL
BEGIN
    ALTER DATABASE TiendaOnline SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TiendaOnline;
END
GO

CREATE DATABASE TiendaOnline;
GO

USE TiendaOnline;
GO

/* ============================================================
   Tabla: Clientes
   ============================================================ */
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Telefono VARCHAR(20) NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);
GO

/* ============================================================
   Tabla: Categorias
   ============================================================ */
CREATE TABLE Categorias (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(100) NOT NULL UNIQUE
);
GO

/* ============================================================
   Tabla: Proveedores
   ============================================================ */
CREATE TABLE Proveedores (
    ProveedorID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProveedor VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20) NULL,
    Email VARCHAR(100) NULL UNIQUE,
    Direccion VARCHAR(200) NULL
);
GO

/* ============================================================
   Tabla: Productos
   ============================================================ */
CREATE TABLE Productos (
    ProductoID INT IDENTITY(1,1) PRIMARY KEY,
    CategoriaID INT NOT NULL,
    ProveedorID INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Caracteristicas NVARCHAR(MAX) NULL,

    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    CONSTRAINT FK_Productos_Proveedores FOREIGN KEY (ProveedorID) REFERENCES Proveedores(ProveedorID),
    CONSTRAINT CK_Productos_Precio CHECK (Precio > 0),
    CONSTRAINT CK_Productos_Caracteristicas_JSON CHECK (Caracteristicas IS NULL OR ISJSON(Caracteristicas) = 1)
);
GO

/* ============================================================
   Tabla: Inventario
   ============================================================ */
CREATE TABLE Inventario (
    InventarioID INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT NOT NULL UNIQUE,
    Stock INT NOT NULL,
    FechaActualizacion DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Inventario_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT CK_Inventario_Stock CHECK (Stock >= 0)
);
GO

/* ============================================================
   Tabla: Pedidos
   ============================================================ */
CREATE TABLE Pedidos (
    PedidoID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaPedido DATETIME NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    Total DECIMAL(10,2) NOT NULL DEFAULT 0,

    CONSTRAINT FK_Pedidos_Clientes FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    CONSTRAINT CK_Pedidos_Total CHECK (Total >= 0),
    CONSTRAINT CK_Pedidos_Estado CHECK (Estado IN ('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado'))
);
GO

/* ============================================================
   Tabla: Detalles_Pedido
   ============================================================ */
CREATE TABLE Detalles_Pedido (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID INT NOT NULL,
    ProductoID INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_DetallesPedido_Pedidos FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    CONSTRAINT FK_DetallesPedido_Productos FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    CONSTRAINT CK_DetallesPedido_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CK_DetallesPedido_PrecioUnitario CHECK (PrecioUnitario > 0)
);
GO

/* ============================================================
   Verificación de tablas creadas
   ============================================================ */
SELECT TABLE_NAME AS Tabla FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' ORDER BY TABLE_NAME;
GO
