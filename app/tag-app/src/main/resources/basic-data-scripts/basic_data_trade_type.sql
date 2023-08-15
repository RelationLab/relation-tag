DROP TABLE if EXISTS  trade_type;
create table trade_type
(
    code varchar(10) NULL,
    trade_type varchar(80) NULL,
    trade_type_alis varchar(80) NULL,
    trade_type_name varchar(80) NULL
) ;

insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o0','ALL','ALL','ALL');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o1','lp','LP','LP');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o2','swap','Swap','Swap');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o3','stake','Stake','Stake');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o4','stakelp','StakeLP','StakeLP');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o5','withdraw','Withdraw','Withdraw');

insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o6','deposit','Deposit','deposit');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o7','redeem','Redeem','redeem');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o8','borrow','Borrow','borrow');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o9','repay','Repay','repay');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('o10','mint','Mint','mint');

insert into tag_result(table_name,batch_date)  SELECT 'basic_data_trade_type' as table_name,'${batchDate}'  as batch_date;
