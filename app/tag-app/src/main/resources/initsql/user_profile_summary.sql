SELECT address, json_build_object(
    "assetAnalysis": json_build_object(
        "totalBalance": tbvu1.balance_usd,
        "totalBalanceLevel": tbvu1.balance_level,
        "totalVolume": tvu1.volume_usd,
        "totalVolumeLevel": tbvu1.volume_level,
        "totalTransferCount": ttc.transfer_count,
        "totalTransferLevel": ttc.count_level,
        "assets": json_agg(
            json_build_object(
                'name', drt.token_name,
                'token', drt.token_id,
                'type', drt.asset_type,
                'balance', tbvu.balance_usd,
                'balanceLevel', tbvu.balance_level,
                'volume', tvu.volume,
                'volumeLevel', tvu.volume_level,
                'transferCount', thvc.transfer_count,
                'countLevel', thvc.count_level
            )
        )
    ),

)
from token_holding_vol_count thvc
left join token_balance_volume_usd tbvu on tbvu.address = thvc.address and thvc.token = thvc.token
left join token_volume_usd tvu on thvc.address = tvu.address and thvc.token = tvu.token
left join dim_rank_token drt on tvu.token = drt.token_id
left join total_transfer_count ttc on ttc.address = thvc.address
left join total_volume_usd tvu1 on tvu1.address = thvc.address
left join total_balance_volume_usd tbvu1 on tbvu1.address = thvc.address
group by tvu.address