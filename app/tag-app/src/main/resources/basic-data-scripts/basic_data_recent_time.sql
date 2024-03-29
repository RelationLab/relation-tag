DROP TABLE if EXISTS  recent_time_temp;
create table recent_time_temp
(
    code varchar(10) NULL,
    recent_time_code varchar(80) NULL,
    recent_time_name varchar(80) NULL,
    recent_time_content varchar(80) NULL,
    block_height int8  NULL,
    days int8  NULL,
    seg_flag varchar(1)  NULL,
    code_revent varchar(10)  NULL
) ;

insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('3d','3d','3-day','3d',3,'d3');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('7d','7d','Weekly','7d',7,'d7');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('15d','15d','15-day','15d',15,'d15');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('1m','1m','1 Month','1m',30,'m1');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('3m','3m','3 Months','3m',90,'m3');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('6m','6m','6 Months','6m',180,'m6');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,code_revent) values('1y','1y','1 Year','1y',365,'y1');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,days,seg_flag,code_revent) values('2y','2y','2 Year','2y',730,'1','y2');
insert into recent_time_temp(code,recent_time_code,recent_time_content,recent_time_name,block_height,seg_flag,code_revent) values('','ALL','','',46147,'1','');

update
    recent_time_temp rt
set
    block_height = bt.height
    from
	(
	select min(height) as height,bti.days as days from (select
		height,
		floor((floor(extract(epoch from now())) - timestamp) / (24 * 3600)) as days
	from
		public.block_timestamp) bti group by bti.days
	) bt
where
    rt.days = bt.days
  and rt.days is not null;
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_recent_time' as table_name,'${batchDate}'  as batch_date;