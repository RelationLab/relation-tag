truncate table address_label_nft_balance_top;
insert into public.address_label_nft_balance_top (address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type || '_' || 'WHALE' as label_name,
    now() as updated_at
    from
    (
        select
            address,
            (
                select
                    distinct  label_type
                from
                    dim_project_token_type dptt
                where
                        dptt.seq_flag = s1.seq_flag
                  and dptt.data_subject = 'balance_top'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%'
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and (dptt.type = ''
                    or dptt.type = 'ALL')) as label_type
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
					nft_holding where address <>'0x000000000000000000000000000000000000dead') totala
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

    ) s1
    where
    s1.rn <= 100 ) t;