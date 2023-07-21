DROP TABLE if EXISTS  nft_trade_type;
create table nft_trade_type
(

    nft_trade_type varchar(80) NULL,
    nft_trade_type_alis varchar(80) NULL,
    type varchar(1) NULL,
    nft_trade_type_name varchar(80) NULL
) ;
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('ALL','ALL','ALL','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Buy','Buyer','Buy','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Sale','Seller','Sale','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Bid','Bid','Bid','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Deposit','Deposit','Deposit','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Withdraw','Withdraw','Withdraw','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Lend','Lend','Lend','1');

insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('ALL','ALL','ALL','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Buy','Buyer','Buy','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Sale','Seller','Sale','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Burn','Burner','Burn','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Mint','Minter','Mint','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Transfer','Transfer','Transfer','0');

insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Bid','Bid','Bid','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Deposit','Deposit','Deposit','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Withdraw','Withdraw','Withdraw','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Lend','Lend','Lend','0');



insert into tag_result(table_name,batch_date)  SELECT 'nft_trade_type' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;

