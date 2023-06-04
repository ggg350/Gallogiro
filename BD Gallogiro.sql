CREATE DATABASE GalloGiro
go
use GalloGiro
go
create table Municipio
(
ID_Municipio int not null,
Nombre nvarchar (50) not null,
Estado nvarchar (50) null,
ID_Zona int not null,
)
create table Zona
(
ID_Zona int not null,
Nombre nvarchar (50) not null,
)
create table Almacen 
(
ID_Almacen int not null ,
ID_Zona int not null,
Nombre nvarchar (50) null,
Direccion nvarchar (100) not null,
Telefono varchar (20),
)
create table Cedis 
(
ID_Cedis int not null,
ID_Almacen int unique not null,
)
create table Sucursal
(
ID_Sucursal int not null,
ID_Almacen int unique not null,
)
create table Componenteactivo 
(
ID_Componenteactivo int not null , 
Nombre nvarchar (50) not null,
Descripcion nvarchar (50) null, 
)
create table Familia 
(
ID_Familia int not null,
FamiliaNombre nvarchar (100) not null, 
FamiliaDescripcion nvarchar (100) not null, 
) 
create table Producto 
(
UPC int not null, 
Nombre nvarchar (150) not null,
Descripcion nvarchar (150) null, 
ID_Familia int not null,
ID_Componenteactivo int not null,
PrecioVenta money not null default 0.0,
)
create table Detalle 
(
ID_Pedido int not null,
UPC int not null,
Cantidad int not null,
PrecioFinal money not null default 0.0,
ID_Almacen int not null,
)
create table Inventario 
(
ID_Almacen int not null,
UPC int not null,
Existencia int not null default 0,
)
create table Proveedor
(
ID_Proveedor int not null, 
Nombre nvarchar(50) not null,
ApellidoPaterno nvarchar (50) null,
ApellidoMaterno nvarchar (50) null,
Telefono varchar (20),
)
create table CompraAProveedor
(
UPC int not null,
ID_Proveedor int not null,
Cantidad int not null default 0,
CostoTotal money not null default 0.0,
Fecha date not null,
ID_Cedis int not null,
) 

create table Formatodepago 
(
ID_Formatodepago int not null,
Nombre nvarchar(10) not null,
) 
create table Cliente 
(
ID_Cliente int not null,
ID_Tipodecliente int not null,
Nombre nvarchar(50) not null,
ApellidoPaterno nvarchar (50) null,
ApellidoMaterno nvarchar (50) null,
Credito money not null default 0.0, 
Telefono varchar (20) null,
Direccion nvarchar (100) not null,
)
create table Tipodecliente
(
ID_Tipodecliente int not null , 
Nombre nvarchar (50),
Descripcion nvarchar (50),
)
create table Tipodeentrega 
(
ID_Tipodeentrega int not null, 
Nombre nvarchar(50) not null,
)
create table Entrega 
(
ID_Entrega int not null , 
ID_Almacen int not null,
ID_Pedido int unique not null,
ID_Tipodeentrega int not null,
Direcciondeentrega nvarchar (100) null,
Nombredestinatario nvarchar (50) null,
Estatusdeentrega nvarchar (30) not null,
Recibio nvarchar (30) null,
)
create table Pedido 
(
ID_Pedido int not null, 
ID_Entrega int unique not null,
ID_Cliente int null,
ID_Formatodepago int not null,
ID_Sucursal int not null,
Fecha date not null,

)
create table Empleado 
(
ID_Empleado int not null,
ID_Almacen int not null,
Nombre nvarchar (50) not null,
CURP nvarchar (50) not null,
RFC nvarchar (50) not null,
Domicilio nvarchar (100) null,
Telefono varchar (20) null,
)
create table TrasladoInventario
(
ID_TrasladoInventario int not null,
ID_AlmacenOrigen int not null,
ID_AlmacenDestino int not null,
UPC int not null,
Cantidad int not null,
Fecha date not null,
)

go
--------------------PRIMARYS KEYS------------------------------------------------------------------------------------------
Alter table Empleado add constraint PK_ID_Empleado primary key (ID_Empleado)
Alter table Familia add constraint PK_ID_Familia primary key (ID_Familia)
Alter table Componenteactivo add constraint PK_ID_Componenteactivo primary key (ID_Componenteactivo)
Alter table Tipodecliente add constraint PK_ID_Tipodecliente primary key (ID_Tipodecliente)
Alter table Cliente add constraint PK_ID_Cliente primary key (ID_Cliente)
Alter table Formatodepago add constraint PK_ID_Formatodepago primary key (ID_Formatodepago)
Alter table Proveedor add constraint PK_ID_Proveedor primary key (ID_Proveedor)
Alter table Producto add constraint PK_UPC primary key (UPC)
Alter table Zona add constraint pk_ID_Zona primary key (ID_Zona)
Alter table Sucursal add constraint PK_ID_Sucursal primary key (ID_Sucursal)
Alter table Cedis add constraint PK_ID_Cedis primary key (ID_Cedis)
Alter table Almacen add constraint pk_Almacen primary key (ID_Almacen)
Alter table Tipodeentrega add constraint PK_ID_Tipodeentrega primary key (ID_Tipodeentrega)
Alter table Entrega add constraint PK_ID_Entrega primary key (ID_Entrega)
Alter table Pedido add constraint pk_Pedido primary key (ID_Pedido)

--ti
Alter table TrasladoInventario add constraint pk_ID_TrasladoInventario primary key (ID_TrasladoInventario)
Alter table TrasladoInventario add constraint fk_ID_TrasladoInventarioAlmacenOrigen foreign key (ID_AlmacenOrigen) references Almacen (ID_Almacen)
Alter table TrasladoInventario add constraint fk_ID_TrasladoInventarioAlmacenDestino foreign key (ID_AlmacenDestino) references Almacen (ID_Almacen)
Alter table TrasladoInventario add constraint fk_ID_TrasladoInventarioUPC foreign key (UPC) references Producto (UPC)
-- -------------------??????????????????? -- -------------------??????????????????? -- -------------------??????????????????? 
--Alter table TrasladoInventario add constraint FK_Traslado_Inventario foreign key (ID_AlmacenOrigen, UPC) references Inventario (ID_Almacen, UPC)
-- -------------------??????????????????? -- -------------------??????????????????? -- -------------------??????????????????? 
go
Alter table Municipio add constraint pk_Municipio_ID_Zona primary key (ID_Zona,ID_Municipio)
Alter table Inventario add constraint pk_Inventario_UPC primary key (ID_Almacen,UPC)
--fk
go
Alter table Municipio add constraint fk_Municipio foreign key (ID_Zona) references Zona (ID_Zona)
Alter table Empleado add constraint fk_Empleado foreign key (ID_Almacen) references Almacen (ID_Almacen)
Alter table Almacen add constraint fk_Almacen foreign key (ID_Zona) references Zona (ID_Zona)
Alter table Cedis add constraint fk_CedAlmacen foreign key (ID_Almacen) references Almacen (ID_Almacen)
Alter table Sucursal add constraint fk_SucAlmacen foreign key (ID_Almacen) references Almacen (ID_Almacen)
Alter table Inventario add constraint fk_InvAlmacen foreign key (ID_Almacen) references Almacen (ID_Almacen)
Alter table Inventario add constraint fk_InvUPC foreign key (UPC) references Producto (UPC)
Alter table Producto add constraint fk_FanmiliaProducto foreign key (ID_Familia) references Familia (ID_Familia)
Alter table Producto add constraint fk_ComponenteActivoProducto foreign key (ID_Componenteactivo) references Componenteactivo (ID_Componenteactivo)
Alter table CompraAProveedor add constraint fk_UPCProveedor foreign key (UPC) references Producto (UPC)
Alter table CompraAProveedor add constraint fk_Proovedor foreign key (ID_Proveedor) references Proveedor (ID_Proveedor)
alter table CompraAProveedor add constraint fk_ProvedoraCedis foreign key (ID_Cedis) references CEDIS (ID_Cedis)
Alter table Cliente add constraint fk_tipocliente foreign key (ID_Tipodecliente) references Tipodecliente (ID_Tipodecliente)
go
Alter table Entrega add constraint fk_EntregaAlmacen foreign key (ID_Almacen) references Almacen (ID_Almacen)
Alter table Entrega add constraint fk_EntregadePedido foreign key (ID_Pedido) references Pedido (ID_Pedido)
Alter table Entrega add constraint fk_Tipodeentrega foreign key (ID_Tipodeentrega) references Tipodeentrega (ID_Tipodeentrega)
go

Alter table Pedido add constraint fk_ClientePedido foreign key (ID_Cliente) references Cliente (ID_Cliente)
Alter table Pedido add constraint fk_SucursalPedido foreign key (ID_Sucursal) references Sucursal (ID_Sucursal)
Alter table Pedido add constraint fk_FormatoPedido foreign key (ID_Formatodepago) references Formatodepago (ID_Formatodepago)
go
Alter table Detalle add constraint fk_DetallePedido foreign key (ID_Pedido) references pedido (ID_Pedido)
Alter table Detalle add constraint fk_DetalleUPC foreign key (UPC) references Producto (UPC)

Alter table Detalle add constraint pk_DetallePedido_UPC primary key (ID_Pedido,UPC)

Alter table Detalle add constraint fk_DetalleInventarioAlmacen foreign key (ID_Almacen,UPC) references Inventario (ID_Almacen,UPC)
