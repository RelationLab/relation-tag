truncate table public.address_label_nft_volume_top;
insert into public.address_label_nft_volume_top(address,label_type,label_name,data,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    data,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from (
    select
    address,
    label_type,
    label_type || '_' || 'TOP' as label_name,
    rn  as data,
    now() as updated_at
    from
    (
        select
            s1.address,
            (
                select
                    distinct  label_type
                from
                    dim_project_token_type dptt
                where
                        dptt.seq_flag = s1.seq_flag
                  and dptt.type = s1.type
                  and dptt.data_subject = 'volume_top'
                  and dptt.label_type like '%NFT%'
                  and dptt.label_type not like '%WEB3%'
                  and (dptt.project = ''
                    or dptt.project = 'ALL')) as label_type,
            rn
    from
		(
		select
			a1.address,
			seq_flag,
			type,
			-- 分组字段很关键
            row_number() over( partition by seq_flag,
			type
		order by
			transfer_volume desc,
			address asc) as rn
		from
			(
			select
				address,
				seq_flag,
				a2.type,
				sum(transfer_volume) as transfer_volume
			from
				(
				-- project(null)+nft+type(null)
				select
					address,
					token,
					'' as type,
					transfer_volume
				from
					nft_volume_count
				where
					transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(null)+nft(ALL)+type(null)
				select
					address,
					'ALL' as token,
					'' as type,
					transfer_volume
				from
					nft_volume_count
				where
					transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(null)+nft+type
				select
					address,
					token,
					type,
					transfer_volume
				from
					nft_volume_count
				where
					transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(null)+nft+type(ALL)
				select
					address,
					token,
					'ALL' as type,
					transfer_volume
				from
					nft_volume_count
				where
					transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(null)+nft（ALL）+type
				select
					address,
					'ALL' as token,
					type,
					transfer_volume
				from
					nft_volume_count
				where
					transfer_volume >= 1 and address <>'0x000000000000000000000000000000000000dead'
          ) tatola
			inner join dim_project_token_type a2
                           on
				tatola.token = a2.token
				and tatola.type = a2.type
				and a2.data_subject = 'volume_top'
				and a2.label_type like '%NFT%'
				and a2.label_type not like '%WEB3%'
				and (a2.project = ''
					or a2.project = 'ALL')
			group by
				address,
				seq_flag,
				a2.type) a1
    ) s1
    where
    s1.rn <= 100) t) atb;