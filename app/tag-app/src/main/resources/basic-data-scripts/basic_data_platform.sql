DROP TABLE if EXISTS  platform_temp;
create table platform_temp
(
    id int8,
    platform_large_code varchar(30) NULL,
    platform varchar(80) NULL,
    platform_name varchar(512) NULL,
    token_all_flag varchar(1) ----控制是否有ALL标签
) ;

insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(1,'DEX','0xdef1c0ded9bec7f1a1670819833240f027b25eff','0x','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(2,'DEX','0x1111111254fb6c44bac0bed2854e76f90643097d','1inch','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(3,'DEX','0xba12222222228d8ba445958a75a0704d566bf2c8','Balancer','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(4,'DEX','0xd061d61a4d941c39e5453435b6345dc261c2fce0','Curve','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(5,'DEX','0x881d40237659c251811cec9c364ef91dc08d300c','Metamask','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(6,'DEX','0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','Mooniswap','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(7,'DEX','0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','Sushiswap','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(8,'DEX','0xc36442b4a4522e871399cd717abdd847ab11fe88','Uniswap','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(8,'DEX','0x7a250d5630b4cf539739df2c5dacb4c659f2488d','Uniswap','1');

insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(9,'LENDING','aave','AAVE','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(10,'LENDING','commpound','Compound','1');

insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(11,'ETH2.0','0xae7ab96520de3a18e5e111b5eaab095312d7fe84','Lido','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(12,'ETH2.0','0xbafa44efe7901e04e39dad13167d089c559c1138','Frax','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(13,'ETH2.0','0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','RocketPool','1');

insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(14,'SERVICES','Instadapp','Instadapp','1');
insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(15,'SERVICES','summerfi','Summer.Fi','1');

insert into platform_temp(id,platform_large_code,platform,platform_name,token_all_flag) values(16,'DERIVATIVES','dydx','dydx','1');



insert into tag_result(table_name,batch_date)  SELECT 'basic_data_platform' as table_name,'${batchDate}'  as batch_date;