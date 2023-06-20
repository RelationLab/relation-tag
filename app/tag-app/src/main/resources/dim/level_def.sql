DROP TABLE if EXISTS  level_def;
create table level_def
(

    level varchar(80) NULL,
    type varchar(80) NULL,
    level_name varchar(80) NULL
) ;
insert into level_def(level,level_name,type) values('L1','Activity Lv1','count');
insert into level_def(level,level_name,type) values('L2','Activity Lv2','count');
insert into level_def(level,level_name,type) values('L3','Activity Lv3','count');
insert into level_def(level,level_name,type) values('L4','Activity Lv4','count');
insert into level_def(level,level_name,type) values('L5','Activity Lv5','count');
insert into level_def(level,level_name,type) values('L6','Activity Lv6','count');
insert into level_def(level,level_name,type) values('Highest','Highest Activity','count');
insert into level_def(level,level_name,type) values('High','High Activity','count');
insert into level_def(level,level_name,type) values('Medium','Medium Activity','count');



insert into level_def(level,level_name,type) values('L1','Vol Lv1','defi_volume_grade');
insert into level_def(level,level_name,type) values('L2','Vol Lv2','defi_volume_grade');
insert into level_def(level,level_name,type) values('L3','Vol Lv3','defi_volume_grade');
insert into level_def(level,level_name,type) values('L4','Vol Lv4','defi_volume_grade');
insert into level_def(level,level_name,type) values('L5','Vol Lv5','defi_volume_grade');
insert into level_def(level,level_name,type) values('L6','Vol Lv6','defi_volume_grade');
insert into level_def(level,level_name,type) values('Million','Trader','defi_volume_grade');
insert into level_def(level,level_name,type) values('Billion','Trader','defi_volume_grade');

insert into level_def(level,level_name,type) values('Legendary','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Elite','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Heavy','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Medium ','Trader','defi_volume_rank');
