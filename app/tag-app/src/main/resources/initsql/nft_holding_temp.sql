

------from
insert into nft_holding_temp(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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
insert into nft_holding_temp(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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
insert into nft_holding_temp(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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
insert into nft_holding_temp(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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