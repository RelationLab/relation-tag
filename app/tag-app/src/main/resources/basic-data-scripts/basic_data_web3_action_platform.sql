DROP TABLE if EXISTS  web3_action_platform_temp;
create table web3_action_platform_temp
(
    platform varchar(80) NULL,
    trade_type varchar(512) NULL,
    dim_type varchar(1) NULL ----------'1'表示balance activity标签都有 '0'表示只有activity
) ;
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('ALL','ALL','1');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('ALL','NFT Recipient','1');

------Mirror
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','write','1');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','ALL','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','NFT Recipient','1');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','mint','0');
------ENS
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','registerer','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','ALL','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','NFT Recipient','1');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','renewer','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','Airdrop Recipient','0');

------Gitcoin
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','donator','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','ALL','0');
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','Airdrop Recipient','0');

------RabbitHole
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0xc9a42690912f6bd134dbc4e2493158b3d72cad21','NFT Recipient','1');
------ProjectGalaxy
insert into web3_action_platform_temp(platform,trade_type,dim_type) values('0x5bd25d2f4f26bc82a34de016d34612a28a0cd492','NFT Recipient','1');


insert into tag_result(table_name,batch_date)  SELECT 'basic_data_web3_action_platform' as table_name,'${batchDate}'  as batch_date;

