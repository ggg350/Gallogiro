use GalloGiro
go

CREATE TRIGGER DetallePedido
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


