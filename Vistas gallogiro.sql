USE GalloGiro
go
--Vistas
--1 El Gerente General de distribución de gallogiro requiere de una Vista General de Inventarios de la Empresa , Teniendo en ella la Existencia de cada Producto en cada Almacen asi como la ubicación del mismo.
--Select * from InventariosGenerales
create view InventariosGenerales AS
select
    I.ID_Almacen,
    A.Nombre as Nombre,
	case
        when C.ID_Almacen is not null then 'Cedis'
        when S.ID_Almacen is not null then 'Sucursal'
    end as Categoria,
    A.Direccion,
	z.Nombre as Zona,
    I.UPC as 'Codigo Del Producto',
    P.Nombre as Producto,
    I.Existencia as Stock
	from Inventario I
    inner join Almacen A on I.ID_Almacen = A.ID_Almacen
    left join Cedis C on A.ID_Almacen = C.ID_Almacen
    left join Sucursal S on A.ID_Almacen = S.ID_Almacen
    inner join Producto P on I.UPC = P.UPC
	inner join Zona z ON z.ID_Zona = a.ID_Zona

----------------------------------------------------------------------
go
--2 El encargado de Logistica a nivel Nacional de la empresa GalloGiro desea Consultar los Centros de distribución disponibles asi como sus respectivas sucursales en cada Zona que compone la empresa GalloGiro
--select * from CedisSucursalesenZonas
create view CedisSucursalesenZonas as
select Z.ID_Zona, Z.Nombre as NombreZona, A.ID_Almacen, A.Nombre as NombreCedis, S.ID_Sucursal, C.ID_Cedis
from Zona Z
left join Almacen A on Z.ID_Zona = A.ID_Zona
left join Sucursal S on A.ID_Almacen = S.ID_Almacen
left join Cedis C on A.ID_Almacen = C.ID_Almacen;
go
--3 Se desea un reporte Total de las Ventas por Zona que tubo GalloGiro asi como la Cantidad de productos que se vendio por Zona
--select ID_Zona, Nombre, ProductosVendidos, CONCAT('$',GananciasTotales) as GananciasDeZona from GananciasFINZona order by ID_Zona
create view GananciasFINZona as
select Z.ID_Zona, Z.Nombre as Nombre, sum(D.Cantidad) as ProductosVendidos, (sum(D.Cantidad * D.PrecioFinal)) as GananciasTotales
from Zona Z
left join Almacen A on Z.ID_Zona = A.ID_Zona
left join Detalle D on A.ID_Almacen = D.ID_Almacen
group by Z.ID_Zona, Z.Nombre;
go
--4 El vendedor de la Sucursal Numero 1 , Requiere revisar el Precio Unitario de cada Producto Disponible en su Inventario , Asi como la cantidad de Productos que tiene disponibles para vender.
--select * from VentasSucursalEmp
create view VentasSucursalEmp as
select P.Nombre as NombreProducto, I.Existencia, P.PrecioVenta
from Producto P
inner join Inventario I on P.UPC = I.UPC
inner join Almacen A on I.ID_Almacen = A.ID_Almacen
inner join Sucursal S on A.ID_Almacen = S.ID_Almacen
where S.ID_Sucursal = 1;
--
go
--5 El supervisor de ventas de GalloGiro a nivel Nacional desea consultar los Ingresos totales de cada sucursal en el transcurso del año 2022
--SELECT Año, ID_Sucursal, CONCAT('$', TotalAnual) AS TotalAnual FROM GananciaAnualSucursales ORDER BY ID_Sucursal;
create view GananciaAnualSucursales as
SELECT s.ID_Sucursal , datepart(year, p.Fecha) as Año,  sum(d.PrecioFinal) as TotalAnual
FROM Detalle d
inner join Pedido p ON p.ID_Pedido = d.ID_Pedido
inner join Entrega e ON e.ID_Pedido = p.ID_Pedido
inner join Almacen a ON a.ID_Almacen = d.ID_Almacen
inner join Sucursal s ON s.ID_Almacen = a.ID_Almacen
group by datepart(year, p.Fecha), s.ID_Sucursal;