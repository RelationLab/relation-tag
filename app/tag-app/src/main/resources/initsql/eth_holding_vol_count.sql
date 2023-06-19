drop table if exists eth_holding_vol_count;
-- ALTER TABLE public.eth_holding_vol_count RENAME TO eth_holding_vol_count_tmp;
CREATE TABLE public.eth_holding_vol_count (
                                              address varchar(256) NULL,
                                              balance numeric(125, 30) NULL,
                                              total_transfer_count int8 NULL,
                                              block_height int8 NULL,
                                              total_transfer_volume numeric(120, 30) NULL,
                                              status varchar(128) NULL,
                                              created_at timestamp NULL,
                                              updated_at timestamp NULL,
                                              removed bool NULL,
                                              fail_count int4 NULL,
                                              error_code int4 NULL,
                                              error_message text NULL,
                                              node_name varchar(512) NULL,
                                              total_transfer_to_count int8 NULL,
                                              total_transfer_all_count int8 NULL,
                                              total_transfer_to_volume numeric(120, 30) NULL,
                                              total_transfer_all_volume numeric(120, 30) NULL
) distributed by (address);
truncate table eth_holding_vol_count;
vacuum eth_holding_vol_count;

insert
into
    eth_holding_vol_count(address,
                          block_height,
                          total_transfer_volume,
                          total_transfer_count,
                          total_transfer_to_count,
                          total_transfer_all_count,
                          total_transfer_to_volume,
                          total_transfer_all_volume)
select
    address,
    max(block_height) as block_height,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
from
    (
        select
            from_address address,
            max(block_number) as block_height,
            sum(amount) total_transfer_volume,
            sum(1) total_transfer_count,
            0 as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            0 as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            eth_tx_record etr
        where
            tx_type!='ETH_INTERNAL'
        group by
            from_address
        union all
        select
            to_address address,
            max(block_number) as block_height,
            0 as total_transfer_volume,
            0 as total_transfer_count,
            sum(1) as total_transfer_to_count,
            sum(1) total_transfer_all_count,
            sum(amount) as total_transfer_to_volume,
            sum(amount) total_transfer_all_volume
        from
            eth_tx_record etr
        where
                tx_type!='ETH_INTERNAL'
        group by
            to_address) atb where address !=''
group by
    address;
insert into tag_result(table_name,batch_date)  SELECT 'eth_holding_vol_count' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;



