drop table if exists dim_rule_content;
create table dim_rule_content
(
    rule_code    varchar(50),
    token        varchar(300),
    label_type   varchar(300),
    operate_type varchar(300),
    data_subject varchar(20),
    create_time  timestamp,
    token_name   varchar(100),

    token_type   varchar(100)
);