truncate table public.address_label_web3_type_balance_rank;
insert into public.address_label_web3_type_balance_rank (address,label_type,label_name,updated_at)
    select
    address ,
    label_type,
    label_type || '_' || case
                             when zb_rate > 0.01
                                 and zb_rate <= 0.025 then 'RARE'
                             when zb_rate > 0.001
                                 and zb_rate <= 0.01 then 'EPIC'
                             when zb_rate > 0.025
                                 and zb_rate <= 0.1 then 'UNCOMMON'
                             when zb_rate <= 0.001 then 'LEGENDARY'
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
                    dim_project_type dptt
                where
                        dptt.project = tb1.project
                  and dptt.type = tb1.type
                  and dptt.data_subject = 'balance_rank') as label_type,
    zb_rate
    from
		(
		select
			t1.address,
			t1.project,
			t1.type,
			t1.balance,
			t1.count_sum,
			t1.count_sum_total,
			t1.zb_rate
		from
			(
			select
				a2.address,
				a2.project,
				a2.type,
				a2.balance,
				a2.count_sum,
				a2.count_sum_total,
				cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
			from
				(
				select
					a1.address,
					a1.project,
					a1.type,
					a1.balance,
					a1.count_sum,
					a10.count_sum_total
				from
					(
					select
						a1.address,
						a1.project,
						a1.type,
						a1.balance,
						row_number() over(partition by project,
						type
					order by
						balance desc,
						address asc) as count_sum
					from
						(
						select
							s1.address,
							s1.project,
							s1.type,
							sum(s1.balance) as balance
						from
							(
							-- project-type
							select
								address,
								total_transfer_volume,
								total_transfer_count,
								type,
								project,
								balance
							from
								web3_transaction_record_summary where balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
						union all
							-- project(ALL)-type
							select
								address,
								total_transfer_volume,
								total_transfer_count,
								type,
								'ALL' as project,
								balance
							from
								web3_transaction_record_summary where  balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
						union all
							-- project(ALL)-type(ALL)
							select
								address,
								total_transfer_volume,
								total_transfer_count,
								'ALL' as type,
								'ALL' as project,
								balance
							from
								web3_transaction_record_summary where  balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
						union all
							-- project-type(ALL)
							select
								address,
								total_transfer_volume,
								total_transfer_count,
								'ALL' as type,
								project,
								balance
							from
								web3_transaction_record_summary where  balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
                                     )
                                         s1
						inner join dim_project_type s2
                                                    on
							s1.project = s2.project
							and s1.type = s2.type
							and s2.data_subject = 'balance_rank'
						where
							balance >= 1
						group by
							s1.address,
							s1.project,
							s1.type) as a1) as a1
				inner join
                       (
					select
						count(distinct address) as count_sum_total,
						type,
						project
					from
						(
						-- project-type
						select
							address,
							type ,
							project
						from
							web3_transaction_record_summary
						where
							balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
					union all
						-- project(ALL)-type
						select
							address,
							type,
							'ALL' as project
						from
							web3_transaction_record_summary
						where
							balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
					union all
						-- project(ALL)-type(ALL)
						select
							address,
							'ALL' as type,
							'ALL' as project
						from
							web3_transaction_record_summary
						where
							balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
					union all
						-- project-type(ALL)
						select
							address,
							'ALL' as type,
							project
						from
							web3_transaction_record_summary
						where
							balance >= 1 and address <>'0x000000000000000000000000000000000000dead') w3trs
					group by
						type,
						project) as a10
                       on
					a10.type = a1.type
					and a10.project = a1.project) as a2) as t1
     ) tb1
	inner join
     dim_project_type tb2
    on
    tb1.project = tb2.project
    and tb1.type = tb2.type
    where
    tb2.data_subject = 'balance_rank'
  and zb_rate <= 0.1) t ;