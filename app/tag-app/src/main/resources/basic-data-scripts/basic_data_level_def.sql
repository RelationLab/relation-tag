DROP TABLE if EXISTS  level_def_temp;
create table level_def_temp
(
    code varchar(10) NULL,
    level varchar(80) NULL,
    type varchar(80) NULL,
    level_name varchar(80) NULL,
    special_flag varchar(1) NULL
) ;

--------------------------------------------------defi-----------------------------------------------
insert into level_def_temp(code,level,level_name,type) values('g1','L1','Vol Lv1','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Vol Lv2','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Vol Lv3','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Vol Lv4','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Vol Lv5','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Vol Lv6','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g7','Million','Trader','defi_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g8','Billion','Trader','defi_volume_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','LEGENDARY','Legendary','defi_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r2','ELITE','Elite','defi_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r3','HEAVY','Heavy','defi_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r4','MEDIUM','Medium','defi_volume_rank');


insert into level_def_temp(code,level,level_name,type) values('r1','LEGENDARY','Legendary Trader','token_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r2','ELITE','Elite Trader','token_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r3','HEAVY','Heavy Trader','token_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r4','MEDIUM','Medium Trader','token_volume_rank');

insert into level_def_temp(code,level,level_name,type) values('g1','L1','Balance Lv1','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Balance Lv2','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Balance Lv3','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Balance Lv4','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Balance Lv5','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Balance Lv6','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g7','Millionaire','Millionaire','defi_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g8','Billionaire','Billionaire','defi_balance_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','HIGH_BALANCE','High Balance','defi_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('t1','WHALE','Whale','defi_balance_top');

insert into level_def_temp(code,level,level_name,type) values('g1','L1','Activity Lv1','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Activity Lv2','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Activity Lv3','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Activity Lv4','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Activity Lv5','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Activity Lv6','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g7','High','Highest Activity','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g8','Medium','High Activity','defi_count');
insert into level_def_temp(code,level,level_name,type) values('g9','Low','Medium Activity','defi_count');

insert into level_def_temp(code,level,level_name,type) values('g1','L1','Lv1-term Holder','defi_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Lv2-term Holder','defi_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Lv3-term Holder','defi_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Lv4-term Holder','defi_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Lv5-term Holder','defi_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Lv6-term Holder','defi_time_grade');


insert into level_def_temp(code,level,level_name,type) values('s1','LONG_TERM_HOLDER','Long-term Holder','defi_time_special');
insert into level_def_temp(code,level,level_name,type) values('s2','SHORT_TERM_HOLDER','Short-term Holder','defi_time_special');

--------------------------------------------------nft-----------------------------------------------
insert into level_def_temp(code,level,level_name,type) values('g1','L1','Activity Lv1','nft_count');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Activity Lv2','nft_count');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Activity Lv3','nft_count');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Activity Lv4','nft_count');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Activity Lv5','nft_count');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Activity Lv6','nft_count');
insert into level_def_temp(code,level,level_name,type,special_flag) values('g7','High','Highest Activity','nft_count','1');
insert into level_def_temp(code,level,level_name,type,special_flag) values('g8','Medium','High Activity','nft_count','1');
insert into level_def_temp(code,level,level_name,type,special_flag) values('g9','Low','Medium Activity','nft_count','1');


insert into level_def_temp(code,level,level_name,type) values('e1','ELITE_NFT_TRADER','Elite','nft_volume_elite');

insert into level_def_temp(code,level,level_name,type) values('g1','L1','Vol Lv1','nft_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Vol Lv2','nft_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Vol Lv3','nft_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Vol Lv4','nft_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Vol Lv5','nft_volume_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Vol Lv6','nft_volume_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','LEGENDARY_NFT_TRADER','Legendary','nft_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r2','EPIC_NFT_TRADER','Epic','nft_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r3','RARE_NFT_TRADER','Rare','nft_volume_rank');
insert into level_def_temp(code,level,level_name,type) values('r4','UNCOMMON_NFT_TRADER','Uncommon','nft_volume_rank');

insert into level_def_temp(code,level,level_name,type) values('t1','TOP','Top','nft_volume_top');


insert into level_def_temp(code,level,level_name,type) values('g1','L1','Lv1 Collector','nft_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Lv2 Collector','nft_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Lv3 Collector','nft_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Lv4 Collector','nft_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Lv5 Collector','nft_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Lv6 Collector','nft_balance_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','LEGENDARY_NFT_COLLECTOR','Legendary Collector','nft_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r2','EPIC_NFT_COLLECTOR','Epic Collector','nft_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r3','RARE_NFT_COLLECTOR','Rare Collector','nft_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r4','UNCOMMON_NFT_COLLECTOR','Uncommon Collector','nft_balance_rank');

insert into level_def_temp(code,level,level_name,type) values('t1','WHALE','Whale','nft_balance_top');

insert into level_def_temp(code,level,level_name,type) values('g1','L1','Lv1-term Holder','nft_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Lv2-term Holder','nft_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Lv3-term Holder','nft_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Lv4-term Holder','nft_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Lv5-term Holder','nft_time_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Lv6-term Holder','nft_time_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','Smart NFT Early Adopter','Smart NFT Early Adopter','nft_time_rank');

insert into level_def_temp(code,level,level_name,type) values('s1','LONG_TERM_HOLDER','Long-term Holder','nft_time_special');
insert into level_def_temp(code,level,level_name,type) values('s2','SHORT_TERM_HOLDER','Short-term Holder','nft_time_special');

--------------------------------------------------WEB3-----------------------------------------------


insert into level_def_temp(code,level,level_name,type) values('g1','L1','Lv1','web3_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Lv2','web3_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Lv3','web3_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Lv4','web3_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Lv5','web3_balance_grade');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Lv6','web3_balance_grade');

insert into level_def_temp(code,level,level_name,type) values('r1','LEGENDARY','Legendary','web3_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r2','EPIC','Epic','web3_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r3','RARE','Rare','web3_balance_rank');
insert into level_def_temp(code,level,level_name,type) values('r4','UNCOMMON','Uncommon','web3_balance_rank');

insert into level_def_temp(code,level,level_name,type) values('t1','WHALE','Whale','web3_balance_top');


insert into level_def_temp(code,level,level_name,type) values('g1','L1','Activity Lv1','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g2','L2','Activity Lv2','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g3','L3','Activity Lv3','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g4','L4','Activity Lv4','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g5','L5','Activity Lv5','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g6','L6','Activity Lv6','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g7','High','Highest Activity','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g8','Medium','High Activity','web3_count');
insert into level_def_temp(code,level,level_name,type) values('g9','Low','Medium Activity','web3_count');

insert into tag_result(table_name,batch_date)  SELECT 'basic_data_level_def' as table_name,'${batchDate}'  as batch_date;



