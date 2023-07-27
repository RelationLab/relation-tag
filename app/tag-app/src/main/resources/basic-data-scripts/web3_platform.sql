DROP TABLE if EXISTS  web3_platform;
create table web3_platform
(
    platform varchar(80) NULL,
    platform_name varchar(512) NULL,
    platform_name_alis varchar(512) NULL
) ;

insert into web3_platform(platform,platform_name,platform_name_alis) values('0xc9a42690912f6bd134dbc4e2493158b3d72cad21','RabbitHole','Rabbit Hole');
insert into web3_platform(platform,platform_name,platform_name_alis) values('0x5bd25d2f4f26bc82a34de016d34612a28a0cd492','ProjectGalaxy','Galxe');
insert into web3_platform(platform,platform_name,platform_name_alis) values('ALL','ALL','Web3');
insert into web3_platform(platform,platform_name,platform_name_alis) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','Gitcoin','Gitcoin');
insert into web3_platform(platform,platform_name,platform_name_alis) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','ENS','ENS');
insert into web3_platform(platform,platform_name,platform_name_alis) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','Mirror','Mirror');
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_web3_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
