DROP TABLE if EXISTS  platform_large_category;
create table platform_large_category
(
    code varchar(2),
    platform_large_code varchar(80) NULL,
    platform_large_name varchar(30) NULL
) ;

insert into platform_large_category(code,platform_large_code,platform_large_name) values('d','DEX','Dex');
insert into platform_large_category(code,platform_large_code,platform_large_name) values('e','ETH2.0','Eth2.0');
insert into platform_large_category(code,platform_large_code,platform_large_name) values('i','LENDING','Lending');
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_platform_large_category' as table_name,'${batchDate}'  as batch_date;
