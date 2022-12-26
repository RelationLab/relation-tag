
    insert
    into
        web3_transaction_record_summary(address,
                                        total_transfer_volume,
                                        total_transfer_count,
                                        type,
                                        project,
                                        balance)
    select
        address,
        sum(total_transfer_volume) as total_transfer_volume ,
        sum(total_transfer_count) as total_transfer_count ,
        type ,
        project,
        sum(balance) as balance
    from
        web3_transaction_record
    group by
        address,
        type ,
        project;

update web3_transaction_record_summary set type ='mint' where type='Mint';
update web3_transaction_record_summary set type ='write' where type='Write';
