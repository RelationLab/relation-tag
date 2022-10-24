-- public.dim_rule_sql_content definition

-- Drop table

drop table if exists dim_rule_sql_content;

CREATE TABLE public.dim_rule_sql_content (
                                             rule_name varchar(100) NULL,
                                             rule_sql text NULL,
                                             rule_order int8 NULL
)
    DISTRIBUTED RANDOMLY;

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_eth_count_grade','truncate
    table public.address_label_eth_count_grade;

insert
into
    public.address_label_eth_count_grade (distributed_key,address,
                                            label_type,
                                            label_name,
                                            updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,
    a1.address
        ,
    a2.label_type
        ,
    a2.label_type||''_''||case
        when total_transfer_all_count >= 1
            and total_transfer_all_count < 10 then ''L1''
        when total_transfer_all_count >= 10
            and total_transfer_all_count < 40 then ''L2''
        when total_transfer_all_count >= 40
            and total_transfer_all_count < 80 then ''L3''
        when total_transfer_all_count >= 80
            and total_transfer_all_count < 120 then ''L4''
        when total_transfer_all_count >= 120
            and total_transfer_all_count < 160 then ''L5''
        when total_transfer_all_count >= 160
            and total_transfer_all_count < 200 then ''L6''
        when total_transfer_all_count >= 200
            and total_transfer_all_count < 400 then ''Low''
        when total_transfer_all_count >= 400
            and total_transfer_all_count < 619 then ''Medium''
        when total_transfer_all_count >= 619 then ''High''
        end as label_name
        ,
        now() as updated_at
from
    (
        select
            address,
           ''eth'' as token,
            total_transfer_all_count
        from
            eth_holding th1
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
where
        a1.total_transfer_all_count >= 1
  and a2.data_subject = ''count'' and a2.token_type=''token''
;',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_balance_grade','-- 第一类标签
-- 第一类标签
truncate
	table public.address_label_token_balance_grade;

insert
	into
	public.address_label_token_balance_grade (distributed_key,address,
	label_type,
	label_name,
	updated_at)
   select
    md5(cast(random() as varchar)) as distributed_key,
	address,
	a2.label_type,
	a2.label_type||''_''||case
		when balance_usd >= 100
		and balance_usd < 1000 then ''L1''
		when balance_usd >= 1000
		and balance_usd < 10000 then ''L2''
		when balance_usd >= 10000
		and balance_usd < 50000 then ''L3''
		when balance_usd >= 50000
		and balance_usd < 100000 then ''L4''
		when balance_usd >= 100000
		and balance_usd < 500000 then ''L5''
		when balance_usd >= 500000
		and balance_usd < 1000000 then ''L6''
		when balance_usd >= 1000000
		and balance_usd < 1000000000 then ''Millionaire''
		when balance_usd >= 1000000000 then ''Billionaire''
	end as label_name
    ,
	now() as updated_at
from
	(
	select
		address,
		token,
		balance_usd
	from
		token_balance_volume_usd tbvutk
union all
	select
		address,
		''ALL'' as token ,
		sum(balance_usd) as balance_usd
	from
		token_balance_volume_usd tbvu
	group by
		address
	) a1
inner join
   dim_rule_content a2
	on
	a1.token = a2.token
where
	a1.balance_usd >= 100
	and a2.data_subject = ''balance_grade'' and a2.token_type=''token''
;

',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_count_grade','truncate
	table public.address_label_token_count_grade;

insert
	into
	public.address_label_token_count_grade (distributed_key,address,
	label_type,
	label_name,
	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,
    a1.address
        ,
    a2.label_type
        ,
    a2.label_type||''_''||case
        when total_transfer_all_count >= 1
            and total_transfer_all_count < 10 then ''L1''
        when total_transfer_all_count >= 10
            and total_transfer_all_count < 40 then ''L2''
        when total_transfer_all_count >= 40
            and total_transfer_all_count < 80 then ''L3''
        when total_transfer_all_count >= 80
            and total_transfer_all_count < 120 then ''L4''
        when total_transfer_all_count >= 120
            and total_transfer_all_count < 160 then ''L5''
        when total_transfer_all_count >= 160
            and total_transfer_all_count < 200 then ''L6''
        when total_transfer_all_count >= 200
            and total_transfer_all_count < 400 then ''Low''
        when total_transfer_all_count >= 400
            and total_transfer_all_count < 619 then ''Medium''
        when total_transfer_all_count >= 619 then ''High''
        end as label_name
        ,
    now() as updated_at
from
    (
        select
            address,
            token,
            total_transfer_all_count
        from
            token_holding th1
        union all
        select
            address,
            ''ALL'' as token ,
            sum(total_transfer_all_count) as total_transfer_all_count
        from
		(
            select address,total_transfer_all_count from  eth_holding th
            union all
            select address,total_transfer_all_count from  token_holding th
        ) th2
        group by
            address
    ) a1
        inner join
    dim_rule_content a2
    on
            a1.token = a2.token
where
        a1.total_transfer_all_count >= 1
  and a2.data_subject = ''count'' and a2.token_type=''token''
;
',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_time_grade','-- -- 第二类标签
truncate
    table public.address_label_token_time_grade;

insert
into public.address_label_token_time_grade (distributed_key,address,
                                    label_type,
                                    label_name,
                                    updated_at)
select md5(cast(random() as varchar)) as distributed_key,
		a1.address,
        a2.label_type,
        a2.label_type||''_''||case
           when counter = 1 then ''L1''
           when counter > 1
               and counter <= 7 then ''L2''
           when counter > 7
               and counter <= 30 then ''L3''
           when counter > 30
               and counter <= 90 then ''L4''
           when counter > 90
               and counter <= 180 then ''L5''
           when counter > 180
               and counter <= 365 then ''L6''
           end as label_name
        ,
       now()   as updated_at
from (select address,
             token,
             counter
      from token_holding_time tbvutk) a1
         inner join
     dim_rule_content a2
     on
         a1.token = a2.token
where  a2.data_subject = ''time_grade'' and counter >= 1 and counter<=365
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_volume_grade','-- -- 第二类标签
truncate
	table public.address_label_token_volume_grade;

insert
	into
	public.address_label_token_volume_grade (distributed_key,address,
	label_type,
	label_name,

	updated_at)
	select md5(cast(random() as varchar)) as distributed_key,
	 a1.address
	,
	a2.label_type
	,
	a2.label_type||''_''||case
		when volume_usd >= 100
		and volume_usd < 1000 then ''L1''
		when volume_usd >= 1000
		and volume_usd < 10000 then ''L2''
		when volume_usd >= 10000
		and volume_usd < 50000 then ''L3''
		when volume_usd >= 50000
		and volume_usd < 100000 then ''L4''
		when volume_usd >= 100000
		and volume_usd < 500000 then ''L5''
		when volume_usd >= 500000
		and volume_usd < 1000000 then ''L6''
		when volume_usd >= 1000000
		and volume_usd < 1000000000 then ''Million''
		when volume_usd >= 1000000000 then ''Billion''
	end as label_name
    ,
	now() as updated_at
from
	(
	select
		address,
		token,
		volume_usd
	from
		token_balance_volume_usd tbvutk
union all
	select
		address,
		''ALL'' as token ,
		sum(volume_usd) as volume_usd
	from
		token_balance_volume_usd tbvu
	group by
		address
	)
	 a1
inner join
   dim_rule_content a2
	on
	a1.token = a2.token
where
	a1.volume_usd >= 100
	and a2.data_subject = ''volume_grade'' and a2.token_type=''token''
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_eth_balance_rank','-- -- 第二类标签
truncate
    table public.address_label_eth_balance_rank;

insert
into public.address_label_eth_balance_rank (distributed_key,address,
                                          label_type,
                                          label_name,

                                          updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||''HIGH_BALANCE'' as label_name
        ,
       now()       as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.balance_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.balance_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.balance_usd
                             , row_number()                      over(order by balance_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.balance_usd) as balance_usd
                              from (select token, address, balance_usd
                                    from token_balance_volume_usd
                                    where token = ''eth''
                                      ) s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where balance_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1
      ) tb1
         inner join
     dim_rule_content tb2
     on
         tb1.token = tb2.token
where tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = ''balance_rank'' and tb2.token_type=''token''
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_eth_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_eth_volume_rank;

insert
into public.address_label_eth_volume_rank (distributed_key,address,
                                      label_type,
                                      label_name,
                                      updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <=0.025 then ''HEAVY''
           when zb_rate > 0.001 and zb_rate <=0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <=0.1 then ''MEDIUM''
           when zb_rate <=0.001 then ''LEGENDARY''
           end as label_name
        ,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.volume_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.volume_usd
                             , row_number()                      over( order by volume_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.volume_usd) as volume_usd
                              from (select token, address, volume_usd
                                    from token_balance_volume_usd
                                    where token =  ''eth'') s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where volume_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1) tb1
         inner join
     dim_rule_content tb2
     on
             tb1.token = tb2.token
where tb1.volume_usd >= 100
  and tb2.data_subject = ''volume_rank'' and tb2.token_type=''token''   and  zb_rate <= 0.1
;',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_time_special','truncate
    table public.address_label_time_special;
insert
into public.address_label_time_special (distributed_key,address,
                                      label_type,
                                      label_name,
                                      updated_at)
select md5(cast(random() as varchar)) as distributed_key,a1.address
        ,
       a2.label_type
        ,
       a2.label_type||''_''||case
           when counter >= 155 then ''LONG_TERM_HOLDER''
           when counter >= 1
               and counter < 155 then ''SHORT_TERM_HOLDER''
           end as label_name
        ,
       now()   as updated_at
from (select address,
             token,
             counter
      from token_holding_time tbvutk) a1
         inner join
     dim_rule_content a2
     on
             a1.token = a2.token
where a2.data_subject = ''time_special'' and counter >= 1 and a2.token_type=''token''
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_balance_rank','-- -- 第二类标签
truncate
    table public.address_label_token_balance_rank;

insert
into public.address_label_token_balance_rank (distributed_key,address,
                                          label_type,
                                          label_name,

                                          updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||''HIGH_BALANCE'' as label_name
        ,
       now()       as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.balance_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.balance_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.balance_usd
                             , row_number()                      over(partition by  token order by balance_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.balance_usd) as balance_usd
                              from (select token, address, balance_usd
                                    from token_balance_volume_usd
                                    where token <> ''eth''
                                      and token <> ''0xdac17f958d2ee523a2206206994597c13d831ec7'') s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where balance_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1
    --token（ALL）
      union  all
      select t1.id,
             t1.address,
             t1.token,
             t1.balance_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.balance_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.balance_usd
                             , row_number()                      over(partition by  token order by balance_usd desc) as count_sum
                        from (select ''ALL'' token,
                                     s1.address,
                                     sum(s1.balance_usd) as balance_usd
                              from token_balance_volume_usd s1
                              where balance_usd >= 100
                              group by  s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1

      ) tb1
         inner join
     dim_rule_content tb2
     on
         tb1.token = tb2.token
where tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = ''balance_rank'' and tb2.token_type=''token''
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_balance_top','truncate table address_label_token_balance_top;
insert into public.address_label_token_balance_top (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		balance_usd desc) as rn
        from
            (
                select
                    address,
                    token,
                    balance_usd,
                    volume_usd
                from
                    token_balance_volume_usd
                union all
                select
                    address,
                    ''ALL'' as token,
                    balance_usd,
                    volume_usd
                from
                    token_balance_volume_usd ) a1
                inner join dim_rule_content a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = ''balance_top'' and a2.token_type=''token''
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_token_volume_rank;

insert
into public.address_label_token_volume_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''HEAVY''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''MEDIUM''
           when zb_rate <= 0.001 then ''LEGENDARY''
           end as label_name
        ,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.volume_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.volume_usd
                             , row_number()                      over(partition by  token order by volume_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.volume_usd) as volume_usd
                              from (select token, address, volume_usd
                                    from token_balance_volume_usd
                                    where token <> ''eth''
                                      and token <> ''0xdac17f958d2ee523a2206206994597c13d831ec7'') s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where volume_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1
           --token（ALL）
      union all
      select t1.id,
             t1.address,
             t1.token,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.volume_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.volume_usd
                             , row_number()                      over(partition by  token order by volume_usd desc) as count_sum
                        from (select ''ALL''                 token,
                                     s1.address,
                                     sum(s1.volume_usd) as volume_usd
                              from token_balance_volume_usd s1
                              where volume_usd >= 100
                              group by s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1) tb1
         inner join
     dim_rule_content tb2
     on
             tb1.token = tb2.token
where tb1.volume_usd >= 100
  and tb2.data_subject = ''volume_rank'' and tb2.token_type=''token''   and  zb_rate <= 0.1
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_usdt_balance_rank','-- -- 第二类标签
truncate
    table public.address_label_usdt_balance_rank;

insert
into public.address_label_usdt_balance_rank (distributed_key,address,
                                          label_type,
                                          label_name,

                                          updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||''HIGH_BALANCE'' as label_name
        ,
       now()       as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.balance_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.balance_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.balance_usd
                             , row_number()                      over(order by balance_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.balance_usd) as balance_usd
                              from (select token, address, balance_usd
                                    from token_balance_volume_usd
                                    where token = ''0xdac17f958d2ee523a2206206994597c13d831ec7''
                                      ) s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where balance_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1
      ) tb1
         inner join
     dim_rule_content tb2
     on
         tb1.token = tb2.token
where tb1.balance_usd >= 100
  and tb1.zb_rate <= 0.1
  and tb2.data_subject = ''balance_rank'' and tb2.token_type=''token''
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_usdt_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_usdt_volume_rank;

insert
into public.address_label_usdt_volume_rank (distributed_key,address,
                                      label_type,
                                      label_name,

                                      updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address
        ,
       tb2.label_type
        ,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <=0.025 then ''HEAVY''
           when zb_rate > 0.001 and zb_rate <=0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <=0.1 then ''MEDIUM''
           when zb_rate <=0.001 then ''LEGENDARY''
           end as label_name
        ,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id
                       , a1.address
                       , a1.token
                       , a1.volume_usd
                       , a1.count_sum
                       , a10.count_sum_total
                  from (select md5(cast(random() as varchar)) as id
                             , a1.address
                             , a1.token
                             , a1.volume_usd
                             , row_number()                      over(order by volume_usd desc) as count_sum
                        from (select s1.token,
                                     s1.address,
                                     sum(s1.volume_usd) as volume_usd
                              from (select token, address, volume_usd
                                    from token_balance_volume_usd
                                    where token = ''0xdac17f958d2ee523a2206206994597c13d831ec7'') s1
                                       inner join dim_rank_token s2
                                                  on s1.token = s2.token_id
                              where volume_usd >= 100
                              group by s1.token, s1.address) as a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from token_balance_volume_usd) as a10
                       on 1 = 1) as a2) as t1) tb1
         inner join
     dim_rule_content tb2
     on
             tb1.token = tb2.token
where tb1.volume_usd >= 100
  and tb2.data_subject = ''volume_rank'' and tb2.token_type=''token'' and  zb_rate <= 0.1
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_web3_type_balance_grade','truncate
    table public.address_label_web3_type_balance_grade;

insert
into
    public.address_label_web3_type_balance_grade (distributed_key,address,
                                               label_type,
                                               label_name,

                                               updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address,
    label_type,
    label_type||''_''||case
        when balance = 1 then ''L1''
        when balance >= 2
            and balance < 4 then ''L2''
        when balance >= 4
            and balance < 11 then ''L3''
        when balance >= 11
            and balance < 51 then ''L4''
        when balance >= 51
            and balance < 101 then ''L5''
        when balance >= 101 then ''L6''
        end  as label_name,
    now() as updated_at
from
    (
        -- project-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                           on  a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''balance_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                           on a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''balance_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                           on a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''balance_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(balance) as balance
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                           on  a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''balance_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where balance>=1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_web3_type_count_grade','truncate
	table public.address_label_web3_type_count_grade;

insert
	into
	public.address_label_web3_type_count_grade (distributed_key,address,
	label_type,
	label_name,

	updated_at)
	select
	 md5(cast(random() as varchar)) as distributed_key,address
	,
	label_type
	,
	label_type||''_''||case
		when total_transfer_count >= 1
		and total_transfer_count < 10 then ''L1''
		when total_transfer_count >= 10
		and total_transfer_count < 40 then ''L2''
		when total_transfer_count >= 40
		and total_transfer_count < 80 then ''L3''
		when total_transfer_count >= 80
		and total_transfer_count < 120 then ''L4''
		when total_transfer_count >= 120
		and total_transfer_count < 160 then ''L5''
		when total_transfer_count >= 160
		and total_transfer_count < 200 then ''L6''
		when total_transfer_count >= 200
		and total_transfer_count < 400 then ''Low''
		when total_transfer_count >= 400
		and total_transfer_count < 619 then ''Medium''
		when total_transfer_count >= 619 then ''High''
	end as label_name
	,
	now() as updated_at
from
    (
        -- project-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                       on  a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                       on a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                       on a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            web3_transaction_record_summary  a1 inner join dim_project_type a2
                                                       on  a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where total_transfer_count>=1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_web3_type_balance_rank','-- -- 第二类标签
truncate
    table public.address_label_web3_type_balance_rank;

insert
into public.address_label_web3_type_balance_rank (distributed_key,address,
                                                      label_type,
                                                      label_name,

                                                      updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''RARE''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''EPIC''
           when zb_rate <= 0.001 then ''LEGENDARY''
           end as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.project,
             t1.type,
             t1.balance,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.project,
                   a2.type,
                   a2.balance,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.project,
                         a1.type,
                         a1.balance,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.project,
                            a1.type,
                            a1.balance,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
ORDER BY
	balance DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.project,
                                    s1.type,
                                    sum(s1.balance) AS balance
                                FROM (
                                         -- project-type
                                         select  address
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,type
                                              ,project
                                              ,balance from web3_transaction_record_summary
                                         union all
                                         -- project(ALL)-type
                                         select  address
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,type
                                              ,''ALL'' as project
                                              ,balance from web3_transaction_record_summary
                                         union all
                                         -- project(ALL)-type(ALL)
                                         select  address
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,''ALL'' as type
                                              ,''ALL'' as project
                                              ,balance from web3_transaction_record_summary
                                         union all
                                         -- project-type(ALL)
                                         select  address
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,''ALL'' as type
                                              ,project
                                              ,balance from web3_transaction_record_summary
                                     )
                                         s1
                                         INNER JOIN dim_project_type s2
                                                    ON
                                                                s1.project = s2.project
                                                            AND s1.type = s2.type
                                                            AND s2.data_subject = ''balance_rank''
                                WHERE
                                        balance >= 100
                                GROUP BY
                                    s1.address,
                                    s1.project,
                                    s1.type,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from web3_transaction_record_summary) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_type tb2
     on
                 tb1.project = tb2.project
             and tb1.type = tb2.type
where tb1.balance >= 100
  and tb2.data_subject = ''balance_rank'' and  zb_rate <= 0.1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_web3_type_balance_top','truncate table address_label_web3_type_balance_top;
insert into public.address_label_web3_type_balance_top (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		balance desc) as rn
        from
            (
                -- project-type
                select  address
                     ,type
                     ,project
                     ,balance from web3_transaction_record_summary
                union all
                -- project(ALL)-type
                select  address
                     ,type
                     ,''ALL'' AS project
                     ,balance from web3_transaction_record_summary
                union all
                -- project(ALL)-type(ALL)
                select  address
                     ,''ALL'' AS type
                     ,''ALL'' AS project
                     ,balance from web3_transaction_record_summary
                union all
                -- project-type(ALL)
                select  address
                     ,''ALL'' AS type
                     ,project
                     ,balance from web3_transaction_record_summary
            ) a1
                inner join dim_project_type a2
                           on
                                       a1.project = a2.project
                                   and a1.type = a2.type
                                   and a2.data_subject = ''balance_top''
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_project_type_balance_grade','truncate
	table public.address_label_token_project_type_balance_grade;

insert
into
    public.address_label_token_project_type_balance_grade(distributed_key,address,
                                               label_type,
                                               label_name,

                                               updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address
        ,
    label_type
        ,
    label_type||''_''||case
        when balance_usd >= 100
            and balance_usd < 1000 then ''L1''
        when balance_usd >= 1000
            and balance_usd < 10000 then ''L2''
        when balance_usd >= 10000
            and balance_usd < 50000 then ''L3''
        when balance_usd >= 50000
            and balance_usd < 100000 then ''L4''
        when balance_usd >= 100000
            and balance_usd < 500000 then ''L5''
        when balance_usd >= 500000
            and balance_usd < 1000000 then ''L6''
        when balance_usd >= 1000000
            and balance_usd < 1000000000 then ''Million''
        when balance_usd >= 1000000000 then ''Billion''
        end as label_name
       ,
    now() as updated_at
from
    (
        -- project-token-type
        select
            a1.address,
            a2.label_type,
            sum(balance_usd) as balance_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_rule_content a2
                                                       on a1.token=a2.token
                                                           and a2.data_subject = ''balance_grade''
                                                           and a2.token_type=''lp''
        group by
            a1.address,
            a2.label_type
    ) t where balance_usd >= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_project_type_count_grade','truncate
	table public.address_label_token_project_type_count_grade;

insert
	into
	public.address_label_token_project_type_count_grade (distributed_key,address,
	label_type,
	label_name,

	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address
        ,
    label_type
        ,
    label_type||''_''||case
        when total_transfer_count >= 1
            and total_transfer_count < 10 then ''L1''
        when total_transfer_count >= 10
            and total_transfer_count < 40 then ''L2''
        when total_transfer_count >= 40
            and total_transfer_count < 80 then ''L3''
        when total_transfer_count >= 80
            and total_transfer_count < 120 then ''L4''
        when total_transfer_count >= 120
            and total_transfer_count < 160 then ''L5''
        when total_transfer_count >= 160
            and total_transfer_count < 200 then ''L6''
        when total_transfer_count >= 200
            and total_transfer_count < 400 then ''Low''
        when total_transfer_count >= 400
            and total_transfer_count < 619 then ''Medium''
        when total_transfer_count >= 619 then ''High''
        end as label_name
        ,
    now() as updated_at
from
    (
        -- project-token-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type

            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_count) as total_transfer_count
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where total_transfer_count >= 1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_project_type_volume_grade','truncate
	table public.address_label_token_project_type_volume_grade;

insert
	into
	public.address_label_token_project_type_volume_grade(distributed_key,address,
	label_type,
	label_name,

	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address
        ,
    label_type
        ,
    label_type||''_''||case
        when total_transfer_volume_usd >= 100
            and total_transfer_volume_usd < 1000 then ''L1''
        when total_transfer_volume_usd >= 1000
            and total_transfer_volume_usd < 10000 then ''L2''
        when total_transfer_volume_usd >= 10000
            and total_transfer_volume_usd < 50000 then ''L3''
        when total_transfer_volume_usd >= 50000
            and total_transfer_volume_usd < 100000 then ''L4''
        when total_transfer_volume_usd >= 100000
            and total_transfer_volume_usd < 500000 then ''L5''
        when total_transfer_volume_usd >= 500000
            and total_transfer_volume_usd < 1000000 then ''L6''
        when total_transfer_volume_usd >= 1000000
            and total_transfer_volume_usd < 1000000000 then ''Million''
        when total_transfer_volume_usd >= 1000000000 then ''Billion''
        end as label_name
        ,
    now() as updated_at
from
    (
        -- project-token-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a2.project=''ALL'' and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a2.token=''ALL'' and a1.project=a2.project and a1.type=a2.type and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project(ALL)-token-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a2.project=''ALL'' and a1.type=a2.type and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type

            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(total_transfer_volume_usd) as total_transfer_volume_usd
        from
            dex_tx_volume_count_summary  a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token and a1.project=a2.project and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where total_transfer_volume_usd >= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_project_time_top','truncate
	table public.address_label_token_project_time_top;

insert
	into
	public.address_label_token_project_time_top(distributed_key,address,
	label_type,
	label_name,

	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over(partition by   a2.seq_flag  order by first_updated_block_height desc) as rn
        from dex_tx_volume_count_summary a1 inner join dim_project_token_type a2
                                                       on a1.token=a2.token
                                                           and a1.project=a2.project
                                                           and a1.type=a2.type and a2.data_subject=''time''
    ) s1 where s1.rn<=100;
',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_project_type_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_token_project_type_volume_rank;

insert
into public.address_label_token_project_type_volume_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''HEAVY''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''MEDIUM''
           when zb_rate <= 0.001 then ''LEGENDARY''
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
	total_transfer_volume_usd DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    s1.project,
                                    s1.type,
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
                                              ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project(ALL)-token(ALL)-type
                                select address
                                              ,''ALL'' AS token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,type
                                              ,''ALL'' AS project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project-token(ALL)-type(ALL)
                                select address
                                              ,''ALL'' AS  token
                                              ,total_transfer_volume_usd
                                              ,total_transfer_count
                                              ,first_updated_block_height
                                              ,''ALL'' AS  type
                                              ,project
                                              ,in_transfer_volume
                                              ,out_transfer_volume
                                              ,in_transfer_count
                                              ,out_transfer_count
                                              ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project(ALL)-token-type(ALL)
                                select address
                                     ,token
                                     ,total_transfer_volume_usd
                                     ,total_transfer_count
                                     ,first_updated_block_height
                                     ,''ALL'' AS type
                                     ,''ALL'' AS project
                                     ,in_transfer_volume
                                     ,out_transfer_volume
                                     ,in_transfer_count
                                     ,out_transfer_count
                                     ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project-token(ALL)-type
                                select address
                                     ,''ALL'' AS token
                                     ,total_transfer_volume_usd
                                     ,total_transfer_count
                                     ,first_updated_block_height
                                     ,type
                                     , project
                                     ,in_transfer_volume
                                     ,out_transfer_volume
                                     ,in_transfer_count
                                     ,out_transfer_count
                                     ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project(ALL)-token-type
                                select address
                                     ,token
                                     ,total_transfer_volume_usd
                                     ,total_transfer_count
                                     ,first_updated_block_height
                                     ,type
                                     ,''ALL'' AS  project
                                     ,in_transfer_volume
                                     ,out_transfer_volume
                                     ,in_transfer_count
                                     ,out_transfer_count
                                     ,balance_usd from dex_tx_volume_count_summary
                                union all
                                -- project-token-type(ALL)
                                select address
                                     ,token
                                     ,total_transfer_volume_usd
                                     ,total_transfer_count
                                     ,first_updated_block_height
                                     ,''ALL'' AS type
                                     , project
                                     ,in_transfer_volume
                                     ,out_transfer_volume
                                     ,in_transfer_count
                                     ,out_transfer_count
                                     ,balance_usd from dex_tx_volume_count_summary)
                                     s1
                                        INNER JOIN dim_project_token_type s2
                                                   ON
                                                               s1.token = s2.token
                                                           AND s1.project = s2.project
                                                           AND s1.type = s2.type
                                                           AND s2.data_subject = ''volume_rank''
                                WHERE
                                        total_transfer_volume_usd >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.project,
                                    s1.type,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from dex_tx_volume_count_summary) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
            and tb1.project = tb2.project
            and tb1.type = tb2.type
where tb1.total_transfer_volume_usd >= 100
  and tb2.data_subject = ''volume_rank''  and  zb_rate <= 0.1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_project_type_count_grade','truncate
    table public.address_label_nft_project_type_count_grade;

insert
into
    public.address_label_nft_project_type_count_grade(distributed_key,address,
                                             label_type,
                                             label_name,

                                             updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address
        ,
    label_type
        ,
    label_type||''_''||case
        when sum_count >= 1
            and sum_count < 10 then ''L1''
        when sum_count >= 10
            and sum_count < 40 then ''L2''
        when sum_count >= 40
            and sum_count < 80 then ''L3''
        when sum_count >= 80
            and sum_count < 120 then ''L4''
        when sum_count >= 120
            and sum_count < 160 then ''L5''
        when sum_count >= 160
            and sum_count < 200 then ''L6''
        when sum_count >= 200
            and sum_count < 400 then ''Low''
        when sum_count >= 400
            and sum_count < 619 then ''Medium''
        when sum_count >= 619 then ''High''
        end as label_name,
    now() as updated_at
from
    (
        -- project-token-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a1.token=a2.token and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token=''ALL'' and a1.platform_group=a2.project and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token=''ALL'' and a1.platform_group=a2.project and a1.type=a2.type and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    transfer_count) as sum_count
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a1.token=a2.token and a1.platform_group=a2.project and a2.type=''ALL'' and a2.data_subject = ''count''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where sum_count >= 1;
',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_project_type_volume_grade','truncate
	table public.address_label_nft_project_type_volume_grade;

insert
	into
	public.address_label_nft_project_type_volume_grade(distributed_key,address,
	label_type,
	label_name,

	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,address
        ,
    label_type
        ,
    label_type||''_''||case
        when volume_usd >= 1
            and volume_usd < 3 then ''L1''
        when volume_usd >= 3
            and volume_usd < 7 then ''L2''
        when volume_usd >= 7
            and volume_usd < 21 then ''L3''
        when volume_usd >= 21
            and volume_usd < 101 then ''L4''
        when volume_usd >= 101
            and volume_usd < 201 then ''L5''
        when volume_usd >= 201 then ''L6''
        end as label_name,
    now() as updated_at
from
    (
        -- project-token-type
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a1.token=a2.token and a1.platform_group=a2.project and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
-- project-token(ALL)-type
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token=''ALL'' and a1.platform_group=a2.project and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token(ALL)-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a2.token=''ALL'' and a1.platform_group=a2.project and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
            -- project-token-type(ALL)
        union all
        select
            a1.address,
            a2.seq_flag,
            a2.label_type,
            sum(
                    volume_usd) as volume_usd
        from
            platform_nft_type_volume_count  a1 inner join dim_project_token_type a2
                                                          on a1.token=a2.token and a1.platform_group=a2.project and a2.type=''ALL'' and a2.data_subject = ''volume_grade''
        group by
            a1.address,
            a2.seq_flag,
            a2.label_type
    ) t where volume_usd >= 1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_project_type_volume_count_rank','-- -- 第二类标签
truncate
    table public.address_label_nft_project_type_volume_count_rank;

insert
into public.address_label_nft_project_type_volume_count_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.project,
             t1.type,
             t1.volume_usd,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate,
             t1.zb_rate_transfer_count
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.project,
                   a2.type,
                   a2.volume_usd,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                   cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.project,
                         a1.type,
                         a1.volume_usd,
                         a1.count_sum,
                         a1.transfer_count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.project,
                            a1.type,
                            a1.volume_usd,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY volume_usd DESC) AS count_sum,
                                ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY transfer_count DESC) AS transfer_count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    s1.platform_group as project,
                                    s1.type,
                                    sum(volume_usd) AS volume_usd,
                                    sum(transfer_count) AS transfer_count
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,token
                                              ,type
                                              ,volume_usd,transfer_count from platform_nft_type_volume_count
                                         union all
                                         -- project-token(ALL)-type
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,''ALL'' AS token
                                              ,type
                                              ,volume_usd,transfer_count from platform_nft_type_volume_count
                                         union all
                                         -- project-token(ALL)-type(ALL)
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,''ALL'' AS token
                                              ,''ALL'' AS type
                                              ,volume_usd,transfer_count from platform_nft_type_volume_count
                                         union all
                                         -- project-token-type(ALL)
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              , token
                                              ,''ALL'' AS type
                                              ,volume_usd,transfer_count from platform_nft_type_volume_count
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s1.platform_group = s2.project
                                                            AND s1.type=s2.type
                                                            AND s2.data_subject = ''volume_rank''
                                WHERE
                                        volume_usd >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.type,
                                    s1.platform_group,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from platform_nft_type_volume_count) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
                 tb1.token = tb2.token
             and tb1.project = tb2.project
             AND tb1.type=tb2.type
where tb1.volume_usd >= 100   and zb_rate <= 0.001 and zb_rate_transfer_count<=0.001
  and tb2.data_subject = ''volume_rank'';',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_project_type_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_nft_project_type_volume_rank;

insert
into public.address_label_nft_project_type_volume_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''RARE_NFT_TRADER''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''EPIC_NFT_TRADER''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''UNCOMMON_NFT_TRADER''
           when zb_rate <= 0.001 then ''LEGENDARY_NFT_TRADER''
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
                                              ,volume_usd from platform_nft_type_volume_count
                                         union all
                                         -- project-token(ALL)-type
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,''ALL'' AS token
                                              ,type
                                              ,volume_usd from platform_nft_type_volume_count
                                         union all
                                         -- project-token(ALL)-type(ALL)
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              ,''ALL'' AS token
                                              ,''ALL'' AS type
                                              ,volume_usd from platform_nft_type_volume_count
                                         union all
                                         -- project-token-type(ALL)
                                         select  address
                                              ,platform_group
                                              ,platform
                                              ,quote_token
                                              , token
                                              ,''ALL'' AS type
                                              ,volume_usd from platform_nft_type_volume_count
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s1.platform_group = s2.project
                                                            AND s1.type = s2.type
                                                            AND s2.data_subject = ''volume_rank''
                                WHERE
                                        volume_usd >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.type,
                                    s1.platform_group,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from platform_nft_type_volume_count) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
                 tb1.token = tb2.token
             and tb1.project = tb2.project
             AND tb1.type= tb2.type
where tb1.volume_usd >= 100
  and tb2.data_subject = ''volume_rank'' and  zb_rate <= 0.1 ;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_project_type_volume_top','-- -- 第二类标签
truncate
    table public.address_label_nft_project_type_volume_top;

insert
into public.address_label_nft_project_type_volume_top (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by seq_flag
	order by
		volume_usd desc) as rn
        from
            (
                select
                    address
                     ,platform_group
                     ,platform as project
                     ,quote_token
                     ,token
                     ,type
                     ,volume_usd
                from
                    platform_nft_type_volume_count
                union all
                -- project-token(ALL)-type
                select
                    address
                     ,platform_group
                     ,platform as project
                     ,quote_token
                     ,''ALL'' as token
                     ,type
                     ,volume_usd
                from
                    platform_nft_type_volume_count
                union all
                -- project-token(ALL)-type(ALL)
                select
                    address
                     ,platform_group
                     ,platform as project
                     ,quote_token
                     ,''ALL'' as token
                     ,''ALL'' as type
                     ,volume_usd
                from
                    platform_nft_type_volume_count
                union all
                -- project-token-type(ALL)
                select
                    address
                     ,platform_group
                     ,platform as project
                     ,quote_token
                     ,token
                     ,''ALL'' as type
                     ,volume_usd
                from
                    platform_nft_type_volume_count ) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = ''volume_top''
                                   and a1.platform_group =a2.project and a1.type=a2.type
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_balance_grade','truncate
    table public.address_label_nft_balance_grade;

insert
into public.address_label_nft_balance_grade(distributed_key,address,
                                  label_type,
                                  label_name,

                                  updated_at)
select md5(cast(random() as varchar)) as distributed_key,address
        ,
       label_type
        ,
       label_type||''_''||case
           when balance = 1 then ''L1''
           when balance >= 2
               and balance < 4 then ''L2''
           when balance >= 4
               and balance < 11 then ''L3''
           when balance >= 11
               and balance < 51 then ''L4''
           when balance >= 51
               and balance < 101 then ''L5''
           when balance >= 101 then ''L6''
           end  as label_name,
       now()   as updated_at
from (
         -- project(null)+nft+type(null)
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(balance) as balance
         from nft_holding a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token and (a2.project ='''' or a2.project =''ALL'') and (a2.type ='''' OR a2.type =''ALL'') and
                                a2.data_subject = ''balance_grade''
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type
         union all
		  -- project(null)+nft(ALL)+type(null)
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(balance) as balance
         from nft_holding a1
                  inner join dim_project_token_type a2
                             on a2.token = ''ALL'' and (a2.project ='''' or a2.project =''ALL'') and (a2.type ='''' OR a2.type =''ALL'') and
                                a2.data_subject = ''balance_grade''
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type
     ) t where balance>=1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_count_grade','truncate
    table public.address_label_nft_count_grade;

insert
into public.address_label_nft_count_grade(distributed_key,address,
                                  label_type,
                                  label_name,

                                  updated_at)
select md5(cast(random() as varchar)) as distributed_key,address
        ,
       label_type
        ,
       label_type||''_''||case
           when sum_count >= 1
               and sum_count < 10 then ''L1''
           when sum_count >= 10
               and sum_count < 40 then ''L2''
           when sum_count >= 40
               and sum_count < 80 then ''L3''
           when sum_count >= 80
               and sum_count < 120 then ''L4''
           when sum_count >= 120
               and sum_count < 160 then ''L5''
           when sum_count >= 160
               and sum_count < 200 then ''L6''
           when sum_count >= 200
               and sum_count < 400 then ''Low''
           when sum_count >= 400
               and sum_count < 619 then ''Medium''
           when sum_count >= 619 then ''High''
           end as label_name,
       now()   as updated_at
from (
		  -- project(null)+nft+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(transfer_count) as sum_count
         from nft_volume_count a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token and (a2.project ='''' or a2.project =''ALL'') and a1.type = a2.type and a2.type!=''Transfer'' and
                                a2.data_subject = ''count''
         group by a1.address,
             a2.seq_flag,
             a2.label_type
-- project(null)+nft（ALL）+type
         union all
         select a1.address,
             a2.seq_flag,
             a2.label_type,
             sum(
             transfer_count) as sum_count
         from nft_volume_count a1
             inner join dim_project_token_type a2
         on a2.token = ''ALL'' and (a2.project ='''' or a2.project =''ALL'') and a1.type = a2.type and a2.type!=''Transfer'' and
             a2.data_subject = ''count''
         group by a1.address,
             a2.seq_flag,
             a2.label_type) t where sum_count >= 1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_time_grade','-- -- 第二类标签
truncate
    table public.address_label_nft_time_grade;

insert
into public.address_label_nft_time_grade (distributed_key,address,
                                label_type,
                                label_name,

                                updated_at)
select md5(cast(random() as varchar)) as distributed_key,a1.address
        ,
       a2.label_type
        ,
       a2.label_type||''_''||case
           when counter = 1 then ''L1''
           when counter > 1
               and counter <= 7 then ''L2''
           when counter > 7
               and counter <= 30 then ''L3''
           when counter > 30
               and counter <= 90 then ''L4''
           when counter > 90
               and counter <= 180 then ''L5''
           when counter > 180
               and counter <= 365 then ''L6''
           end as label_name
        ,
       now()   as updated_at
from (select token,
             address,
             floor((floor(extract(epoch from now())) - nht.latest_tx_time) / (24 * 3600)) as counter
      from nft_holding_time nht
      where nht.latest_tx_time is not null
        and balance > 0
     ) a1
         inner join
     dim_project_token_type a2
     on
             a1.token = a2.token
where a2.data_subject = ''time_grade''   and counter > 0
  and counter <= 365 and (a2.type ='''' or a2.type =''ALL'') and (a2.project ='''' or a2.project =''ALL'')
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_volume_grade','truncate
    table public.address_label_nft_volume_grade;

insert
into public.address_label_nft_volume_grade(distributed_key,address,
                                  label_type,
                                  label_name,

                                  updated_at)
select md5(cast(random() as varchar)) as distributed_key,address
        ,
       label_type
        ,
       label_type||''_''||case
           when volume_usd >= 1
               and volume_usd < 3 then ''L1''
           when volume_usd >= 3
               and volume_usd < 7 then ''L2''
           when volume_usd >= 7
               and volume_usd < 21 then ''L3''
           when volume_usd >= 21
               and volume_usd < 101 then ''L4''
           when volume_usd >= 101
               and volume_usd < 201 then ''L5''
           when volume_usd >= 201 then ''L6''
           end as label_name,
       now()   as updated_at
from (
		-- project(null)+nft+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(
                        transfer_volume) as volume_usd
         from nft_volume_count a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token and (a2.project ='''' or a2.project =''ALL'') and a1.type = a2.type and a2.type!=''transfer'' and
                                a2.data_subject = ''volume_grade''
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type
         union all
		 -- project(null)+nft（ALL）+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(
                        transfer_volume) as volume_usd
         from nft_volume_count a1
                  inner join dim_project_token_type a2
                             on a2.token = ''ALL'' and (a2.project ='''' or a2.project =''ALL'') and a1.type = a2.type and a2.type!=''transfer'' and
                                a2.data_subject = ''volume_grade''
         group by a1.address,
             a2.seq_flag,
             a2.label_type) t where volume_usd >= 1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_balance_rank','truncate
    table public.address_label_nft_balance_rank;

insert
into public.address_label_nft_balance_rank(distributed_key,address,
                                  label_type,
                                  label_name,

                                  updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''RARE_NFT_COLLECTOR''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''EPIC_NFT_COLLECTOR''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''UNCOMMON_NFT_COLLECTOR''
           when zb_rate <= 0.001 then ''LEGENDARY_NFT_COLLECTOR''
           end as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.balance,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.balance,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.balance,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.balance,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
ORDER BY
	balance DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    sum(s1.balance) AS balance
                                FROM (
                                     -- project(null)+nft+type(null)
                                         select  address
                                              ,token
                                              ,balance
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,total_transfer_to_volume
                                              ,total_transfer_to_count
                                              ,total_transfer_mint_volume
                                              ,total_transfer_mint_count
                                              ,total_transfer_burn_volume
                                              ,total_transfer_burn_count
                                              ,total_transfer_all_volume
                                              ,total_transfer_all_count
                                              ,updated_block_height from nft_holding
                                         union all
                                         -- project(null)-token(ALL)-type(null)
                                         select address
                                              ,''ALL'' as token
                                              ,balance
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                              ,total_transfer_to_volume
                                              ,total_transfer_to_count
                                              ,total_transfer_mint_volume
                                              ,total_transfer_mint_count
                                              ,total_transfer_burn_volume
                                              ,total_transfer_burn_count
                                              ,total_transfer_all_volume
                                              ,total_transfer_all_count
                                              ,updated_block_height  from nft_holding
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND  (s2.project ='''' or s2.project =''ALL'')
                                                            AND (s2.type='''' or s2.type=''ALL'')
                                                            AND s2.data_subject = ''balance_rank''
                                WHERE
                                        balance >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from nft_holding) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
where tb1.balance >= 100  AND   (tb2.project ='''' or tb2.project =''ALL'')
  AND (tb2.type='''' OR tb2.type=''ALL'')
  and tb2.data_subject = ''balance_rank'' and  zb_rate <= 0.1 ;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_balance_top','truncate table address_label_nft_balance_top;
insert into public.address_label_nft_balance_top (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		balance desc) as rn
        from
            (
                select
                    address,
                    token,
                    balance
                from
                    nft_holding
                union all
                select
                    address,
                    ''ALL'' as token,
                    balance
                from
                    nft_holding ) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = ''balance_top''
        and (a2.project ='''' or a2.project =''ALL'')  AND (a2.type='''' or a2.type=''ALL'')
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_time_rank','truncate
    table public.address_label_nft_time_rank;
insert
into public.address_label_nft_time_rank (distributed_key,address,
                                label_type,
                                label_name,

                                updated_at)
select md5(cast(random() as varchar)) as distributed_key,a1.address
        ,
       a2.label_type
        ,
       a2.label_type||''_''||case
           when counter >= 155 then ''LONG_TERM_HOLDER''
           when counter >= 1
               and counter < 155 then ''SHORT_TERM_HOLDER''
           end as label_name
        ,
		now()   as updated_at
from (select token,
             address,
             floor((floor(extract(epoch from now())) - nht.latest_tx_time) / (24 * 3600)) as counter
      from nft_holding_time nht
      where nht.latest_tx_time is not null
        and balance > 0)  a1
         inner join
     dim_project_token_type a2
     on
             a1.token = a2.token
where a2.data_subject = ''time_special'' and counter >=1
  and counter <= 365  AND (a2.type='''' or a2.type=''ALL'') and (a2.project ='''' or a2.project =''ALL'')
;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_time_top','truncate
    table public.address_label_nft_time_top;
insert
into public.address_label_nft_time_top (distributed_key,address,
                                label_type,
                                label_name,

                                updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		first_tx_time asc) as rn
        from
            (
                select
                    address
                     ,token
                     ,latest_tx_time
                     ,balance
                     ,first_tx_time
                from
                    nft_holding_time
            ) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = ''time_special''   AND (a2.type='''' or a2.type=''ALL'') and (a2.project ='''' or a2.project =''ALL'')
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_volume_count_rank','truncate
    table public.address_label_nft_volume_count_rank;
insert
into
	public.address_label_nft_volume_count_rank(distributed_key,address,
	label_type,
	label_name,

	updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,tb1.address ,
    tb2.label_type,
    tb2.label_type as label_name,
    now() as updated_at
from
    (
        select
            t1.id,
            t1.address,
            t1.token,
            t1.type,
            t1.transfer_volume,
            t1.count_sum,
            t1.count_sum_total,
            t1.zb_rate,
            t1.zb_rate_transfer_count
        from
            (
                select
                    a2.id,
                    a2.address,
                    a2.token,
                    a2.type,
                    a2.transfer_volume,
                    a2.count_sum,
                    a2.count_sum_total,
                    cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                    cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
                from
                    (
                        select
                            a1.id,
                            a1.address,
                            a1.token,
                            a1.type,
                            a1.transfer_volume,
                            a1.count_sum,
                            a1.transfer_count_sum,
                            a10.count_sum_total
                        from
                            (
                                select
                                    md5(cast(random() as varchar)) as id,
                                    a1.address,
                                    a1.token,
                                    a1.type,
                                    a1.transfer_volume,
                                    a1.transfer_count,
                                    row_number() over(partition by seq_flag
				order by
					transfer_volume desc) as count_sum,
                                        row_number() over(partition by seq_flag
				order by
					transfer_count desc) as transfer_count_sum
                                from
                                    (
                                        select
                                            s1.address,
                                            s2.seq_flag,
                                            s1.token,
                                            s1.type,
                                            sum(transfer_volume) as transfer_volume,
                                            sum(transfer_count) as transfer_count
                                        from
                                            (
											-- project(null)+nft+type
                                                select
                                                    address ,
                                                    token ,
                                                    type ,
                                                    transfer_volume ,
                                                    transfer_count
                                                from
                                                    nft_volume_count
                                                union all
                                                -- project(null)+nft（ALL）+type
                                                select
                                                    address ,
                                                    ''ALL'' as token ,
                                                    type ,
                                                    transfer_volume ,
                                                    transfer_count
                                                from
                                                    nft_volume_count ) s1
                                                inner join dim_project_token_type s2 on
                                                        s1.token = s2.token
                                                    and s2.type = s2.type
                                                    and s2.data_subject = ''volume_rank''
                                        where
                                                transfer_volume >= 100
                                        group by
                                            s1.address,
                                            s1.token,
                                            s1.type,
                                            s2.seq_flag) as a1) as a1
                                inner join (
                                select
                                    count(distinct address) as count_sum_total
                                from
                                    nft_volume_count) as a10 on
                                    1 = 1) as a2) as t1 ) tb1
        inner join dim_project_token_type tb2 on
                tb1.token = tb2.token
            and tb2.type = tb2.type  and (tb2.project ='''' or tb2.project =''ALL'')
where
        tb1.transfer_volume >= 100
  and zb_rate <= 0.001
  and zb_rate_transfer_count <= 0.001
  and tb2.data_subject = ''volume_rank'';',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_volume_rank','truncate
    table public.address_label_nft_volume_rank;

insert
into public.address_label_nft_volume_rank(distributed_key,address,
                                  label_type,
                                  label_name,

                                  updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''RARE_NFT_TRADER''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''EPIC_NFT_TRADER''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''UNCOMMON_NFT_TRADER''
           when zb_rate <= 0.001 then ''LEGENDARY_NFT_TRADER''
           end as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.type,
             t1.transfer_volume,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.type,
                   a2.transfer_volume,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.type,
                         a1.transfer_volume,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.type,
                            a1.transfer_volume,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
ORDER BY
	transfer_volume DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    s1.type,
                                    sum(transfer_volume) AS transfer_volume
                                FROM (

                                         -- project(null)+nft+type
                                         select  address
                                              ,token
                                              ,type
                                              ,transfer_volume
                                              ,transfer_count from nft_volume_count
										  union all
										-- project(null)+nft（ALL）+type
                                         select  address
                                              ,''ALL'' AS token
                                              ,type
                                              ,transfer_volume
                                              ,transfer_count from nft_volume_count

                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s2.type = s2.type
                                                            AND s2.data_subject = ''volume_rank''
                                WHERE
                                        transfer_volume >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s1.type,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from nft_volume_count) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
                 tb1.token = tb2.token
             AND tb2.type = tb2.type and (tb2.project ='''' or tb2.project =''ALL'')
where tb1.transfer_volume >= 100  and tb2.data_subject = ''volume_rank''  and  zb_rate <= 0.1 ;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_volume_top','-- -- 第二类标签
truncate
    table public.address_label_nft_volume_top;

insert
into public.address_label_nft_volume_top (distributed_key,address,
                                                   label_type,
                                                   label_name,

                                                   updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by seq_flag
	order by
		transfer_volume desc) as rn
        from
            (
                -- project(null)+nft+type(null)
                select
                    address
                     ,token
                     ,'''' as type
                     ,transfer_volume
                     ,transfer_count
                from
                    nft_volume_count
                union all
                -- project(null)+nft(ALL)+type(null)
                select
                    address
                     ,''ALL'' AS token
                     ,'''' AS type
                     ,transfer_volume
                     ,transfer_count

                from
                    nft_volume_count
                union all
                -- project(null)+nft+type
                select
                    address
                     ,token
                     ,type
                     ,transfer_volume
                     ,transfer_count

                from
                    nft_volume_count
                union all
                -- project(null)+nft+type(ALL)
                select
                    address
                     ,token
                     ,''ALL'' AS type
                     ,transfer_volume
                     ,transfer_count

                from
                    nft_volume_count
                union all
                -- project(null)+nft（ALL）+type
                select
                    address
                     ,''ALL'' AS token
                     ,type
                     ,transfer_volume
                     ,transfer_count
                from
                    nft_volume_count
            ) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.data_subject = ''volume_top''
                                   and a1.type=a2.type and (a2.project ='''' or a2.project =''ALL'')
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_transfer_count_grade','truncate
    table public.address_label_nft_transfer_count_grade;

insert
into public.address_label_nft_transfer_count_grade(distributed_key,address,
                                          label_type,
                                          label_name,

                                          updated_at)
select md5(cast(random() as varchar)) as distributed_key,address
        ,
       label_type
        ,
       label_type||''_''||case
           when sum_count >= 1
               and sum_count < 10 then ''L1''
           when sum_count >= 10
               and sum_count < 40 then ''L2''
           when sum_count >= 40
               and sum_count < 80 then ''L3''
           when sum_count >= 80
               and sum_count < 120 then ''L4''
           when sum_count >= 120
               and sum_count < 160 then ''L5''
           when sum_count >= 160
               and sum_count < 200 then ''L6''
           when sum_count >= 200
               and sum_count < 400 then ''Low''
           when sum_count >= 400
               and sum_count < 619 then ''Medium''
           when sum_count >= 619 then ''High''
           end as label_name,
       now()   as updated_at
from (
         -- project(null)+nft+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(total_transfer_count) as sum_count
         from nft_transfer_holding a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token   and
                                a2.type = ''Transfer'' and
                                a2.data_subject = ''count''
		and (a2.project ='''' or a2.project =''ALL'')
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type
		union all
		  -- project(null)+nft（ALL）+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(total_transfer_count) as sum_count
         from nft_transfer_holding a1
                  inner join dim_project_token_type a2
                             on a2.token = ''ALL''   and
                                a2.type = ''Transfer'' and
                                a2.data_subject = ''count''
								and (a2.project ='''' or a2.project =''ALL'')
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type) t where sum_count >= 1;',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_transfer_volume_grade','truncate
    table public.address_label_nft_transfer_volume_grade;

insert
into public.address_label_nft_transfer_volume_grade(distributed_key,address,
                                          label_type,
                                          label_name,

                                          updated_at)
select md5(cast(random() as varchar)) as distributed_key,address
        ,
       label_type
        ,
       label_type||''_''||case
           when volume_usd >= 1
               and volume_usd < 3 then ''L1''
           when volume_usd >= 3
               and volume_usd < 7 then ''L2''
           when volume_usd >= 7
               and volume_usd < 21 then ''L3''
           when volume_usd >= 21
               and volume_usd < 101 then ''L4''
           when volume_usd >= 101
               and volume_usd < 201 then ''L5''
           when volume_usd >= 201 then ''L6''
           end as label_name,
       now()   as updated_at
from (
         -- project(null)+nft+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(total_transfer_volume) as volume_usd
         from nft_transfer_holding a1
                  inner join dim_project_token_type a2
                             on a1.token = a2.token   and
                                a2.type = ''Transfer'' and
                                a2.data_subject = ''volume_grade''
								and (a2.project ='''' or a2.project =''ALL'')
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type
         union all
		 -- project(null)+nft（ALL）+type
         select a1.address,
                a2.seq_flag,
                a2.label_type,
                sum(total_transfer_volume) as volume_usd
         from nft_transfer_holding a1
                  inner join dim_project_token_type a2
                             on a2.token = ''ALL''   and
                                a2.type = ''Transfer'' and
                                a2.data_subject = ''volume_grade'' and (a2.project ='''' or a2.project =''ALL'')
         group by a1.address,
                  a2.seq_flag,
                  a2.label_type) t where volume_usd >= 1;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_transfer_volume_count_rank','-- -- 第二类标签
truncate
    table public.address_label_nft_transfer_volume_count_rank;

insert
into public.address_label_nft_transfer_volume_count_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.total_transfer_volume,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate,
             t1.zb_rate_transfer_count
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.total_transfer_volume,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate,
                   cast(a2.transfer_count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate_transfer_count
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.total_transfer_volume,
                         a1.count_sum,
                         a1.transfer_count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.total_transfer_volume,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY total_transfer_volume DESC) AS count_sum,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag ORDER BY total_transfer_count DESC) AS transfer_count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    sum(s1.total_transfer_volume) AS total_transfer_volume,
                                    sum(s1.total_transfer_count) AS total_transfer_count
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,token
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                         from nft_transfer_holding
                                         union all
                                         -- project(null)+nft（ALL）+type
                                         select  address
                                              ,''ALL'' as token
                                              ,total_transfer_volume
                                              ,total_transfer_count
                                         from nft_transfer_holding
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s2.data_subject = ''volume_rank'' and (s2.project ='''' or s2.project =''ALL'')
                                WHERE
                                        total_transfer_volume >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from nft_transfer_holding) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
where tb1.total_transfer_volume >= 100
  and tb2.type = ''Transfer''  and (tb2.project ='''' or tb2.project =''ALL'')
  and zb_rate <= 0.001 and zb_rate_transfer_count<=0.001
  and tb2.data_subject = ''volume_rank'';',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_transfer_volume_rank','-- -- 第二类标签
truncate
    table public.address_label_nft_transfer_volume_rank;

insert
into public.address_label_nft_transfer_volume_rank (distributed_key,address,
                                         label_type,
                                         label_name,

                                         updated_at)
select md5(cast(random() as varchar)) as distributed_key,tb1.address ,
       tb2.label_type,
       tb2.label_type||''_''||case
           when zb_rate > 0.01 and zb_rate <= 0.025 then ''HEAVY''
           when zb_rate > 0.001 and zb_rate <= 0.01 then ''ELITE''
           when zb_rate > 0.025 and zb_rate <= 0.1 then ''MEDIUM''
           when zb_rate <= 0.001 then ''LEGENDARY''
           end as label_name,
       now()   as updated_at
from (select t1.id,
             t1.address,
             t1.token,
             t1.total_transfer_volume,
             t1.count_sum,
             t1.count_sum_total,
             t1.zb_rate
      from (select a2.id,
                   a2.address,
                   a2.token,
                   a2.total_transfer_volume,
                   a2.count_sum,
                   a2.count_sum_total,
                   cast(a2.count_sum as numeric(20, 8)) / cast(a2.count_sum_total as numeric(20, 8)) as zb_rate
            from (select a1.id,
                         a1.address,
                         a1.token,
                         a1.total_transfer_volume,
                         a1.count_sum,
                         a10.count_sum_total
                  from (SELECT
                            md5(CAST(random() AS varchar)) AS id,
                            a1.address,
                            a1.token,
                            a1.total_transfer_volume,
                            ROW_NUMBER() OVER(PARTITION BY seq_flag
ORDER BY
	total_transfer_volume DESC) AS count_sum
                        FROM
                            (
                                SELECT
                                    s1.address,
                                    s2.seq_flag,
                                    s1.token,
                                    sum(s1.total_transfer_volume) AS total_transfer_volume
                                FROM (
                                         -- project-token-type
                                         select  address
                                              ,token
                                              ,total_transfer_volume
                                         from nft_transfer_holding
                                         union all
                                         -- project(null)+nft（ALL）+type
                                         select  address
                                              ,''ALL'' as token
                                              ,total_transfer_volume
                                         from nft_transfer_holding
                                     )
                                         s1
                                         INNER JOIN dim_project_token_type s2
                                                    ON
                                                                s1.token = s2.token
                                                            AND s2.data_subject = ''volume_rank''
                                WHERE
                                        total_transfer_volume >= 100
                                GROUP BY
                                    s1.address,
                                    s1.token,
                                    s2.seq_flag) AS a1) as a1
                           inner join
                       (select count(distinct address) as count_sum_total
                        from nft_transfer_holding) as a10
                       on 1 = 1) as a2) as t1
     ) tb1
         inner join
     dim_project_token_type tb2
     on
             tb1.token = tb2.token
where tb1.total_transfer_volume >= 100
  and tb2.type = ''Transfer''  and (tb2.project ='''' or tb2.project =''ALL'')
  and tb2.data_subject = ''volume_rank'' and  zb_rate <= 0.1 ;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_nft_transfer_volume_top','truncate table address_label_nft_transfer_volume_top;
insert into public.address_label_nft_transfer_volume_top (distributed_key,address,
                                                label_type,
                                                label_name,

                                                updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    label_type||''_''||''WHALE'' as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.token
	order by
		total_transfer_volume desc) as rn
        from
            (
                select  address
                     ,token
                     ,total_transfer_volume
                from nft_transfer_holding
                union all
                -- project(null)+nft（ALL）+type
                select  address
                     ,''ALL'' as token
                     ,total_transfer_volume
                from nft_transfer_holding) a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token
                                   and a2.type = ''Transfer'' and (a2.project ='''' or a2.project =''ALL'')
                                   and a2.data_subject = ''volume_top''
    ) s1
where
        s1.rn <= 100;',1);


insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_balance_provider','truncate table address_label_token_balance_provider;
insert into public.address_label_token_balance_provider (distributed_key,address,
                                                    label_type,
                                                    label_name,
                                                    updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		balance_usd desc) as rn
        from (select * from
            dex_tx_volume_count_summary where type=''lp'')  a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token and a1.project=a2.project
                                   and a2.data_subject = ''HEAVY_LP''
    ) s1
where
        s1.rn <= 200;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_balance_staked','truncate table address_label_token_balance_staked;
insert into public.address_label_token_balance_staked (distributed_key,address,
                                                    label_type,
                                                    label_name,
                                                    updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		balance_usd desc) as rn
        from
            (select * from
                dex_tx_volume_count_summary where type=''stake'')  a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token and a1.project=a2.project
                                   and a2.data_subject = ''HEAVY_LP_STAKER''
    ) s1
where
        s1.rn <= 200;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_time_first_lp','truncate table address_label_token_time_first_lp;
insert into public.address_label_token_time_first_lp (distributed_key,address,
                                                    label_type,
                                                    label_name,
                                                    updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		first_updated_block_height asc) as rn
        from
            (select * from
                dex_tx_volume_count_summary where type=''lp'') a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token and a1.project=a2.project
                                   and a2.data_subject = ''FIRST_MOVER_LP''
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('address_label_token_time_first_stake','truncate table address_label_token_time_first_stake;
insert into public.address_label_token_time_first_stake (distributed_key,address,
                                                       label_type,
                                                       label_name,
                                                       updated_at)
select
    md5(cast(random() as varchar)) as distributed_key,s1.address,
    s1.label_type,
    s1.label_type as label_name,
    now() as updated_at
from
    (
        select
            a1.address,
            a2.label_type,
            -- 分组字段很关键
            row_number() over( partition by a2.seq_flag
	order by
		first_updated_block_height asc) as rn
        from
            (select * from
                dex_tx_volume_count_summary where type=''stake'')  a1
                inner join dim_project_token_type a2
                           on
                                       a1.token = a2.token and a1.project=a2.project
                                   and a2.data_subject = ''FIRST_MOVER_STAKING''
    ) s1
where
        s1.rn <= 100;',1);

insert into dim_rule_sql_content (rule_name, rule_sql, rule_order)
values ('summary','truncate table address_label_gp_temp;
insert into public.address_label_gp_temp(address,label_type,label_name,updated_at,owner,source)
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source from address_label_eth_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source from address_label_token_project_type_balance_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_project_type_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_project_type_volume_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_project_time_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_project_type_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_project_type_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_project_type_volume_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_project_type_volume_count_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_project_type_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_project_type_volume_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_balance_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_time_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_volume_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_balance_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_balance_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_time_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_time_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_volume_count_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_volume_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_transfer_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_transfer_volume_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_transfer_volume_count_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_transfer_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_nft_transfer_volume_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_balance_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_time_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_volume_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_eth_balance_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_eth_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_time_special  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_balance_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_balance_top  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_usdt_balance_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_usdt_volume_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_web3_type_balance_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_web3_type_count_grade  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_web3_type_balance_rank  union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_web3_type_balance_top union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_balance_provider union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_balance_staked union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_time_first_lp union all
select address,label_type,label_name,updated_at,''-1'' as owner,''SYSTEM'' as source  from address_label_token_time_first_stake union all
select address,label_type,label_name,updated_at, owner, source  from address_label_third_party union all
select address,label_type,label_name,updated_at,owner, source  from address_label_ugc;',999999);
