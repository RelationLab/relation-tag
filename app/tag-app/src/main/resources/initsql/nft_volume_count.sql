DROP TABLE if EXISTS public.nft_volume_count;
CREATE TABLE public.nft_volume_count (
                                         address varchar(512) NOT NULL,
                                         "token" varchar(512) NOT NULL,
                                         type varchar(100) NOT NULL,
                                         transfer_volume int8 NOT NULL,
                                         transfer_count int8 NULL,
                                         created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                         removed bool NULL DEFAULT false,
);
truncate table nft_volume_count;
vacuum nft_volume_count;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Mint', total_transfer_mint_volume, total_transfer_mint_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Burn', total_transfer_burn_volume, total_transfer_burn_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Buy', total_transfer_buy_volume, total_transfer_buy_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Sale', total_transfer_sell_volume, total_transfer_sell_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'ALL', total_transfer_all_volume,
           total_transfer_all_count as total_transfer_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Transfer', total_transfer_volume, total_transfer_count from nft_transfer_holding;
insert into tag_result(table_name,batch_date)  SELECT 'nft_volume_count' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
