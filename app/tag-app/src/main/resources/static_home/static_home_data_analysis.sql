insert into home_data_analysis(analysis_date,analysis_result,config_environment)
select floor(EXTRACT(epoch FROM NOW())*1000) as analysis_date,
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
               'address_image_text',address_image_text::jsonb,
               'asset',asset_range::jsonb,
               'platform',platform_range::jsonb,
               'action',action_range::jsonb

           )
  AS analysis_result, '${configEnvironment}' as config_environment
FROM static_total_data${tableSuffix} where code='static_total' ;
insert into tag_result(table_name,batch_date)  SELECT 'static_home_data_analysis${tableSuffix}' as table_name,'${batchDate}'  as batch_date;

