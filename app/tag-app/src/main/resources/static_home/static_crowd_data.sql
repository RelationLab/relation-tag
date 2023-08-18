DROP TABLE if EXISTS  static_crowd_data${tableSuffix};
create table static_crowd_data${tableSuffix}
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_crowd_data${tableSuffix};
vacuum static_crowd_data${tableSuffix};

insert into static_crowd_data${tableSuffix}(static_code,address_num)
select
    label_name as static_code,
    count(1) as address_num
from
    (
        select
            count(address),
            case when label_name='cau' then 'Active users'
                 when label_name='crowd_elite' then 'Elite'
                 when label_name='cnau' then 'NFT active users'
                 when label_name='clth' then 'Long-term holder'
                 when label_name='cnw' then 'NFT whale'
                 when label_name='cnhd' then 'NFT high demander'
                 when label_name='ctw' then 'Token whale'
                 when label_name='cdau' then 'DeFi active users'
                 when label_name='cdhd' then 'DeFi high demander'
                 when label_name='cwau' then 'Web3 active users'
                 else 'undefine'
                end as label_name
                ,
            address
        from
            address_label_gp${tableSuffix} where (recent_time_code ='ALL' OR recent_time_code IS NULL) AND
                                                 label_name in('cau',
                                                 'crowd_elite',
                                                 'cnau',
                                                 'clth',
                                                 'cnw',
                                                 'cnhd',
                                                 'ctw',
                                                 'cdau',
                                                 'cdhd',
                                                 'cwau')
        group by
            label_name,
            address) out_t
group by
    label_name;
insert into tag_result${tableSuffix}(table_name,batch_date)  SELECT 'static_crowd_data${tableSuffix}' as table_name,'${batchDate}'  as batch_date;


