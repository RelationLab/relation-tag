DROP TABLE if EXISTS  dex_action_platform_temp;
create table dex_action_platform_temp
(
    platform varchar(80) NULL,
    trade_type varchar(512) NULL
) ;

insert into dex_action_platform_temp(platform,trade_type) values('0xba12222222228d8ba445958a75a0704d566bf2c8','lp');
insert into dex_action_platform_temp(platform,trade_type) values('0xd061d61a4d941c39e5453435b6345dc261c2fce0','lp');
insert into dex_action_platform_temp(platform,trade_type) values('0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','lp');
insert into dex_action_platform_temp(platform,trade_type) values('0xc36442b4a4522e871399cd717abdd847ab11fe88','lp');
insert into dex_action_platform_temp(platform,trade_type) values('0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','lp');
insert into dex_action_platform_temp(platform,trade_type) values('0x7a250d5630b4cf539739df2c5dacb4c659f2488d','lp');

insert into dex_action_platform_temp(platform,trade_type) values('0xdef1c0ded9bec7f1a1670819833240f027b25eff','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0x1111111254fb6c44bac0bed2854e76f90643097d','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0xba12222222228d8ba445958a75a0704d566bf2c8','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0xd061d61a4d941c39e5453435b6345dc261c2fce0','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0x881d40237659c251811cec9c364ef91dc08d300c','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0xc36442b4a4522e871399cd717abdd847ab11fe88','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','swap');
insert into dex_action_platform_temp(platform,trade_type) values('0x7a250d5630b4cf539739df2c5dacb4c659f2488d','swap');

insert into dex_action_platform_temp(platform,trade_type) values('0xdef1c0ded9bec7f1a1670819833240f027b25eff','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0x1111111254fb6c44bac0bed2854e76f90643097d','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0xba12222222228d8ba445958a75a0704d566bf2c8','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0xd061d61a4d941c39e5453435b6345dc261c2fce0','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0x881d40237659c251811cec9c364ef91dc08d300c','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0x71cd6666064c3a1354a3b4dca5fa1e2d3ee7d303','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0xc36442b4a4522e871399cd717abdd847ab11fe88','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0x7a250d5630b4cf539739df2c5dacb4c659f2488d','ALL');

insert into dex_action_platform_temp(platform,trade_type) values('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0xbafa44efe7901e04e39dad13167d089c559c1138','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','ALL');

insert into dex_action_platform_temp(platform,trade_type) values('aave','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('commpound','ALL');

insert into dex_action_platform_temp(platform,trade_type) values('Instadapp','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('summerfi','ALL');
insert into dex_action_platform_temp(platform,trade_type) values('dydx','ALL');



insert into dex_action_platform_temp(platform,trade_type) values('0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f','stakelp');
insert into dex_action_platform_temp(platform,trade_type) values('0x1111111254fb6c44bac0bed2854e76f90643097d','stakelp');
insert into dex_action_platform_temp(platform,trade_type) values('0xd061d61a4d941c39e5453435b6345dc261c2fce0','stakelp');
insert into dex_action_platform_temp(platform,trade_type) values('0xba12222222228d8ba445958a75a0704d566bf2c8','stakelp');


insert into dex_action_platform_temp(platform,trade_type) values('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','stake');
insert into dex_action_platform_temp(platform,trade_type) values('0xbafa44efe7901e04e39dad13167d089c559c1138','stake');
insert into dex_action_platform_temp(platform,trade_type) values('0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','stake');

insert into dex_action_platform_temp(platform,trade_type) values('0xae7ab96520de3a18e5e111b5eaab095312d7fe84','withdraw');
insert into dex_action_platform_temp(platform,trade_type) values('0xbafa44efe7901e04e39dad13167d089c559c1138','withdraw');
insert into dex_action_platform_temp(platform,trade_type) values('0x4d05e3d48a938db4b7a9a59a802d5b45011bde58','withdraw');



insert into dex_action_platform_temp(platform,trade_type) values('aave','deposit');
insert into dex_action_platform_temp(platform,trade_type) values('aave','redeem');
insert into dex_action_platform_temp(platform,trade_type) values('aave','borrow');
insert into dex_action_platform_temp(platform,trade_type) values('aave','repay');

insert into dex_action_platform_temp(platform,trade_type) values('commpound','mint');
insert into dex_action_platform_temp(platform,trade_type) values('commpound','redeem');
insert into dex_action_platform_temp(platform,trade_type) values('commpound','borrow');
insert into dex_action_platform_temp(platform,trade_type) values('commpound','repay');

insert into dex_action_platform_temp(platform,trade_type) values('summerfi','execute');
insert into dex_action_platform_temp(platform,trade_type) values('Instadapp','deposit');
insert into dex_action_platform_temp(platform,trade_type) values('Instadapp','withdraw');

insert into dex_action_platform_temp(platform,trade_type) values('dydx','operate');



insert into tag_result(table_name,batch_date)  SELECT 'basic_data_dex_action_platform' as table_name,'${batchDate}'  as batch_date;
