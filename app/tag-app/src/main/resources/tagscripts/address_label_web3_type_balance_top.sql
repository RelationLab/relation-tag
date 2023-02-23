drop table if exists address_label_web3_type_balance_top;
CREATE TABLE public.address_label_web3_type_balance_top (

                                                            address varchar(512) NULL,
                                                            data numeric(250, 20) NULL,
                                                            wired_type varchar(20) NULL,
                                                            label_type varchar(512) NULL,
                                                            label_name varchar(1024) NULL,
                                                            updated_at timestamp(6) NULL,
                                                            "group" varchar(1) NULL,
                                                            "level" varchar(20) NULL,
                                                            category varchar(20) NULL,
                                                            trade_type varchar(30) NULL,
                                                            project varchar(50) NULL,
                                                            asset varchar(50) NULL
);
truncate table address_label_web3_type_balance_top;
insert into public.address_label_web3_type_balance_top(address,label_type,label_name,data,wired_type,updated_at,group,level,category,trade_type,project,asset)
    select
    address,
    label_type,
    label_type || '_' || 'WHALE' as label_name,
    rn  as data,
    'WEB3'  as wired_type,
    now() as updated_at
    from
    (
        select
            address,
            (
                select
                    distinct label_type
                from
                    dim_project_type dptt
                where
                        dptt.project = s1.project
                  and dptt.type = s1.type
                  and dptt.data_subject = 'balance_top'
                limit 1) as label_type,
            rn
    from
		(
		select
			a1.address,
			a2.label_type,
			a2.type,
			a2.project,
			-- 分组字段很关键
            row_number() over( partition by a2.type,a2.project
		order by
			balance desc,
			address asc) as rn
		from
			(
			select
				address,
				type,
				project,
				sum(balance) as balance
			from
				(
				-- project-type
				select
					address,
					type ,
					project,
					balance
				from
					web3_transaction_record_summary
				where
					balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(ALL)-type
				select
					address,
					type,
					'ALL' as project,
					balance
				from
					web3_transaction_record_summary
				where
					balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project(ALL)-type(ALL)
				select
					address,
					'ALL' as type,
					'ALL' as project,
					balance
				from
					web3_transaction_record_summary
				where
					balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
			union all
				-- project-type(ALL)
				select
					address,
					'ALL' as type,
					project,
					balance
				from
					web3_transaction_record_summary
				where
					balance >= 1 and address <>'0x000000000000000000000000000000000000dead'
               ) totala
			group by
				address,
				type,
				project)
            a1
		inner join dim_project_type a2
            on
			a1.project = a2.project
			and a1.type = a2.type
			and a2.data_subject = 'balance_top'
    ) s1
    where
    s1.rn <= 100) t ;