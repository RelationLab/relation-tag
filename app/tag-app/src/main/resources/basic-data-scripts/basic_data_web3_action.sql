DROP TABLE if EXISTS  web3_action_temp;
create table web3_action_temp
(
    code varchar(10) NULL,
    trade_type varchar(80) NULL,
    trade_type_alis varchar(80) NULL,
    trade_type_name varchar(80) NULL
) ;

---------------WEB3_Mirror_Write_ACTIVITY_L1
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o0','ALL','ALL','ALL');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o1','write','Write','Writer');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o2','NFT Recipient','NFTRecipient','NFT Recipient');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o3','registerer','Registerer','Registerer');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o4','renewer','Renewer','Renewer');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o5','Airdrop Recipient','AirdropRecipient','Airdrop Recipient');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o6','donator','Donator','Donator');
insert into web3_action_temp(code,trade_type,trade_type_name,trade_type_alis) values('o7','mint','Mint','Minter');
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_web3_action' as table_name,'${batchDate}'  as batch_date;