drop table if exists address_label_crowd_elite;
CREATE TABLE public.address_label_crowd_elite (
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
truncate table public.address_label_crowd_elite;
insert into public.address_label_crowd_elite(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    a1.address ,
    'crowd_elite' as label_type,
    'crowd_elite' as label_name,
    0  as data,
    'CROWD'  as wired_type,
    now() as updated_at,
    'g'  as "group",
    'crowd_elite' level,
    'other' as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
from (
         select address from address_label_nft_volume_count_rank
         where label_name = 'ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER'
         union all
         select address from address_label_token_volume_rank_all
         where label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'
     ) a1
where
        address <>'0x000000000000000000000000000000000000dead';