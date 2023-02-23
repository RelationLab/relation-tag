drop table if exists address_label_token_balance_provider;
CREATE TABLE public.address_label_token_balance_provider (

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
truncate table address_label_token_balance_provider;
insert into public.address_label_token_balance_provider(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
    select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    rn  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    s1.label_type  as level,
    'other'  as category,
    'all' trade_type,
    'all' as project,
    s1.token_name as asset
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
                    *
                from
                    token_balance_volume_usd tbvu
                where
                        balance_usd>0 and address <>'0x000000000000000000000000000000000000dead') a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = 'HEAVY_LP'
    ) s1
    where
        s1.rn <= 200;