DROP TABLE if EXISTS  static_top_hundred_token;
create table static_top_hundred_token
(
    token  varchar(200) not null,
    rownumber numeric(250, 20) NULL,
    token_name varchar(200) not null,
    token_type varchar(100) not null
);
truncate table static_top_hundred_token;
vacuum static_top_hundred_token;

insert into static_top_hundred_token(token,rownumber,token_name,token_type) values ('ALL',0,'ALL','defi');
insert into static_top_hundred_token(token,rownumber,token_name,token_type) values ('ALL',0,'ALL','nft');

----token排名前10
insert into static_top_hundred_token(token,rownumber,token_name,token_type)
select distinct s2.token as token,
                s2.rn as rownumber,
                drc.token_name as token_name ,
                'defi' as token_type from (
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
                                                                token in(select token_id from dim_rank_token)
                                                                and not exists
                                                                    (select 1 from token_balance_volume_usd tbvu2
                                                                              where tbvu2.token='0x839e71613f9aa06e5701cf6de63e303616b0dde3'
                                                                                and address='0xf6e06de459057d3efa8f0ebd3656e06f66ea02da'
                                                                                and tbvu.token=tbvu2.token
                                                                                and tbvu.address=tbvu2.address)
                                                              group by
                                                                  token)
                                                              rowtable ) s1
                                              where
                                                      s1.rn <= 10) s2 inner join dim_rule_content drc on(drc.token=s2.token);

----nft排名前10
INSERT
INTO
    static_top_hundred_token(token,
                  rownumber,
                  token_name,
                  token_type)
SELECT
    distinct s2.token AS token,
             s2.rn AS rownumber,
             drc.token_name AS token_name ,
             'nft' AS token_type
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
                            snapshot_nft_holding tbvu where token in(select token_id from dim_project_token_type_rank)
                        GROUP BY
                            token)
                        rowtable ) s1
        WHERE
                s1.rn <= 10) s2
        INNER JOIN dim_project_token_type drc ON
        (drc.token = s2.token);
insert into tag_result(table_name,batch_date)  SELECT 'static_top_ten_token' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
