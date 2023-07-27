DROP TABLE if EXISTS  static_total_data${tableSuffix};
create table static_total_data${tableSuffix}
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
    address_image_text text NULL,
    json_text text NULL,
    asset_range text NULL,
    platform_range text NULL,
    action_range text NULL
);
truncate table static_total_data${tableSuffix};

-----计算合约和个人地址数
insert into static_total_data${tableSuffix}(code,address_num,individual_address_num,contract_address_num)
select
    'static_total' as code,
    count(distinct alg.address) as address_num,
    sum(case when aljg.contract_address is null then 1 else 0 end ) as individual_address_num,
    sum(case when aljg.contract_address is not null then 1 else 0 end) as contract_address_num
from  address_init${tableSuffix} alg
left join contract aljg on (alg.address = aljg.contract_address);

-- select 'static_total' as code,
--        count(1) as address_num,
--        sum(case when aljg.address_type is null or aljg.address_type='p' then 1 else 0 end ) as  individual_address_num,
--        sum(case when aljg.address_type='c' then 1 else 0 end) as contract_address_num
-- from address_info aljg
--          inner join address_init${tableSuffix} ais  on(aljg.address=ais.address);

update  static_total_data${tableSuffix}
set
    address_image_text =  (select
                               string_agg(a.address,',')
                           from
                               (
                                   select
                                       distinct t.address
                                   from
                                       (
                                           select
                                               alg.address
                                           from
                                               address_init${tableSuffix} alg
                                       limit 10000) t
                                       limit 4) a
    )
where
    code = 'static_total';

DROP TABLE if EXISTS  total_balance_usd_init${tableSuffix};
create table total_balance_usd_init${tableSuffix}
(
    address  varchar(200) not null,
    balance_usd numeric(250, 20) NULL
);
truncate table total_balance_usd_init${tableSuffix};
insert into total_balance_usd_init${tableSuffix}(address,balance_usd) select aljg.address,balance_usd
from total_balance_volume_usd aljg                  inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
 where balance_usd>=100;


-----更新余额中位数
update
    static_total_data${tableSuffix}
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
                               total_balance_usd_init${tableSuffix} ) out_t
                   where
                           rn >=(
                           select
                               case
                                   when count(1)%2 = 0 then count(1)/ 2
                                   else count(1)/ 2 + 1
                                   end
                           from
                               total_balance_usd_init${tableSuffix} )
                     and rn <=(
                       select
                                   count(1)/ 2 + 1
                       from
                           total_balance_usd_init${tableSuffix}
                   ))
where
        code = 'static_total';

-----更新交易额中位数
DROP TABLE if EXISTS  total_volume_usd_init${tableSuffix};
create table total_volume_usd_init${tableSuffix}
(
    address  varchar(200) not null,
    volume_usd numeric(250, 20) NULL
);
truncate table total_volume_usd_init${tableSuffix};
insert into total_volume_usd_init${tableSuffix}(address,volume_usd)
select aljg.address,volume_usd  from total_volume_usd aljg
    inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
where volume_usd>=100  and recent_time_code='ALL';

update
    static_total_data${tableSuffix}
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
                              total_volume_usd_init${tableSuffix} where volume_usd>=100

                      ) out_t
                  where
                          rn >=(
                          select
                              case
                                  when count(1)%2 = 0 then count(1)/ 2
                                  else count(1)/ 2 + 1
                                  end
                          from
                              total_volume_usd_init${tableSuffix} where volume_usd>=100
                      )
                    and rn <=(
                      select
                                  count(1)/ 2 + 1
                      from
                          total_volume_usd_init${tableSuffix} where volume_usd>=100
                  ))
where
        code = 'static_total';


-----计算活跃度中位数
DROP TABLE if EXISTS  address_activity_init${tableSuffix};
create table address_activity_init${tableSuffix}
(
    address  varchar(200) not null,
    activity_num numeric(250, 20) NULL
);
truncate table address_activity_init${tableSuffix};
insert into address_activity_init${tableSuffix}(activity_num,address)
select sum(activity_num) as activity_num,address from(
  select
     sum(total_transfer_count) as activity_num,aljg.address from  eth_holding_vol_count aljg
          inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
  where recent_time_code='ALL'
  group by aljg.address
  union all
 select
     sum(total_transfer_count) as activity_num,aljg.address from  token_holding_vol_count aljg
           inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
        where token in(select token_id from dim_rank_token)  and recent_time_code='ALL'
    group by aljg.address
 union all
 select
     sum(total_transfer_count) as activity_num,aljg.address from  web3_transaction_record_summary aljg
        inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
      where recent_time_code='ALL'
 group by aljg.address
 union all
 select
     sum(total_transfer_all_count) as activity_num,aljg.address from  nft_holding aljg
    inner join address_init${tableSuffix} ais  on(aljg.address=ais.address)
  where  token in(select token_id from dim_project_token_type_rank_temp) and recent_time_code='ALL'
  group by aljg.address)
 out_t group by address;

-----更新活跃度中位数
update
    static_total_data${tableSuffix}
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
                                address_activity_init${tableSuffix}

                        ) out_t
                    where
                            rn >=(
                            select
                                case
                                    when count(1)%2 = 0 then count(1)/ 2
                                    else count(1)/ 2 + 1
                                    end
                            from
                                address_activity_init${tableSuffix}
                        )
                      and rn <=(
                        select
                                    count(1)/ 2 + 1
                        from
                            address_activity_init${tableSuffix}
                    ))
where
        code = 'static_total';

-----更新诞生天数平均值
update
    static_total_data${tableSuffix}
set
    avg_birthday = (select
                        round(avg(trunc((extract(epoch from cast( now() as TIMESTAMP)) - bt."timestamp")/(24 * 60 * 60)))) as avg_birthday
                    from
                        address_init${tableSuffix} ais
                            left join (select
                                           address,
                                           min(first_up_chain_block_height) as first_up_chain_block_height
                                       from
                                           (
                                               select
                                                   address,
                                                   first_up_chain_block_height
                                               from
                                                   address_info aiin
                                               union all
                                               select
                                                   contract_address as address,
                                                   block_height as first_up_chain_block_height
                                               from
                                                   contract c) aiout
                                       group by
                                           address) ai on
                            (ai.address = ais.address)
                            left join block_timestamp bt on
                            (bt.height = ai.first_up_chain_block_height)
                    where
                        ai.address is not null
    )
where
        code = 'static_total';

-----更新三大类地址数统计值
update
    static_total_data${tableSuffix}
set
    defi_address_num = static_wired_type_address${tableSuffix}.defi_address_num,
    nft_address_num = static_wired_type_address${tableSuffix}.nft_address_num,
    web3_address_num = static_wired_type_address${tableSuffix}.web3_address_num
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
			static_wired_type_address${tableSuffix}
		group by
			wired_type) out_t
	group by
		wired_type
        ) static_wired_type_address${tableSuffix}
where
    code = 'static_total';
-----更新人群标签地址数统计值
update static_total_data${tableSuffix} set crowd_json_text= (select
                                                                 json_agg(JSON_BUILD_OBJECT('content', static_code, 'number', address_num))
                                                             from
                                                                 static_crowd_data${tableSuffix})
where  code = 'static_total';


-----更新asset_range
update static_total_data${tableSuffix} set asset_range= (
    select
        ('{' || string_agg(json_text::text, ',')|| '}')::jsonb
    from
        (
            select
                    '"' || token_type || '":' || ('{' || string_agg(json_text::text, ',')|| '}')::jsonb as json_text
            from
                (
                    select
                        case
                            when sttt.token_type = 'defi' then 'token'
                            else token_type
                            end token_type,
                        '"' || bus_type || '":' || json_agg( JSON_BUILD_OBJECT('name',token_name,'address',token) order by rownumber) as json_text
                    from
                        static_top_ten_token${tableSuffix} sttt
                    where
                            token_name <> 'ALL'
                    group by
                        bus_type,
                        token_type) t
            group by
                token_type ) tout)
where  code = 'static_total';

-----更新platform_range
update static_total_data${tableSuffix} set platform_range= (
    select
        ('{' || string_agg(json_text::text, ',')|| '}')::jsonb
    from
        (
            select
                    '"' || token_type || '":' || ('{' || string_agg(json_text::text, ',')|| '}')::jsonb as json_text
            from
                (
                    select
                        case
                            when sttt.token_type = 'defi' then 'token'
                            else token_type
                            end token_type,
                        '"' || bus_type || '":' || json_agg( token_name order by rownumber) as json_text
                    from
                        static_top_ten_platform${tableSuffix} sttt
                    where
                            token_name <> 'ALL'
                    group by
                        bus_type,
                        token_type) t
            group by
                token_type ) tout)
where  code = 'static_total';

-----更新action_range
update
    static_total_data${tableSuffix} set action_range= (
    select
        ('{' || string_agg(json_text::text, ',')|| '}')::jsonb
    from
        (
            select
                    '"' || token_type || '":' || ('{' || string_agg(json_text::text, ',')|| '}')::jsonb as json_text
            from
                (
                    select
                        case
                            when sttt.token_type = 'defi' then 'token'
                            else token_type
                            end token_type,
                        '"' || bus_type || '":' || json_agg( token_name order by rownumber) as json_text
                    from
                        static_top_ten_action${tableSuffix} sttt
                    where
                            token_name <> 'ALL'
                    group by
                        bus_type,
                        token_type) t
            group by
                token_type ) tout)
where  code = 'static_total';

-----更新资产级别地址数统计值
update static_total_data${tableSuffix} set json_text= (
    select
        '{'||string_agg(json_text,',')||'}'
    from
        static_category_json${tableSuffix})
where  code = 'static_total';
INSERT INTO tag_result${tableSuffix}(table_name,batch_date) select ('static_total_data${tableSuffix}') as table_name,'${batchDate}'  as batch_date;





