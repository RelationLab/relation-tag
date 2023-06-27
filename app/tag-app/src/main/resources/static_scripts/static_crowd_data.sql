DROP TABLE if EXISTS  static_crowd_data${tableSuffix};
create table static_crowd_data${tableSuffix}
(
    static_code  varchar(200) not null,
    address_num numeric(250, 20) NULL
);
truncate table static_crowd_data${tableSuffix};

insert into static_crowd_data${tableSuffix}(static_code,address_num)
select
    label_name as static_code,
    count(1) as address_num
from
    (
        select
            count(1),
            case when label_name='crowd_active_users' then 'Active users'
                 when label_name='crowd_elite' then 'Elite'
                 when label_name='crowd_nft_active_users' then 'NFT active users'
                 when label_name='crowd_long_term_holder' then 'Long-term holder'
                 when label_name='crowd_nft_whale' then 'NFT whale'
                 when label_name='crowd_nft_high_demander' then 'NFT high demander'
                 when label_name='crowd_token_whale' then 'Token whale'
                 when label_name='crowd_defi_active_users' then 'DeFi active users'
                 when label_name='crowd_defi_high_demander' then 'DeFi high demander'
                 when label_name='crowd_web3_active_users' then 'Web3 active users'
                 else 'undefine'
                end as label_name
                ,
            algout.address
        from
            address_label_gp_${configEnvironment} algout         inner join address_init${tableSuffix} ais  on(algout.address=ais.address)
        where label_name in('crowd_active_users',
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
            algout.address) out_t
group by
    label_name;
INSERT INTO tag_result${tableSuffix}(table_name,batch_date) select ('static_crowd_data${tableSuffix}') as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date;



