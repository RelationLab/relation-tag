DROP TABLE if EXISTS  static_wired_type_address${tableSuffix};
create table static_wired_type_address${tableSuffix}
(
    wired_type  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_wired_type_address${tableSuffix};
insert into static_wired_type_address${tableSuffix}  (wired_type,address_num)
select
    wired_type,
    count(1) as address_num
from
    (
        select
            count(1),
            wired_type,
            algout.address
        from
    address_label_gp_${configEnvironment} algout
        inner join address_init${tableSuffix} ais  on(algout.address=ais.address)
        group by
            wired_type,
            algout.address) out_t
group by
    wired_type;
INSERT INTO tag_result${tableSuffix}(table_name,batch_date) select ('static_wired_type_address${tableSuffix}') as table_name,'${batchDate}'  as batch_date;