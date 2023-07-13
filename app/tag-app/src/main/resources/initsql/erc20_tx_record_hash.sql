drop table if exists erc20_tx_record_hash;
CREATE TABLE public.erc20_tx_record_hash(
                                                 address varchar(256) NULL,
                                                 "token" varchar(256) NULL,
                                                 block_height bigint NULL,
                                                 total_transfer_volume numeric(125, 30) NULL,
                                                 total_transfer_count bigint NULL,
                                                 created_at timestamp NULL,
                                                 total_transfer_to_count bigint NULL,
                                                 total_transfer_all_count bigint NULL,
                                                 total_transfer_to_volume numeric(120, 30) NULL,
                                                 total_transfer_all_volume numeric(120, 30) NULL,
                                                 recent_time_code varchar(30) NULL
) distributed by (address,"token");
truncate table erc20_tx_record_hash;
vacuum erc20_tx_record_hash;
insert into
    erc20_tx_record_hash(address,
                              token,
                              block_height,
                              total_transfer_volume,
                              total_transfer_count,
                              total_transfer_to_count,
                              total_transfer_all_count,
                              total_transfer_to_volume,
                              total_transfer_all_volume,
                              recent_time_code)

select
    from_address address,
    token,
    max(block_number) as block_height,
    sum(amount) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    0 as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    0 as total_transfer_to_volume,
    sum(amount) total_transfer_all_volume,
    recent_time_code
from
    (
        select
            sender,
            from_address,
            token,
            block_number,
            case
                when erc20_tx_record.block_number >= recent_time.block_height then amount
                else 0
                end as amount,
            case
                when sender = from_address
                    and erc20_tx_record.block_number >= recent_time.block_height then 1
                else 0
                end total_transfer_count,
            case
                when sender = from_address
                    and erc20_tx_record.block_number >= recent_time.block_height then 1
                else 0
                end total_transfer_all_count,
            recent_time.recent_time_code
        from
            erc20_tx_record
                inner join recent_time on
                (1 = 1) ) e20tr
group by
    from_address,
    sender,
    token,
    recent_time_code;
insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_hash' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
