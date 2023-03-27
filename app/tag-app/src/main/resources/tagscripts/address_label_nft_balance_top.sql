drop table if exists address_label_nft_balance_top;
CREATE TABLE public.address_label_nft_balance_top (
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
truncate table address_label_nft_balance_top;
insert into public.address_label_nft_balance_top(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address,
    label_type,
    label_type || '_' || 'WHALE' as label_name,
    rn  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    'WHALE'  as level,
        'top' as category,
        t.type as trade_type,
        t.project_name as project,
        t.token_name as asset,
    'balance' as bus_type
    from
    (
        select
            address,
            dptt.label_type as label_type,
            dptt.type as type,
            dptt.project_name as project_name,
            dptt.token_name as token_name,
            s1.rn
    from
		(
		select
			a1.address,
			seq_flag,
			-- 分组字段很关键
    row_number() over( partition by seq_flag
		order by
			balance desc,
			address asc) as rn
		from
			(
			select
				address,
				seq_flag,
				sum(balance) as balance
			from
				(
				select
					address,
					token,
					balance
				from
					nft_holding where address <>'0x000000000000000000000000000000000000dead'
			union all
				select
					address,
					'ALL' as token,
					balance
				from
					nft_holding where address <>'0x000000000000000000000000000000000000dead'
					              and token in (select token_id from dim_project_token_type_rank dpttr)
                ) totala
			inner join dim_project_token_type a2
    on
				totala.token = a2.token
				and a2.data_subject = 'balance_top'
				and a2.label_type like '%NFT%'
				and a2.label_type not like '%WEB3%'
				and (a2.project = ''
					or a2.project = 'ALL')
				and (a2.type = ''
					or a2.type = 'ALL')
			where
				totala.balance >= 1
			group by
				address,
				seq_flag) a1

    ) s1 inner join dim_project_token_type dptt on (
        dptt.seq_flag = s1.seq_flag
                  and dptt.data_subject = 'balance_top'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%'
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and (dptt.type = ''
                    or dptt.type = 'ALL')
    )
    where
    s1.rn <= 100 ) t;