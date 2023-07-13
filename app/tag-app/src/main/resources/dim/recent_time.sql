DROP TABLE if EXISTS  recent_time;
create table recent_time
(
    recent_time_code varchar(80) NULL,
    recent_time_name varchar(80) NULL,
    recent_time_content varchar(80) NULL,
    block_height int8  NULL
) ;

insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('3d','3-day','3d');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('7d','Weekly','7d');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('15d','15-day','15d');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('1m','1 Month','1m');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('3m','3 Months','3m');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('6m','6 Months','6m');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('1y','1 Year','1y');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name) values('2y','2 Year','2y');
insert into recent_time(recent_time_code,recent_time_content,recent_time_name,block_height) values('ALL','','',0);