
CREATE INDEX nft_activity_volume_address_gin_trgm ON public.nft_volume_count USING btree (address);
CREATE INDEX nft_activity_volume_token_gin_trgm ON public.nft_volume_count USING btree (token);

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Mint', total_transfer_mint_volume, total_transfer_mint_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Burn', total_transfer_burn_volume, total_transfer_burn_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Buy', total_transfer_buy_volume, total_transfer_buy_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Sale', total_transfer_sell_volume, total_transfer_sell_count from nft_buy_sell_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'ALL', total_transfer_all_volume, total_transfer_all_count from nft_holding;

insert into nft_volume_count(address, token, type, transfer_volume, transfer_count)
    select address, token , 'Transfer', total_transfer_volume, total_transfer_count from nft_transfer_holding;
