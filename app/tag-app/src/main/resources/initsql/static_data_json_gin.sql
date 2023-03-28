DROP TABLE if EXISTS  static_data_json_gin;
CREATE TABLE public.static_data_json_gin (
                                             static_code varchar(512) NULL,
                                             static_text jsonb NULL
);

insert into static_data_json_gin(static_code,static_text)
select 'static_code' as static_code,
       JSON_AGG(
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
                        ),'crowd_portrait_distribution',JSON_BUILD_OBJECT(
                               'active_users_address_num',crowd_active_users,
                               'elite_address_num', crowd_elite,
                               'nft_active_users_address_num', crowd_nft_active_users,
                               'long_term_holder_address_num', crowd_long_term_holder,
                               'nft_whale_address_num', crowd_nft_whale,
                               'nft_high_demander_address_num', crowd_nft_high_demander,
                               'token_whale_address_num', crowd_token_whale,
                               'defi_active_users_address_num', crowd_defi_active_users,
                               'defi_high_demander_address_num', crowd_defi_high_demander,
                               'web3_active_users_address_num', crowd_web3_active_users
                       ),

                       'median_statistics',JSON_BUILD_OBJECT(
                               'balance_median',avg_balance,
                               'volume_median', avg_volume,
                               'activity_median', avg_activity,
                               'live_day_median', avg_birthday
                           ),
                       'level_address_statistics',json_text::jsonb

                   )
           )::JSONB                                                                                       AS static_text
FROM static_total_data where code='static_total' group by code;
