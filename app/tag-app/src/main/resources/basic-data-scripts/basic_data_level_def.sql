DROP TABLE if EXISTS  level_def_temp;
create table level_def_temp
(
    code varchar(3) NULL,
    level varchar(80) NULL,
    type varchar(80) NULL,
    level_name varchar(80) NULL,
    special_flag varchar(1) NULL,
    asset_type varchar(30) NULL,
    dim_type varchar(10) NULL,
    short_name varchar(80) NULL
) ;

--------------------------------------------------defi-----------------------------------------------
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0a','L1','Balance Lv1','defi_balance_grade','defi','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0b','L2','Balance Lv2','defi_balance_grade','defi','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0c','L3','Balance Lv3','defi_balance_grade','defi','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0d','L4','Balance Lv4','defi_balance_grade','defi','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0e','L5','Balance Lv5','defi_balance_grade','defi','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0f','L6','Balance Lv6','defi_balance_grade','defi','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0g','Millionaire','Millionaire','defi_balance_grade','defi','balance','Millionaire');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0h','Billionaire','Billionaire','defi_balance_grade','defi','balance','Billionaire');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0i','HIGH_BALANCE','High Balance','defi_balance_rank','defi','balance','High Balance');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0j','WHALE','Whale','defi_balance_top','defi','balance','Whale');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0k','HEAVY_LP','Heavy LP','defi_lp_heavy_lp','defi_lp','balance','Heavy LP');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('0l','HEAVY_LP_STAKER','Heavy Lp Staker','defi_lp_heavy_lp_staker','defi_lp','balance','Heavy Lp Staker');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1a','L1','Vol Lv1','defi_volume_grade','defi','volume','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1b','L2','Vol Lv2','defi_volume_grade','defi','volume','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1c','L3','Vol Lv3','defi_volume_grade','defi','volume','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1d','L4','Vol Lv4','defi_volume_grade','defi','volume','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1e','L5','Vol Lv5','defi_volume_grade','defi','volume','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1f','L6','Vol Lv6','defi_volume_grade','defi','volume','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1g','Million','Million Trader','defi_volume_grade','defi','volume','Million Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1h','Billion','Billion Trader','defi_volume_grade','defi','volume','Billion Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1i','MEDIUM','Medium Trader','defi_volume_rank','defi','volume','Medium Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1g','HEAVY','Heavy Trader','defi_volume_rank','defi','volume','Heavy Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1k','ELITE','Elite Trader','defi_volume_rank','defi','volume','Elite Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('1l','LEGENDARY','Legendary Trader','defi_volume_rank','defi','volume','Legendary Trader');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2a','L1','Activity Lv1','defi_count','defi','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2b','L2','Activity Lv2','defi_count','defi','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2c','L3','Activity Lv3','defi_count','defi','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2d','L4','Activity Lv4','defi_count','defi','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2e','L5','Activity Lv5','defi_count','defi','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2f','L6','Activity Lv6','defi_count','defi','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2g','Low','Medium Activity','defi_count','defi','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2h','Medium','High Activity','defi_count','defi','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('2i','High','Highest Activity','defi_count','defi','activity','Highest Activity');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3a','L1','Lv1-term Holder','defi_time_grade','defi_token','time','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3b','L2','Lv2-term Holder','defi_time_grade','defi_token','time','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3c','L3','Lv3-term Holder','defi_time_grade','defi_token','time','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3d','L4','Lv4-term Holder','defi_time_grade','defi_token','time','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3e','L5','Lv5-term Holder','defi_time_grade','defi_token','time','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3f','L6','Lv6-term Holder','defi_time_grade','defi_token','time','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3g','LONG_TERM_HOLDER','Long-term Holder','defi_time_special','defi_token','time','Long-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3h','SHORT_TERM_HOLDER','Short-term Holder','defi_time_special','defi_token','time','Short-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3i','FIRST_MOVER_STAKING','First Mover Staking','defi_lp_first_mover_staking','defi_lp','time','First Mover Staking');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('3j','FIRST_MOVER_LP','First Mover LP','defi_lp_first_mover_lp','defi_lp','time','First Mover LP');


--------------------------------------------------nft-----------------------------------------------
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4a','L1','Lv1 Collector','nft_balance_grade','nft_nft','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4b','L2','Lv2 Collector','nft_balance_grade','nft_nft','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4c','L3','Lv3 Collector','nft_balance_grade','nft_nft','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4d','L4','Lv4 Collector','nft_balance_grade','nft_nft','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4e','L5','Lv5 Collector','nft_balance_grade','nft_nft','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4f','L6','Lv6 Collector','nft_balance_grade','nft_nft','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4g','UNCOMMON_NFT_COLLECTOR','Uncommon Collector','nft_balance_rank','nft_nft','balance','Uncommon Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4h','RARE_NFT_COLLECTOR','Rare Collector','nft_balance_rank','nft_nft','balance','Rare Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4i','EPIC_NFT_COLLECTOR','Epic Collector','nft_balance_rank','nft_nft','balance','Epic Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4j','LEGENDARY_NFT_COLLECTOR','Legendary Collector','nft_balance_rank','nft_nft','balance','Legendary Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('4k','WHALE','Whale','nft_balance_top','nft_nft','balance','Whale');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5a','L1','Vol Lv1','nft_volume_grade','nft','volume','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5b','L2','Vol Lv2','nft_volume_grade','nft','volume','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5c','L3','Vol Lv3','nft_volume_grade','nft','volume','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5d','L4','Vol Lv4','nft_volume_grade','nft','volume','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5e','L5','Vol Lv5','nft_volume_grade','nft','volume','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5f','L6','Vol Lv6','nft_volume_grade','nft','volume','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5g','UNCOMMON_NFT_TRADER','Uncommon','nft_volume_rank','nft','volume','Uncommon Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5h','RARE_NFT_TRADER','Rare','nft_volume_rank','nft','volume','Rare Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5i','EPIC_NFT_TRADER','Epic','nft_volume_rank','nft','volume','Epic Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5j','LEGENDARY_NFT_TRADER','Legendary','nft_volume_rank','nft','volume','Legendary Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5k','TOP','Top','nft_volume_top','nft','volume','Top Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('5l','ELITE_NFT_TRADER','Elite','nft_volume_elite','nft','volume','Elite Trader');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6a','L1','Activity Lv1','nft_count','nft','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6b','L2','Activity Lv2','nft_count','nft','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6c','L3','Activity Lv3','nft_count','nft','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6d','L4','Activity Lv4','nft_count','nft','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6e','L5','Activity Lv5','nft_count','nft','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('6f','L6','Activity Lv6','nft_count','nft','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values('6g','Low','Medium Activity','nft_count',1,'nft','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values('6h','Medium','High Activity','nft_count',1,'nft','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values('6i','High','Highest Activity','nft_count',1,'nft','activity','Highest Activity');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7a','L1','Lv1-term Holder','nft_time_grade','nft_nft','time','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7b','L2','Lv2-term Holder','nft_time_grade','nft_nft','time','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7c','L3','Lv3-term Holder','nft_time_grade','nft_nft','time','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7d','L4','Lv4-term Holder','nft_time_grade','nft_nft','time','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7e','L5','Lv5-term Holder','nft_time_grade','nft_nft','time','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7f','L6','Lv6-term Holder','nft_time_grade','nft_nft','time','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7g','LONG_TERM_HOLDER','Long-term Holder','nft_time_special','nft_nft','time','Long-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7h','SHORT_TERM_HOLDER','Short-term Holder','nft_time_special','nft_nft','time','Short-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('7i','Smart NFT Early Adopter','Smart NFT Early Adopter','nft_time_rank','nft_nft','time','Smart NFT Early Adopter');


--------------------------------------------------WEB3-----------------------------------------------


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8a','L1','Lv1','web3_balance_grade','web3','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8b','L2','Lv2','web3_balance_grade','web3','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8c','L3','Lv3','web3_balance_grade','web3','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8d','L4','Lv4','web3_balance_grade','web3','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8e','L5','Lv5','web3_balance_grade','web3','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8f','L6','Lv6','web3_balance_grade','web3','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8g','UNCOMMON','Uncommon','web3_balance_rank','web3','balance','Uncommon Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8h','RARE','Rare','web3_balance_rank','web3','balance','Rare Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8i','EPIC','Epic','web3_balance_rank','web3','balance','Epic Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8j','LEGENDARY','Legendary','web3_balance_rank','web3','balance','Legendary Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('8k','WHALE','Whale','web3_balance_top','web3','balance','Web3NFT Whale');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9a','L1','Activity Lv1','web3_count','web3','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9b','L2','Activity Lv2','web3_count','web3','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9c','L3','Activity Lv3','web3_count','web3','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9d','L4','Activity Lv4','web3_count','web3','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9e','L5','Activity Lv5','web3_count','web3','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9f','L6','Activity Lv6','web3_count','web3','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9g','Low','Medium Activity','web3_count','web3','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9h','Medium','High Activity','web3_count','web3','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values('9i','High','Highest Activity','web3_count','web3','activity','Highest Activity');


insert into tag_result(table_name,batch_date)  SELECT 'basic_data_level_def' as table_name,'${batchDate}'  as batch_date;



