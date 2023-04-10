drop table if exists token_holding_vol_count_tmp;
ALTER TABLE public.token_holding_vol_count RENAME TO token_holding_vol_count_tmp;
CREATE TABLE public.token_holding_vol_count (
                                                address varchar(256) NULL,
                                                "token" varchar(256) NULL,
                                                balance numeric(125, 30) NULL,
                                                block_height bigint NULL,
                                                total_transfer_volume numeric(125, 30) NULL,
                                                total_transfer_count bigint NULL,
                                                status varchar(128) NULL,
                                                created_at timestamp NULL,
                                                updated_at timestamp NULL,
                                                removed bool NULL,
                                                fail_count int4 NULL,
                                                error_code int4 NULL,
                                                error_message text NULL,
                                                node_name varchar(512) NULL,
                                                total_transfer_to_count bigint NULL,
                                                total_transfer_all_count bigint NULL,
                                                total_transfer_to_volume numeric(120, 30) NULL,
                                                total_transfer_all_volume numeric(120, 30) NULL
) distributed by (address);

truncate table token_holding_vol_count;
vacuum token_holding_vol_count;

insert into
    token_holding_vol_count(address,
                            block_height,
                            token,
                            total_transfer_volume,
                            total_transfer_count,
                            total_transfer_to_count,
                            total_transfer_all_count,
                            total_transfer_to_volume,
                            total_transfer_all_volume)
select
    address,
    max(block_height) as block_height,
    token,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
from
    (
        select
            address,
            max(block_height) as block_height,
            token,
            sum(total_transfer_volume) total_transfer_volume,
            sum(total_transfer_count) total_transfer_count,
            sum(total_transfer_to_count) as total_transfer_to_count,
            sum(total_transfer_all_count) total_transfer_all_count,
            sum(total_transfer_to_volume) as total_transfer_to_volume,
            sum(total_transfer_all_volume) total_transfer_all_volume
        from
            token_holding_vol_count_tmp thvc
        group by
            address,
            token
        union all
        select
            from_address address,
            max(block_number) as block_height,
            token,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            0 as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            erc20_tx_record
        group by
            from_address,
            token

        union all select
                      to_address address,
                      max(block_number) as block_height,
                      token,
                      0 as total_transfer_volume,
                      0 as total_transfer_count,
                      sum(1) as total_transfer_to_count,
                      sum(1) total_transfer_all_count,
                      sum(amount) as total_transfer_to_volume,
                      sum(amount) total_transfer_all_volume
        from
            erc20_tx_record
        group by
            to_address,
            token ) atb where address !='' group by  address,token;

insert into
    token_holding_vol_count_tmp(address,
                            block_height,
                            token,
                            total_transfer_volume,
                            total_transfer_count,
                            total_transfer_to_count,
                            total_transfer_all_count,
                            total_transfer_to_volume,
                            total_transfer_all_volume)
select address,
       block_height,
       token,
       total_transfer_volume,
       total_transfer_count,
       total_transfer_to_count,
       total_transfer_all_count,
       total_transfer_to_volume,
       total_transfer_all_volume
from token_holding_vol_count limit 10;