------from
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count,
                               total_transfer_to_volume,
                               total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                               total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                               total_transfer_all_count, updated_block_height, recent_time_code)

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
       max(block_number),
       recent_time_code
from erc721_tx_record
         inner join (select *
                     from recent_time
                     where recent_time.recent_time_code = '${recent_time_code}') recent_time on
    (erc721_tx_record.block_number >= recent_time.block_height)
where to_address != '0x0000000000000000000000000000000000000000'
          and to_address != '0x000000000000000000000000000000000000dead'
          and from_address != '0x0000000000000000000000000000000000000000'
group by from_address, token, recent_time_code;

------burn
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count,
                               total_transfer_to_volume,
                               total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                               total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                               total_transfer_all_count, updated_block_height, recent_time_code)

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
            max(block_number),
            recent_time_code
     from erc721_tx_record
              inner join (select *
                          from recent_time
                          where recent_time.recent_time_code = '${recent_time_code}') recent_time on
         (erc721_tx_record.block_number >= recent_time.block_height)
     where (to_address = '0x0000000000000000000000000000000000000000'
         or to_address = '0x000000000000000000000000000000000000dead')
       and from_address != '0x0000000000000000000000000000000000000000'
     group by from_address, token, recent_time_code);

-----------------to
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count,
                               total_transfer_to_volume,
                               total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                               total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                               total_transfer_all_count, updated_block_height, recent_time_code)

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
            max(block_number),
            recent_time_code
     from erc721_tx_record
              inner join (select *
                          from recent_time
                          where recent_time.recent_time_code = '${recent_time_code}') recent_time on
         (erc721_tx_record.block_number >= recent_time.block_height)
     where from_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x000000000000000000000000000000000000dead'
     group by to_address, token, recent_time_code);

-------------------mint
insert into nft_holding_middle(address, token, balance, total_transfer_volume, total_transfer_count,
                               total_transfer_to_volume,
                               total_transfer_to_count, total_transfer_mint_volume, total_transfer_mint_count,
                               total_transfer_burn_volume, total_transfer_burn_count, total_transfer_all_volume,
                               total_transfer_all_count, updated_block_height, recent_time_code)

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
            max(block_number),
            recent_time_code
     from erc721_tx_record
              inner join (select *
                          from recent_time
                          where recent_time.recent_time_code = '${recent_time_code}') recent_time on
         (erc721_tx_record.block_number >= recent_time.block_height)
     where from_address = '0x0000000000000000000000000000000000000000'
       and to_address != '0x0000000000000000000000000000000000000000'
               and to_address != '0x000000000000000000000000000000000000dead'
     group by to_address, token, recent_time_code);