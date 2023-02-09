truncate table token_holding_vol_count;
insert into
    token_holding_vol_count(address,
                            token,
                            total_transfer_volume,
                            total_transfer_count,
                            count_level,
                            total_transfer_to_count,
                            total_transfer_all_count,
                            total_transfer_to_volume,
                            total_transfer_all_volume)
select
    address,
    token,
    sum(total_transfer_volume) total_transfer_volume,
    sum(total_transfer_count) total_transfer_count,
    case
      when sum(total_transfer_count) >= 1
          and sum(total_transfer_count) < 10 then 'L1'
      when sum(total_transfer_count) >= 10
          and sum(total_transfer_count) < 40 then 'L2'
      when sum(total_transfer_count) >= 40
          and sum(total_transfer_count) < 80 then 'L3'
      when sum(total_transfer_count) >= 80
          and sum(total_transfer_count) < 120 then 'L4'
      when sum(total_transfer_count) >= 120
          and sum(total_transfer_count) < 160 then 'L5'
      when sum(total_transfer_count) >= 160
          and sum(total_transfer_count) < 200 then 'L6'
      when sum(total_transfer_count) >= 200
          and sum(total_transfer_count) < 400 then 'Low'
      when sum(total_transfer_count) >= 400
          and sum(total_transfer_count) < 619 then 'Medium'
      when sum(total_transfer_count) >= 619 then 'High'
    end as "count_level",
    sum(total_transfer_to_count) as total_transfer_to_count,
    sum(total_transfer_all_count) as total_transfer_all_count,
    sum(total_transfer_to_volume) as total_transfer_to_volume,
    sum(total_transfer_all_volume) total_transfer_all_volume
from
    (
        select
            from_address address,
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
            token ) atb group by  address,token;



