DROP TABLE IF EXISTS public.nft_platform;
CREATE TABLE public.nft_platform (
                                       address varchar NOT NULL,
                                       platform varchar NOT NULL,
                                       platform_name varchar NULL,
                                       created_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
                                       updated_at timestamptz NULL DEFAULT CURRENT_TIMESTAMP,
                                       "removed" bool DEFAULT false,
                                       CONSTRAINT nft_platform_un UNIQUE (address, platform)
);
truncate table nft_platform;
vacuum nft_platform;

insert into nft_platform (address, platform,platform_name)
select address, platform,platform_group  from platform_nft_holding
group by address, platform,platform_group;