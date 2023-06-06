use GalloGiro
--Procedimientos Almacenados 
--1
go
CREATE PROCEDURE CrearPedidoEntregaa
    @ID_Cliente int,
    @ID_Almacen int,
    @ID_Sucursal int,
    @UPC int,
    @Cantidad int
as
begin
    set coconut on;
    begin transaction;
    declare @ID_Pedido int;
    select @ID_Pedido = max(ID_Pedido) + 1 from Pedido; 
    declare @ID_Entrega int;
	select @ID_Entrega = max(ID_Entrega) + 1 from Entrega;
	insert into Pedido (ID_Pedido, ID_Entrega, ID_Cliente, ID_Sucursal, Fecha)
    values (@ID_Pedido, @ID_Entrega, @ID_Cliente, @ID_Sucursal, GETDATE());
    insert into Entrega (ID_Entrega,ID_Almacen, ID_Pedido)
    values (@ID_Entrega,@ID_Almacen, @ID_Pedido);
    update Pedido
    set ID_Entrega = @ID_Entrega
    where ID_Pedido = @ID_Pedido;
    declare @CostoTotal money, @PrecioFinal money;
    select @CostoTotal = P.PrecioVenta * @Cantidad,
           @PrecioFinal = P.PrecioVenta
    from Producto P
    where P.UPC = @UPC;
    insert into Detalle (ID_Pedido, UPC, Cantidad, PrecioFinal, ID_Almacen)
    values (@ID_Pedido, @UPC, @Cantidad, @PrecioFinal, @ID_Almacen);
--------------------------------------------------------- inventario descontar
    update Inventario
    set Existencia = Existencia - @Cantidad
    where ID_Almacen = @ID_Almacen AND UPC = @UPC;
    commit;
    select @ID_Pedido AS ID_Pedido, @ID_Entrega AS ID_Entrega;
end

go
--2
--create procedure InsertarTrasladoInventario
(
    @ID_AlmacenOrigen int,
    @ID_AlmacenDestino int,
    @UPC int,
    @Cantidad int,
    @Fecha date
)
as
begin
    if exists (
        select 1
        from Almacen A1
        inner join Almacen A2 ON A1.ID_Zona <> A2.ID_Zona
        where A1.ID_Almacen = @ID_AlmacenOrigen and A2.ID_Almacen = @ID_AlmacenDestino
    )
    begin
        raiserror('No pertenece a la misma zona', 16, 1);
        return;
    end;
	update Inventario set Existencia = Existencia - @Cantidad
    where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
    if  @@rowcount = 0
    begin
        raiserror('No hay suficiente cantidad de existencia para cumplir el traslado', 16, 1);
        return; end;
    update Inventario
    set Existencia = Existencia + @Cantidad
    where ID_Almacen = @ID_AlmacenDestino AND UPC = @UPC;
    if @@rowcount = 0
    begin
        update Inventario
        set Existencia = Existencia + @Cantidad
        where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
        raiserror('error no es posible terminar el traslado', 16, 1);
        return;
    end;
    declare @ID_TrasladoInventario int;
    set @ID_TrasladoInventario = (select isnull(max(ID_TrasladoInventario), 0) + 1 from TrasladoInventario);
    insert into TrasladoInventario (ID_TrasladoInventario, ID_AlmacenOrigen, ID_AlmacenDestino, UPC, Cantidad, Fecha)
    values (@ID_TrasladoInventario, @ID_AlmacenOrigen, @ID_AlmacenDestino, @UPC, @Cantidad, @Fecha);

    if @@rowcount = 0
    begin
        update Inventario
        set Existencia = Existencia + @Cantidad
        where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
        update Inventario
        set Existencia = Existencia - @Cantidad
        where ID_Almacen = @ID_AlmacenDestino and UPC = @UPC;
        raiserror('No se pudo insertar el registro en la tabla TrasladoInventario.', 16, 1);
        return;
    end;
end;
go
create procedure InsertarTrasladoInventariof
(
    @ID_AlmacenOrigen int,
    @ID_AlmacenDestino int,
    @UPC int,
    @Cantidad int,
    @Fecha date
)
as
begin
    if exists ( select 1 from Almacen A1
        inner join Almacen A2 ON A1.ID_Zona <> A2.ID_Zona  where A1.ID_Almacen = @ID_AlmacenOrigen AND A2.ID_Almacen = @ID_AlmacenDestino)
    begin
        raiserror('Zona diferente , no puedes enviar a un almacen lejano', 16, 1);
        return;
    end;
    update Inventario
    set Existencia = Existencia - @Cantidad
    where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
    if @@rowcount = 0
    begin raiserror('Faltan unidades para cumplir el traslado', 16, 1);
        return;end;
    update Inventario
    set Existencia = Existencia + @Cantidad
    where ID_Almacen = @ID_AlmacenDestino and UPC = @UPC;
    if @@rowcount = 0
    begin
        update Inventario
        set Existencia = Existencia + @Cantidad
        where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
        raiserror('error', 16, 1);
        return;
    end;

    declare @ID_TrasladoInventario int;
    set @ID_TrasladoInventario = (select isnull(max(ID_TrasladoInventario), 0) + 1 from TrasladoInventario);
    insert into TrasladoInventario (ID_TrasladoInventario, ID_AlmacenOrigen, ID_AlmacenDestino, UPC, Cantidad, Fecha)
    values (@ID_TrasladoInventario, @ID_AlmacenOrigen, @ID_AlmacenDestino, @UPC, @Cantidad, @Fecha);
    if @@rowcount = 0
    begin
        update Inventario set Existencia = Existencia + @Cantidad
        where ID_Almacen = @ID_AlmacenOrigen and UPC = @UPC;
        update Inventario
        set Existencia = Existencia - @Cantidad
        where ID_Almacen = @ID_AlmacenDestino and UPC = @UPC;
        raiserror('Traslado no se ha podido completar', 16, 1);
        return;
    end;
end;

go
create procedure InsertarCredito
    @ID_Cliente int,
    @Cantidad money,
    @FechaInicio date,
    @FechaFinal date
as
begin
    set nocount on;
    begin transaction;
    insert into Credito (ID_Cliente, Cantidad, FechaInicio, FechaFinal)
    values (@ID_Cliente, @Cantidad, @FechaInicio, @FechaFinal);
    update Cliente
    set Credito = Credito + @Cantidad
    where ID_Cliente = @ID_Cliente;
    commit transaction;
end;

select * from Credito