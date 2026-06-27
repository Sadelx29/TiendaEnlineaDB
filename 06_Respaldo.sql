/* ============================================================
   Proyecto Final - Taller de Bases de Datos 2
   Script: 06_Respaldo.sql
   Base de datos: TiendaOnline
   Objetivo: Generar el archivo .bak
   ============================================================ */

USE master;
GO

-- ============================================================
-- NOTA IMPORTANTE PARA EL CONTENEDOR DOCKER
-- ============================================================
-- Como estás ejecutando SQL Server en un contenedor Docker (Linux), 
-- la ruta de respaldo debe usar formato Linux y apuntar a un directorio
-- existente dentro del contenedor, por defecto: /var/opt/mssql/data/
--
-- Para extraer el archivo .bak a tu máquina anfitriona (tu PC), puedes usar:
-- docker cp <id_del_contenedor>:/var/opt/mssql/data/TiendaOnline.bak ./TiendaOnline.bak
-- ============================================================

DECLARE @BackupPath NVARCHAR(500) = '/var/opt/mssql/data/'; 
DECLARE @BackupFile NVARCHAR(500) = @BackupPath + 'TiendaOnline.bak';

PRINT 'Iniciando respaldo de la base de datos TiendaOnline...'
PRINT 'Ruta destino dentro del contenedor: ' + @BackupFile;

BEGIN TRY
    BACKUP DATABASE TiendaOnline
    TO DISK = @BackupFile
    WITH 
        FORMAT,          -- Crea un nuevo conjunto de medios, sobrescribe archivos existentes
        INIT,            -- Inicializa el archivo
        NAME = 'Respaldo Completo de la BD TiendaOnline',
        SKIP,            
        NOREWIND, 
        NOUNLOAD, 
        STATS = 10;      -- Muestra progreso en consola cada 10%

    PRINT '========================================='
    PRINT 'Respaldo completado con éxito.'
    PRINT '========================================='
END TRY
BEGIN CATCH
    PRINT 'Ocurrió un error al intentar crear el respaldo.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO
