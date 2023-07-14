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
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('stake','Stake','Stake');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('stakelp','StakeLP','StakeLP');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('withdraw','withdraw','withdraw');
insert into tag_result(table_name,batch_date)  SELECT 'trade_type' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
