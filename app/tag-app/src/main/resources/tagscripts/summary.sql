
truncate table address_label_gp;
insert into public.address_label_gp(address,label_type,label_name,data,updated_at,owner,source)
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source from address_label_eth_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_project_type_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_project_type_volume_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_project_type_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_project_type_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_project_type_volume_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_project_type_volume_count_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_project_type_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_project_type_volume_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_balance_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_time_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_volume_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_balance_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_balance_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_time_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_time_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_volume_count_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_volume_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_transfer_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_transfer_volume_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_transfer_volume_count_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_transfer_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_nft_transfer_volume_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_time_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_volume_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_eth_balance_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_eth_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_time_special  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_top  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_usdt_balance_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_usdt_volume_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_web3_type_balance_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_web3_type_count_grade  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_web3_type_balance_rank  union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_web3_type_balance_top union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_provider union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_staked union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_time_first_lp union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_time_first_stake union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_eth_time_grade union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_eth_time_special union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_grade_all union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_volume_grade_all union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_rank_all union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_balance_top_all union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_token_volume_rank_all union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_balance_grade union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_count_grade union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_volume_grade union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_balance_rank union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_balance_top union all
select address,label_type,label_name,data,updated_at,'-1' as owner,'SYSTEM' as source  from address_label_univ3_volume_rank union all
select address,label_type,label_name,data,updated_at, owner, source  from address_label_third_party union all
select address,label_type,label_name,data,updated_at,owner, source  from address_label_ugc;

-- 统计user profile 数据
INSERT INTO address_label_gp_profile(
	owner,address,data,asset,asset_type,label_type,label_name,label_level,label_group,source,updated_at
)
select
	alg.owner, alg.address, alg.data, comb.asset, comb.asset_type, alg.label_type, alg.label_name,
	case when comb.balance <> '' then comb.balance
	     when comb.volume <> '' then comb.volume
		 when comb.activity <> '' then comb.activity
	end as label_level,
	case when position('BALANCE' in alg.label_name) > 0 then 'Balance'
	     when position('VOLUME' in alg.label_name) > 0 then 'Volume'
		 when position('ACTIVITY' in alg.label_name) > 0 then 'Activity'
	end as label_group,
	alg."source", alg.updated_at
FROM address_label_gp alg
inner join combination comb on comb.label_name = alg.label_name
	and (comb.balance in ('L1','L2','L3','L4','L5','L6','Millionaire','Billionaire')
		or comb.volume in ('L1','L2','L3','L4','L5','L6','Million','Billion')
		or comb.activity in ('L1','L2','L3','L4','L5','L6','Low','Medium','High')
	);

-- 用户标签
truncate
    table public.address_labels_json_gin;
insert into
    address_labels_json_gin(address,
                            labels,
                            updated_at)
    select
    address,
    json_object_agg(label_type, label_name order by label_type desc)::jsonb as labels,
                CURRENT_TIMESTAMP as updated_at
    from
    address_label_gp
    group by
    address;

-- user profile
--insert into user_profile_summary(
--    address, analysis_json
--)
--SELECT
--    algp.address,
--    algp.balance,
--    json_build_object(
--        'assets', json_agg(
--                      json_build_object(
--                          'name', drt.token_name,
--                          'type', drt.asset_type,
--                          'balance', json_build_object(
--                                        'data', drt.token_name,
--                                        'level', drt.asset_type,
--                                      ),
--                          'volume', json_build_object(
--                                        'data', drt.token_name,
--                                        'level', drt.asset_type,
--                                      ),
--                          'activity', json_build_object(
--                                        'data', drt.token_name,
--                                        'level', drt.asset_type,
--                                      )
--                      )
--                  )
--    )
--from address_label_gp_profile algp
--group by algp.address, algp.balance
