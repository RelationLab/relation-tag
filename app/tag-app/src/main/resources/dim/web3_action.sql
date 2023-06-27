DROP TABLE if EXISTS  web3_action;
create table web3_action
(

    trade_type varchar(80) NULL,
    trade_type_alis varchar(80) NULL,
    trade_type_name varchar(80) NULL
) ;

---------------WEB3_Mirror_Write_ACTIVITY_L1
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('ALL','ALL','ALL');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('write','Write','Writer');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('NFT Recipient','NFTRecipient','NFT Recipient');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('registerer','Registerer','Registerer');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('renewer','Renewer','Renewer');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('Airdrop Recipient','AirdropRecipient','Airdrop Recipient');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('donator','Donator','Donator');
insert into web3_action(trade_type,trade_type_name,trade_type_alis) values('mint','Mint','Minter');
