truncate table public.address_label_eth_time_special;
insert into public.address_label_eth_time_special(address,label_type,label_name,data,wired_type,updated_at)
 select
    a1.address,
    a2.label_type,
    a2.label_type || '_' || case
                                when counter >= 155 then 'LONG_TERM_HOLDER'
                                when counter >= 1
                                    and counter < 155 then 'SHORT_TERM_HOLDER'
        end as label_name,
    a1.counter  as data,
    'DEFI'  as wired_type,
    now() as updated_at
    from
    (
        select
            address,
            'eth' as token,
            floor((floor(extract(epoch from now())) - latest_tx_time) / (24 * 3600)) as counter
        from
            eth_holding_time tbvutk) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    where
        a2.data_subject = 'time_special'
  and counter >= 1
  and a2.token_type = 'token' and address <>'0x000000000000000000000000000000000000dead';


truncate table public.address_label_crowd_long_term_holder;
insert into public.address_label_crowd_long_term_holder(address,label_type,label_name,data,wired_type,updated_at)
 select
           a1.address ,
           'crowd_long_term_holder' as label_type,
           'crowd_long_term_holder' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at
       from (
                select address from address_label_eth_time_special
                where label_name = 'ETH_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
                union all
                select address from address_label_token_time_special
                where label_name like '%_HOLDING_TIME_SPECIAL_LONG_TERM_HOLDER'
                union all
                select address from address_label_nft_time_rank
                where label_name like '%_NFT_TIME_SPECIAL_LONG_TERM_HOLDER'
            ) a1
       where  address <>'0x000000000000000000000000000000000000dead';