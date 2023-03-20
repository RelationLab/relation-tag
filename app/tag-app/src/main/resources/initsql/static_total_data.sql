DROP TABLE if EXISTS  static_wired_type_address;
create table static_wired_type_address
(
    wired_type  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_wired_type_address;
insert into static_wired_type_address  (wired_type,address_num)
select
    wired_type,
    count(1) as address_num
from
    (
        select
            count(address),
            wired_type,
            address
        from
            address_label_gp
        group by
            wired_type,
            address) out_t
group by
    wired_type;

DROP TABLE if EXISTS  static_total_data;
create table static_total_data
(
    code  varchar(200) not null,
    address_num numeric(250, 20) NULL,
    individual_address_num numeric(250, 20) NULL,
    contract_address_num numeric(250, 20) NULL,
    avg_balance numeric(250, 20) NULL,
    avg_volume numeric(250, 20) NULL,
    avg_activity numeric(250, 20) NULL,
    avg_birthday numeric(250, 20) NULL
);
truncate table static_total_data;

insert into static_total_data  (code,individual_address_num,contract_address_num)
select 'static_total' as code,
       sum(case when address_type='p' then 1 else 0 end ) as  individual_address_num,
       sum(case when address_type='c' then 1 else 0 end) as contract_address_num
from address_labels_json_gin ;

update
    static_total_data
set
    address_num = (
        select
            count(distinct address)
        from
            (
                select
                    distinct address
                from
                    token_volume_usd
                union all
                select
                    distinct address
                from
                    nft_holding) out_t)
where
        code = 'static_total';

update
    static_total_data
set
    avg_balance = (select
                       balance_usd
                   from
                       (
                           select
                               balance_usd,
                               row_number() over( partition by 1 = 1
	order by
			balance_usd asc) as rn
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')
                       ) out_t
                   where
                           rn =(
                           select
                                   count(1)/ 2
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')))
where
        code = 'static_total';

update
    static_total_data
set
    avg_volume = (select
                      volume_usd
                   from
                       (
                           select
                               volume_usd,
                               row_number() over( partition by 1 = 1
	order by
			volume_usd asc) as rn
                           from
                               token_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')
                       ) out_t
                   where
                           rn =(
                           select
                                   count(1)/ 2
                           from
                               token_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')))
where
        code = 'static_total';

update
    static_total_data
set
    avg_balance = (select
                       balance_usd
                   from
                       (
                           select
                               balance_usd,
                               row_number() over( partition by 1 = 1
	order by
			balance_usd asc) as rn
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')
                       ) out_t
                   where
                           rn =(
                           select
                                   count(1)/ 2
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')))
where
        code = 'static_total';

update
    static_total_data
set
    avg_balance = (select
                       balance_usd
                   from
                       (
                           select
                               balance_usd,
                               row_number() over( partition by 1 = 1
	order by
			balance_usd asc) as rn
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')
                       ) out_t
                   where
                           rn =(
                           select
                                   count(1)/ 2
                           from
                               token_balance_volume_usd
                           where
                                   token in (
                                   select
                                       token_id
                                   from
                                       dim_rank_token
                                   where
                                           asset_type = 'token')))
where
        code = 'static_total';


