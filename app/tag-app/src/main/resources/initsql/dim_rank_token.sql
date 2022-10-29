drop table if exists dim_rank_token;
CREATE TABLE public.dim_rank_token (
    token_id varchar(512) NULL
);
insert into dim_rank_token select distinct token from dim_rule_content;
