-- DROP TABLE if EXISTS  static_data_json_gin;
-- CREATE TABLE public.static_data_json_gin (
--                                              static_code varchar(512) NULL,
--                                              static_text jsonb NULL
-- );

-- insert into static_data_json_gin(static_code,static_text)
-- select 'static_code' as static_code,
--        JSON_BUILD_OBJECT(
--                'total_address_num', address_num,
--                'refresh_time', CURRENT_TIMESTAMP,
--                'address_type',JSON_BUILD_OBJECT(
--                        'personal_address_num',individual_address_num,
--                        'contract_address_num', contract_address_num
--                    ),
--                'label_statistics',JSON_BUILD_OBJECT(
--                        'defi_address_num',defi_address_num,
--                        'nft_address_num', nft_address_num,
--                        'web30_address_num', web3_address_num
--                    ),
--                 'crowd_portrait_distribution',crowd_json_text::jsonb,
--                'median_statistics',JSON_BUILD_OBJECT(
--                        'balance_median',avg_balance,
--                        'volume_median', avg_volume,
--                        'activity_median', avg_activity,
--                        'live_day_median', avg_birthday
--                    ),
--                'level_address_statistics',json_text::jsonb
--
--            )
--                      AS static_text
-- FROM static_total_data where code='static_total' ;
insert into home_data_analysis(analysis_date,analysis_result)
select floor(EXTRACT(epoch FROM NOW())*1000-836001000) as analysis_date,
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
               'level_address_statistics',json_text::jsonb

           )
                                                       AS analysis_result
FROM static_total_data where code='static_total' ;
