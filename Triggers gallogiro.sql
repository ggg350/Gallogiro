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