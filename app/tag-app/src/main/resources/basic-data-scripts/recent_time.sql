DROP TABLE if EXISTS  recent_time;
create table recent_time
(
    recent_time_code varchar(80) NULL,
    recent_time_name varchar(80) NULL,
    recent_time_content varchar(80) NULL,
    block_height int8  NULL,
    days int8  NULL
) ;

insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('3d','3-day','3d',3);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('7d','Weekly','7d',7);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('15d','15-day','15d',15);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('1m','1 Month','1m',30);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('3m','3 Months','3m',90);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('6m','6 Months','6m',180);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('1y','1 Year','1y',365);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,days) values('2y','2 Year','2y',730);
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,block_height) values('ALL','','',0);

update
    recent_time rt
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
insert into tag_result(table_name,batch_date)  SELECT 'basic_data_recent_time' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
