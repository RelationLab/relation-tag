drop table if exists address_label_crowd_active_users;
CREATE TABLE public.address_label_crowd_active_users (
                                                         address varchar(512) NULL,
                                                         data numeric(250, 20) NULL,
                                                         wired_type varchar(20) NULL,
                                                         label_type varchar(512) NULL,
                                                         label_name varchar(1024) NULL,
                                                         updated_at timestamp(6) NULL,
                                                         "group" varchar(1) NULL,
                                                         "level" varchar(50) NULL,
                                                         category varchar(50) NULL,
                                                         trade_type varchar(50) NULL,
                                                         project varchar(50) NULL,
                                                         asset varchar(50) NULL
);
truncate table public.address_label_crowd_active_users;
insert into public.address_label_crowd_active_users(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
select
    a1.address ,
    'crowd_active_users' as label_type,
    'crowd_active_users' as label_name,
    0  as data,
    'CROWD'  as wired_type,
    now() as updated_at,
    'g'  as "group",
    'crowd_active_users'  as level,
    'other'  as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
from (
         select address from address_label_nft_count_grade
         where label_name = 'ALL_ALL_ALL_NFT_ACTIVITY_High'
         union all
         select address from address_label_web3_type_count_grade
         where label_name = 'WEB3_ALL_NFTRecipient_ACTIVITY_High'
         union all
         select address from address_label_token_count_grade
         where label_name = 'ALL_ALL_ALL_ACTIVITY_High') a1
where
        address <>'0x000000000000000000000000000000000000dead' ;