DROP TABLE if EXISTS  platform_detail;
create table platform_detail
(
    platform varchar(80) NULL,
    platform_name varchar(512) NULL

) ;

insert into platform_detail(platform,platform_name) values('0xdef1c0ded9bec7f1a1670819833240f027b25eff','0x');
insert into platform_detail(platform,platform_name) values('0x1111111254fb6c44bac0bed2854e76f90643097d','1inch');
insert into platform_detail(platform,platform_name) values('0xba12222222228d8ba445958a75a0704d566bf2c8','Balancer');
insert into platform_detail(platform,platform_name) values('0xd061d61a4d941c39e5453435b6345dc261c2fce0','Curve');
insert into platform_detail(platform,platform_name) values('0x881d40237659c251811cec9c364ef91dc08d300c','Metamask');
insert into platform_detail(platform,platform_name) values('0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','Mooniswap');
insert into platform_detail(platform,platform_name) values('0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','Sushiswap');
insert into platform_detail(platform,platform_name) values('0xc36442b4a4522e871399cd717abdd847ab11fe88','Uniswap_v3');
insert into platform_detail(platform,platform_name) values('0x7a250d5630b4cf539739df2c5dacb4c659f2488d','Uniswap_v2');


insert into platform_detail(platform,platform_name) values('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','Lido');
insert into platform_detail(platform,platform_name) values('0xbafa44efe7901e04e39dad13167d089c559c1138','Frax');
insert into platform_detail(platform,platform_name) values('0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','RocketPool');
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_platform_detail' as table_name,'${batchDate}'  as batch_date;
