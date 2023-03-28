

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
    avg_birthday numeric(250, 20) NULL,
    defi_address_num numeric(250, 20) NULL,
    nft_address_num numeric(250, 20) NULL,
    web3_address_num numeric(250, 20) NULL,

    crowd_active_users numeric(250, 20) NULL,
    crowd_elite numeric(250, 20) NULL,
    crowd_nft_active_users numeric(250, 20) NULL,
    crowd_long_term_holder numeric(250, 20) NULL,
    crowd_nft_whale numeric(250, 20) NULL,
    crowd_nft_high_demander numeric(250, 20) NULL,
    crowd_token_whale numeric(250, 20) NULL,
    crowd_defi_active_users numeric(250, 20) NULL,
    crowd_defi_high_demander numeric(250, 20) NULL,
    crowd_web3_active_users numeric(250, 20) NULL,

    json_text text NULL
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
                       avg(balance_usd) balance_usd
                   from
                       (
                           select
                               balance_usd,
                               row_number() over( partition by 1 = 1
	order by
			balance_usd asc) as rn
                           from
                               token_balance_volume_usd
                       ) out_t
                   where
                           rn >=(
                           select
                               case
                                   when count(1)%2 = 0 then count(1)/ 2
                                   else count(1)/ 2 + 1
                                   end
                           from
                               token_balance_volume_usd
                       )
                     and rn <=(
                       select
                                   count(1)/ 2 + 1
                       from
                           token_balance_volume_usd
                   ))
where
        code = 'static_total';

update
    static_total_data
set
    avg_volume = (select
                      avg(volume_usd) volume_usd
                  from
                      (
                          select
                              volume_usd,
                              row_number() over( partition by 1 = 1
	order by
			volume_usd asc) as rn
                          from
                              total_volume_usd

                      ) out_t
                  where
                          rn >=(
                          select
                              case
                                  when count(1)%2 = 0 then count(1)/ 2
                                  else count(1)/ 2 + 1
                                  end
                          from
                              total_volume_usd
                      )
                    and rn <=(
                      select
                                  count(1)/ 2 + 1
                      from
                          total_volume_usd
                  ))
where
        code = 'static_total';


DROP TABLE if EXISTS  address_activity;
create table address_activity
(
    address  varchar(200) not null,
    activity_num numeric(250, 20) NULL
);

truncate table address_activity;
insert into address_activity(activity_num,address)
select sum(activity_num),address from(
 select
     sum(total_transfer_count) as activity_num,address from  token_holding_vol_count group by address
 union all
 select
     sum(total_transfer_count) as activity_num,address from  web3_transaction_record_summary group by address
 union all
 select
     sum(total_transfer_all_count) as activity_num,address from  nft_holding group by address)
 out_t group by address;

update
    static_total_data
set
    avg_activity = (select
                        avg(activity_num) activity_num
                    from
                        (
                            select
                                activity_num,
                                row_number() over( partition by 1 = 1
	order by
			activity_num asc) as rn
                            from
                                address_activity

                        ) out_t
                    where
                            rn >=(
                            select
                                case
                                    when count(1)%2 = 0 then count(1)/ 2
                                    else count(1)/ 2 + 1
                                    end
                            from
                                address_activity
                        )
                      and rn <=(
                        select
                                    count(1)/ 2 + 1
                        from
                            address_activity
                    ))
where
        code = 'static_total';

update
    static_total_data
set
    avg_birthday = (select
                        avg(days) as avg_birthday
                   from address_info)
where
        code = 'static_total';


update
    static_total_data
set  defi_address_num =(select address_num from static_wired_type_address where wired_type='DEFI') ,
    nft_address_num  =(select address_num from static_wired_type_address where wired_type='NFT') ,
    web3_address_num  =(select address_num from static_wired_type_address where wired_type='WEB3')
where
        code = 'static_total';


update static_total_data set json_text= (select '{'||string_agg('"'||
                                                                case when dimension_type = 'project' and bus_type='balance' then 'platform_label_balance'
                                                                     when dimension_type = 'token' and bus_type='balance'  then 'token_label_balance'
                                                                     when dimension_type = 'token' and bus_type='volume'  then 'token_label_volume'
                                                                     when dimension_type = 'token' and bus_type='activity'  then 'token_label_activity'
                                                                     when dimension_type = 'nft' and bus_type='balance'  then 'nft_label_balance'
                                                                     when dimension_type = 'nft' and bus_type='volume'  then 'nft_label_volume'
                                                                     when dimension_type = 'nft' and bus_type='activity'  then 'nft_label_activity'
                                                                     when dimension_type = 'project' and bus_type='volume'  then 'platform_label_volume'
                                                                     when dimension_type = 'project' and bus_type='activity'  then 'platform_label_activity'
                                                                     when dimension_type = 'action' and bus_type='volume'  then 'action_label_volume'
                                                                     when dimension_type = 'action' and bus_type='activity'  then 'action_label_activity'
                                                                     else 'undefine'
                                                                    end
                                                                    ||'":'||json_text,',')||'}'
                                         from static_asset_data_json)
where  code = 'static_total';


update static_total_data set crowd_active_users=static_crowd_data.crowd_active_users,
    crowd_elite=static_crowd_data.crowd_elite,
    crowd_nft_active_users=static_crowd_data.crowd_nft_active_users,
    crowd_long_term_holder=static_crowd_data.crowd_long_term_holder,
    crowd_nft_whale=static_crowd_data.crowd_nft_whale,
    crowd_nft_high_demander =static_crowd_data.crowd_nft_high_demander,
    crowd_token_whale =static_crowd_data.crowd_token_whale,
    crowd_defi_active_users =static_crowd_data.crowd_defi_active_users,
    crowd_defi_high_demander =static_crowd_data.crowd_defi_high_demander,
    crowd_web3_active_users =static_crowd_data.crowd_web3_active_users
        from (select case static_code when 'crowd_active_users' then address_num else 0 end as crowd_active_users,
            case static_code when 'crowd_elite' then address_num else 0 end as crowd_elite,
            case static_code when 'crowd_nft_active_users' then address_num else 0 end as crowd_nft_active_users,
            case static_code when 'crowd_long_term_holder' then address_num else 0 end as crowd_long_term_holder,
            case static_code when 'crowd_nft_whale' then address_num else 0 end as crowd_nft_whale,
            case static_code when 'crowd_nft_high_demander' then address_num else 0 end as crowd_nft_high_demander,
            case static_code when 'crowd_token_whale' then address_num else 0 end as crowd_token_whale,
            case static_code when 'crowd_defi_active_users' then address_num else 0 end as crowd_defi_active_users,
            case static_code when 'crowd_defi_high_demander' then address_num else 0 end as crowd_defi_high_demander,
            case static_code when 'crowd_web3_active_users' then address_num else 0 end as crowd_web3_active_users
            from static_crowd_data) as static_crowd_data
where  code = 'static_total';



