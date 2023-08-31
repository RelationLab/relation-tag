DROP TABLE if EXISTS  lp_action_platform_temp;
create table lp_action_platform_temp
(
    platform varchar(80) NULL,
    trade_type varchar(512) NULL
) ;

insert into lp_action_platform_temp(platform,trade_type) values('Balancer','stakelp');
insert into lp_action_platform_temp(platform,trade_type) values('Sushiswap','stakelp');
insert into lp_action_platform_temp(platform,trade_type) values('1inch','stakelp');

insert into tag_result(table_name,batch_date)  SELECT 'basic_data_lp_action_platform' as table_name,'${batchDate}'  as batch_date;
