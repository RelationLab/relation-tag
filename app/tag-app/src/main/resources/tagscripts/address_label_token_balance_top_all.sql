truncate table address_label_token_balance_top_all;
insert into public.address_label_token_balance_top_all(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from (
    select
    s1.address,
    s1.label_type,
    s1.label_type || '_' || 'WHALE' as label_name,
    rn  as data,
    now() as updated_at
    from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		balance_usd desc,
		address asc) as rn
        from
            (
                select
                    address,
                    token,
                    sum(balance_usd) as balance_usd
                from
                    (
                        select
                            address,
                            'ALL' as token,
                            balance_usd,
                            volume_usd
                        from
                            total_balance_volume_usd
                        where
                                balance_usd>0 and address <>'0x000000000000000000000000000000000000dead') totala
                where
                        balance_usd>100
                group by
                    address,
                    token) a1
                inner join dim_rule_content a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'balance_top'
                                   and a2.token_type = 'token'
    ) s1
    where
        s1.rn <= 100) atb;