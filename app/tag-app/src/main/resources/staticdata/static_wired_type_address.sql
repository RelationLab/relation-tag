DROP TABLE if EXISTS  static_wired_type_address;
create table static_wired_type_address
(
    wired_type  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_wired_type_address;
vacuum static_wired_type_address;

insert into static_wired_type_address  (wired_type,address_num)
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
            address_label_gp where 1=1 
        group by
            wired_type,
            address) out_t
group by
    wired_type;
insert into tag_result(table_name,batch_date)  SELECT 'static_wired_type_address' as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;
