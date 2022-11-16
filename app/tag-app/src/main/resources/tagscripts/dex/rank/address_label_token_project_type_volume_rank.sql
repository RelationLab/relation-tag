truncate table public.address_label_token_project_type_volume_rank;
insert into public.address_label_token_project_type_volume_rank(address,label_type,label_name,updated_at)
    select tb1.address ,
       tb2.label_type,
       tb2.label_type||'_'||case
                                when zb_rate > 0.01 and zb_rate <= 0.025 then 'HEAVY'
                                when zb_rate > 0.001 and zb_rate <= 0.01 then 'ELITE'
                                when zb_rate > 0.025 and zb_rate <= 0.1 then 'MEDIUM'
                                when zb_rate <= 0.001 then 'LEGENDARY'
           end as label_name,
       now()   as updated_at
    from (select t1.id,
             t1.address,
             t1.token,
             t1.project,
             t1.type,
             t1.total_transfer_volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.project,
                   a2.type,
                   a2.total_transfer_volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.project,
                         a1.type,
                         a1.total_transfer_volume_usd,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.project,
                            a1.type,
                            a1.total_transfer_volume_usd,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
    ORDER BY
	total_transfer_volume_usd DESC,address asc) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    s1.project,
                                    s1.type,
                                    min(s1.first_updated_block_height) as first_updated_block_height,
                                    sum(s1.total_transfer_volume_usd) AS total_transfer_volume_usd
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,type
                                              ,project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100
                                         union all
                                         -- project(ALL)-token(ALL)-type
                                         select address
                                              ,'ALL' AS token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,type
                                              ,'ALL' AS project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                         union all
                                         -- project-token(ALL)-type(ALL)
                                         select address
                                              ,'ALL' AS  token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,'ALL' AS  type
                                              ,project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                         union all
                                         -- project(ALL)-token-type(ALL)
                                         select address
                                              ,token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,'ALL' AS type
                                              ,'ALL' AS project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100
                                         union all
                                         -- project-token(ALL)-type
                                         select address
                                              ,'ALL' AS token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,type
                                              , project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                         union all
                                         -- project(ALL)-token-type
                                         select address
                                              ,token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,type
                                              ,'ALL' AS  project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100
                                         union all
                                         -- project-token-type(ALL)
                                         select address
                                              ,token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,'ALL' AS type
                                              , project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100)
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s1.project = s2.project
                                                            AND s1.type = s2.type
                                                            AND s2.data_subject = 'volume_rank'
                                WHERE
                                        total_transfer_volume_usd >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.project,
                                    s1.type,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (
                       select count(distinct address) as count_sum_total,token,project,type
                        from (
                                 select
                                     address
                                      ,token
                                      ,type
                                      ,project
                                      ,sum(total_transfer_volume_usd) total_transfer_volume_usd from (
                                     select  address
                                          ,token
                                          ,type
                                          ,project
                                          ,total_transfer_volume_usd
                                     from dex_tx_volume_count_summary where total_transfer_volume_usd >=100
                                     union all
                                     -- project(ALL)-token(ALL)-type
                                     select address
                                          ,'ALL' AS token
                                          ,type
                                          ,'ALL' AS project
                                          ,total_transfer_volume_usd from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                     union all
                                     -- project-token(ALL)-type(ALL)
                                     select address
                                          ,'ALL' AS  token
                                          ,'ALL' AS  type
                                          ,project
                                          ,total_transfer_volume_usd  from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                     union all
                                     -- project(ALL)-token-type(ALL)
                                     select address
                                          ,token
                                          ,'ALL' AS type
                                          ,'ALL' AS project
                                          ,total_transfer_volume_usd
                                     from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100
                                     union all
                                     -- project-token(ALL)-type
                                     select address
                                          ,'ALL' AS token
                                          ,type
                                          , project
                                          ,total_transfer_volume_usd
                                     from dex_tx_volume_count_summary where total_transfer_volume_usd > 0
                                     union all
                                     -- project(ALL)-token-type
                                     select address
                                          ,token
                                          ,type
                                          ,'ALL' AS  project
                                          ,total_transfer_volume_usd
                                     from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100
                                     union all
                                     -- project-token-type(ALL)
                                     select address
                                          ,token
                                          ,'ALL' AS type
                                          , project
                                          ,total_transfer_volume_usd from dex_tx_volume_count_summary where total_transfer_volume_usd >= 100)
                                     ta group by address
                                               ,token
                                               ,type
                                               ,project) dtvcs where  total_transfer_volume_usd>=100
                        group by token,project,type ) as a10
                       on a10.token = a1.token and a10.project=a1.project and a10.type=a1.type) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
                 tb1.token = tb2.token
             and tb1.project = tb2.project
             and tb1.type = tb2.type
    where tb1.total_transfer_volume_usd >= 100
  and tb2.data_subject = 'volume_rank' and  zb_rate <= 0.1;