insert
into nft_holding (address,
                  token,
                  balance,
                  total_transfer_volume,
                  total_transfer_count,
                  total_transfer_to_volume,
                  total_transfer_to_count,
                  total_transfer_mint_volume,
                  total_transfer_mint_count,
                  total_transfer_burn_volume,
                  total_transfer_burn_count,
                  total_transfer_all_volume,
                  total_transfer_all_count,
                  updated_block_height)
select address,
       token,
       sum(balance)                    balance,
       sum(total_transfer_volume)      total_transfer_volume,
       sum(total_transfer_count)       total_transfer_count,
       sum(total_transfer_to_volume)   total_transfer_to_volume,
       sum(total_transfer_to_count)    total_transfer_to_count,
       sum(total_transfer_mint_volume) total_transfer_mint_volume,
       sum(total_transfer_mint_count)  total_transfer_mint_count,
       sum(total_transfer_burn_volume) total_transfer_burn_volume,
       sum(total_transfer_burn_count)  total_transfer_burn_count,
       sum(total_transfer_volume + total_transfer_to_volume + total_transfer_mint_volume +
           total_transfer_burn_volume) total_transfer_all_volume,
       sum(total_transfer_count + total_transfer_to_count + total_transfer_mint_count + total_transfer_burn_count)       total_transfer_all_count,
       max(updated_block_height)       updated_block_height
from (
         select address,
                case
                    when token = '0x6ba6f2207e343923ba692e5cae646fb0f566db8d'
                        then '0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb'
                    else token
                    end as                      token,
                sum(balance)                    balance,
                sum(total_transfer_volume)      total_transfer_volume,
                sum(total_transfer_count)       total_transfer_count,
                sum(total_transfer_to_volume)   total_transfer_to_volume,
                sum(total_transfer_to_count)    total_transfer_to_count,
                sum(total_transfer_mint_volume) total_transfer_mint_volume,
                sum(total_transfer_mint_count)  total_transfer_mint_count,
                sum(total_transfer_burn_volume) total_transfer_burn_volume,
                sum(total_transfer_burn_count)  total_transfer_burn_count,
                min(updated_block_height)       updated_block_height
         from nft_holding_record
         group by address, token, transaction_hash, nft_token_id) t
group by address,
         token;


insert into nft_holding(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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


insert into nft_holding(address, token, balance, total_transfer_volume, total_transfer_count, total_transfer_to_volume,
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
               and token = #{token}
                and block_number <![CDATA[<=]]> #{maxHeight}
                and block_number <![CDATA[>]]> #{minHeight}
     group by from_address, token)