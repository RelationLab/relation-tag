update ugc_label_data_analysis set status='DONE',
                                   analysis_at = CURRENT_TIMESTAMP,
                                   address_image_text=(select address_image_text from static_total_data${tableSuffix}),
                                   analysis_address_num=(select address_num from static_total_data${tableSuffix} ),analysis_result = (select
                                                             JSON_BUILD_OBJECT(
                                                                     'total_address_num', address_num,
                                                                     'refresh_time', CURRENT_TIMESTAMP,
                                                                     'address_type',JSON_BUILD_OBJECT(
                                                                             'personal_address_num',individual_address_num,
                                                                             'contract_address_num', contract_address_num
                                                                         ),
                                                                     'label_statistics',JSON_BUILD_OBJECT(
                                                                             'defi_address_num',defi_address_num,
                                                                             'nft_address_num', nft_address_num,
                                                                             'web30_address_num', web3_address_num
                                                                         ),
                                                                     'crowd_portrait_distribution',crowd_json_text::jsonb,
                                                                     'median_statistics',JSON_BUILD_OBJECT(
                                                                             'balance_median',avg_balance,
                                                                             'volume_median', avg_volume,
                                                                             'activity_median', avg_activity,
                                                                             'live_day_median', avg_birthday
                                                                         ),
                                                                     'level_address_statistics',json_text::jsonb,
                                                                        'asset',asset_range::jsonb,
                                                                     'platform',platform_range::jsonb,
                                                                     'action',action_range::jsonb
                                                                 )
                                                                                                             AS analysis_result
                                                      FROM static_total_data${tableSuffix} where code='static_total' )
where id=${id} and  config_environment = '${configEnvironment}';
INSERT INTO tag_result${tableSuffix}(table_name,batch_date) select ('static_ugc_label_data_analysis${tableSuffix}') as table_name,'${batchDate}'  as batch_date;