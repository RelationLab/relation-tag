DROP TABLE if EXISTS  trade_type;
create table trade_type
(

    trade_type varchar(80) NULL,
    trade_type_alis varchar(80) NULL,
    trade_type_name varchar(80) NULL
) ;
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('ALL','ALL','ALL');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('lp','LP','LP');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('swap','Swap','Swap');