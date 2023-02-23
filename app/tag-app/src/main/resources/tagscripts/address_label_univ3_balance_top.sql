drop table if exists address_label_univ3_balance_top;
CREATE TABLE public.address_label_univ3_balance_top (

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
truncate table address_label_univ3_balance_top;
insert into public.address_label_univ3_balance_top(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset)
    select
    s1.address,
    s1.label_type,
    s1.label_type || '_' || 'WHALE' as label_name,
    rn  as data,
    'DEFI'  as wired_type,
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
                            balance_usd
                        from
                            dex_tx_volume_count_summary
                        where
                                project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                          and balance_usd >= 100
                          and type = 'lp' and address <>'0x000000000000000000000000000000000000dead'
                    ) totala
                group by
                    address,
                    token) a1
                inner join dim_rule_content a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'balance_top'
                                   and a2.label_type  like 'Uniswap_v3%'
    ) s1
    where
        s1.rn <= 100;