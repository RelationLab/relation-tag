truncate  table public.address_label_nft_balance_rank;
insert into public.address_label_nft_balance_rank(address,label_type,label_name,updated_at)
    select
    address,
    label_type,
    label_type || '_' || case
                             when zb_rate > 0.01
                                 and zb_rate <= 0.025 then 'RARE_NFT_COLLECTOR'
                             when zb_rate > 0.001
                                 and zb_rate <= 0.01 then 'EPIC_NFT_COLLECTOR'
                             when zb_rate > 0.025
                                 and zb_rate <= 0.1 then 'UNCOMMON_NFT_COLLECTOR'
                             when zb_rate <= 0.001 then 'LEGENDARY_NFT_COLLECTOR'
        end as label_name,
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
                        dptt.seq_flag = tb1.seq_flag
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and (dptt.type = ''
                    or dptt.type = 'ALL')
                  and dptt.data_subject = 'balance_rank'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%') as label_type,
    zb_rate
    from
		(
		select
			t1.address,
			t1.balance,
			t1.seq_flag
			t1.count_sum,
			t1.count_sum_total,
			t1.zb_rate
		from
			(
			select
				a2.id,
				a2.address,
				a2.seq_flag,
				a2.balance,
				a2.count_sum,
				a2.count_sum_total,
				cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
			from
				(
				select
					a1.id,
					a1.address,
					a1.seq_flag,
					a1.balance,
					a1.count_sum,
					a10.count_sum_total
				from
					(
					select
						md5(cast(random() as varchar)) as id,
						a1.address,
						a1.seq_flag,
						a1.balance,
						row_number() over(partition by seq_flag
					order by
						balance desc,
						address asc) as count_sum
					from
						(
						select
							s1.address,
							s2.seq_flag,
							sum(s1.balance) as balance
						from
							(
							-- project(null)+nft+type(null)
							select
								address,
								token,
								balance
							from
								nft_holding
							where
								balance >= 1
						union all
							-- project(null)-token(ALL)-type(null)
							select
								address,
								'ALL' as token,
								balance
							from
								nft_holding
							where
								balance >= 1
    )
    s1
						inner join dim_project_token_type s2
    on
							s1.token = s2.token
							and (s2.project = ''
								or s2.project = 'ALL')
							and (s2.type = ''
								or s2.type = 'ALL')
							and s2.data_subject = 'balance_rank'
							and s2.label_type like '%NFT%'
							and s2.label_type not like '%WEB3%'
						where
							balance >= 1
						group by
							s1.address,
							s2.seq_flag) as a1) as a1
				inner join
    (
					select
						count(distinct address) as count_sum_total,
						seq_flag
					from
						(
						select
							address,
							token,
							balance
						from
							nft_holding
						where
							balance >= 1
					union all
						-- project(null)-token(ALL)-type(null)
						select
							address,
							'ALL' as token,
							balance
						from
							nft_holding
						where
							balance >= 1) totala
					inner join dim_project_token_type tb2
    on
						totala.token = tb2.token
						and (tb2.project = ''
							or tb2.project = 'ALL')
						and (tb2.type = ''
							or tb2.type = 'ALL')
						and tb2.data_subject = 'balance_rank'
						and tb2.label_type like '%NFT%'
						and tb2.label_type not like '%WEB3%'
					group by
						seq_flag) as a10
    on
					a10.seq_flag = a1.seq_flag) as a2) as t1
    ) tb1
    where
    tb1.balance >= 1
  and zb_rate <= 0.1) t;