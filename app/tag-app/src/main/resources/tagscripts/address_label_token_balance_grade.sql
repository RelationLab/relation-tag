truncate table public.address_label_token_balance_grade;
insert into public.address_label_token_balance_grade(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from (
    select
    address,
    a2.label_type,
    a2.label_type || '_' || case
                                when balance_usd >= 100
                                    and balance_usd < 1000 then 'L1'
                                when balance_usd >= 1000
                                    and balance_usd < 10000 then 'L2'
                                when balance_usd >= 10000
                                    and balance_usd < 50000 then 'L3'
                                when balance_usd >= 50000
                                    and balance_usd < 100000 then 'L4'
                                when balance_usd >= 100000
                                    and balance_usd < 500000 then 'L5'
                                when balance_usd >= 500000
                                    and balance_usd < 1000000 then 'L6'
                                when balance_usd >= 1000000
                                    and balance_usd < 1000000000 then 'Millionaire'
                                when balance_usd >= 1000000000 then 'Billionaire'
        end as label_name,
    balance_usd  as `data`,
    now() as updated_at
    from
    (
        select
            address,
            token,
            balance_usd
        from
            token_balance_volume_usd tbvutk
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
    and a2.label_type not like 'Uniswap_v3%'
    where
        a1.balance_usd >= 100
  and a2.data_subject = 'balance_grade' and address <>'0x000000000000000000000000000000000000dead') atb;


