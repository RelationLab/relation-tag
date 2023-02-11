truncate table address_label_token_balance_top;
insert into public.address_label_token_balance_top (address,label_type,label_name,data,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type || '_' || 'WHALE' as label_name,
    rn,
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
                            token,
                            balance_usd,
                            volume_usd
                        from
                            token_balance_volume_usd
                        where
                                balance_usd>100 and address <>'0x000000000000000000000000000000000000dead'
                    ) totala
                group by
                    address,
                    token) a1
                inner join dim_rule_content a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'balance_top'
                                   and a2.label_type not like 'Uniswap_v3%'
    ) s1
    where
        s1.rn <= 100;