drop table if exists total_balance_volume_usd;

CREATE TABLE public.total_balance_volume_usd (
                                                 address varchar(512) NOT NULL,
                                                 balance_usd numeric(250, 20) NULL,
                                                 volume_usd numeric(250, 20) NULL,
                                                 created_at timestamp(6) NULL,
                                                 updated_at timestamp(6) NULL,
                                                 removed bool NULL
);
truncate table total_balance_volume_usd;

insert into total_balance_volume_usd(address, balance_usd, volume_usd)
     (select address, sum(balance_usd), sum(volume_usd) from token_balance_volume_usd where address is not null group by address);
