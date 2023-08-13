DROP TABLE if EXISTS  trade_type;
create table trade_type
(
    code varchar(10) NULL,
    trade_type varchar(80) NULL,
    trade_type_alis varchar(80) NULL,
    trade_type_name varchar(80) NULL
) ;

insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('a1','ALL','ALL','ALL');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('l1','lp','LP','LP');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('s1','swap','Swap','Swap');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('s2','stake','Stake','Stake');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('s3','stakelp','StakeLP','StakeLP');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('w1','withdraw','Withdraw','Withdraw');

insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('d1','deposit','Deposit','deposit');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('r1','redeem','Redeem','redeem');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('b1','borrow','Borrow','borrow');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('r2','repay','Repay','repay');
insert into trade_type(code,trade_type,trade_type_name,trade_type_alis) values('m1','mint','Mint','mint');

insert into tag_result(table_name,batch_date)  SELECT 'basic_data_trade_type' as table_name,'${batchDate}'  as batch_date;
