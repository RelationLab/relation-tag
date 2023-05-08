DROP TABLE if EXISTS  static_top_ten_action;
create table static_top_ten_action
(
    token  varchar(200) not null,
    rownumber numeric(250, 20) NULL,
    token_name varchar(200) not null,
    token_type varchar(100) not null,
    bus_type varchar(20) not null
);
truncate table static_top_ten_action;
vacuum static_top_ten_action;

----platform vol
insert into static_top_ten_action(token,rownumber,token_name,token_type,bus_type)
select
    distinct s2.token as token,
             s2.rn as rownumber,
             drc.type as token_name ,
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
                    row_number() over( partition by 1 = 1
		order by
			volume_usd desc) as rn
                from
                    (
                        select
                            sum(total_transfer_volume_usd) as volume_usd,
                            type as token
                        from
                            dex_tx_volume_count_summary  tbvu
                        group by
                            type)
                        rowtable ) s1
        where
                s1.rn <= 100) s2
        inner join dim_project_token_type drc on
        (drc.type = s2.token) ;

----nft vol
INSERT
INTO
    static_top_ten_action(token,
                          rownumber,
                          token_name,
                          token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.type AS token_name ,
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
                            type as token
                        FROM
                            nft_volume_count tbvu
                        GROUP BY
                            type)
                        rowtable ) s1
        WHERE
                s1.rn <= 100) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.type = s2.token);


insert into static_top_ten_action(token,rownumber,token_name,token_type,bus_type) values ('ALL',0,'ALL','web3','activity');
----web3 activity
insert into static_top_ten_action(token,rownumber,token_name,token_type,bus_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.type as token_name ,
                'web3' as token_type,
                'activity' as bus_type
from (
         select
             token,
             rn
         from
             (
                 select
                     type as token,
                     -- 分组字段很关键
                     row_number() over( partition by 1=1
	order by
		total_transfer_count desc) as rn
                 from
                     (
                         select
                             sum(total_transfer_count) as total_transfer_count,
                             type
                         from
                             web3_transaction_record_summary tbvu
                         group by
                             type)
                         rowtable ) s1
         where
                 s1.rn <= 1000) s2 inner join dim_project_type drc on(drc.type=s2.token);



-----platform activity
insert into static_top_ten_action(token,rownumber,token_name,token_type,bus_type)
select
    distinct s2.token as token,
             s2.rn as rownumber,
             drc.type as token_name ,
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
                     row_number() over( partition by 1 = 1
		order by
			total_transfer_count desc) as rn
                 from
                     (
                         select
                             sum(total_transfer_count) as total_transfer_count,
                             type as token
                         from
                             dex_tx_volume_count_summary  tbvu
                         group by
                             type)
                         rowtable ) s1
         where
                 s1.rn <= 100) s2
         inner join dim_project_token_type drc on
    (drc.type = s2.token) ;

----nft activity
INSERT
INTO
    static_top_ten_action(token,
                          rownumber,
                          token_name,
                          token_type,bus_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.type AS token_name ,
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
                            type as token
                        FROM
                            nft_volume_count tbvu
                        GROUP BY
                            type)
                        rowtable ) s1
        WHERE
                s1.rn <= 100) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.type = s2.token);
insert into tag_result(table_name,batch_date)  SELECT 'static_top_ten_action' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;