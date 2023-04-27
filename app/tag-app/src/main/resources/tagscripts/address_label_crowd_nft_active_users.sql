drop table if exists address_label_crowd_nft_active_users;
CREATE TABLE public.address_label_crowd_nft_active_users (
                                                             address varchar(512) NULL,
                                                             data numeric(250, 20) NULL,
                                                             wired_type varchar(20) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL,
                                                             "group" varchar(1) NULL,
                                                             "level" varchar(80) NULL,
                                                             category varchar(80) NULL,
                                                             trade_type varchar(80) NULL,
                                                             project varchar(80) NULL,
                                                             asset varchar(80) NULL,
                                                             bus_type varchar(20) NULL
);
truncate table public.address_label_crowd_nft_active_users;
vacuum address_label_crowd_nft_active_users;

insert into public.address_label_crowd_nft_active_users(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    distinct a1.address ,
    'crowd_nft_active_users' as label_type,
    'crowd_nft_active_users' as label_name,
    0  as data,
    'CROWD'  as wired_type,
    now() as updated_at,
    'g'  as "group",
    'crowd_nft_active_users'  as level,
    'other' as category,
    'ALL' as trade_type,
    'ALL' as project,
    'ALL' as asset,
    'CROWD' as bus_type
from address_label_nft_count_grade a1
where (label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Low'
    or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_Medium'
    or label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High')
  and
         address not in (select address from exclude_address);
insert into tag_result(table_name,batch_date)  SELECT 'address_label_crowd_nft_active_users' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
