drop table if exists address_label_univ3_balance_provider;
CREATE TABLE public.address_label_univ3_balance_provider (
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
                                                             asset varchar(50) NULL,
                                                             bus_type varchar(20) NULL
);
truncate table address_label_univ3_balance_provider;
insert into public.address_label_univ3_balance_provider(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
    select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    rn  as data,
    'WEB3'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    s1.label_type  as level,
    'other'  as category,
    'all' trade_type,
    'all' as project,
    s1.token_name as asset,
    'balance' as bus_type
    from
    (
        select
            a1.address,
            a2.label_type,
    a2.token_name,
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
                            round(balance_usd,3) balance_usd
                        from
                            dex_tx_volume_count_summary
                        where
                                project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                          and balance_usd >= 100
                          and type = 'lp' and address <>'0x000000000000000000000000000000000000dead'  and address <> '0x0000000000000000000000000000000000000000'
                    ) totala
                group by
                    address,
                    token) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'HEAVY_LP'
    ) s1
    where
        s1.rn <= 200;