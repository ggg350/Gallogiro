use GalloGiro
--Procedimientos Almacenados
go
CREATE PROCEDURE InsertarTrasladoInventario
(
    @ID_AlmacenOrigen int,
    @ID_AlmacenDestino int,
    @UPC int,
    @Cantidad int,
    @Fecha date
)
AS
BEGIN
    IF EXISTS (         --Una Sucursal no puede enviar a otra Sucursal
        SELECT 1
        FROM Almacen A1
        INNER JOIN Almacen A2 ON A1.ID_Zona = A2.ID_Zona
        WHERE A1.ID_Almacen = @ID_AlmacenOrigen AND A2.ID_Almacen = @ID_AlmacenDestino
          AND A1.ID_Almacen <> A2.ID_Almacen
    )
    BEGIN
        RAISERROR('No se permite enviar de un almacén de una sucursal a otro almacén de otra sucursal.', 16, 1);
        RETURN;
    END;
    -- Restar existencias del AlmacenOrigen
    UPDATE Inventario
    SET Existencia = Existencia - @Cantidad
    WHERE ID_Almacen = @ID_AlmacenOrigen AND UPC = @UPC;

    -- Verificar si existen suficientes existencias en el AlmacenOrigen
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('No hay suficientes existencias en el AlmacenOrigen.', 16, 1);
        RETURN;
    END;

    -- Agregar existencias al AlmacenDestino
    UPDATE Inventario
    SET Existencia = Existencia + @Cantidad
    WHERE ID_Almacen = @ID_AlmacenDestino AND UPC = @UPC;

    -- Verificar si la inserción fue exitosa en el AlmacenDestino
    IF @@ROWCOUNT = 0
    BEGIN
        -- Revertir la resta en el AlmacenOrigen
        UPDATE Inventario
        SET Existencia = Existencia + @Cantidad
        WHERE ID_Almacen = @ID_AlmacenOrigen AND UPC = @UPC;

        RAISERROR('No se pudo agregar existencias en el AlmacenDestino.', 16, 1);
        RETURN;
    END;

    -- Declarar la variable @ID_TrasladoInventario
    DECLARE @ID_TrasladoInventario int;

    -- Asignar un valor a la variable @ID_TrasladoInventario
    SET @ID_TrasladoInventario = (SELECT ISNULL(MAX(ID_TrasladoInventario), 0) + 1 FROM TrasladoInventario);

    -- Insertar el registro en la tabla TrasladoInventario
    INSERT INTO TrasladoInventario (ID_TrasladoInventario, ID_AlmacenOrigen, ID_AlmacenDestino, UPC, Cantidad, Fecha)
    VALUES (@ID_TrasladoInventario, @ID_AlmacenOrigen, @ID_AlmacenDestino, @UPC, @Cantidad, @Fecha);

    IF @@ROWCOUNT = 0
    BEGIN
        -- Revertir la resta en el AlmacenOrigen
        UPDATE Inventario
        SET Existencia = Existencia + @Cantidad
        WHERE ID_Almacen = @ID_AlmacenOrigen AND UPC = @UPC;

        -- Revertir la suma en el AlmacenDestino
        UPDATE Inventario
        SET Existencia = Existencia - @Cantidad
        WHERE ID_Almacen = @ID_AlmacenDestino AND UPC = @UPC;

        RAISERROR('No se pudo insertar el registro en la tabla TrasladoInventario.', 16, 1);
    END;
END;
go
