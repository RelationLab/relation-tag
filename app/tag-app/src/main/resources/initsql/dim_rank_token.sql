drop table if exists dim_rank_token;
create table dim_rank_token
(
    token_id   varchar(512),
    asset_type varchar(10)
);
insert into dim_rank_token
select distinct token,token_type from dim_rule_content;












