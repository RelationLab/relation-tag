DROP TABLE if EXISTS  nft_trade_type_temp;
create table nft_trade_type_temp
(
    code varchar(10) NULL,
    nft_trade_type varchar(80) NULL,
    nft_trade_type_alis varchar(80) NULL,
    type varchar(1) NULL,
    nft_trade_type_name varchar(80) NULL,
    asset_type varchar(10) NULL
) ;

insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o0','ALL','ALL','ALL','1');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o1','Buy','Buyer','Buy','1');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o2','Sale','Seller','Sale','1');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o3','Bid','Bid','Bid','1');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type,asset_type) values('o4','Deposit','Deposit','Deposit','1','token');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type,asset_type) values('o5','Withdraw','Withdraw','Withdraw','1','token');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o6','Lend','Lend','Lend','1');

insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o0','ALL','ALL','ALL','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o1','Buy','Buyer','Buy','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o2','Sale','Seller','Sale','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o3','Bid','Bid','Bid','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type,asset_type) values('o4','Deposit','Deposit','Deposit','0','token');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type,asset_type) values('o5','Withdraw','Withdraw','Withdraw','0','token');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o6','Lend','Lend','Lend','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o7','Burn','Burner','Burn','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o8','Mint','Minter','Mint','0');
insert into nft_trade_type_temp(code,nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('o9','Transfer','Transfer','Transfer','0');


insert into tag_result(table_name,batch_date)  SELECT 'basic_data_nft_trade_type' as table_name,'${batchDate}'  as batch_date;

