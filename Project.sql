create extension postgis;

create table if not exists city (
fid serial primary key,
name varchar(7) not null,
population int,
area decimal null,
geom geometry(Polygon, 4326)
);

create table if not exists neighbourhood (
fid serial primary key,
city_fid int not null,
name varchar(20) not null,
area decimal null,
geom geometry(Polygon, 4326),
constraint fk_city foreign key(city_fid) references city(fid)
);

create table if not exists education (
fid serial primary key,
neighbourhood_fid int not null,
name varchar(50) not null,
type varchar(20) not null,
geom geometry(Polygon, 4326),
constraint fk_neighbourhood_education foreign key(neighbourhood_fid) references neighbourhood(fid)
);

create table if not exists commercial (
fid serial primary key,
neighbourhood_fid int not null,
geom geometry(Polygon, 4326),
constraint fk_neighbourhood_commercial foreign key(neighbourhood_fid) references neighbourhood(fid)
);

create table if not exists medical (
fid serial primary key,
neighbourhood_fid int not null,
geom geometry(Polygon, 4326),
constraint fk_neighbourhood_medical foreign key(neighbourhood_fid) references neighbourhood(fid)
);

create table if not exists parks (
fid serial primary key,
city_fid int not null,
name varchar(50) not null,
area decimal null,
geom geometry(Polygon, 4326),
constraint fk_city_parks foreign key(city_fid) references city(fid)
);

create table if not exists attractions (
fid serial primary key,
city_fid int not null,
name varchar(50) not null,
geom geometry(Point, 4326),
constraint fk_city_attractions foreign key(city_fid) references city(fid)
);

update city set area=ST_Area(geom);
update neighbourhood set area=ST_Area(geom);
update parks set area=ST_Area(geom);

create view neighbourhood_high_schools as 
select education.neighbourhood_fid, education.name, education.type from education
inner join neighbourhood
on education.neighbourhood_fid=neighbourhood.fid
where type = 'Liceu';

select * from neighbourhood_high_schools;