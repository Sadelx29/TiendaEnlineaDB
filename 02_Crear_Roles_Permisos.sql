/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Participante 2: Seguridad y Carga de Datos
   Script: 02_Crear_Roles_Permisos.sql
   Base de datos: TiendaOnline
   ============================================================ */

USE TiendaOnline;
GO

/* ============================================================
   Eliminar roles si existen (permite ejecutar el script varias veces)
   ============================================================ */
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Gerente')
    DROP ROLE Gerente;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Vendedor')
    DROP ROLE Vendedor;
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Cliente')
    DROP ROLE Cliente;
GO

/* ============================================================
   Creación de Roles
   ============================================================ */
CREATE ROLE Gerente;
GO

CREATE ROLE Vendedor;
GO

CREATE ROLE Cliente;
GO

/* ============================================================
   Permisos para Gerente
   Acceso completo a todas las tablas.
   ============================================================ */
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Gerente;
GO

/* ============================================================
   Permisos para Vendedor
   Puede consultar clientes y productos.
   Puede registrar y actualizar pedidos.
   ============================================================ */
GRANT SELECT ON Clientes TO Vendedor;
GO
GRANT SELECT ON Productos TO Vendedor;
GO
GRANT INSERT, UPDATE ON Pedidos TO Vendedor;
GO
GRANT INSERT, UPDATE ON Detalles_Pedido TO Vendedor;
GO

/* ============================================================
   Permisos para Cliente
   Solo puede consultar productos y categorías.
   ============================================================ */
GRANT SELECT ON Productos TO Cliente;
GO
GRANT SELECT ON Categorias TO Cliente;
GO

/* ============================================================
   Verificación de Roles
   ============================================================ */
SELECT name AS Rol FROM sys.database_principals WHERE type = 'R' ORDER BY name;
GO
