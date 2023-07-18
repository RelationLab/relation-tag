drop table if exists nft_holding_middle;
CREATE TABLE public.nft_holding_middle (
                                    address varchar(512) NOT NULL,
                                    "token" varchar(512) NOT NULL,
                                    balance int8 NOT NULL,
                                    total_transfer_volume int8 NOT NULL,
                                    total_transfer_count int8 NULL,
                                    total_transfer_to_volume int8 NOT NULL,
                                    total_transfer_to_count int8 NULL,
                                    total_transfer_mint_volume int8 NOT NULL,
                                    total_transfer_mint_count int8 NULL,
                                    total_transfer_burn_volume int8 NOT NULL,
                                    total_transfer_burn_count int8 NULL,
                                    total_transfer_all_volume int8 NOT NULL,
                                    total_transfer_all_count int8 NULL,
                                    updated_block_height int8 NOT NULL,
                                    created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
) distributed by (address,"token");
truncate table nft_holding_middle;
vacuum nft_holding_middle;

------from
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
                        total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                        total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                        total_transfer_all_count, updated_block_height)

select from_address,
       token,
       sum(-1),
       count(1),
       count(1),
       0,
       0,
       0,
       0,
       0,
       0,
       count(1),
       count(1),
       max(block_number)
from erc721_tx_record
where to_address != '0x0000000000000000000000000000000000000000'
          and to_address != '0x000000000000000000000000000000000000dead'
          and from_address != '0x0000000000000000000000000000000000000000'
group by from_address, token;

------burn
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
                        total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                        total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                        total_transfer_all_count, updated_block_height)

    (select from_address,
            token,
            sum(-1),
            0,
            0,
            0,
            0,
            0,
            0,
            count(1),
            count(1),
            count(1),
            count(1),
            max(block_number)
     from erc721_tx_record
     where (to_address = '0x0000000000000000000000000000000000000000'
         or to_address = '0x000000000000000000000000000000000000dead')
       and from_address != '0x0000000000000000000000000000000000000000'
     group by from_address, token);

-----------------to
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
                        total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                        total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                        total_transfer_all_count, updated_block_height)

    (select to_address,
            token,
            sum(1),
            0,
            0,
            count(1),
            count(1),
            0,
            0,
            0,
            0,
            count(1),
            count(1),
            max(block_number)
     from erc721_tx_record
     where from_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x000000000000000000000000000000000000dead'
     group by to_address, token);

-------------------mint
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
                        total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                        total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                        total_transfer_all_count, updated_block_height)

    (select to_address,
            token,
            sum(1),
            0,
            0,
            0,
            0,
            count(1),
            count(1),
            0,
            0,
            count(1),
            count(1),
            max(block_number)
     from erc721_tx_record
     where from_address = '0x0000000000000000000000000000000000000000'
       and to_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x000000000000000000000000000000000000dead'
     group by to_address, token);
insert into tag_result(table_name,batch_date)  SELECT 'nft_holding_middle' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
