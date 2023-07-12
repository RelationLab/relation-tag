drop table if exists address_label_token_time_first_stake;
CREATE TABLE public.address_label_token_time_first_stake (
                                                             address varchar(512) NULL,
                                                             data numeric(280, 20) NULL,
                                                             wired_type varchar(20) NULL,
                                                             label_type varchar(512) NULL,
                                                             label_name varchar(1024) NULL,
                                                             updated_at timestamp(6) NULL,
                                                             "group" varchar(1) NULL,
                                                             "level" varchar(80) NULL,
                                                             category varchar(80) NULL,
                                                             trade_type varchar(80) NULL,
                                                             project varchar(80) NULL,
                                                             asset varchar(80) NULL,
                                                             bus_type varchar(20) NULL
);
truncate table address_label_token_time_first_stake;
vacuum address_label_token_time_first_stake;

insert into public.address_label_token_time_first_stake(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset,bus_type)
select
    s1.address,
    s1.label_type,
    s1.label_type as label_name,
    rn  as data,
    'DEFI'  as wired_type,
    now() as updated_at,
    't'  as "group",
    s1.label_type  as level,
    'other'  as category,
    'ALL' trade_type,
    '' as project,
    s1.token_name as asset,
    'time' as bus_type
from
    (
        select
            a1.address,
            a2.label_type, a2.token_name,
            -- 分组字段很关键
            row_number() over( partition by a2.token,
		seq_flag
	order by
		first_updated_block_height asc,
		address asc) as rn
        from
            (
                select
                    *
                from
                    dex_tx_volume_count_summary_stake
                where
                        type = 'stakelp'
                  and balance_usd>0 and address not in (select address from exclude_address)) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a1.project = a2.project
                                   and a2.data_subject = 'FIRST_MOVER_STAKING'
    ) s1
where
        s1.rn <= 100;
insert into tag_result(table_name,batch_date)  SELECT 'address_label_token_time_first_stake' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
