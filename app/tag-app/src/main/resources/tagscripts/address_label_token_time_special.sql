truncate table public.address_label_token_time_special;
insert into public.address_label_token_time_special (address, label_type, label_name, updated_at)
select a1.address,
       a2.label_type,
       a2.label_type || ''_''||case
           when counter >= 155 then ''LONG_TERM_HOLDER''
           when counter >= 1
               and counter < 155 then ''SHORT_TERM_HOLDER''
           end as label_name, now() as updated_at
from (select address,
             token,
             counter
      from token_holding_time tbvutk
      where balance > 0) a1
         inner join
     dim_rule_content a2
     on
         a1.token = a2.token
where a2.data_subject = ''time_special'' and counter >= 1 and a2.token_type=''token'';