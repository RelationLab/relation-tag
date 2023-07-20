DROP TABLE if EXISTS  nft_action_platform;
create table nft_action_platform
(
    platform varchar(80) NULL,
    nft_trade_type varchar(512) NULL,
    token varchar(80) NULL
) ;

insert into nft_action_platform(platform,nft_trade_type) values('0x00000000006c3852cbef3e08e8df289169ede581','ALL');
insert into nft_action_platform(platform,nft_trade_type) values('0x00000000006c3852cbef3e08e8df289169ede581','Buy');
insert into nft_action_platform(platform,nft_trade_type) values('0x00000000006c3852cbef3e08e8df289169ede581','Sale');

insert into nft_action_platform(platform,nft_trade_type) values('0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb','ALL');
insert into nft_action_platform(platform,nft_trade_type) values('0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb','Buy');
insert into nft_action_platform(platform,nft_trade_type) values('0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb','Sale');

insert into nft_action_platform(platform,nft_trade_type) values('0x74312363e45dcaba76c59ec49a7aa8a65a67eed3','ALL');
insert into nft_action_platform(platform,nft_trade_type) values('0x74312363e45dcaba76c59ec49a7aa8a65a67eed3','Buy');
insert into nft_action_platform(platform,nft_trade_type) values('0x74312363e45dcaba76c59ec49a7aa8a65a67eed3','Sale');

insert into nft_action_platform(platform,nft_trade_type) values('0x59728544b08ab483533076417fbbb2fd0b17ce3a','ALL');
insert into nft_action_platform(platform,nft_trade_type) values('0x59728544b08ab483533076417fbbb2fd0b17ce3a','Buy');
insert into nft_action_platform(platform,nft_trade_type) values('0x59728544b08ab483533076417fbbb2fd0b17ce3a','Sale');


insert into nft_action_platform(platform,nft_trade_type) values('0x39da41747a83aee658334415666f3ef92dd0d541','ALL');
insert into nft_action_platform(platform,nft_trade_type) values('0x39da41747a83aee658334415666f3ef92dd0d541','Buy');
insert into nft_action_platform(platform,nft_trade_type) values('0x39da41747a83aee658334415666f3ef92dd0d541','Sale');

insert into nft_action_platform(platform,nft_trade_type,token) values('0x39da41747a83aee658334415666f3ef92dd0d541','Bid','0x0000000000a39bb272e79075ade125fd351887ac');
insert into nft_action_platform(platform,nft_trade_type,token) values('0x39da41747a83aee658334415666f3ef92dd0d541','Deposit','0x0000000000a39bb272e79075ade125fd351887ac');
insert into nft_action_platform(platform,nft_trade_type,token) values('0x39da41747a83aee658334415666f3ef92dd0d541','Withdraw','0x0000000000a39bb272e79075ade125fd351887ac');
insert into nft_action_platform(platform,nft_trade_type,token) values('0x39da41747a83aee658334415666f3ef92dd0d541','Lend','0x0000000000a39bb272e79075ade125fd351887ac');

insert into tag_result(table_name,batch_date)  SELECT 'nft_action_platform' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
