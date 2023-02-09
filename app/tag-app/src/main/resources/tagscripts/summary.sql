
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