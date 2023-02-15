drop table if exists address_label_nft_transfer_volume_rank;
CREATE TABLE public.address_label_nft_transfer_volume_rank (

                                                               address varchar(512) NULL,
                                                               data numeric(250, 20) NULL,
                                                               wired_type varchar(20) NULL,
                                                               label_type varchar(512) NULL,
                                                               label_name varchar(1024) NULL,
                                                               updated_at timestamp(6) NULL
);
truncate table public.address_label_nft_transfer_volume_rank;
insert into public.address_label_nft_transfer_volume_rank(address,label_type,label_name,data,wired_type,updated_at)
 select
    address ,
    label_type,
    label_type || '_' || case
                             when zb_rate > 0.01
                                 and zb_rate <= 0.025 then 'RARE_NFT_TRADER'
                             when zb_rate > 0.001
                                 and zb_rate <= 0.01 then 'EPIC_NFT_TRADER'
                             when zb_rate > 0.025
                                 and zb_rate <= 0.1 then 'UNCOMMON_NFT_TRADER'
                             when zb_rate <= 0.001 then 'LEGENDARY_NFT_TRADER'
        end as label_name,
    zb_rate  as data,
    'NFT'  as wired_type,
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
                  and dptt.type = 'Transfer'
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and dptt.type = 'Transfer'
                  and (dptt.project = ''
                    or dptt.project = 'ALL')
                  and dptt.data_subject = 'volume_rank'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%') as label_type,
    zb_rate
    from
		(
		select
			t1.address,
			t1.seq_flag,
			t1.total_transfer_volume,
			t1.count_sum,
			t1.count_sum_total,
			t1.zb_rate
		from
			(
			select
				a2.address,
				a2.seq_flag,
				a2.total_transfer_volume,
				a2.count_sum,
				a2.count_sum_total,
				cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
			from
				(
				select
					a1.address,
					a1.seq_flag,
					a1.total_transfer_volume,
					a1.count_sum,
					a10.count_sum_total
				from
					(
					select
						a1.address,
						a1.seq_flag,
						a1.total_transfer_volume,
						row_number() over(partition by seq_flag
					order by
						total_transfer_volume desc,
						address asc) as count_sum
					from
						(
						select
							s1.address,
							s2.seq_flag,
							sum(s1.total_transfer_volume) as total_transfer_volume
						from
							(
							-- project-token-type
							select
								address,
								token,
								total_transfer_volume
							from
								nft_transfer_holding
							where
								total_transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
						union all
							-- project(null)+nft（ALL）+type
							select
								address,
								'ALL' as token,
								total_transfer_volume
							from
								nft_transfer_holding
							where
								total_transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
                                     ) s1
						inner join dim_project_token_type s2
                                                    on
							s1.token = s2.token
							and s2.type = 'Transfer'
							and (s2.project = ''
								or s2.project = 'ALL')
							and s2.data_subject = 'volume_rank'
							and s2.label_type like '%NFT%'
							and s2.label_type not like '%WEB3%'
						where
							total_transfer_volume >= 1
						group by
							s1.address,
							s2.seq_flag) as a1) as a1
				inner join
                       (
					select
						count(distinct address) as count_sum_total ,
						seq_flag
					from
						(
						-- project-token-type
						select
							address,
							token
						from
							nft_transfer_holding
						where
							total_transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
					union all
						-- project(null)+nft（ALL）+type
						select
							address,
							'ALL' as token
						from
							nft_transfer_holding
						where
							total_transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead') totala
					inner join
     dim_project_token_type tb2
     on
						totala.token = tb2.token
						and tb2.type = 'Transfer'
						and (tb2.project = ''
							or tb2.project = 'ALL')
						and tb2.data_subject = 'volume_rank'
						and tb2.label_type like '%NFT%'
						and tb2.label_type not like '%WEB3%'
					group by
						seq_flag) as a10
                       on
					a10.seq_flag = a1.seq_flag) as a2) as t1
     ) tb1
    where
    tb1.total_transfer_volume >= 1
  and zb_rate <= 0.1) t ;