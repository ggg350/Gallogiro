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
ID_Municipio int not null,
)

create table Cedis 
(
ID_Cedis int not null,
--ID_Almacen int foreign key references Almacen (ID_Almacen),
Nombre nvarchar (50) null,
Direccion nvarchar (100) not null,
Telefono varchar (20),
)
create table Sucursal
(
ID_Sucursal int not null,
--ID_Almacen int foreign key references Almacen (ID_Almacen),
Nombre nvarchar (50) null,
Direccion nvarchar (100) not null,
Telefono varchar (20),
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
--ID_Familia int foreign key references Familia (ID_Familia),
--ID_Componenteactivo int foreign key references Componenteactivo (ID_Componenteactivo),
Nombre nvarchar (50) not null,
Descripcion nvarchar (100) null, 
PrecioVenta money not null default 0.0,

)
create table Inventario 
(
--ID_Almacen int foreign key references Almacen (ID_Almacen),
--UPC int foreign key references Producto (UPC),
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
--UPC int foreign key references Producto (UPC),
--ID_Proveedor int foreign key references Proveedor (ID_Proveedor),
Costo money not null default 0.0,
Cantidad int not null default 0,
)
create table Detalle 
(
--ID_Pedido int not null identity primary key,
--UPC int foreign key references Producto (UPC),
Cantidad int not null,
PrecioFinal money not null default 0.0,
)
create table Formatodepago 
(
ID_Formatodepago int not null,
Efectivo int null,
Credito int null,
Tarjeta int null,
) 
create table Cliente 
(
ID_Cliente int not null,
Nombre nvarchar(50) not null,
ApellidoPaterno nvarchar (50) null,
ApellidoMaterno nvarchar (50) null,
Credito int null, 
Telefono varchar (20),
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
--ID_Almacen int foreign key references Almacen (ID_Almacen),
--ID_Pedido int foreign key references Pedido (ID_Pedido),
--ID_Tipodeentrega int foreign key references Tipodeentrega (ID_Tipodeentrega),
Direcciondeentrega nvarchar (100) not null,
Nombredestinatario nvarchar (50) not null,
Estatusdeentrega nvarchar (30) not null,
Recibio nvarchar (30) null,
)
create table Pedido 
(
ID_Pedido int not null, 
--ID_Entrega int foreign key references Entrega (ID_Entrega),
--ID_Cliente int foreign key references Cliente (ID_Cliente),
--ID_Formatodepago int foreign key references Formatodepago (ID_Formatodepago),
--ID_Sucursal int foreign key references Sucursal (ID_Sucursal),
Fecha date,
Costototal int not null,
)
create table Empleado 
(
ID_Empleado int not null,
--ID_Almacen int foreign key references Almacen (ID_Almacen),
Nombre nvarchar (50) not null,
CURP nvarchar (50) not null,
RFC nvarchar (50) not null,
Domicilio nvarchar (100) null,
Telefono varchar (20) null,
)
go
--------------------PRIMARYS KEYS------------------------------------------------------------------------------------------
Alter table Empleado add constraint PK_ID_Empleado primary key (ID_Empleado)
Alter table Tipodeentrega add constraint PK_ID_Tipodeentrega primary key (ID_Tipodeentrega)
Alter table Familia add constraint PK_ID_Familia primary key (ID_Familia)
Alter table Componenteactivo add constraint PK_ID_Componenteactivo primary key (ID_Componenteactivo)
Alter table Pedido add constraint PK_ID_Pedido primary key (ID_Pedido)
Alter table Entrega add constraint PK_ID_Entrega primary key (ID_Entrega)
Alter table Tipodecliente add constraint PK_ID_Tipodecliente primary key (ID_Tipodecliente)
Alter table Cliente add constraint PK_ID_Cliente primary key (ID_Cliente)
Alter table Formatodepago add constraint PK_ID_Formatodepago primary key (ID_Formatodepago)
Alter table Cedis add constraint PK_ID_Cedis primary key (ID_Cedis)
Alter table Proveedor add constraint PK_ID_Proveedor primary key (ID_Proveedor)
Alter table Sucursal add constraint PK_ID_Sucursal primary key (ID_Sucursal)
Alter table Producto add constraint PK_UPC primary key (UPC)




--pk
Alter table Zona add constraint pk_ID_Zona primary key (ID_Zona)
Alter table Municipio add constraint pk_Municipio_ID_Zona primary key (ID_Zona,ID_Municipio)
Alter table Almacen add constraint pk_Almacen primary key (ID_Almacen)
--fk
Alter table Municipio add constraint fk_Municipio foreign key (ID_Zona) references Zona (ID_Zona)
Alter table Almacen add constraint fk_Almacen foreign key (ID_Zona,ID_Municipio) references Municipio (ID_Zona,ID_Municipio)




select * from Almacen

--Comando para borrar tablas ---> drop table nombre
