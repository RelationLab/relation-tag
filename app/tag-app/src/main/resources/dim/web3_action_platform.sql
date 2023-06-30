DROP TABLE if EXISTS  web3_action_platform;
create table web3_action_platform
(
    platform varchar(80) NULL,
    trade_type varchar(512) NULL,
    dim_type varchar(1) NULL
) ;
insert into web3_action_platform(platform,trade_type,dim_type) values('ALL','ALL','1');

insert into web3_action_platform(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','write','1');
insert into web3_action_platform(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','ALL','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','NFT Recipient','1');
insert into web3_action_platform(platform,trade_type,dim_type) values('0xaf89c5e115ab3437fc965224d317d09faa66ee3e','mint','0');

insert into web3_action_platform(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','registerer','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','ALL','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','NFT Recipient','1');
insert into web3_action_platform(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','renewer','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0x283af0b28c62c092c9727f1ee09c02ca627eb7f5','Airdrop Recipient','0');


insert into web3_action_platform(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','donator','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','ALL','0');
insert into web3_action_platform(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','Airdrop Recipient','0');

insert into web3_action_platform(platform,trade_type,dim_type) values('0xc9a42690912f6bd134dbc4e2493158b3d72cad21','NFT Recipient','1');

insert into web3_action_platform(platform,trade_type,dim_type) values('0xde30da39c46104798bb5aa3fe8b9e0e1f348163f','NFT Recipient','1');
insert into tag_result(table_name,batch_date)  SELECT 'web3_action_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

