
ALTER TABLE top_token_1000_temp                         RENAME TO top_token_1000;
ALTER TABLE token_holding_temp                          RENAME TO token_holding;
ALTER TABLE eth_holding_temp                            RENAME TO eth_holding;
ALTER TABLE nft_holding_time_temp                       RENAME TO nft_holding_time;
ALTER TABLE eth_holding_time_temp                       RENAME TO eth_holding_time;
ALTER TABLE token_holding_time_temp                     RENAME TO token_holding_time;
ALTER TABLE white_list_lp_temp                          RENAME TO white_list_lp;
ALTER TABLE white_list_price_temp                       RENAME TO white_list_price;

ALTER TABLE dex_action_platform_temp                    RENAME TO dex_action_platform;
ALTER TABLE level_def_temp                              RENAME TO level_def;
ALTER TABLE mp_nft_platform_temp                        RENAME TO mp_nft_platform;
ALTER TABLE nft_action_platform_temp                    RENAME TO nft_action_platform;
ALTER TABLE nft_trade_type_temp                         RENAME TO nft_trade_type;
ALTER TABLE platform_temp                               RENAME TO platform;
ALTER TABLE platform_detail_temp                        RENAME TO platform_detail;
ALTER TABLE recent_time_temp                            RENAME TO recent_time;
ALTER TABLE token_platform_temp                         RENAME TO token_platform;
ALTER TABLE nft_platform_temp                           RENAME TO nft_platform;
ALTER TABLE web3_platform_temp                          RENAME TO web3_platform;
ALTER TABLE web3_action_platform_temp                   RENAME TO web3_action_platform;
ALTER TABLE web3_action_temp                            RENAME TO web3_action;

ALTER TABLE combination_temp                            RENAME TO combination;
ALTER TABLE label_temp                                  RENAME TO label;
ALTER TABLE label_factor_seting_temp                    RENAME TO label_factor_seting;
ALTER TABLE dim_project_token_type_temp                 RENAME TO dim_project_token_type;
ALTER TABLE dim_project_type_temp                       RENAME TO dim_project_type;
ALTER TABLE dim_project_token_type_rank_temp            RENAME TO dim_project_token_type_rank;
ALTER TABLE dim_rule_content_temp                       RENAME TO dim_rule_content;
ALTER TABLE dim_rule_sql_content_temp                   RENAME TO dim_rule_sql_content;
ALTER TABLE white_list_erc20_temp                       RENAME TO white_list_erc20;
ALTER TABLE white_list_erc20_tag_temp                   RENAME TO white_list_erc20_tag;

ALTER TABLE address_label_gp_temp_${tableSuffix}                    RENAME TO address_label_gp_${tableSuffix};
ALTER TABLE address_labels_json_gin_temp_${tableSuffix}              RENAME TO address_labels_json_gin_${tableSuffix} ;
ALTER TABLE nft_buy_sell_holding_temp                   RENAME TO nft_buy_sell_holding;
ALTER TABLE nft_holding_temp                            RENAME TO nft_holding;
ALTER TABLE nft_transfer_holding_temp                   RENAME TO nft_transfer_holding;
ALTER TABLE platform_nft_holding_temp                   RENAME TO platform_nft_holding;
ALTER TABLE token_balance_volume_usd_temp               RENAME TO token_balance_volume_usd;
ALTER TABLE token_volume_usd_temp                       RENAME TO token_volume_usd;
ALTER TABLE total_balance_volume_usd_temp               RENAME TO total_balance_volume_usd;
ALTER TABLE dex_tx_count_summary_temp                   RENAME TO dex_tx_count_summary;
ALTER TABLE dex_tx_volume_count_summary_temp            RENAME TO dex_tx_volume_count_summary;
ALTER TABLE dex_tx_volume_count_summary_stake_temp      RENAME TO dex_tx_volume_count_summary_stake;
ALTER TABLE dex_tx_volume_count_summary_univ3_temp      RENAME TO dex_tx_volume_count_summary_univ3;
ALTER TABLE eth_holding_vol_count_temp                  RENAME TO eth_holding_vol_count;
ALTER TABLE token_holding_vol_count_temp                RENAME TO token_holding_vol_count;
ALTER TABLE platform_nft_type_volume_count_temp         RENAME TO platform_nft_type_volume_count;
ALTER TABLE nft_volume_count_temp                       RENAME TO nft_volume_count;


insert into tag_result(table_name,batch_date)  SELECT 'rename_table_${tableSuffix}' as table_name,'${batchDate}'  as batch_date;
delete from  tag_result where  table_name='tagging';
delete from tag_result where batch_date<'${batchDate}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;