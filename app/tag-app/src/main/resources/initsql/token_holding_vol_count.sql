drop table if exists token_holding_vol_count;
CREATE TABLE public.token_holding_vol_count (
                                                address varchar(256) NULL,
                                                "token" varchar(256) NULL,
                                                balance numeric(125, 30) NULL,
                                                block_height bigint NULL,
                                                total_transfer_volume numeric(125, 30) NULL,
                                                total_transfer_count bigint NULL,
                                                recent_time_code varchar(30) NULL,
                                                created_at timestamp NULL,
                                                updated_at timestamp NULL
) distributed by (address);

truncate table token_holding_vol_count;
vacuum token_holding_vol_count;

insert into
    token_holding_vol_count(address,
                            block_height,
                            token,
                            total_transfer_volume,
                            total_transfer_count)
select
    address,
    max(block_height) as block_height,
    token,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    recent_time_code
from
    (
        select
            address address,
            max(block_height) as block_height,
            token,
            sum(total_transfer_volume) total_transfer_volume,
            sum(total_transfer_count) total_transfer_count,
            recent_time_code
        from
            erc20_tx_record_from e20tr
        group by
            address,
            token,
            recent_time_code
        union all
        select
                      to_address address,
                      max(block_number) as block_height,
                      token,
                      sum(amount)  as total_transfer_volume,
                      0 as total_transfer_count,
                      recent_time_code
        from
            erc20_tx_record_to e20tr
        group by
            to_address,
            token ) atb where address !=''

                        group by  address,token,recent_time_code;
insert into tag_result(table_name,batch_date)  SELECT 'token_holding_vol_count' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
