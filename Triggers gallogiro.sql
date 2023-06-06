use GalloGiro
go

--CREATE TRIGGER DetallePedido FUNCION REMPLAZA EN EL PROCEDIMIENTO ALMACENADO DE CREACIONDEPEDIDO
ON Detalle
AFTER INSERT
AS
BEGIN
  UPDATE Detalle
  SET PrecioFinal = p.PrecioVenta * i.cantidad
  FROM Detalle d
  INNER JOIN inserted i ON d.ID_Pedido = i.ID_Pedido
  INNER JOIN Producto p ON d.UPC = p.UPC
 END
 -------------------------------------------------------------------------
 go
create trigger ComprasAProveedor
on CompraAProveedor
for insert
as
begin
    update Inventario
    set Existencia = Existencia + inserted.Cantidad
    from Inventario i
    inner join inserted on I.ID_Almacen = (select ID_Almacen from Cedis where ID_Cedis = inserted.ID_Cedis)
                          and I.UPC = inserted.UPC		  
end

--Test ComprasAProveedor
--select * from Inventario where ID_Almacen=1 and UPC=808838419
--insert into CompraAProveedor (UPC, ID_Proveedor, Cantidad, CostoTotal, Fecha, ID_Cedis) values (808838419, 1, 469, '$403.22', '2/24/2023', 1);
--------------------------------------------------------------------------------------------------------------------------------------------------
go
create trigger trasladotrigger
on trasladoinventario
instead of insert
as
begin
    if exists (
        select 1
        from inserted i
        inner join almacen a1 on i.id_almacenorigen = a1.id_almacen
        inner join almacen a2 on i.id_almacendestino = a2.id_almacen
        where a1.id_zona = a2.id_zona
    )
    begin
        raiserror('No puedes trasladar a una Zona diferente a la tuya', 16, 1); rollback transaction; 
    end
    else
    begin
        insert into trasladoinventario (id_trasladoinventario, id_almacenorigen, id_almacendestino, upc, cantidad, fecha)
        select id_trasladoinventario, id_almacenorigen, id_almacendestino, upc, cantidad, fecha from inserted;
    end
end;
go
create Trigger AlmacenSucursalExiste
on Sucursal
after insert
as
	declare @ID_Almacen int
select @ID_Almacen=id_almacen from inserted

	if exists (select*from Almacen a inner join CEDIS c on c.ID_Almacen=a.ID_Almacen where c.ID_Almacen=(select @ID_Almacen))
	begin
		raiserror('Almacen ya usado en Cedis',16,1)
		rollback tran
		return
	end
------------------------------------------------------------------------------------------------------------------------------------------------
go
create trigger AlmacenCedisExiste
On Sucursal 
after insert
as
	declare @ID_Almacen int
select @ID_Almacen=id_almacen from inserted
	if exists (select*from Almacen a inner join CEDIS c on c.ID_Almacen=a.ID_Almacen where c.ID_Almacen=(select @ID_Almacen))
	begin
		raiserror('Almacen ya usado en Sucursal',16,1)
		rollback tran
		return
	end
go
create trigger detallecompra
on detalle
instead of insert
as
begin
    if exists (select 1
        from inserted i
        inner join almacen a on i.id_almacen = a.id_almacen
        inner join cedis c on a.id_almacen = c.id_almacen)
    begin
        raiserror('No puedes comprar en un CEDIS', 16, 1);
        rollback transaction; end
    else begin
        insert into detalle (id_pedido, upc, cantidad, preciofinal, id_almacen)
        select id_pedido, upc, cantidad, preciofinal, id_almacen
        from inserted;
    end
end;
go


