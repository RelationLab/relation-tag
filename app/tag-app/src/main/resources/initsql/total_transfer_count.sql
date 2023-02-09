

insert into total_transfer_count(address, transfer_count, "count_level")
    (
    SELECT address, transfer_count,
          case
              when transfer_count >= 1
                  and transfer_count < 10 then 'L1'
              when transfer_count >= 10
                  and transfer_count < 40 then 'L2'
              when transfer_count >= 40
                  and transfer_count < 80 then 'L3'
              when transfer_count >= 80
                  and transfer_count < 120 then 'L4'
              when transfer_count >= 120
                  and transfer_count < 160 then 'L5'
              when transfer_count >= 160
                  and transfer_count < 200 then 'L6'
              when transfer_count >= 200
                  and transfer_count < 400 then 'Low'
              when transfer_count >= 400
                  and transfer_count < 619 then 'Medium'
              when transfer_count >= 619 then 'High'
          end as "count_level"
          from (
              select address, sum(transfer_count) as transfer_count from token_holding_vol_count where address is not null group by address
          ) a
    );