use gallogiro
go
--1-Dame los 5 componentes activos que estan mas presentes en los productos que mas se venden al cliente
select top 5
    Componenteactivo.Nombre as ComponenteActivo,  
	sum(Detalle.Cantidad) as TotalVentas
from 
    Producto
    inner join Componenteactivo on Producto.ID_Componenteactivo = Componenteactivo.ID_Componenteactivo
    inner join Detalle on Producto.UPC = Detalle.UPC
group by Componenteactivo.Nombre
order by TotalVentas desc;

--2-Muestrame el total de existencias juntando todos los productos de cada centro de distribucion 
select c.ID_Cedis, sum(i.Existencia) as TotalDeProductos
from Cedis c
inner join Almacen A on C.ID_Almacen = A.ID_Almacen
inner join Inventario I on A.ID_Almacen = I.ID_Almacen
group by C.ID_Cedis

--3-Muestrame el nombre de todos los productos que tiene el Almacen 7 asi como las existencias de cada producto
select Producto.Nombre, Inventario.Existencia 
from Producto 
inner join Inventario on Producto.UPC = Inventario.UPC 
where Inventario.ID_Almacen = 1

--4-Muestrame todos los proveedores que han proveido el producto que lleva el UPC '329702025'

select Proveedor.Nombre 
from Proveedor 
inner join CompraAProveedor on Proveedor.ID_Proveedor = CompraAProveedor.ID_Proveedor 
where CompraAProveedor.UPC = 329702025

--5-Se desea saber que Municipios conforman la Zona numero 5

select Municipio.Nombre from Municipio 
inner join Zona on Municipio.ID_Zona = Zona.ID_Zona
where Zona.ID_Zona = 5;

--6-Cual fue la cantidad de pedidos totales echos durante el mes de junio del 2022

select count(*) as PedidosMesDeJunio
from Pedido
where Fecha between '2022-06-01' and '2022-06-30';

--7-Todos los empleados de sucursales asi como en la sucursal en la cual trabajan
select e.Nombre as Empleado, s.ID_Sucursal as Sucursal
from Empleado e
inner join Almacen a on e.ID_Almacen = a.ID_Almacen
inner join Sucursal s on a.ID_Almacen = s.ID_Almacen;

--8-Los clientes que han comprado Productos provenientes de la familia 'Herbicidas' asi como las veces que lo han comprado
select c.Nombre, count(*) as Cantidadcomprada
from Cliente c
inner join Pedido p on c.ID_Cliente = p.ID_Cliente
inner join Detalle d on p.ID_Pedido = d.ID_Pedido
inner join Producto pr on d.UPC = pr.UPC
inner join Familia f on pr.ID_Familia = f.ID_Familia
where f.FamiliaNombre = 'Herbicidas'
group by c.Nombre

--9-La cantidad total de inventario que tiene cada almacen

select a.ID_Almacen,
sum(i.Existencia) as Cantidad_Inventario
from Almacen a
inner join Inventario i on a.ID_Almacen = i.ID_Almacen
group by a.ID_Almacen, a.Nombre
order by Cantidad_Inventario asc;

--10-El formato de pago que es mas utilizado en los productos que contienen el ID_Familia 1
select top 1 f.Nombre, count(*) as cantidad
from Pedido p
inner join Detalle d on p.ID_Pedido = d.ID_Pedido
inner join Producto pr ON d.UPC = pr.UPC
inner join Formatodepago f ON p.ID_Formatodepago = f.ID_Formatodepago
where pr.ID_Familia = 1
group by f.Nombre
order by cantidad desc

--11- La sucursal que mas ha realizado pedidos
select top 1 s.ID_Sucursal, count(*)  NumPedidos
from Pedido p
inner join Sucursal s on p.ID_Sucursal = s.ID_Sucursal
group by s.ID_Sucursal
order by NumPedidos desc;

--12- Se desea consultar cual es la cantidad de pedidos que han sido pagados con los diversos formatos de pago
select f.Nombre as FormatoDePago, count(*) as TotalPedidos
from Pedido p
inner join Formatodepago f on p.ID_Formatodepago = f.ID_Formatodepago
group by f.Nombre
order by TotalPedidos desc

--13- Se desea consultar cuales son los 5 Productos que mas se venden

select top 5 UPC, sum(Cantidad) as TotalVentas
from Detalle
group by UPC
order by TotalVentas desc

--14- Se quiere consultar cual es la cantidad total de CEDIS que se encuentra en cada Zona 

select z.ID_Zona, COUNT(c.ID_Cedis) as Numero_de_Cedis
from Zona z
inner join Almacen a on z.ID_Zona = a.ID_Zona
inner join Cedis c on a.ID_Almacen = c.ID_Almacen
group by z.ID_Zona, z.Nombre
order by Numero_de_Cedis desc

--15- Se requiere consultar cual es la cantidad de pedidos hechos por cada tipo de cliente
select tc.Nombre AS TipoCliente, count(*) as NumPedidos
FROM Pedido p
INNER JOIN Cliente c ON p.ID_Cliente = c.ID_Cliente
INNER JOIN Tipodecliente tc ON c.ID_Tipodecliente = tc.ID_Tipodecliente
GROUP BY tc.Nombre
ORDER BY NumPedidos DESC