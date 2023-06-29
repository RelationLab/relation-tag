drop table if exists dim_project_token_type;
create table dim_project_token_type
(
    project  varchar(100)
    ,token    varchar(100)
    ,type   varchar(100)
    ,label_type   varchar(100)
    ,label_name  varchar(100)
    ,content   varchar(100)
    ,operate_type   varchar(100)
    ,seq_flag varchar(100)
    ,data_subject varchar(100)
    ,etl_update_time timestamp
    ,project_name varchar(100)
    ,token_name varchar(100)
);
truncate table dim_project_token_type;