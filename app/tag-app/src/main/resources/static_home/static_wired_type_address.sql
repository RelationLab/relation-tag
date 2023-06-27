DROP TABLE if EXISTS  static_wired_type_address${tableSuffix};
create table static_wired_type_address${tableSuffix}
(
    wired_type  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_wired_type_address${tableSuffix};
vacuum static_wired_type_address${tableSuffix};

insert into static_wired_type_address${tableSuffix}  (wired_type,address_num)
select
    wired_type,
    count(1) as address_num
from
    (
        select
            count(distinct address),
            wired_type,
            address
        from
            address_label_gp${tableSuffix} where 1=1
        group by
            wired_type,
            address) out_t
group by
    wired_type;
insert into tag_result${tableSuffix}(table_name,batch_date)  SELECT 'static_wired_type_address${tableSuffix}' as table_name,'${tagBatch}'  as batch_date;
