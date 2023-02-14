truncate table public.address_label_token_count_grade;
insert into public.address_label_token_count_grade(address,label_type,label_name,data,wired_type,updated_at)
    select
    a1.address ,
    a2.label_type,
    a2.label_type || '_' || case
                                when total_transfer_count >= 1
                                    and total_transfer_count < 10 then 'L1'
                                when total_transfer_count >= 10
                                    and total_transfer_count < 40 then 'L2'
                                when total_transfer_count >= 40
                                    and total_transfer_count < 80 then 'L3'
                                when total_transfer_count >= 80
                                    and total_transfer_count < 120 then 'L4'
                                when total_transfer_count >= 120
                                    and total_transfer_count < 160 then 'L5'
                                when total_transfer_count >= 160
                                    and total_transfer_count < 200 then 'L6'
                                when total_transfer_count >= 200
                                    and total_transfer_count < 400 then 'Low'
                                when total_transfer_count >= 400
                                    and total_transfer_count < 619 then 'Medium'
                                when total_transfer_count >= 619 then 'High'
        end as label_name,
    total_transfer_count  as data,
    'DEFI'  as wired_type,
    now() as updated_at
    from
    (
        select
            address,
            token,
            total_transfer_count
        from
            token_holding_vol_count th1
        union all
        select
            address,
            'ALL' as token ,
            sum(total_transfer_count) as total_transfer_count
        from
            (
                select
                    address,
                    total_transfer_count
                from
                    eth_holding_vol_count th
                union all
                select
                    address,
                    total_transfer_count
                from
                    token_holding_vol_count th where th.token in (select token_id from dim_rank_token)
            ) th2
        group by
            address
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
         and a2.label_type not like 'Uniswap_v3%'
    where
        a1.total_transfer_count >= 1
  and a2.data_subject = 'count' and address <>'0x000000000000000000000000000000000000dead';

truncate table public.address_label_crowd_defi_active_users;
insert into public.address_label_crowd_defi_active_users(address,label_type,label_name,data,wired_type,updated_at)
select
           a1.address ,
           'crowd_defi_active_users' as label_type,
           'crowd_defi_active_users' as label_name,
           0  as data,
           'CROWD'  as wired_type,
           now() as updated_at
       from address_label_token_count_grade a1
       where (label_name = 'ALL_ALL_ALL_ACTIVITY_High'
           or label_name = 'ALL_ALL_ALL_ACTIVITY_Medium'
           or label_name = 'ALL_ALL_ALL_ACTIVITY_Low')
         and  address <>'0x000000000000000000000000000000000000dead';

truncate table public.address_label_crowd_active_users;
insert into public.address_label_crowd_active_users(address,label_type,label_name,data,wired_type,updated_at)
         select
             a1.address ,
             'crowd_active_users' as label_type,
             'crowd_active_users' as label_name,
             0  as data,
             'CROWD'  as wired_type,
             now() as updated_at
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