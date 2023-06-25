--------count project+token
-- Blur_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Sale_MP_NFT_ACTIVITY
-- Blur_CryptoPunks_Buy_MP_NFT_ACTIVITY
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    nft_platform.platform_name  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from nft_sync_address
         inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
         inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

-----------------PROJECT(ALL)+token(ALL)
INSERT INTO dim_project_token_type (project,"token","type",label_type,label_name,"content",operate_type,seq_flag,data_subject,etl_update_time,project_name,token_name) VALUES
('ALL','ALL','ALL','ALL_ALL_ALL_MP_NFT_ACTIVITY','','','T','ALL_ALL_ALL','count','2023-06-25 15:34:35.147','ALL','ALL'),
('','ALL','ALL','ALL_ALL_ALL_NFT_ACTIVITY','','','T','ALL_ALL_ALL','count','2023-06-25 15:33:47.706','ALL','ALL'),
('','ALL','Burn','ALL_ALL_Burn_NFT_ACTIVITY','','','T','ALL_ALL_Burn','count','2023-06-25 15:33:47.706','ALL','ALL'),
('ALL','ALL','Buy','ALL_ALL_Buy_MP_NFT_ACTIVITY','','','T','ALL_ALL_Buy','count','2023-06-25 15:34:35.147','ALL','ALL'),
('','ALL','Buy','ALL_ALL_Buy_NFT_ACTIVITY','','','T','ALL_ALL_Buy','count','2023-06-25 15:33:47.706','ALL','ALL'),
('','ALL','Mint','ALL_ALL_Mint_NFT_ACTIVITY','','','T','ALL_ALL_Mint','count','2023-06-25 15:33:47.706','ALL','ALL'),
('ALL','ALL','Sale','ALL_ALL_Sale_MP_NFT_ACTIVITY','','','T','ALL_ALL_Sale','count','2023-06-25 15:34:35.147','ALL','ALL'),
('','ALL','Sale','ALL_ALL_Sale_NFT_ACTIVITY','','','T','ALL_ALL_Sale','count','2023-06-25 15:33:47.706','ALL','ALL'),
('','ALL','Transfer','ALL_ALL_Transfer_NFT_ACTIVITY','','','T','ALL_ALL_Transfer','count','2023-06-25 15:33:47.706','ALL','ALL');

INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv1 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv2 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv3 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv4 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv5 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv6 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','MP NFT Medium Activity Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','MP NFT High Activity Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_MP_NFT_ACTIVITY','ALL_ALL_ALL_MP_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','MP NFT Highest Activity Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
('RelationTeam','ALL_ALL_ALL_NFT_ACTIVITY','ALL_ALL_ALL_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity','',NULL,'SQL','ALL_ALL_ALL_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_ACTIVITY','ALL_ALL_Burn_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv1 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv2 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv3 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv4 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv5 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv6 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','MP NFT Medium Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','MP NFT High Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_ACTIVITY','ALL_ALL_Buy_MP_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','MP NFT Highest Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_ACTIVITY','ALL_ALL_Buy_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_ACTIVITY','ALL_ALL_Mint_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv1 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv2 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv3 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv4 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv5 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','MP NFT Activity Lv6 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','MP NFT Medium Activity Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','MP NFT High Activity Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_ACTIVITY','ALL_ALL_Sale_MP_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','MP NFT Highest Activity Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_ACTIVITY','ALL_ALL_Sale_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L1','SYSTEM','PUBLIC','GRADE','NFT Activity Lv1 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L2','SYSTEM','PUBLIC','GRADE','NFT Activity Lv2 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L3','SYSTEM','PUBLIC','GRADE','NFT Activity Lv3 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L4','SYSTEM','PUBLIC','GRADE','NFT Activity Lv4 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L5','SYSTEM','PUBLIC','GRADE','NFT Activity Lv5 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_L6','SYSTEM','PUBLIC','GRADE','NFT Activity Lv6 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_Low','SYSTEM','PUBLIC','GRADE','NFT Medium Activity Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_Medium','SYSTEM','PUBLIC','GRADE','NFT High Activity Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_ACTIVITY','ALL_ALL_Transfer_NFT_ACTIVITY_High','SYSTEM','PUBLIC','GRADE','NFT Highest Activity Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_ACTIVITY','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');



INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
('ALL_NFT','ALL','','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L4','MP NFT Activity Lv4 Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L5','MP NFT Activity Lv5 Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L6','MP NFT Activity Lv6 Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_Low','MP NFT Medium Activity Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_Medium','MP NFT High Activity Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_High','MP NFT Highest Activity Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L1','MP NFT Activity Lv1 Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L2','MP NFT Activity Lv2 Trader','nft','GRADE'),
('ALL_NFT','ALL','','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_ACTIVITY_L3','MP NFT Activity Lv3 Trader','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L1','NFT Activity Lv1','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L2','NFT Activity Lv2','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L3','NFT Activity Lv3','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L4','NFT Activity Lv4','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L5','NFT Activity Lv5','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_L6','NFT Activity Lv6','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_Low','NFT Medium Activity','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_Medium','NFT High Activity','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_ACTIVITY_High','NFT Highest Activity','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Burn','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_Medium','NFT High Activity Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_High','NFT Highest Activity Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L1','NFT Activity Lv1 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L2','NFT Activity Lv2 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L3','NFT Activity Lv3 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L4','NFT Activity Lv4 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L5','NFT Activity Lv5 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_L6','NFT Activity Lv6 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_ACTIVITY_Low','NFT Medium Activity Burner','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L1','MP NFT Activity Lv1 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L2','MP NFT Activity Lv2 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L3','MP NFT Activity Lv3 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L4','MP NFT Activity Lv4 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L5','MP NFT Activity Lv5 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_L6','MP NFT Activity Lv6 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_Low','MP NFT Medium Activity Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_Medium','MP NFT High Activity Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_ACTIVITY_High','MP NFT Highest Activity Buyer','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L1','NFT Activity Lv1 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L2','NFT Activity Lv2 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L3','NFT Activity Lv3 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L4','NFT Activity Lv4 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L5','NFT Activity Lv5 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_L6','NFT Activity Lv6 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_Low','NFT Medium Activity Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_Medium','NFT High Activity Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_ACTIVITY_High','NFT Highest Activity Buyer','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L1','NFT Activity Lv1 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L2','NFT Activity Lv2 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L3','NFT Activity Lv3 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L4','NFT Activity Lv4 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L5','NFT Activity Lv5 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_L6','NFT Activity Lv6 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_Low','NFT Medium Activity Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_Medium','NFT High Activity Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_ACTIVITY_High','NFT Highest Activity Minter','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L1','MP NFT Activity Lv1 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L2','MP NFT Activity Lv2 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L4','MP NFT Activity Lv4 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L5','MP NFT Activity Lv5 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L6','MP NFT Activity Lv6 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_Low','MP NFT Medium Activity Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_Medium','MP NFT High Activity Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_High','MP NFT Highest Activity Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_ACTIVITY_L3','MP NFT Activity Lv3 Seller','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L1','NFT Activity Lv1 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L2','NFT Activity Lv2 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L3','NFT Activity Lv3 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L4','NFT Activity Lv4 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L5','NFT Activity Lv5 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_L6','NFT Activity Lv6 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_Low','NFT Medium Activity Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_Medium','NFT High Activity Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_ACTIVITY_High','NFT Highest Activity Seller','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L1','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L1','NFT Activity Lv1 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L2','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L2','NFT Activity Lv2 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L3','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L3','NFT Activity Lv3 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L4','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L4','NFT Activity Lv4 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L5','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L5','NFT Activity Lv5 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','L6','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_L6','NFT Activity Lv6 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','Low','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_Low','NFT Medium Activity Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','Medium','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_Medium','NFT High Activity Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','','High','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_ACTIVITY_High','NFT Highest Activity Transferer','nft','GRADE');


--------count project(ALL)+token
-- ALL_CryptoPunks_ALL_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Buy_MP_NFT_ACTIVITY
-- ALL_CryptoPunks_Sale_MP_NFT_ACTIVITY
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    'ALL'  project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'|| level_def.level label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'count') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------count project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_ACTIVITY
-- Blur_ALL_Buy_MP_NFT_ACTIVITY
-- Blur_ALL_Sale_MP_NFT_ACTIVITY
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'count' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'count') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_ACTIVITY_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'count') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

------volume_elite
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'ELITE' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_elite
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_ELITE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'|| level_def.level  label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'ELITE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_elite') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_elite project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Buy_MP_NFT_VOLUME_ELITE
-- Blur_ALL_Sale_MP_NFT_VOLUME_ELITE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_elite' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_elite') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_ELITE_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_elite') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

INSERT INTO dim_project_token_type (project,"token","type",label_type,label_name,"content",operate_type,seq_flag,data_subject,etl_update_time,project_name,token_name) VALUES
('ALL','ALL','ALL','ALL_ALL_ALL_MP_NFT_VOLUME_ELITE','','','T','ALL_ALL_ALL','volume_elite','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','ALL','ALL_ALL_ALL_NFT_VOLUME_ELITE','','','T','ALL_ALL_ALL','volume_elite','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Burn','ALL_ALL_Burn_NFT_VOLUME_ELITE','','','T','ALL_ALL_Burn','volume_elite','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Buy','ALL_ALL_Buy_MP_NFT_VOLUME_ELITE','','','T','ALL_ALL_Buy','volume_elite','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Buy','ALL_ALL_Buy_NFT_VOLUME_ELITE','','','T','ALL_ALL_Buy','volume_elite','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Mint','ALL_ALL_Mint_NFT_VOLUME_ELITE','','','T','ALL_ALL_Mint','volume_elite','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Sale','ALL_ALL_Sale_MP_NFT_VOLUME_ELITE','','','T','ALL_ALL_Sale','volume_elite','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Sale','ALL_ALL_Sale_NFT_VOLUME_ELITE','','','T','ALL_ALL_Sale','volume_elite','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Transfer','ALL_ALL_Transfer_NFT_VOLUME_ELITE','','','T','ALL_ALL_Transfer','volume_elite','2023-06-25 15:33:38.949','ALL','ALL');

INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Elite NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Elite Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Elite Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Elite Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');

INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Mint','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Minter','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Burner','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Transferer','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Buyer','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Seller','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','MP NFT Elite Buyer','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','MP NFT Elite Seller','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','','','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','Elite NFT Trader','nft','ELITE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','ELITE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_ELITE_ELITE_NFT_TRADER','MP NFT Elite Trader','nft','ELITE');



--------volume_grade
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_grade
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_GRADE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'|| level_def.level  label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'nft' asset_type,
    'GRADE' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_grade') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_grade project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Buy_MP_NFT_VOLUME_GRADE
-- Blur_ALL_Sale_MP_NFT_VOLUME_GRADE
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_grade' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_grade') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_GRADE_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_grade') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;
INSERT INTO dim_project_token_type (project,"token","type",label_type,label_name,"content",operate_type,seq_flag,data_subject,etl_update_time,project_name,token_name) VALUES
('ALL','ALL','ALL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','','','T','ALL_ALL_ALL','volume_grade','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','ALL','ALL_ALL_ALL_NFT_VOLUME_GRADE','','','T','ALL_ALL_ALL','volume_grade','2023-06-25 15:33:34.278','ALL','ALL'),
('','ALL','Burn','ALL_ALL_Burn_NFT_VOLUME_GRADE','','','T','ALL_ALL_Burn','volume_grade','2023-06-25 15:33:34.278','ALL','ALL'),
('ALL','ALL','Buy','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','','','T','ALL_ALL_Buy','volume_grade','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Buy','ALL_ALL_Buy_NFT_VOLUME_GRADE','','','T','ALL_ALL_Buy','volume_grade','2023-06-25 15:33:34.278','ALL','ALL'),
('','ALL','Mint','ALL_ALL_Mint_NFT_VOLUME_GRADE','','','T','ALL_ALL_Mint','volume_grade','2023-06-25 15:33:34.278','ALL','ALL'),
('ALL','ALL','Sale','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','','','T','ALL_ALL_Sale','volume_grade','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Sale','ALL_ALL_Sale_NFT_VOLUME_GRADE','','','T','ALL_ALL_Sale','volume_grade','2023-06-25 15:33:34.278','ALL','ALL'),
('','ALL','Transfer','ALL_ALL_Transfer_NFT_VOLUME_GRADE','','','T','ALL_ALL_Transfer','volume_grade','2023-06-25 15:33:34.278','ALL','ALL');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME_GRADE','ALL_ALL_ALL_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME_GRADE','ALL_ALL_Mint_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6 Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME_GRADE','ALL_ALL_Burn_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6 Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME_GRADE','ALL_ALL_Transfer_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6 Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME_GRADE','ALL_ALL_Buy_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6 Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','NFT VOL Lv1 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','NFT VOL Lv2 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','NFT VOL Lv3 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','NFT VOL Lv4 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','NFT VOL Lv5 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME_GRADE','ALL_ALL_Sale_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','NFT VOL Lv6 Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv1 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv2 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv3 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv4 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv5 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv6 Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv1 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv2 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv3 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv4 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv5 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv6 Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L1','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv1 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L2','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv2 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L3','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv3 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L4','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv4 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L5','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv5 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L6','SYSTEM','PUBLIC','GRADE','MP NFT VOL Lv6 Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME_GRADE','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Mint','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L1','NFT VOL Lv1 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L2','NFT VOL Lv2 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L3','NFT VOL Lv3 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L4','NFT VOL Lv4 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L5','NFT VOL Lv5 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_GRADE_L6','NFT VOL Lv6 Minter','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L1','NFT VOL Lv1 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L2','NFT VOL Lv2 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L3','NFT VOL Lv3 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L4','NFT VOL Lv4 Burner','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Burn','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L5','NFT VOL Lv5 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_GRADE_L6','NFT VOL Lv6 Burner','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L1','NFT VOL Lv1 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L2','NFT VOL Lv2 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L3','NFT VOL Lv3 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L4','NFT VOL Lv4 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L5','NFT VOL Lv5 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_GRADE_L6','NFT VOL Lv6 Transferer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L1','NFT VOL Lv1 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L2','NFT VOL Lv2 Buyer','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Buy','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L3','NFT VOL Lv3 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L4','NFT VOL Lv4 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L5','NFT VOL Lv5 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_GRADE_L6','NFT VOL Lv6 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L1','NFT VOL Lv1 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L2','NFT VOL Lv2 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L3','NFT VOL Lv3 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L4','NFT VOL Lv4 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L5','NFT VOL Lv5 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_GRADE_L6','NFT VOL Lv6 Seller','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L1','MP NFT VOL Lv1 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L2','MP NFT VOL Lv2 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L3','MP NFT VOL Lv3 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L4','MP NFT VOL Lv4 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L5','MP NFT VOL Lv5 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_GRADE_L6','MP NFT VOL Lv6 Buyer','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L1','MP NFT VOL Lv1 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L2','MP NFT VOL Lv2 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L3','MP NFT VOL Lv3 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L4','MP NFT VOL Lv4 Seller','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L5','MP NFT VOL Lv5 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_GRADE_L6','MP NFT VOL Lv6 Seller','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L1','NFT VOL Lv1','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L2','NFT VOL Lv2','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L3','NFT VOL Lv3','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L4','NFT VOL Lv4','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L5','NFT VOL Lv5','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','','','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_GRADE_L6','NFT VOL Lv6','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','L1','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L1','MP NFT VOL Lv1 Trader','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','L2','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L2','MP NFT VOL Lv2 Trader','nft','GRADE');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','','','L3','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L3','MP NFT VOL Lv3 Trader','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','L4','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L4','MP NFT VOL Lv4 Trader','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','L5','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L5','MP NFT VOL Lv5 Trader','nft','GRADE'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','L6','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_GRADE_L6','MP NFT VOL Lv6 Trader','nft','GRADE');

--------volume_rank
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level  label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)   "content",
    'nft' asset_type,
    'RANK' label_category
from  nft_sync_address
          inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
          inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_rank
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_RANK
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_RANK
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    'ALL'   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    level_def.level volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'|| level_def.level   label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'RANK' label_category
from  nft_sync_address
          inner join nft_trade_type  on(1=1)
          inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_rank') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_rank project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_RANK
-- Blur_ALL_Buy_MP_NFT_VOLUME_RANK
-- Blur_ALL_Sale_MP_NFT_VOLUME_RANK
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_rank' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_rank') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_RANK_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_rank') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;
INSERT INTO dim_project_token_type (project,"token","type",label_type,label_name,"content",operate_type,seq_flag,data_subject,etl_update_time,project_name,token_name) VALUES
('ALL','ALL','ALL','ALL_ALL_ALL_MP_NFT_VOLUME_RANK','','','T','ALL_ALL_ALL','volume_rank','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','ALL','ALL_ALL_ALL_NFT_VOLUME_RANK','','','T','ALL_ALL_ALL','volume_rank','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Burn','ALL_ALL_Burn_NFT_VOLUME_RANK','','','T','ALL_ALL_Burn','volume_rank','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Buy','ALL_ALL_Buy_MP_NFT_VOLUME_RANK','','','T','ALL_ALL_Buy','volume_rank','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Buy','ALL_ALL_Buy_NFT_VOLUME_RANK','','','T','ALL_ALL_Buy','volume_rank','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Mint','ALL_ALL_Mint_NFT_VOLUME_RANK','','','T','ALL_ALL_Mint','volume_rank','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Sale','ALL_ALL_Sale_MP_NFT_VOLUME_RANK','','','T','ALL_ALL_Sale','volume_rank','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Sale','ALL_ALL_Sale_NFT_VOLUME_RANK','','','T','ALL_ALL_Sale','volume_rank','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Transfer','ALL_ALL_Transfer_NFT_VOLUME_RANK','','','T','ALL_ALL_Transfer','volume_rank','2023-06-25 15:33:38.949','ALL','ALL');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Legendary NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Epic NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Rare NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','Uncommon NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Legendary Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Epic Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Rare Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Uncommon Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Legendary Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Epic Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Rare Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Uncommon Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Legendary Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Epic Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Rare Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','SYSTEM','PUBLIC','GRADE','MP NFT Uncommon Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Mint','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Minter','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Minter','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Minter','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Mint','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Minter','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Burner','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Burner','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Burner','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Burner','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Transferer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Transferer','nft','RANK');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Transfer','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Transferer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Transferer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Seller','nft','RANK');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','MP NFT Legendary Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','MP NFT Epic Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','MP NFT Rare Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','MP NFT Uncommon Buyer','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','MP NFT Legendary Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','MP NFT Epic Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','MP NFT Rare Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','MP NFT Uncommon Seller','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','Legendary NFT Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_RANK_EPIC_NFT_TRADER','Epic NFT Trader','nft','RANK');
INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_RANK_RARE_NFT_TRADER','Rare NFT Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','','','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','Uncommon NFT Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','LEGENDARY_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_LEGENDARY_NFT_TRADER','MP NFT Legendary Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','EPIC_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_EPIC_NFT_TRADER','MP NFT Epic Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','RARE_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_RARE_NFT_TRADER','MP NFT Rare Trader','nft','RANK'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','UNCOMMON_NFT_TRADER','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_RANK_UNCOMMON_NFT_TRADER','MP NFT Uncommon Trader','nft','RANK');

--------volume_top
-- Blur_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
-- Blur_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    nft_platform.platform_name project,
    nft_platform.address "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    mp_nft_platform.platform_name project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_platform on
        (nft_sync_address.address = nft_platform.address)
        inner join mp_nft_platform on
        (mp_nft_platform.platform = nft_platform.platform)
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    mp_nft_platform.platform_name project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    'TOP' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level label_name,
    mp_nft_platform.platform_name||' ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'TOP' label_category
from nft_sync_address
         inner join nft_platform on
    (nft_sync_address.address = nft_platform.address)
         inner join mp_nft_platform on
    (mp_nft_platform.platform = nft_platform.platform)
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';

--------volume_top
-- ALL_CryptoPunks_ALL_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Buy_MP_NFT_VOLUME_TOP
-- ALL_CryptoPunks_Sale_MP_NFT_VOLUME_TOP
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    'ALL' project,
    nft_sync_address.address "token",
    nft_trade_type.nft_trade_type "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    'ALL_' || nft_sync_address.platform ||'_'||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    'ALL' project_name,
    nft_sync_address.platform token_name
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from
    nft_sync_address
        inner join nft_trade_type  on(1=1)
        inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';
insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    nft_sync_address.platform asset,
    'ALL' project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    'TOP' volume,
    '' activity,
    '' hold_time,
    now() created_at,
    'ALL_' || nft_sync_address.platform || '_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'|| level_def.level label_name,
    'MP ' ||nft_sync_address.platform||' '||level_def.level_name|| ' '||(case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'TOP' label_category
from nft_sync_address
         inner join nft_trade_type  on(1=1)
         inner join (
    select
        *
    from
        level_def
    where
            type = 'nft_volume_top') level_def on
    (1 = 1)
where nft_sync_address.type<>'ERC1155' and nft_trade_type.type='1';


--------volume_top project+token(ALL)
-- Blur_ALL_ALL_MP_NFT_VOLUME_TOP
-- Blur_ALL_Buy_MP_NFT_VOLUME_TOP
-- Blur_ALL_Sale_MP_NFT_VOLUME_TOP
insert
into
    dim_project_token_type (project,
                            "token",
                            "type",
                            label_type,
                            operate_type,
                            seq_flag,
                            data_subject,
                            project_name,
                            token_name)
select
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
        limit 1)  project,
    'ALL' "token",
    nft_trade_type.nft_trade_type "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' label_type,
    'T' operate_type,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type seq_flag,
    'volume_top' data_subject,
    mp_nft_platform.platform_name project_name,
    'ALL' token_name
from 	mp_nft_platform
    inner join nft_trade_type on
    (1 = 1)
where
    nft_trade_type.type = '1' ;

insert
into
    public."label" ("owner",
                    "type",
                    "name",
                    "source",
                    visible_type,
                    strategy,
                    "content",
                    rule_type,
                    rule_group,
                    value_type,
                    run_order,
                    created_at,
                    refresh_time,
                    wired_type,
                    label_order,
                    sync_es_status)
select
    'RelationTeam' "owner",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' as "type",
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'||level_def.level as "name",
    'SYSTEM' "source",
    'PUBLIC' visible_type,
    'TOTAL_PART' strategy,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end)  "content",
    'SQL' rule_type,
    mp_nft_platform.platform_name ||'_ALL_'||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP' rule_group,
    'RESULT' value_type,
    999999 run_order,
    now() created_at,
    0 refresh_time,
    'NFT' wired_type,
    999 label_order,
    'WAITING' sync_es_status
from

    mp_nft_platform
        inner join nft_trade_type on
        (1 = 1) inner join (
        select
            *
        from
            level_def
        where
                type = 'nft_volume_top') level_def on
        (1 = 1)
where
        nft_trade_type.type = '1' ;

insert
into
    public.combination (asset,
                        project,
                        trade_type,
                        balance,
                        volume,
                        activity,
                        hold_time,
                        created_at,
                        label_name,
                        "content",
                        asset_type,
                        label_category)
select
    'ALL' asset,
    (
        select
            nft_platform.platform_name
        from
            nft_platform
        where
                mp_nft_platform.platform = nft_platform.platform
          limit 1)   project,
    nft_trade_type.nft_trade_type trade_type,
    '' balance,
    '' volume,
    level_def.level activity,
    '' hold_time,
    now() created_at,
    mp_nft_platform.platform_name || '_ALL_' ||nft_trade_type.nft_trade_type||'_MP_NFT_VOLUME_TOP_'||level_def.level label_name,
    mp_nft_platform.platform_name||' NFT '||level_def.level_name||' '||
    (case when nft_trade_type.nft_trade_type='ALL' then 'Trader' else nft_trade_type.nft_trade_type_name end) "content",
    'nft' asset_type,
    'GRADE' label_category
from
    mp_nft_platform
    inner join nft_trade_type on
    (1 = 1) inner join (
    select
    *
    from
    level_def
    where
    type = 'nft_volume_top') level_def on
    (1 = 1)
where
    nft_trade_type.type = '1' ;


INSERT INTO dim_project_token_type (project,"token","type",label_type,label_name,"content",operate_type,seq_flag,data_subject,etl_update_time,project_name,token_name) VALUES
('ALL','ALL','ALL','ALL_ALL_ALL_MP_NFT_VOLUME_TOP','','','T','ALL_ALL_ALL','volume_top','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','ALL','ALL_ALL_ALL_NFT_VOLUME_TOP','','','T','ALL_ALL_ALL','volume_top','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Burn','ALL_ALL_Burn_NFT_VOLUME_TOP','','','T','ALL_ALL_Burn','volume_top','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Buy','ALL_ALL_Buy_MP_NFT_VOLUME_TOP','','','T','ALL_ALL_Buy','volume_top','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Buy','ALL_ALL_Buy_NFT_VOLUME_TOP','','','T','ALL_ALL_Buy','volume_top','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Mint','ALL_ALL_Mint_NFT_VOLUME_TOP','','','T','ALL_ALL_Mint','volume_top','2023-06-25 15:33:38.949','ALL','ALL'),
('ALL','ALL','Sale','ALL_ALL_Sale_MP_NFT_VOLUME_TOP','','','T','ALL_ALL_Sale','volume_top','2023-06-25 15:33:58.883','ALL','ALL'),
('','ALL','Sale','ALL_ALL_Sale_NFT_VOLUME_TOP','','','T','ALL_ALL_Sale','volume_top','2023-06-25 15:33:38.949','ALL','ALL'),
('','ALL','Transfer','ALL_ALL_Transfer_NFT_VOLUME_TOP','','','T','ALL_ALL_Transfer','volume_top','2023-06-25 15:33:38.949','ALL','ALL');

INSERT INTO label ("owner","type","name","source",visible_type,strategy,"content","rule",default_rule,rule_type,rule_group,value_type,description,run_order,created_at,updated_at,removed,for_init,error_msg,status,popular,refresh_time,mark_type,ar_tx_hash,ar_status,ar_error_msg,ar_error_count,api_level,personal,wired_type,label_order,sync_es_status) VALUES
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_NFT_VOLUME','ALL_ALL_ALL_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Trader','',NULL,'SQL','ALL_ALL_ALL_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Mint_NFT_VOLUME','ALL_ALL_Mint_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Minter','',NULL,'SQL','ALL_ALL_Mint_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Burn_NFT_VOLUME','ALL_ALL_Burn_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Burner','',NULL,'SQL','ALL_ALL_Burn_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Transfer_NFT_VOLUME','ALL_ALL_Transfer_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Transferer','',NULL,'SQL','ALL_ALL_Transfer_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_NFT_VOLUME','ALL_ALL_Buy_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Buyer','',NULL,'SQL','ALL_ALL_Buy_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_NFT_VOLUME','ALL_ALL_Sale_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','Top NFT Seller','',NULL,'SQL','ALL_ALL_Sale_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_ALL_MP_NFT_VOLUME','ALL_ALL_ALL_MP_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','MP NFT Top Trader','',NULL,'SQL','ALL_ALL_ALL_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Buy_MP_NFT_VOLUME','ALL_ALL_Buy_MP_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','MP NFT Top Buyer','',NULL,'SQL','ALL_ALL_Buy_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING'),
                                                                                                                                                                                                                                                                                                                                                                  ('RelationTeam','ALL_ALL_Sale_MP_NFT_VOLUME','ALL_ALL_Sale_MP_NFT_VOLUME_TOP_TOP','SYSTEM','PUBLIC','GRADE','MP NFT Top Seller','',NULL,'SQL','ALL_ALL_Sale_MP_NFT_VOLUME','RESULT',NULL,999999,'2023-06-20 07:47:36.462','2023-06-20 07:47:36.462',false,false,NULL,'SUCCESS',false,0,NULL,NULL,'PENDING',NULL,0,NULL,0,'NFT',999,'WAITING');

INSERT INTO public.combination (asset,project,trade_type,balance,volume,activity,hold_time,created_at,updated_at,removed,label_name,"content",asset_type,label_category) VALUES
                                                                                                                                                                             ('ALL_NFT','','Mint','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Mint_NFT_VOLUME_TOP_TOP','Top NFT Minter','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','','Burn','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Burn_NFT_VOLUME_TOP_TOP','Top NFT Burner','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','','Transfer','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Transfer_NFT_VOLUME_TOP_TOP','Top NFT Transferer','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','','Buy','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_NFT_VOLUME_TOP_TOP','Top NFT Buyer','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','','Sale','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_NFT_VOLUME_TOP_TOP','Top NFT Seller','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','ALL','Buy','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Buy_MP_NFT_VOLUME_TOP_TOP','MP NFT Top Buyer','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','ALL','Sale','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_Sale_MP_NFT_VOLUME_TOP_TOP','MP NFT Top Seller','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','','','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_NFT_VOLUME_TOP_TOP','Top NFT Trader','nft','TOP'),
                                                                                                                                                                             ('ALL_NFT','ALL','','','TOP','','','2023-06-20 07:49:34.394','2023-06-20 07:49:34.394',false,'ALL_ALL_ALL_MP_NFT_VOLUME_TOP_TOP','MP NFT Top Trader','nft','TOP');
