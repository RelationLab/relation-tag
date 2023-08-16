DROP TABLE if EXISTS  level_def_temp;
create table level_def_temp
(
    code bigint NULL,
    level varchar(80) NULL,
    type varchar(80) NULL,
    level_name varchar(80) NULL,
    special_flag varchar(1) NULL,
    asset_type varchar(30) NULL,
    dim_type varchar(10) NULL,
    short_name varchar(80) NULL
) ;

--------------------------------------------------defi-----------------------------------------------
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(1,'L1','Balance Lv1','defi_balance_grade','defi','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(2,'L2','Balance Lv2','defi_balance_grade','defi','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(3,'L3','Balance Lv3','defi_balance_grade','defi','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(4,'L4','Balance Lv4','defi_balance_grade','defi','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(5,'L5','Balance Lv5','defi_balance_grade','defi','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(6,'L6','Balance Lv6','defi_balance_grade','defi','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(7,'Millionaire','Millionaire','defi_balance_grade','defi','balance','Millionaire');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(8,'Billionaire','Billionaire','defi_balance_grade','defi','balance','Billionaire');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(9,'HIGH_BALANCE','High Balance','defi_balance_rank','defi','balance','High Balance');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(10,'WHALE','Whale','defi_balance_top','defi','balance','Whale');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(11,'HEAVY_LP','Heavy LP','defi_lp_heavy_lp','defi_lp','balance','Heavy LP');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(12,'HEAVY_LP_STAKER','Heavy LP Staker','defi_lp_heavy_lp_staker','defi_lp','balance','Heavy LP Staker');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(13,'L1','Vol Lv1','defi_volume_grade','defi','volume','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(14,'L2','Vol Lv2','defi_volume_grade','defi','volume','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(15,'L3','Vol Lv3','defi_volume_grade','defi','volume','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(16,'L4','Vol Lv4','defi_volume_grade','defi','volume','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(17,'L5','Vol Lv5','defi_volume_grade','defi','volume','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(18,'L6','Vol Lv6','defi_volume_grade','defi','volume','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(19,'Million','Million Trader','defi_volume_grade','defi','volume','Million Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(20,'Billion','Billion Trader','defi_volume_grade','defi','volume','Billion Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(21,'MEDIUM','Medium Trader','defi_volume_rank','defi','volume','Medium Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(22,'HEAVY','Heavy Trader','defi_volume_rank','defi','volume','Heavy Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(23,'ELITE','Elite Trader','defi_volume_rank','defi','volume','Elite Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(24,'LEGENDARY','Legendary Trader','defi_volume_rank','defi','volume','Legendary Trader');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(25,'L1','Activity Lv1','defi_count','defi','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(26,'L2','Activity Lv2','defi_count','defi','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(27,'L3','Activity Lv3','defi_count','defi','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(28,'L4','Activity Lv4','defi_count','defi','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(29,'L5','Activity Lv5','defi_count','defi','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(30,'L6','Activity Lv6','defi_count','defi','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(31,'Low','Medium Activity','defi_count','defi','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(32,'Medium','High Activity','defi_count','defi','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(33,'High','Highest Activity','defi_count','defi','activity','Highest Activity');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(34,'L1','Lv1-term Holder','defi_time_grade','defi_token','time','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(35,'L2','Lv2-term Holder','defi_time_grade','defi_token','time','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(36,'L3','Lv3-term Holder','defi_time_grade','defi_token','time','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(37,'L4','Lv4-term Holder','defi_time_grade','defi_token','time','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(38,'L5','Lv5-term Holder','defi_time_grade','defi_token','time','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(39,'L6','Lv6-term Holder','defi_time_grade','defi_token','time','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(40,'LONG_TERM_HOLDER','Long-term Holder','defi_time_special','defi_token','time','Long-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(41,'SHORT_TERM_HOLDER','Short-term Holder','defi_time_special','defi_token','time','Short-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(42,'FIRST_MOVER_STAKING','First Mover Staking','defi_lp_first_mover_staking','defi_lp','time','First Mover Staking');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(43,'FIRST_MOVER_LP','First Mover LP','defi_lp_first_mover_lp','defi_lp','time','First Mover LP');


--------------------------------------------------nft-----------------------------------------------
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(44,'L1','Lv1 Collector','nft_balance_grade','nft_nft','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(45,'L2','Lv2 Collector','nft_balance_grade','nft_nft','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(46,'L3','Lv3 Collector','nft_balance_grade','nft_nft','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(47,'L4','Lv4 Collector','nft_balance_grade','nft_nft','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(48,'L5','Lv5 Collector','nft_balance_grade','nft_nft','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(49,'L6','Lv6 Collector','nft_balance_grade','nft_nft','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(50,'UNCOMMON_NFT_COLLECTOR','Uncommon Collector','nft_balance_rank','nft_nft','balance','Uncommon Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(51,'RARE_NFT_COLLECTOR','Rare Collector','nft_balance_rank','nft_nft','balance','Rare Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(52,'EPIC_NFT_COLLECTOR','Epic Collector','nft_balance_rank','nft_nft','balance','Epic Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(53,'LEGENDARY_NFT_COLLECTOR','Legendary Collector','nft_balance_rank','nft_nft','balance','Legendary Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(54,'WHALE','Whale','nft_balance_top','nft_nft','balance','Whale');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(55,'L1','Vol Lv1','nft_volume_grade','nft','volume','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(56,'L2','Vol Lv2','nft_volume_grade','nft','volume','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(57,'L3','Vol Lv3','nft_volume_grade','nft','volume','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(58,'L4','Vol Lv4','nft_volume_grade','nft','volume','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(59,'L5','Vol Lv5','nft_volume_grade','nft','volume','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(60,'L6','Vol Lv6','nft_volume_grade','nft','volume','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(61,'UNCOMMON_NFT_TRADER','Uncommon','nft_volume_rank','nft','volume','Uncommon Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(62,'RARE_NFT_TRADER','Rare','nft_volume_rank','nft','volume','Rare Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(63,'EPIC_NFT_TRADER','Epic','nft_volume_rank','nft','volume','Epic Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(64,'LEGENDARY_NFT_TRADER','Legendary','nft_volume_rank','nft','volume','Legendary Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(65,'TOP','Top','nft_volume_top','nft','volume','Top Trader');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(66,'ELITE_NFT_TRADER','Elite','nft_volume_elite','nft','volume','Elite Trader');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(67,'L1','Activity Lv1','nft_count','nft','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(68,'L2','Activity Lv2','nft_count','nft','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(69,'L3','Activity Lv3','nft_count','nft','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(70,'L4','Activity Lv4','nft_count','nft','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(71,'L5','Activity Lv5','nft_count','nft','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(72,'L6','Activity Lv6','nft_count','nft','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values(73,'Low','Medium Activity','nft_count',1,'nft','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values(74,'Medium','High Activity','nft_count',1,'nft','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,special_flag,asset_type,dim_type,short_name) values(75,'High','Highest Activity','nft_count',1,'nft','activity','Highest Activity');

insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(76,'L1','Lv1-term Holder','nft_time_grade','nft_nft','time','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(77,'L2','Lv2-term Holder','nft_time_grade','nft_nft','time','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(78,'L3','Lv3-term Holder','nft_time_grade','nft_nft','time','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(79,'L4','Lv4-term Holder','nft_time_grade','nft_nft','time','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(80,'L5','Lv5-term Holder','nft_time_grade','nft_nft','time','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(81,'L6','Lv6-term Holder','nft_time_grade','nft_nft','time','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(82,'LONG_TERM_HOLDER','Long-term Holder','nft_time_special','nft_nft','time','Long-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(83,'SHORT_TERM_HOLDER','Short-term Holder','nft_time_special','nft_nft','time','Short-term Holder');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(84,'Smart NFT Early Adopter','Smart NFT Early Adopter','nft_time_rank','nft_nft','time','Smart NFT Early Adopter');


--------------------------------------------------WEB3-----------------------------------------------


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(85,'L1','Lv1','web3_balance_grade','web3','balance','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(86,'L2','Lv2','web3_balance_grade','web3','balance','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(87,'L3','Lv3','web3_balance_grade','web3','balance','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(88,'L4','Lv4','web3_balance_grade','web3','balance','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(89,'L5','Lv5','web3_balance_grade','web3','balance','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(90,'L6','Lv6','web3_balance_grade','web3','balance','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(91,'UNCOMMON','Uncommon','web3_balance_rank','web3','balance','Uncommon Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(92,'RARE','Rare','web3_balance_rank','web3','balance','Rare Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(93,'EPIC','Epic','web3_balance_rank','web3','balance','Epic Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(94,'LEGENDARY','Legendary','web3_balance_rank','web3','balance','Legendary Web3NFT Collector');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(95,'WHALE','Whale','web3_balance_top','web3','balance','Web3NFT Whale');


insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(96,'L1','Activity Lv1','web3_count','web3','activity','Lv1');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(97,'L2','Activity Lv2','web3_count','web3','activity','Lv2');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(98,'L3','Activity Lv3','web3_count','web3','activity','Lv3');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(99,'L4','Activity Lv4','web3_count','web3','activity','Lv4');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(100,'L5','Activity Lv5','web3_count','web3','activity','Lv5');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(101,'L6','Activity Lv6','web3_count','web3','activity','Lv6');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(102,'Low','Medium Activity','web3_count','web3','activity','Medium Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(103,'Medium','High Activity','web3_count','web3','activity','High Activity');
insert into level_def_temp(code,level,level_name,type,asset_type,dim_type,short_name) values(104,'High','Highest Activity','web3_count','web3','activity','Highest Activity');


insert into tag_result(table_name,batch_date)  SELECT 'basic_data_level_def' as table_name,'${batchDate}'  as batch_date;



