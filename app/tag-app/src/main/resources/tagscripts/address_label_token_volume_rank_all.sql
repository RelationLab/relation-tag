drop table if exists address_label_token_volume_rank_all;
CREATE TABLE public.address_label_token_volume_rank_all (

                                                            address varchar(512) NULL,
                                                            data numeric(250, 20) NULL,
                                                            wired_type varchar(20) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL,
                                                            "group" varchar(1) NULL,
                                                            "level" varchar(20) NULL,
                                                            category varchar(20) NULL,
                                                            trade_type varchar(30) NULL,
                                                            project varchar(50) NULL,
                                                            asset varchar(50) NULL
);
truncate table public.address_label_token_volume_rank_all;
insert into public.address_label_token_volume_rank_all(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
    select
    tb1.address,
    tb2.label_type,
    tb2.label_type || '_' || case
                                 when zb_rate > 0.025
                                     and zb_rate <= 0.1 then 'MEDIUM'
                                 when zb_rate > 0.01
                                     and zb_rate <= 0.025 then 'HEAVY'
                                 when zb_rate > 0.001
                                     and zb_rate <= 0.01 then 'ELITE'
                                 when zb_rate <= 0.001 then 'LEGENDARY'
        end as label_name,
    zb_rate  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'v'  as "group",
    case
    when zb_rate > 0.025
    and zb_rate <= 0.1 then 'MEDIUM'
    when zb_rate > 0.01
    and zb_rate <= 0.025 then 'HEAVY'
    when zb_rate > 0.001
    and zb_rate <= 0.01 then 'ELITE'
    when zb_rate <= 0.001 then 'LEGENDARY' end  as level,
    'rank'  as category,
    'all' trade_type,
    'all' as project,
    'all' as asset
    from
    (
        select
            t1.address,
            t1.token,
            t1.volume_usd,
            t1.count_sum,
            t1.count_sum_total,
            t1.zb_rate
        from
            (
                select
                    a2.address,
                    a2.token,
                    a2.volume_usd,
                    a2.count_sum,
                    a2.count_sum_total,
                    cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
                from
                    (
                        select
                            a1.address,
                            a1.token,
                            a1.volume_usd,
                            a1.count_sum,
                            a10.count_sum_total
                        from
                            (
                                select
                                    a1.address,
                                    a1.token,
                                    a1.volume_usd,
                                    row_number() over(partition by token
				order by
					volume_usd desc,
					address asc) as count_sum
                                from
                                    (
                                        select
                                            'ALL' token,
                                            s1.address,
                                            s1.volume_usd
                                        from
                                            total_volume_usd s1
                                        where
                                                volume_usd >0 and address <>'0x000000000000000000000000000000000000dead') as a1) as a1
                                inner join
                            (
                                select
                                    count(distinct address) as count_sum_total,
                                    token
                                from
                                    (
                                        select
                                            token,
                                            address,
                                            sum(volume_usd) as volume_usd
                                        from
                                            (
                                                select
                                                    'ALL' token,
                                                    address,
                                                    volume_usd
                                                from
                                                    total_volume_usd
                                                where
                                                        volume_usd >= 100 and address <>'0x000000000000000000000000000000000000dead') totala
                                        group by
                                            token,
                                            address) tbvu
                                where
                                        volume_usd >= 100
                                group by
                                    token) as a10
                            on
                                    a10.token = a1.token) as a2) as t1) tb1
        inner join
    dim_rule_content tb2
    on
            tb1.token = tb2.token
    where
        tb1.volume_usd >= 100
  and tb2.data_subject = 'volume_rank'
  and tb2.token_type = 'token'
  and zb_rate <= 0.1;

drop table if exists address_label_crowd_defi_high_demander;
CREATE TABLE public.address_label_crowd_defi_high_demander (
                                                               address varchar(512) NULL,
                                                               data numeric(250, 20) NULL,
                                                               wired_type varchar(20) NULL,
                                                               label_type varchar(512) NULL,
                                                               label_name varchar(1024) NULL,
                                                               updated_at timestamp(6) NULL,
                                                               "group" varchar(1) NULL,
                                                               "level" varchar(20) NULL,
                                                               category varchar(20) NULL,
                                                               trade_type varchar(30) NULL,
                                                               project varchar(50) NULL,
                                                               asset varchar(50) NULL
);
truncate table public.address_label_crowd_defi_high_demander;
insert into public.address_label_crowd_defi_high_demander(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset)
select
           a1.address ,
           'crowd_defi_high_demander' as label_type,
           'crowd_defi_high_demander' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at,
           'g'  as group,
    'crowd_defi_high_demander' level,
    'other' as category,
    'all' trade_type,
    'all' as project,
    'all' as asset  from address_label_token_volume_rank_all a1
       where (label_name = 'ALL_ALL_ALL_VOLUME_RANK_MEDIUM' or label_name = 'ALL_ALL_ALL_VOLUME_RANK_HEAVY'
           or label_name = 'ALL_ALL_ALL_VOLUME_RANK_ELITE'  or label_name = 'ALL_ALL_ALL_VOLUME_RANK_LEGENDARY')
         and
               address <>'0x000000000000000000000000000000000000dead';

drop table if exists address_label_crowd_elite;
CREATE TABLE public.address_label_crowd_elite (
                                                  address varchar(512) NULL,
                                                  data numeric(250, 20) NULL,
                                                  wired_type varchar(20) NULL,
                                                  label_type varchar(512) NULL,
                                                  label_name varchar(1024) NULL,
                                                  updated_at timestamp(6) NULL,
                                                  "group" varchar(1) NULL,
                                                  "level" varchar(20) NULL,
                                                  category varchar(20) NULL,
                                                  trade_type varchar(30) NULL,
                                                  project varchar(50) NULL,
                                                  asset varchar(50) NULL
);
truncate table public.address_label_crowd_elite;
insert into public.address_label_crowd_elite(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset)
 select
           a1.address ,
           'crowd_elite' as label_type,
           'crowd_elite' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at,
           'g'  as group,
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