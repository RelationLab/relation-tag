truncate table public.address_label_nft_project_type_count_grade;
insert into public.address_label_nft_project_type_count_grade(address,label_type,label_name,`data`,wired_type,updated_at)
select
    address ,
    label_type,
    label_name,
    `data`,
    (select wired_type from label l where l.name=label_name) as wired_type,
    updated_at
from ( select
    address,
    label_type,
    label_type||'_'||case
        when sum_count >= 1
            and sum_count < 10 then 'L1'
        when sum_count >= 10
            and sum_count < 40 then 'L2'
        when sum_count >= 40
            and sum_count < 80 then 'L3'
        when sum_count >= 80
            and sum_count < 120 then 'L4'
        when sum_count >= 120
            and sum_count < 160 then 'L5'
        when sum_count >= 160
            and sum_count < 200 then 'L6'
        when sum_count >= 200
            and sum_count < 400 then 'Low'
        when sum_count >= 400
            and sum_count < 619 then 'Medium'
        when sum_count >= 619 then 'High'
        end as label_name,
    sum_count  as `data`,
    now() as updated_at
    from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            sum(
                    transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
            on a1.token=a2.token and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(
            transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a2.token='ALL' and a1.platform_group=a2.project and a2.type='ALL' and a1.type=a2.type and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type
            -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.label_type,
            sum(
            transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a2.token='ALL' and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type
            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.label_type,
            sum(
            transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
        on a1.token=a2.token and a1.platform_group=a2.project and a2.type='ALL' and a1.type= a2.type and a2.data_subject = 'count'
        group by
            a1.address,
            a2.label_type
    ) t where sum_count >= 1 and address <>'0x000000000000000000000000000000000000dead') atb;