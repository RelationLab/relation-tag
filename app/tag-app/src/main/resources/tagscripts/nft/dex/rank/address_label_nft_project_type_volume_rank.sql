truncate table public.address_label_nft_project_type_volume_rank;
insert into public.address_label_nft_project_type_volume_rank (address,label_type,label_name,updated_at)
    select tb1.address ,
       tb2.label_type,
       tb2.label_type||'_'||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then 'RARE_NFT_TRADER'
           when zb_rate > 0.001 and zb_rate <= 0.01 then 'EPIC_NFT_TRADER'
           when zb_rate > 0.025 and zb_rate <= 0.1 then 'UNCOMMON_NFT_TRADER'
           when zb_rate <= 0.001 then 'LEGENDARY_NFT_TRADER'
           end as label_name,
        now()   as updated_at
    from (select t1.id,
             t1.address,
             t1.token,
             t1.project,
             t1.type,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.project,
                   a2.type,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.project,
                         a1.type,
                         a1.volume_usd,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.project,
                            a1.type,
                            a1.volume_usd,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
    ORDER BY
	volume_usd DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    s1.platform_group as project,
                                    s1.type,
                                    sum(volume_usd) AS volume_usd
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,token
                                              ,type
                                              ,volume_usd from platform_nft_type_volume_count where volume_usd >= 100
                                         union all
                                         -- project-token(ALL)-type
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,'ALL' AS token
                                              ,type
                                              ,volume_usd from platform_nft_type_volume_count where volume_usd >0
                                         union all
                                         -- project-token(ALL)-type(ALL)
                                         select  address
                                                 ,platform_group
                                                 ,platform
                                                 ,quote_token
                                                 ,'ALL' AS token
                                                 ,'ALL' AS type
                                                 ,volume_usd from platform_nft_type_volume_count where volume_usd >0
                                         union all
                                         -- project-token-type(ALL)
                                         select  address
                                                 ,platform_group
                                                 ,platform
                                                 ,quote_token
                                                 , token
                                                 ,'ALL' AS type
                                                 ,volume_usd from platform_nft_type_volume_count where volume_usd >= 100
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s1.platform_group = s2.project
                                                            AND s1.type = s2.type
                                                            AND s2.data_subject = 'volume_rank'
                                WHERE
                                    volume_usd >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.type,
                                    s1.platform_group,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total,platform_group,token,type
                                       from (select address
                                                  ,platform_group
                                                  ,token
                                                  ,type
                                                  ,sum(volume_usd) as volume_usd from (
                                                  -- project-token-type
                                                  select  address
                                                       ,platform_group
                                                       ,token
                                                       ,type
                                                       ,volume_usd from platform_nft_type_volume_count where volume_usd >= 100
                                                  union all
                                                  -- project-token(ALL)-type
                                                  select  address
                                                       ,platform_group
                                                       ,'ALL' AS token
                                                       ,type
                                                       ,volume_usd  from platform_nft_type_volume_count where volume_usd >0
                                                  union all
                                                  -- project-token(ALL)-type(ALL)
                                                  select  address
                                                       ,platform_group
                                                       ,'ALL' AS token
                                                       ,'ALL' AS type
                                                       ,volume_usd from platform_nft_type_volume_count where volume_usd >0
                                                  union all
                                                  -- project-token-type(ALL)
                                                  select  address
                                                       ,platform_group
                                                       , token
                                                       ,'ALL' AS type
                                                       ,volume_usd from platform_nft_type_volume_count where volume_usd >= 100
                                              ) ta group by address
                                                          ,platform_group
                                                          ,token
                                                          ,type) pntvc  where volume_usd>=100
                                       group by  platform_group,token,type  ) as a10
                                on a10.platform_group=a1.project and a10.token=a1.token and a10.type=a1.type) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
                 tb1.token = tb2.token
             and tb1.project = tb2.project
             AND tb1.type= tb2.type
    where tb1.volume_usd >= 100
  and tb2.data_subject = 'volume_rank' and  zb_rate <= 0.1;