use Gallogiro
go

--Seguridad
--Creacion de roles 
-- Role vendedor Select Inventario , Producto , ComponenteActivo, Familia Insert  tabla Detalle 
create role Vendedor

go
create role GestorInvNac
go
create role Logistica
go
create role Contador
go
--Permisos Vendedor 
grant select on Inventario to Vendedor;
grant select on Producto to Vendedor;
grant select on ComponenteActivo to Vendedor;
grant select on Familia to Vendedor;
grant insert on Detalle to Vendedor;
grant select on Detalle to Vendedor;
grant select on Pedido to Vendedor;
grant insert on Pedido to Vendedor;
grant select on VentasSucursalEmp to Vendedor; --Vista
----
go
--Permisos Gestor Inventarios
grant select on Inventario to GestorInvNac;
grant select on Producto to GestorInvNac;
grant select on TrasladoInventario to GestorInvNac;
grant select on ComponenteActivo to GestorInvNac;
grant select on Familia to GestorInvNac;
grant select on Almacen to GestorInvNac;
grant select on Cedis to GestorInvNac;
grant select on Sucursal to GestorInvNac;
grant insert on Inventario to GestorInvNac; 
grant insert on TrasladoInventario to GestorInvNac;
grant update on Inventario to GestorInvNac;
grant select on InventariosGenerales to GestorInvNac; --Vista
go
--Permisos Logistica
grant select on Zona to Logistica;
grant select on Cedis to Logistica;
grant select on Almacen to Logistica;
grant select on Sucursal to Logistica;
grant select on Detalle to Logistica;
grant select on Pedido to Logistica;
grant select on Producto to Logistica;
grant select on ComponenteActivo to Logistica;
grant select on Familia to Logistica;
grant select on CedisSucursalesenZonas to Logistica; --Vista
go
--Permisos contador
grant select on Detalle to Contador;
grant select on Zona to Contador;
grant select on Sucursal to Contador;
grant select on Cedis to Contador;
grant select on Almacen to Contador;
grant select on Pedido to Contador;
grant select on Producto to Contador;
grant select on ComponenteActivo to Contador;
grant select on Familia to Contador;
grant select on GananciasFINZona to Contador; --Vista
grant select on GananciaAnualSucursales to Contador; --Vista

go
--Creacion de usuarios y asignacion de sus respectivos roles
--Vendedor , Capaz de insertar ventas en Detalle
create login amlo with password='123'
use GalloGiro
create user amlo for login amlo
alter role Vendedor add member amlo

--Gestor Inventario , capaz de gestionar el inventario de todos los Almacenes
create login juan with password='123'
use GalloGiro
create user juan for login juan
alter role GestorInvNac add member juan

--Logistica Capaz de mirar en las diferentes areas de la empresa en lo que en cada zona ocurre , asi como las ventas de estas y las gestion de las mismas.
create login taco with password='123'
use GalloGiro
create user taco for login taco
alter role Logistica add member taco


--Contador Capaz de mirar las ventas de la empresa a nivel General a si como las vistas que este incluye.
create login tamal with password='123'
use GalloGiro
create user tamal for login tamal
alter role Contador add member tamal


