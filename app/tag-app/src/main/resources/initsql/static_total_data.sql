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

--     crowd_active_users numeric(250, 20) NULL,
--     crowd_elite numeric(250, 20) NULL,
--     crowd_nft_active_users numeric(250, 20) NULL,
--     crowd_long_term_holder numeric(250, 20) NULL,
--     crowd_nft_whale numeric(250, 20) NULL,
--     crowd_nft_high_demander numeric(250, 20) NULL,
--     crowd_token_whale numeric(250, 20) NULL,
--     crowd_defi_active_users numeric(250, 20) NULL,
--     crowd_defi_high_demander numeric(250, 20) NULL,
--     crowd_web3_active_users numeric(250, 20) NULL,
    crowd_json_text text NULL,
    json_text text NULL
);
truncate table static_total_data;

-----计算合约和个人地址数
insert into static_total_data  (code,individual_address_num,contract_address_num)
select 'static_total' as code,
       sum(case when address_type='p' then 1 else 0 end ) as  individual_address_num,
       sum(case when address_type='c' then 1 else 0 end) as contract_address_num
from address_labels_json_gin ;

-----更新总地址数
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

-----更新余额中位数
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

-----更新交易额中位数
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


-----计算活跃度中位数
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

-----更新活跃度中位数
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

-----更新诞生天数平均值
update
    static_total_data
set
    avg_birthday = (select
                        avg(days) as avg_birthday
                   from address_info)
where
        code = 'static_total';

-----更新三大类地址数统计值
update
    static_total_data
set
    defi_address_num = static_wired_type_address.defi_address_num,
    nft_address_num = static_wired_type_address.nft_address_num,
    web3_address_num = static_wired_type_address.web3_address_num
    from
	(
	select
		sum(defi_address_num) as defi_address_num,
		sum(nft_address_num) as nft_address_num,
		sum(web3_address_num) as web3_address_num
	from
		(
		select
			'wired_type' as wired_type,
			max(case wired_type when 'DEFI' then address_num else 0 end) as defi_address_num,
			max(case wired_type when 'NFT' then address_num else 0 end) as nft_address_num,
			max(case wired_type when 'WEB3' then address_num else 0 end) as web3_address_num
		from
			static_wired_type_address
		group by
			wired_type) out_t
	group by
		wired_type
        ) static_wired_type_address
where
    code = 'static_total';

-----更新资产级别地址数统计值
update static_total_data set json_text= (
    select
        json_agg(json_text::jsonb)
    from
        static_category_json)
where  code = 'static_total';

-----更新人群标签地址数统计值
update static_total_data set crowd_json_text= (select
                                                   jsonb_agg(JSON_BUILD_OBJECT('content', static_code, 'number', address_num))
                                               from
                                                   static_crowd_data)
where  code = 'static_total';
-- update static_total_data set crowd_active_users=static_crowd_data.crowd_active_users,
--     crowd_elite=static_crowd_data.crowd_elite,
--     crowd_nft_active_users=static_crowd_data.crowd_nft_active_users,
--     crowd_long_term_holder=static_crowd_data.crowd_long_term_holder,
--     crowd_nft_whale=static_crowd_data.crowd_nft_whale,
--     crowd_nft_high_demander =static_crowd_data.crowd_nft_high_demander,
--     crowd_token_whale =static_crowd_data.crowd_token_whale,
--     crowd_defi_active_users =static_crowd_data.crowd_defi_active_users,
--     crowd_defi_high_demander =static_crowd_data.crowd_defi_high_demander,
--     crowd_web3_active_users =static_crowd_data.crowd_web3_active_users
--         from (
-- select
-- 	sum(crowd_active_users) as crowd_active_users,
-- 	sum(crowd_elite) as crowd_elite,
-- 	sum(crowd_nft_active_users) as crowd_nft_active_users,
-- 	sum(crowd_long_term_holder) as crowd_long_term_holder,
-- 	sum(crowd_nft_whale) as crowd_nft_whale,
-- 	sum(crowd_nft_high_demander) as crowd_nft_high_demander,
-- 	sum(crowd_token_whale) as crowd_token_whale,
-- 	sum(crowd_defi_active_users) as crowd_defi_active_users,
-- 	sum(crowd_defi_high_demander) as crowd_defi_high_demander,
-- 	sum(crowd_web3_active_users) as crowd_web3_active_users
-- from
-- 	(
-- 	select
-- 		'define' static_code,
-- 		max(case static_code when 'crowd_active_users' then address_num else 0 end) as crowd_active_users,
-- 		max(case static_code when 'crowd_elite' then address_num else 0 end) as crowd_elite,
-- 		max(case static_code when 'crowd_nft_active_users' then address_num else 0 end) as crowd_nft_active_users,
-- 		max(case static_code when 'crowd_long_term_holder' then address_num else 0 end) as crowd_long_term_holder,
-- 		max(case static_code when 'crowd_nft_whale' then address_num else 0 end) as crowd_nft_whale,
-- 		max(case static_code when 'crowd_nft_high_demander' then address_num else 0 end) as crowd_nft_high_demander,
-- 		max(case static_code when 'crowd_token_whale' then address_num else 0 end) as crowd_token_whale,
-- 		max(case static_code when 'crowd_defi_active_users' then address_num else 0 end) as crowd_defi_active_users,
-- 		max(case static_code when 'crowd_defi_high_demander' then address_num else 0 end) as crowd_defi_high_demander,
-- 		max(case static_code when 'crowd_web3_active_users' then address_num else 0 end) as crowd_web3_active_users
-- 	from
-- 		static_crowd_data
-- 	group by
-- 		static_code) out_t
-- group by
-- 	static_code) as static_crowd_data
-- where  code = 'static_total';



