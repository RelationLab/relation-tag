DROP TABLE if EXISTS  nft_trade_type;
create table nft_trade_type
(

    nft_trade_type varchar(80) NULL,
    nft_trade_type_alis varchar(80) NULL,
    type varchar(1) NULL,
    nft_trade_type_name varchar(80) NULL
) ;
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('ALL','ALL','ALL','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Buy','Buy','Buy','1');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Sale','Sale','Sale','1');

insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('ALL','ALL','ALL','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Buy','Buy','Buy','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Sale','Sale','Sale','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Burn','Burn','Burn','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('Mint','Mint','Mint','0');
insert into nft_trade_type(nft_trade_type,nft_trade_type_name,nft_trade_type_alis,type) values('ALL','ALL','Transfer','0');

