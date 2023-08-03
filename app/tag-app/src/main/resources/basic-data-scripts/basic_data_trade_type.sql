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
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('withdraw','Withdraw','Withdraw');

insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('deposit','deposit','deposit');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('redeem','redeem','redeem');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('borrow','borrow','borrow');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('repay','repay','repay');
insert into trade_type(trade_type,trade_type_name,trade_type_alis) values('mint','mint','mint');

insert into tag_result(table_name,batch_date)  SELECT 'basic_data_trade_type' as table_name,'${batchDate}'  as batch_date;
