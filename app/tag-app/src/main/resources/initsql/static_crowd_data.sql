DROP TABLE if EXISTS  static_crowd_data;
create table static_crowd_data
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_crowd_data;

insert into static_crowd_data(static_code,address_num)
select
    label_name as static_code,
    count(1) as address_num
from
    (
        select
            count(address),
            label_name,
            address
        from
            address_label_gp where label_name in('crowd_active_users',
                                                 'crowd_elite',
                                                 'crowd_nft_active_users',
                                                 'crowd_long_term_holder',
                                                 'crowd_nft_whale',
                                                 'crowd_nft_high_demander',
                                                 'crowd_token_whale',
                                                 'crowd_defi_active_users',
                                                 'crowd_defi_high_demander',
                                                 'crowd_web3_active_users')
        group by
            label_name,
            address) out_t
group by
    label_name;