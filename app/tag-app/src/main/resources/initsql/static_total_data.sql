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
    crowd_json_text text NULL,
    json_text text NULL
);
truncate table static_total_data;

-----计算合约和个人地址数
insert into static_total_data  (code,individual_address_num,contract_address_num)
select 'static_total' as code,
       sum(case when aljg.address_type='p' then 1 else 0 end ) as  individual_address_num,
       sum(case when aljg.address_type='c' then 1 else 0 end) as contract_address_num
from address_labels_json_gin aljg ;

-----更新总地址数
update
    static_total_data
set
    address_num = (
        select
            count(distinct address)
        from
            address_labels_json_gin out_t)
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
                               total_balance_volume_usd where balance_usd>=100
                       ) out_t
                   where
                           rn >=(
                           select
                               case
                                   when count(1)%2 = 0 then count(1)/ 2
                                   else count(1)/ 2 + 1
                                   end
                           from
                               total_balance_volume_usd where balance_usd>=100
                       )
                     and rn <=(
                       select
                                   count(1)/ 2 + 1
                       from
                           total_balance_volume_usd where balance_usd>=100
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
                              total_volume_usd where volume_usd>=100

                      ) out_t
                  where
                          rn >=(
                          select
                              case
                                  when count(1)%2 = 0 then count(1)/ 2
                                  else count(1)/ 2 + 1
                                  end
                          from
                              total_volume_usd where volume_usd>=100
                      )
                    and rn <=(
                      select
                                  count(1)/ 2 + 1
                      from
                          total_volume_usd where volume_usd>=100
                  ))
where
        code = 'static_total';


-----计算活跃度中位数
DROP TABLE if EXISTS  address_activity_init;
create table address_activity_init
(
    address  varchar(200) not null,
    activity_num numeric(250, 20) NULL
);
truncate table address_activity_init;
insert into address_activity_init(activity_num,address)
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
                                address_activity_init

                        ) out_t
                    where
                            rn >=(
                            select
                                case
                                    when count(1)%2 = 0 then count(1)/ 2
                                    else count(1)/ 2 + 1
                                    end
                            from
                                address_activity_init
                        )
                      and rn <=(
                        select
                                    count(1)/ 2 + 1
                        from
                            address_activity_init
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
        '{'||string_agg(json_text,',')||'}'
    from
        static_category_json)
where  code = 'static_total';

-----更新人群标签地址数统计值
update static_total_data set crowd_json_text= (select
                                                   jsonb_agg(JSON_BUILD_OBJECT('content', static_code, 'number', address_num))
                                               from
                                                   static_crowd_data)
where  code = 'static_total';



