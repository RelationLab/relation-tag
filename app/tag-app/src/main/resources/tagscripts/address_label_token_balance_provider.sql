truncate table address_label_token_balance_provider;
insert into public.address_label_token_balance_provider (address,label_type,label_name,updated_at)
    select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
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
                    *
                from
                    token_balance_volume_usd tbvu
                where
                        balance_usd>0) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'HEAVY_LP'
    ) s1
    where
        s1.rn <= 200;