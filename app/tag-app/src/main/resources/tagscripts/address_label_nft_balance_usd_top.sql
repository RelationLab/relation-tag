drop table if exists address_label_nft_balance_usd_top;
CREATE TABLE public.address_label_nft_balance_usd_top (
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
                                                          bus_type varchar(20) NULL,
                                                          recent_time_code varchar(30) NULL
);
truncate table address_label_nft_balance_usd_top;
vacuum address_label_nft_balance_usd_top;

insert into public.address_label_nft_balance_usd_top(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    address,
    label_type,
    label_type || '_' || 'WHALE' as label_name,
    rn  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    'b'  as "group",
    'WHALE'  as level,
    'top' as category,
    t.type as trade_type,
    '' as project,
    t.token_name as asset,
    'balance' as bus_type
from
    (
        select
            address,
            dptt.label_type as label_type,
            dptt.type as type,
            dptt.project_name as project_name,
            dptt.token_name as token_name,
            s1.rn
        from
            (
                select
                    a1.address,
                    seq_flag,
                    -- 分组字段很关键
                    row_number() over( partition by seq_flag
		order by
			balance desc,
			address asc) as rn
                from
                    (
                        select
                            address,
                            seq_flag,
                            sum(balance) as balance
                        from
                            (
                                select
                                    address,
                                    token,
                                    balance_usd as balance
                                from
                                    nft_balance_usd_temp where  address not in (select address from exclude_address)
                                                           and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                                union all
                                select
                                    address,
                                    'ALL' as token,
                                    balance_usd as balance
                                from
                                    nft_balance_usd_temp where  address not in (select address from exclude_address)
                                                           and token in (select token_id from dim_project_token_type_rank_temp dpttr)
                            ) totala
                                inner join dim_project_token_type_temp a2
                                           on
                                                       totala.token = a2.token
                                                   and a2.data_subject = 'balance_top'
                                                   and a2.label_type like '%NFT%'
                                                   and a2.label_type not like '%WEB3%'
                                                   and a2.project = ''
                                                   and (a2.type = ''
                                                   or a2.type = 'ALL')
                        where
                                totala.balance >= 100
                        group by
                            address,
                            seq_flag) a1

            ) s1 inner join dim_project_token_type_temp dptt on (
                        dptt.seq_flag = s1.seq_flag
                    and dptt.data_subject = 'balance_top'
                    and dptt.label_type like '%NFT%'
                    and dptt.label_type not like '%WEB3%'
                    and dptt.project = ''
                    and (dptt.type = ''
                    or dptt.type = 'ALL')
                )
        where
                s1.rn <= 100 ) t;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_nft_balance_usd_top' as table_name,'${batchDate}'  as batch_date;
