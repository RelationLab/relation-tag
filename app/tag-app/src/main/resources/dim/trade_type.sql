DROP TABLE if EXISTS  trade_type;
create table trade_type
(

    trade_type varchar(80) NULL,

    trade_type_name varchar(80) NULL
) ;
insert into trade_type(trade_type,trade_type_name) values('ALL','ALL');
insert into trade_type(trade_type,trade_type_name) values('lp','LP');
insert into trade_type(trade_type,trade_type_name) values('swap','SWAP');