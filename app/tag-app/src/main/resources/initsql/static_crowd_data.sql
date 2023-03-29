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
            case when label_name='crowd_active_users' then 'Active users'
                 when label_name='crowd_elite' then 'Elite'
                 when label_name='crowd_nft_active_users' then 'NFT active users'
                 when label_name='crowd_long_term_holder' then 'Long-term holder'
                 when label_name='crowd_nft_whale' then 'NFT whale'
                 when label_name='crowd_nft_high_demander' then 'NFT high demander'
                 when label_name='crowd_token_whale' then 'oken whale'
                 when label_name='crowd_defi_active_users' then 'DeFi active users'
                 when label_name='crowd_defi_high_demander' then 'DeFi high demander'
                 when label_name='crowd_web3_active_users' then 'Web3 active users'
                 else 'undefine'
                end as label_name
                ,
            address
        from
            address_label_gp_test where label_name in('crowd_active_users',
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


