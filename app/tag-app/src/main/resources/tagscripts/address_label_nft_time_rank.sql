drop table if exists address_label_nft_time_rank;
CREATE TABLE public.address_label_nft_time_rank (

                                                    address varchar(512) NULL,
                                                    data numeric(250, 20) NULL,
                                                    wired_type varchar(20) NULL,
                                                    label_type varchar(512) NULL,
                                                    label_name varchar(1024) NULL,
                                                    updated_at timestamp(6) NULL,
    "group" varchar(1) NULL,
    "level" varchar(50) NULL,
    category varchar(50) NULL,
    trade_type varchar(50) NULL,
    project varchar(50) NULL,
    asset varchar(50) NULL
);
truncate table public.address_label_nft_time_rank;
insert into public.address_label_nft_time_rank(address,label_type,label_name,data,wired_type,updated_at,"group",level,category,trade_type,project,asset)
select
    a1.address,
    a2.label_type,
    a2.label_type || '_' || case
                                when counter >= 155 then 'LONG_TERM_HOLDER'
                                when counter >= 1
                                    and counter < 155 then 'SHORT_TERM_HOLDER'
        end as label_name,
    counter  as data,
    'NFT'  as wired_type,
    now() as updated_at,
    't'  as "group",
    case
    when counter >= 155 then 'LONG_TERM_HOLDER'
    when counter >= 1
    and counter < 155 then 'SHORT_TERM_HOLDER' end  as level,
    'rank' as category,
    a2.type as trade_type,
    a2.project_name as project,
    a2.token_name as asset
    from
    (
        select
            token,
            address,
            floor((floor(extract(epoch from now())) - nht.latest_tx_time) / (24 * 3600)) as counter
        from
            nft_holding_time nht
        where
            nht.latest_tx_time is not null
          and balance > 0) a1
        inner join
    dim_project_token_type a2
    on
            a1.token = a2.token
    where
        a2.data_subject = 'time_special'
  and a2.label_type like '%NFT%'
  and a2.label_type not like '%WEB3%'
  and counter >= 1
  and counter <= 365
  and (a2.type = ''
    or a2.type = 'ALL')
  and (a2.project = ''
    or a2.project = 'ALL') and address <>'0x000000000000000000000000000000000000dead';