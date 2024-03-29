DROP TABLE if EXISTS  static_top_ten_token${tableSuffix};
create table static_top_ten_token${tableSuffix}
(
    token  varchar(200) not null,
    rownumber numeric(250, 20) NULL,
    token_name varchar(200) not null,
    token_type varchar(100) not null,
    bus_type varchar(20) not null
);
truncate table static_top_ten_token${tableSuffix};
vacuum static_top_ten_token${tableSuffix};

insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','defi','balance');
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','nft','balance');

----token balance排名前10
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'defi' as token_type,
                'balance' as bus_type
from (
                                              select
                                                  token,
                                                  rn
                                              from
                                                  (
                                                      select
                                                          token,
                                                          -- 分组字段很关键
                                                          row_number() over( partition by 1=1
	order by
		balance_usd desc) as rn
                                                      from
                                                          (
                                                              select
                                                                  sum(balance_usd) as balance_usd,
                                                                  token
                                                              from
                                                                  token_balance_volume_usd tbvu where
                                                                token in(select
                                                                             address
                                                                         from
                                                                             top_token_1000
                                                                         where
                                                                                 holders >= 100
                                                                           and removed = false)
                                                                and not exists
                                                                    (select 1 from token_balance_volume_usd tbvu2
                                                                              where tbvu2.token='0x839e71613f9aa06e5701cf6de63e303616b0dde3'
                                                                                and address='0xf6e06de459057d3efa8f0ebd3656e06f66ea02da'
                                                                                and tbvu.token=tbvu2.token
                                                                                and tbvu.address=tbvu2.address)
                                                                and  token not in (select token from exclude_token)
                                                                                                  and balance_usd >=100
                                                              and tbvu.address not in (select address from exclude_address)
                                                              group by
                                                                  token)
                                                              rowtable ) s1
                                              where
                                                      s1.rn <= 10) s2 inner join dim_rule_content drc on(drc.token=s2.token);

----nft balance排名前10
INSERT
INTO
    static_top_ten_token${tableSuffix}(token,
                  rownumber,
                  token_name,
                  token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.token_name AS token_name ,
             'nft' AS token_type,
             'balance' as bus_type
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
			balance DESC) AS rn
                FROM
                    (
                        SELECT
                            sum(balance) AS balance,
                            token
                        FROM
                            nft_holding tbvu where token in(select token_id from dim_project_token_type_rank)
                            and   balance >=1 and recent_time_code='ALL'
                                               and tbvu.address not in (select address from exclude_address)
                        GROUP BY
                            token)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.token = s2.token);

insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','defi','volume');
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','nft','volume');
----token vol排名前10
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'defi' as token_type,
                'volume' as bus_type
from (
         select
             token,
             rn
         from
             (
                 select
                     token,
                     -- 分组字段很关键
                     row_number() over( partition by 1=1
	order by
		volume_usd desc) as rn
                 from
                     (
                         select
                             sum(volume_usd) as volume_usd,
                             token
                         from
                             token_volume_usd tbvu where
                                 token in(select
                                              address
                                          from
                                              top_token_1000
                                          where
                                                  holders >= 100
                                            and removed = false)
                                                             and not exists
                                 (select 1 from token_volume_usd tbvu2
                                  where tbvu2.token='0x839e71613f9aa06e5701cf6de63e303616b0dde3'
                                    and address='0xf6e06de459057d3efa8f0ebd3656e06f66ea02da'
                                    and tbvu.token=tbvu2.token
                                    and tbvu.address=tbvu2.address  and tbvu2.recent_time_code='ALL')
                                 and  token not in (select token from exclude_token)
                                                     and volume_usd >=100
                                                     and tbvu.address not in (select address from exclude_address)
                                                     and tbvu.recent_time_code='ALL'

                         group by
                             token)
                         rowtable ) s1
         where
                 s1.rn <= 10) s2 inner join dim_rule_content drc on(drc.token=s2.token);

----nft vol排名前10
INSERT
INTO
    static_top_ten_token${tableSuffix}(token,
                         rownumber,
                         token_name,
                         token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.token_name AS token_name ,
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
			transfer_volume DESC) AS rn
                FROM
                    (
                        SELECT
                            sum(transfer_volume) AS transfer_volume,
                            token
                        FROM
                            nft_volume_count tbvu where token in(select token_id from dim_project_token_type_rank)
                                                    and token<>'0x0000000000a39bb272e79075ade125fd351887ac'
                            and   transfer_volume >=1 and tbvu.address not in (select address from exclude_address)
                                                    and recent_time_code='ALL'
                                                  GROUP BY
                            token)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.token = s2.token);


insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','defi','activity');
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','nft','activity');

----token activity排名前10
insert into static_top_ten_token${tableSuffix}(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'defi' as token_type,
                'activity' as bus_type
from (
         select
             token,
             rn
         from
             (
                 select
                     token,
                     -- 分组字段很关键
                     row_number() over( partition by 1=1
	order by
		total_transfer_count desc) as rn
                 from
                     (
                         select
                             sum(total_transfer_count) as total_transfer_count,
                             token
                         from
                             token_holding_vol_count tbvu where
                                 token in(select
                                              address
                                          from
                                              top_token_1000
                                          where
                                                  holders >= 100
                                            and removed = false)
                                                            and recent_time_code='ALL'
                                                             and not exists
                                 (select 1 from token_balance_volume_usd tbvu2
                                  where tbvu2.token='0x839e71613f9aa06e5701cf6de63e303616b0dde3'
                                    and address='0xf6e06de459057d3efa8f0ebd3656e06f66ea02da'
                                    and tbvu.token=tbvu2.token
                                    and tbvu.address=tbvu2.address)
                                                            and  token not in (select token from exclude_token)
                                                            and tbvu.address not in (select address from exclude_address)
                                                            and total_transfer_count >0
                         group by
                             token)
                         rowtable ) s1
         where
                 s1.rn <= 10) s2 inner join dim_rule_content drc on(drc.token=s2.token);

----nft activity排名前10
INSERT
INTO
    static_top_ten_token${tableSuffix}(token,
                         rownumber,
                         token_name,
                         token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.token_name AS token_name ,
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
                            token
                        FROM
                            nft_volume_count tbvu where token in(select token_id from dim_project_token_type_rank)
                                                    and tbvu.address not in (select address from exclude_address)
                                                    and transfer_count >0  and recent_time_code='ALL'
                        GROUP BY
                            token)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.token = s2.token);
insert into tag_result${tableSuffix}(table_name,batch_date)  SELECT 'static_top_ten_token${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
