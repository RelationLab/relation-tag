drop table if exists address_label_nft_transfer_volume_top;
CREATE TABLE public.address_label_nft_transfer_volume_top (
                                                              address varchar(512) NULL,
                                                              data numeric(250, 20) NULL,
                                                              wired_type varchar(20) NULL,
                                                              label_type varchar(512) NULL,
                                                              label_name varchar(1024) NULL,
                                                              updated_at timestamp(6) NULL,
                                                              "group" varchar(1) NULL,
                                                              "level" varchar(100) NULL,
                                                              category varchar(100) NULL,
                                                              trade_type varchar(100) NULL,
                                                              project varchar(100) NULL,
                                                              asset varchar(100) NULL,
                                                              bus_type varchar(20) NULL
);
truncate table address_label_nft_transfer_volume_top;
vacuum address_label_nft_transfer_volume_top;

insert
into
    public.address_label_nft_transfer_volume_top(address,
                                                 label_type,
                                                 label_name,
                                                 data,
                                                 wired_type,
                                                 updated_at,
                                                 "group",
                                                 level,
                                                 category,
                                                 trade_type,
                                                 project,
                                                 asset,
                                                 bus_type)
select
    address,
    label_type,
    label_type || '_' || 'TOP' as label_name,
    rn as data,
    'NFT' as wired_type,
    now() as updated_at,
    'v' as "group",
    'TOP' as level,
    'top' as category,
    t.type as trade_type,
    '' as project,
    t.token_name as asset,
    'volume' as bus_type
from
    (
        select
            address,
            dptt.label_type as label_type,
            dptt.type as type,
            dptt.project_name as project_name,
            dptt.token_name as token_name,
            rn,
            recent_time_code
        from
            (
                select
                    a1.address,
                    seq_flag,
                    -- 分组字段很关键
                    row_number() over( partition by seq_flag,
			recent_time_code
		order by
			total_transfer_volume desc,
			address asc) as rn,
                        recent_time_code
                from
                    (
                        select
                            address,
                            seq_flag,
                            sum(total_transfer_volume) as total_transfer_volume,
                            recent_time_code
                        from
                            (
                                select
                                    address,
                                    token,
                                    total_transfer_volume,
                                    recent_time_code
                                from
                                    nft_transfer_holding
                                where
                                        total_transfer_volume >= 1
                                  and address not in (
                                    select
                                        address
                                    from
                                        exclude_address)
                                  and token in (
                                    select
                                        token_id
                                    from
                                        dim_project_token_type_rank dpttr)
                                union all
                                -- project(null)+nft（ALL）+type
                                select
                                    address,
                                    'ALL' as token,
                                    total_transfer_volume,
                                    recent_time_code
                                from
                                    nft_transfer_holding
                                where
                                        total_transfer_volume >= 1
                                  and address not in (
                                    select
                                        address
                                    from
                                        exclude_address)
                                  and token in (
                                    select
                                        token_id
                                    from
                                        dim_project_token_type_rank dpttr)
                            ) totala
                                inner join dim_project_token_type a2
                                           on
                                                       totala.token = a2.token
                                                   and a2.type = 'Transfer'
                                                   and (a2.project = ''
                                                   or a2.project = 'ALL')
                                                   and a2.data_subject = 'volume_top'
                                                   and a2.label_type like '%NFT%'
                                                   and a2.label_type not like '%WEB3%'
                                                   and totala.recent_time_code = a2.recent_code
                        group by
                            address,
                            recent_time_code,
                            seq_flag) a1) s1
                inner join dim_project_token_type dptt on
                (dptt.seq_flag = s1.seq_flag
                    and dptt.type = 'Transfer'
                    and (dptt.project = ''
                        or dptt.project = 'ALL')
                    and dptt.data_subject = 'volume_top'
                    and dptt.label_type like '%NFT%'
                    and dptt.label_type not like '%WEB3%'
                    and s1.recent_time_code = dptt.recent_code)
        where
                s1.rn <= 100) t ;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_transfer_volume_top' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;