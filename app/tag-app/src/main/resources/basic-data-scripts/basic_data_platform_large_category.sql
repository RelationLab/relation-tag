DROP TABLE if EXISTS  basic_data_platform_large_category;
create table basic_data_platform_large_category
(

    platform_large_code varchar(80) NULL,
    platform_large_name varchar(30) NULL
) ;
insert into basic_data_platform_large_category(platform_large_code,platform_large_name) values('DEX','Dex');
insert into basic_data_platform_large_category(platform_large_code,platform_large_name) values('ETH.2.0','Eth.2.0');
insert into basic_data_platform_large_category(platform_large_code,platform_large_name) values('LENDING','Lending');
