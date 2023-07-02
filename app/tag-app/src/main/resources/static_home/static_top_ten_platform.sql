DROP TABLE if EXISTS  static_top_ten_platform${tableSuffix};
create table static_top_ten_platform${tableSuffix}
(
    token  varchar(200) not null,
    rownumber numeric(250, 20) NULL,
    token_name varchar(200) not null,
    token_type varchar(100) not null,
    bus_type varchar(20) not null
);
truncate table static_top_ten_platform${tableSuffix};
vacuum static_top_ten_platform${tableSuffix};

insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','web3','balance');

----web3 balance
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'web3' as token_type,
                'balance' as bus_type
from (
         select
             token,
             rn
         from
             (
                 select
                     project as token,
                     -- 分组字段很关键
                     row_number() over( partition by 1=1
	order by
		balance desc) as rn
                 from
                     (
                         select
                             sum(balance) as balance,
                             project
                         from
                             web3_transaction_record_summary tbvu where
                             project in(select project from dim_project_type)
                             and tbvu.type='NFT Recipient'  and tbvu.address not in (select address from exclude_address) and  balance >=1
                         group by
                             project)
                         rowtable ) s1
         where
                 s1.rn <= 10) s2 inner join dim_project_type drc on(drc.project=s2.token);


insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','defi','volume');
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','nft','volume');
----platform defi vol
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select
    distinct s2.token as token,
             s2.rn as rownumber,
             drc.project_name as token_name ,
             'defi' as token_type,
             'volume' as bus_type
from
    (
        select
            token,
            rn
        from
            (
                select
                    token,
                    -- 分组字段很关键
                    row_number() over( partition by 1 = 1
		order by
			volume_usd desc) as rn
                from
                    (
                        select
                            sum(total_transfer_volume_usd) as volume_usd,
                            project as token
                        from
                            (
                                select
                                    total_transfer_volume_usd,
                                    case
                                        when project = '0xc36442b4a4522e871399cd717abdd847ab11fe88' then '0x7a250d5630b4cf539739df2c5dacb4c659f2488d'
                                        else project
                                        end as project
                                from
                                    dex_tx_volume_count_summary  where total_transfer_volume_usd >=100
                                    and address not in (select address from exclude_address)
                                ) tbvu
                        group by
                            project)
                        rowtable ) s1
        where
                s1.rn <= 10) s2
        inner join dim_project_token_type drc on
        (drc.project = s2.token
            and (drc.project_name <> 'Uniswap_v2'
                and drc.project_name <> 'Uniswap_v3')) ;

----platform nft vol
INSERT
INTO
    static_top_ten_platform${tableSuffix}(token,
                         rownumber,
                         token_name,
                         token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.project_name AS token_name ,
             'nft' AS token_type,
             'volume' as bus_type
FROM
    (
        SELECT
            token,
            rn
        FROM
            (
                SELECT
                    token,
                    -- 分组字段很关键
                    ROW_NUMBER() OVER( PARTITION BY 1=1
		ORDER BY
			volume_usd DESC) AS rn
                FROM
                    (
                        SELECT
                            sum(volume_usd) AS volume_usd,
                            platform_group as token
                        FROM
                            platform_nft_volume_usd tbvu
                         where volume_usd >=100
                           and tbvu.address not in (select address from exclude_address)
                        GROUP BY
                            platform_group)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.project = s2.token);

insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','defi','activity');
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','nft','activity');
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','web3','activity');

----platform defi activity
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select
    distinct s2.token as token,
             s2.rn as rownumber,
             drc.project_name as token_name ,
             'defi' as token_type,
             'activity' as bus_type
from
    (
        select
            token,
            rn
        from
            (
                select
                    token,
                    -- 分组字段很关键
                    row_number() over( partition by 1 = 1
		order by
			total_transfer_count desc) as rn
                from
                    (
                        select
                            sum(total_transfer_count) as total_transfer_count,
                            project as token
                        from
                            (
                                select
                                    address,
                                    case
                                        when project = '0xc36442b4a4522e871399cd717abdd847ab11fe88'
                                            then '0x7a250d5630b4cf539739df2c5dacb4c659f2488d'
                                        else project
                                        end as project,
                                    total_transfer_count
                                from
                                    dex_tx_volume_count_summary)
                                tbvu
                        where
                                tbvu.address not in (
                                select
                                    address
                                from
                                    exclude_address)
                          and total_transfer_count >0
                        group by
                            project)
                        rowtable ) s1
        where
                s1.rn <= 10) s2
        inner join dim_project_token_type drc on
        (drc.project = s2.token
            and (drc.project_name <> 'Uniswap_v2'
                and drc.project_name <> 'Uniswap_v3'))  ;

----platform nft activity
INSERT
INTO
    static_top_ten_platform${tableSuffix}(token,
                         rownumber,
                         token_name,
                         token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.project_name AS token_name ,
             'nft' AS token_type,
             'activity' as bus_type
FROM
    (
        SELECT
            token,
            rn
        FROM
            (
                SELECT
                    token,
                    -- 分组字段很关键
                    ROW_NUMBER() OVER( PARTITION BY 1=1
		ORDER BY
			transfer_count DESC) AS rn
                FROM
                    (
                        SELECT
                            sum(transfer_count) AS transfer_count,
                            platform_group as token
                        FROM
                            platform_nft_type_volume_count tbvu
                        where   tbvu.address not in (select address from exclude_address)
                        and transfer_count>0
                        GROUP BY
                            platform_group)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.project = s2.token);

----web3 activity
insert into static_top_ten_platform${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'web3' as token_type,
                'activity' as bus_type
from (
         select
             token,
             rn
         from
             (
                 select
                     project as token,
                     -- 分组字段很关键
                     row_number() over( partition by 1=1
	order by
		total_transfer_count desc) as rn
                 from
                     (
                         select
                             sum(total_transfer_count) as total_transfer_count,
                             project
                         from
                             web3_transaction_record_summary tbvu where
                                 project in(select project from dim_project_type)
                                and  tbvu.address not in (select address from exclude_address)
                         group by
                             project)
                         rowtable ) s1
         where
                 s1.rn <= 10) s2 inner join dim_project_type drc on(drc.project=s2.token);
insert into tag_result${tableSuffix}(table_name,batch_date)  SELECT 'static_top_ten_platform${tableSuffix}' as table_name,'${tagBatch}'  as batch_date;
