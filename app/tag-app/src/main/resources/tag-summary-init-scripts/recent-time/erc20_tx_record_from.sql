insert into
    erc20_tx_record_from(address,
                         token,
                         block_height,
                         total_transfer_volume,
                         total_transfer_count,
                         recent_time_code)
select
    from_address address,
    token,
    max(block_number) as block_height,
    sum(amount) total_transfer_volume,
    sum(case
            when sender = from_address then 1
            else 0
        end ) total_transfer_count,
    '${recentTimeCode}' recent_time_code
from erc20_tx_record
where erc20_tx_record.block_number >= ${recentTimeBlockHeight}
and erc20_tx_record.hash not in(
        ---------OMG--------------
        '0x8fd7391b8d8ceeb907f891b0e2fc479206c837b06d3446facf03794161e9d75c',
        '0xad9e98bc7b4146d19473a1ec8601d946840b91d0c2a8da711841cdfa3739b810',
        ---------MANA--- 0x0f5d2fb29fb7d3cfee444a200298f468908cc942-----------
        '0xde99cab6cdd2011479e84cc46f3b0fea3594ed345922a825785c4a4ccfd9808f',
        '0xae5df58211a8f2bc9dcc7040c2a15a2762bf2a149755b8c83d6e27eca557a9b6',
        '0x8fff10a34ba8bee4f2c37aaf75fb890e1d146adbecb696bb8a67eeb03bb340ac',
        ---------VVS--- 0x839e71613f9aa06e5701cf6de63e303616b0dde3-----------
        '0x91eb4de2a9d8048fbdf15f2a64228784ebc50e9bc1bacb9a78c069de7477fdff',
        ---------COTI--- 0xddb3422497e61e13543bea06989c0789117555c5-----------
        '0x200ba9b29e5f56b98ac5d52f4c19929616540345e86f968917540b439346509b',
        '0xee42ee13bab169ffbc04b330d4ffe9f2bb2bde3c7bd85512876225a0521b59e6',
        '0x6b4849d05502da93170bc4f75c75e3c9ac945c7684e30c1cb884afdc2b01730a',
        '0x51dce51ee7738db8acb5de7c366ff876aeeb4a170a3f89ddb02a3d3e5d376e12',
        '0xd36940dad40aa23e0a0184390090ce40e5f35c26aafa6c28dc67a8698ea6ef00',
        '0x573e3a0046fd806fd56cebdee77fa1af6d0cacc972debc850ce7e42d40394a75',
        '0x7f0877f6b2ea17a496bff75e75d0f39a73d385935f89a0c67607853928b25721',
        '0x83ec20f4fe947efb69982ee5b3a5bb9841d07bd3725ca6eaf45fd2eeb0387cda',
        '0x561551aaada7cddd98641a29730f810314bd57d863dfae2e97fa634dadb57a4e',
        ---------Dentacoin--- 0x08d32b0da63e2c3bcf8019c9c5d849d7a9d791e6-----------
        '0x226b59db0805cbbf90023ecac07c9b16f387e5e4d86d18e43494679c67d808d0',
        '0x5402f1c7031adc0032691d6199bcc420579886cdb29d01e2bb0435cb8c74c971',
        '0x89777b2cd16c1e4be4ad1b3f5c67bcc6009dee9fa51d1f1703eca3a5fcc9b7f9',
        '0xaa185bb6e8de62154108b1270ee7839ce19197cff3dd369d6b553e56af0d1f7e',
        '0xbde82d6ba6cce5c7416537196d926f2daee2ed6ea069f006f9eda3cc825e6429',
        '0x6036ff50582d48fc22ca586316abbe08911c5020c205778dfd31b88f83a56389',
        '0x909e92d51fd7c6043e61a67e14eaca98d3ad40f838882033281ea3c3da8d3ce4',
        '0x488003dd7e73ac4d27b618a146ecce650c0339a223a7ef632744bc7a9313e2ae',
        '0x2de29043bffc4a10c319f15b051ffbaa875279b21991f7ebff13f4bac8cb1b38',
        '0x9b8162eb96fcf3dae8ee993153e37fff603fd0a4854cdb4afd0c40c3faed05be',
        '0x595fb7d460d7f8b2063c794732fb7df8c356dd975143b6d90c4c37924f6c83f3',
        '0x0f2d33828d747c94e661ce58e71c38a8a0ce26fd621091ed46cc756461e35808',
        '0x0a530c2990b1d1af54be2c26ea992f8ff9a4dc8fbb24a0af6e78da4ce973ab7e',
        '0x6c9d8baf59f3e8d60a2454b2f8606731118ce3112646133ddb79b2962e6767e0'
                               )
group by
    from_address,
    sender,
    token;
insert into tag_result(table_name,batch_date)  SELECT 'erc20_tx_record_from_${recentTimeCode}' as table_name,'${batchDate}'  as batch_date;
