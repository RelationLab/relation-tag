DROP TABLE if EXISTS  platform_detail_temp;
create table platform_detail_temp
(
    id int8,
    platform varchar(80) NULL,
    platform_name varchar(512) NULL,
    platform_symbol varchar(80) NULL
) ;

insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(1,'0xdef1c0ded9bec7f1a1670819833240f027b25eff','0x','0x');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(2,'0x1111111254fb6c44bac0bed2854e76f90643097d','1inch','1inch');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(3,'0xba12222222228d8ba445958a75a0704d566bf2c8','Balancer','Balancer');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(4,'0xd061d61a4d941c39e5453435b6345dc261c2fce0','Curve','Curve');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(5,'0x881d40237659c251811cec9c364ef91dc08d300c','Metamask','Metamask');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(6,'0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','Mooniswap','Mooniswap');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(7,'0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','Sushiswap','Sushiswap');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(99,'0xc36442b4a4522e871399cd717abdd847ab11fe88','Uniswap_v3','Uniswap v3');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(8,'0x7a250d5630b4cf539739df2c5dacb4c659f2488d','Uniswap_v2','Uniswap v2');


insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(11,'0xae7ab96520de3a18e5e111b5eaab095312d7fe84','Lido','Lido');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(12,'0xbafa44efe7901e04e39dad13167d089c559c1138','Frax','Frax');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(13,'0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','RocketPool','RocketPool');

insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(9,'aave','AAVE','AAVE');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(10,'commpound','Commpound','Compound');


insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(14,'Instadapp','Instadapp','Instadapp');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(15,'summerfi','Summer.Fi','Summer.Fi');
insert into platform_detail_temp(id,platform,platform_name,platform_symbol) values(16,'dydx','dydx','dydx');
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_platform_detail' as table_name,'${batchDate}'  as batch_date;