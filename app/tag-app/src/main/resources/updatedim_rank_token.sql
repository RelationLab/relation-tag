update
    dim_rank_token b
set
    token_name = a.token_name
    from
	(
	select
		"token",
		min(seq_flag) as token_name
	from
		dim_project_token_type
	where
		label_name like '%NFT%'
	group by
		"token" ) a
where
    b.token_id = a.token ;

update dim_rank_token  b
set token_name =  a.token_name
    FROM   (select token,
	min(token_name)  as token_name
from
	dim_rule_content drc
group by
	token ) a where  b.token_id = a.token
;
