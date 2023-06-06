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

--8-Dame los nombres de los Proveedores asi como el nombre y la cantidad de los articulos que han Proveido 

select p.Nombre, cp.Cantidad, pr.Nombre
from CompraAProveedor cp
inner join Producto p on cp.UPC = p.UPC
inner join Proveedor pr on cp.ID_Proveedor = pr.ID_Proveedor

--9-La cantidad total de inventario que tiene cada almacen

select a.ID_Almacen,
sum(i.Existencia) as TotalInventario
from Almacen a
inner join Inventario i on a.ID_Almacen = i.ID_Almacen
group by a.ID_Almacen, a.Nombre
order by TotalInventario asc;

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

select z.ID_Zona, count(c.ID_Cedis) as Numero_de_Cedis
from Zona z
inner join Almacen a on z.ID_Zona = a.ID_Zona
inner join Cedis c on a.ID_Almacen = c.ID_Almacen
group by z.ID_Zona, z.Nombre
order by Numero_de_Cedis desc

--15- Se requiere consultar cual es la cantidad de pedidos hechos por cada tipo de cliente
select tc.Nombre as TipoCliente, count(*) as NumPedidos
from Pedido p
inner join Cliente c on p.ID_Cliente = c.ID_Cliente
inner join Tipodecliente tc on c.ID_Tipodecliente = tc.ID_Tipodecliente
group by tc.Nombre
order by NumPedidos desc

--16- Se requiere consultar cual es la cantidad de ordenes de pedidos totales durante cada mes
select datepart(month, Fecha) as Mes, count(*) as CantidadDeOrdenes
from Pedido
group by datepart(month, Fecha)
order by Mes 

--17- Se requiere consultar que cantidad total de componentesactivos esta siendo distribuida por cada uno de los distribuidores

select P.Nombre as Proveedor, CA.Nombre as ComponenteActivo, sum(CAP.Cantidad) as CantidadTotal
from Proveedor P
inner join CompraAProveedor CAP on CAP.ID_Proveedor = P.ID_Proveedor
inner join Componenteactivo CA on CA.ID_Componenteactivo = CA.ID_Componenteactivo
group by P.Nombre, CA.Nombre
order by P.Nombre, CantidadTotal asc;

--18- Cual es el almacen que cuenta con mayor cantidad de empleados 
select a.Nombre AS Almacen, count(e.ID_Empleado) as Empleados
from Almacen a
inner join Empleado e ON a.ID_Almacen = e.ID_Almacen
group by a.Nombre
having count(e.ID_Empleado) = (select max(NumEmpleados) from (
    select a.ID_Almacen, count(e.ID_Empleado) as NumEmpleados
    from Almacen a
    inner join Empleado e on a.ID_Almacen = e.ID_Almacen
    group by a.ID_Almacen
) t)

--19- Se desea consultar todos aquellos clientes que poseen un credito mayor o igual a las 7500 Unidades

select Cliente.Nombre, Cliente.ApellidoPaterno, Cliente.ApellidoMaterno from Cliente
where Cliente.Credito >= '7500' 

--20- Se requiere saber el Precio de Venta de cada Producto 

select P.UPC,  P.PrecioVenta
from Producto P

--21- Se quiere consultar cual es la presencia Total de todos los componentes activos en los distintos Productos que tenemos
select c.Nombre AS ComponenteActivo, count(distinct p.UPC) as UPC_Count
from Producto p
inner join Componenteactivo c on p.ID_Componenteactivo = c.ID_Componenteactivo
group by p.ID_Componenteactivo, c.Nombre
having count(distinct p.UPC) > 1

--22- Se require consultar la cantidad total de pedidos de cada mes con los cuales se ha pagado con el formato de pago tarjeta
select month(Fecha) as Mes, count(*) as NumeroPedidos
from Pedido
where ID_Formatodepago = (select ID_Formatodepago from Formatodepago where Nombre = 'Tarjeta')
group by month(Fecha)
order by NumeroPedidos desc

--23- Se desea consultar el telefono de todos los empleados del Cedis 1 , Posdata se me olvido insertarle el Telefono a los Empleados en los Datos

select Empleado.Telefono
from Empleado
inner join Almacen on Empleado.ID_Almacen = Almacen.ID_Almacen
inner join Cedis on Almacen.ID_Almacen = Cedis.ID_Almacen
where Cedis.ID_Cedis = 1

--24- Se desea consultar todo lo que se pago a proovedores durante el transcurso de todo el mes de Mayo de 2022

select sum(CostoTotal) as PagoAProveedoresMayo2022
from CompraAProveedor
where Fecha between '2022-05-01' and '2022-05-31'

--25-Se desea Tener la Cantidad Total de Productos con un precio mayor a las $900 Unidades que hay distribuidos en todos los Almacenes de cada Zona

select Zona.Nombre as Zona, sum(Inventario.Existencia) AS TotalDeProductos
from Zona
inner join Almacen on Zona.ID_Zona = Almacen.ID_Zona
inner join Inventario on Almacen.ID_Almacen = Inventario.ID_Almacen
inner join Producto on Inventario.UPC = Producto.UPC
where Producto.PrecioVenta > 900
group by Zona.Nombre

--26- Cual es el Metodo De Pago mas usado por Clientes de tipo Domestico

select top 1 f.Nombre as MetodoDePago, count(*) as Cantidad
from Pedido p
inner join Cliente c on p.ID_Cliente = c.ID_Cliente
inner join Formatodepago f on p.ID_Formatodepago = f.ID_Formatodepago
inner join Tipodecliente t on c.ID_Tipodecliente = t.ID_Tipodecliente
where t.Nombre = 'Domestico'
group by f.Nombre
order by Cantidad desc;

--27- Se desea consultar Las unidades totales vendidas de cada Familia de Productos

select 
    f.FamiliaNombre, 
    sum(d.Cantidad) as UnidadesTotalesVendidas
from 
    Producto p 
    inner join Detalle d on p.UPC = d.UPC 
    inner join Familia f on p.ID_Familia = f.ID_Familia 
group by
    f.FamiliaNombre 
order by
    sum(d.Cantidad) desc 

--28- Cual es el Tipo de entrega mas frecuente para Clientes de tipo Domestico

select top 1 e.Nombre, COUNT(*) as Cantidad
from Entrega as en
inner join Tipodeentrega as e on en.ID_Tipodeentrega = e.ID_Tipodeentrega
inner join Pedido as p on en.ID_Pedido = p.ID_Pedido
inner join Cliente as c on p.ID_Cliente = c.ID_Cliente
inner join Tipodecliente as tc on c.ID_Tipodecliente = tc.ID_Tipodecliente
where tc.Nombre = 'Domestico'
group by e.Nombre
order by Cantidad desc;
--29- Se desea consultar cual ha sido la Sucursal que mas ha echo pedidos 
select top 1 s.ID_Sucursal, count(*)  NumPedidos
from Pedido p
inner join Sucursal s on p.ID_Sucursal = s.ID_Sucursal
group by s.ID_Sucursal
order by NumPedidos desc;

--30-Los clientes que han comprado Productos provenientes de la familia 'Herbicidas' asi como las veces que lo han comprado
select c.Nombre, count(*) as Cantidadcomprada
from Cliente c
inner join Pedido p on c.ID_Cliente = p.ID_Cliente
inner join Detalle d on p.ID_Pedido = d.ID_Pedido
inner join Producto pr on d.UPC = pr.UPC
inner join Familia f on pr.ID_Familia = f.ID_Familia
where f.FamiliaNombre = 'Herbicidas'
group by c.Nombre

