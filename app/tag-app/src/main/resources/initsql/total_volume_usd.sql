

insert into total_volume_usd(address, volume_usd, "volume_level")
    (
    SELECT address, total_volume,
          case
            when total_volume >= 100
                    and total_volume < 1000 then 'L1'
            when total_volume >= 1000
                    and total_volume < 10000 then 'L2'
            when total_volume >= 10000
                    and total_volume < 50000 then 'L3'
            when total_volume >= 50000
                    and total_volume < 100000 then 'L4'
            when total_volume >= 100000
                    and total_volume < 500000 then 'L5'
            when total_volume >= 500000
                    and total_volume < 1000000 then 'L6'
            when total_volume >= 1000000
                    and total_volume < 1000000000 then 'Million'
            when total_volume >= 1000000000 then 'Billion'
          end as "volume_level"
          from (
              select address,  sum(volume_usd) as total_volume from token_volume_usd where address is not null group by address
          ) a
    );