USE master;
GO



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
