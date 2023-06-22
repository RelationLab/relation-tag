DROP TABLE if EXISTS  level_def;
create table level_def
(

    level varchar(80) NULL,
    type varchar(80) NULL,
    level_name varchar(80) NULL
) ;

insert into level_def(level,level_name,type) values('L1','Activity Lv1','count');
insert into level_def(level,level_name,type) values('L2','Activity Lv2','count');
insert into level_def(level,level_name,type) values('L3','Activity Lv3','count');
insert into level_def(level,level_name,type) values('L4','Activity Lv4','count');
insert into level_def(level,level_name,type) values('L5','Activity Lv5','count');
insert into level_def(level,level_name,type) values('L6','Activity Lv6','count');
insert into level_def(level,level_name,type) values('Highest','Highest Activity','count');
insert into level_def(level,level_name,type) values('High','High Activity','count');
insert into level_def(level,level_name,type) values('Medium','Medium Activity','count');

--------------------------------------------------defi-----------------------------------------------
insert into level_def(level,level_name,type) values('L1','Vol Lv1','defi_volume_grade');
insert into level_def(level,level_name,type) values('L2','Vol Lv2','defi_volume_grade');
insert into level_def(level,level_name,type) values('L3','Vol Lv3','defi_volume_grade');
insert into level_def(level,level_name,type) values('L4','Vol Lv4','defi_volume_grade');
insert into level_def(level,level_name,type) values('L5','Vol Lv5','defi_volume_grade');
insert into level_def(level,level_name,type) values('L6','Vol Lv6','defi_volume_grade');
insert into level_def(level,level_name,type) values('Million','Trader','defi_volume_grade');
insert into level_def(level,level_name,type) values('Billion','Trader','defi_volume_grade');

insert into level_def(level,level_name,type) values('Legendary','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Elite','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Heavy','Trader','defi_volume_rank');
insert into level_def(level,level_name,type) values('Medium ','Trader','defi_volume_rank');


--------------------------------------------------nft-----------------------------------------------
insert into level_def(level,level_name,type) values('ELITE_NFT_TRADER','Elite','nft_volume_elite');

insert into level_def(level,level_name,type) values('L1','Vol Lv1','nft_volume_grade');
insert into level_def(level,level_name,type) values('L2','Vol Lv2','nft_volume_grade');
insert into level_def(level,level_name,type) values('L3','Vol Lv3','nft_volume_grade');
insert into level_def(level,level_name,type) values('L4','Vol Lv4','nft_volume_grade');
insert into level_def(level,level_name,type) values('L5','Vol Lv5','nft_volume_grade');
insert into level_def(level,level_name,type) values('L6','Vol Lv6','nft_volume_grade');

insert into level_def(level,level_name,type) values('LEGENDARY_NFT_TRADER','Legendary','nft_volume_rank');
insert into level_def(level,level_name,type) values('EPIC_NFT_TRADER','Epic','nft_volume_rank');
insert into level_def(level,level_name,type) values('RARE_NFT_TRADER','Rare','nft_volume_rank');
insert into level_def(level,level_name,type) values('UNCOMMON_NFT_TRADER','Uncommon','nft_volume_rank');

insert into level_def(level,level_name,type) values('TOP','Top','nft_volume_top');


insert into level_def(level,level_name,type) values('L1','Lv1 Collector','nft_balance_grade');
insert into level_def(level,level_name,type) values('L2','Lv2 Collector','nft_balance_grade');
insert into level_def(level,level_name,type) values('L3','Lv3 Collector','nft_balance_grade');
insert into level_def(level,level_name,type) values('L4','Lv4 Collector','nft_balance_grade');
insert into level_def(level,level_name,type) values('L5','Lv5 Collector','nft_balance_grade');
insert into level_def(level,level_name,type) values('L6','Lv6 Collector','nft_balance_grade');

insert into level_def(level,level_name,type) values('LEGENDARY_NFT_COLLECTOR','Legendary Collector','nft_balance_rank');
insert into level_def(level,level_name,type) values('EPIC_NFT_COLLECTOR','Epic Collector','nft_balance_rank');
insert into level_def(level,level_name,type) values('RARE_NFT_COLLECTOR','Rare Collector','nft_balance_rank');
insert into level_def(level,level_name,type) values('UNCOMMON_NFT_COLLECTOR','Uncommon Collector','nft_balance_rank');

insert into level_def(level,level_name,type) values('WHALE','Whale','nft_balance_top');

insert into level_def(level,level_name,type) values('L1','Lv1-term Holder','nft_time_grade');
insert into level_def(level,level_name,type) values('L2','Lv2-term Holder','nft_time_grade');
insert into level_def(level,level_name,type) values('L3','Lv3-term Holder','nft_time_grade');
insert into level_def(level,level_name,type) values('L4','Lv4-term Holder','nft_time_grade');
insert into level_def(level,level_name,type) values('L5','Lv5-term Holder','nft_time_grade');
insert into level_def(level,level_name,type) values('L6','Lv6-term Holder','nft_time_grade');

insert into level_def(level,level_name,type) values('Smart NFT Early Adopter','Smart NFT Early Adopter','nft_time_rank');

insert into level_def(level,level_name,type) values('LONG_TERM_HOLDER','Long-term Holder','nft_time_special');
insert into level_def(level,level_name,type) values('SHORT_TERM_HOLDER','Short-term Holder','nft_time_special');







