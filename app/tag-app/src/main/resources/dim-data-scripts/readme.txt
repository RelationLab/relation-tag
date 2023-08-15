**************************资产*********************************
t-表示token
l-表示lp
n-表示nft
w-表示web3

**************************平台*********************************
d-dex
e-eth2.0
i-lending
m-mp

****************************交易类型*****************************
o-表示交易类型

**************************等级*********************************
cg-活跃度等级
ve-活跃度ELITE
vg-交易量等级
vr-交易量范围
vt-交易量top
bg-余额等级
br-余额范围
bt-余额top
tg-时间等级

ts-TIME_SPECIAL
ea-TIME_SMART_NFT_EARLY_ADOPTER
tf-HOLDING_TIME_FIRST_MOVER_LP
bhl-BALANCE_HEAVY_LP
bf-BALANCE_FIRST_MOVER_STAKING
bhs-BALANCE_HEAVY_LP_STAKER

*********************************************************dim_rule_content.sql start*********************************************************
***********************************LP*********************************
label_name                                label_type new_label_name 时间维度label_type 时间维度new_label_name
Uniswap_v3_UNI/WETH_0x1d42_BALANCE_GRADE  l1bg       l1bg1
Uniswap_v3_UNI/WETH_0x1d42_BALANCE_RANK   l1br       l1br1
Uniswap_v3_UNI/WETH_0x1d42_BALANCE_TOP    l1bt       l1bt1
Uniswap_v3_UNI/WETH_0x1d42_ACTIVITY       l1cg       l1cg1          3dl1cg            3dl1cg1
Uniswap_v3_UNI/WETH_0x1d42_VOLUME_GRADE   l1vg       l1vg1          3dl1vg            3dl1vg1
Uniswap_v3_UNI/WETH_0x1d42_VOLUME_RANK    l1vr       l1vr1          3dl1vr            3dl1vr1


***********************************token*********************************
label_name                                label_type new_label_name   时间维度label_type 时间维度new_label_name
ALL_DAI(0x6b1754)_ALL_BALANCE_GRADE         t1bg       t1bg1
ALL_ALL_ALL_BALANCE_GRADE                     bg         bg1
ALL_DAI(0x6b1754)_ALL_BALANCE_RANK          t1br       t1br1
ALL_ALL_ALL_BALANCE_RANK                      br         br1
ALL_DAI(0x6b1754)_ALL_BALANCE_TOP           t1bt       t1bt1
ALL_ALL_ALL_BALANCE_TOP                       bt         bt1
ALL_DAI(0x6b1754)_ALL_ACTIVITY              t1cg       t1cg1            3dt1cg           3dt1cg1
ALL_ALL_ALL_ACTIVITY                          cg         cg1            3dcg             3dcg1
DOP(0x6bb612)_HOLDING_TIME_GRADE            t1tg       t1tg1
DAI(0x6b1754)_HOLDING_TIME_SPECIAL          t1ts       t1ts1
ALL_DAI(0x6b1754)_ALL_VOLUME_GRADE          t1vg       t1vg1            3dt1vg           3dt1vg1
ALL_ALL_ALL_VOLUME_GRADE                    vg         vg1              3dvg             3dvg1
ALL_DAI(0x6b1754)_ALL_VOLUME_RANK           t1vr       t1vr1            3dt1vr           3dt1vr1
ALL_ALL_ALL_VOLUME_RANK                     vr         vr1              3dvr             3dvr1
*********************************************************dim_rule_content.sql end *********************************************************


*********************************************************dim_project_type.sql start*********************************************************
***********************************LP*********************************
label_name                                              label_type new_label_name 时间维度label_type 时间维度new_label_name
WEB3_RabbitHole_NFTRecipient_BALANCE_GRADE              w1o1bg       w1o1bg1
WEB3_RabbitHole_NFTRecipient_BALANCE_RANK               w1o1br       w1o1br1
WEB3_RabbitHole_NFTRecipient_BALANCE_TOP                w1o1bt       w1o1bt1
WEB3_RabbitHole_NFTRecipient_ACTIVITY                   w1o1cg       w1o1cg1        3dw1o1cg           3dw1o1cg1
*********************************************************dim_project_type.sql end*********************************************************


*********************************************************dim_project_token_type.sql start*********************************************************
***********************************LP*********************************
label_name                                              label_type new_label_name 时间维度label_type 时间维度new_label_name
Uniswap_v2_UNI/WETH_0xd3d2_HOLDING_TIME_FIRST_MOVER_LP  l1tf       l1tf1
Uniswap_v2_UNI/WETH_0xd3d2_BALANCE_HEAVY_LP             l1bhl      l1bhl1
Sushiswap_SYN/WETH_0x4a86_BALANCE_FIRST_MOVER_STAKING   l1bf       l1bf1
Sushiswap_SYN/WETH_0x4a86_BALANCE_HEAVY_LP_STAKER       l1bhs      l1bhs1

***********************************nft mp*********************************
label_name                                label_type new_label_name   时间维度label_type 时间维度new_label_name
Blur_CryptoPunks_Buy_MP_NFT_ACTIVITY      1n1mo1cg   1n1mo1cg1        3d1n1mo1cg       3d1n1mo1cg1
ALL_ALL_Buy_MP_NFT_ACTIVITY               mo1cg      mo1cg1           3d1mo1cg         3dmo1cg1
ALL_CryptoPunks_Buy_MP_NFT_ACTIVITY       n1mo1cg    n1mo1cg1         3dn1mo1cg        3dn1mo1cg1
Blur_ALL_Buy_MP_NFT_ACTIVITY              1mo1cg     1mo1cg1          3d1mo1cg         3d1mo1cg1

Blur_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE  1n1mo1ve   1n1mo1ve1        3d1n1mo1ve       3d1n1mo1ve1
ALL_ALL_Buy_MP_NFT_VOLUME_ELITE           mo1ve      mo1ve1           3d1mo1ve         3dmo1ve1
ALL_CryptoPunks_Buy_MP_NFT_VOLUME_ELITE   n1mo1ve    n1mo1ve1         3dn1mo1ve        3dn1mo1ve1
Blur_ALL_Buy_MP_NFT_VOLUME_ELITE          1mo1ve     1mo1ve1          3d1mo1ve         3d1mo1ve1

Blur_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE  1n1mo1vg   1n1mo1vg1        3d1n1mo1vg       3d1n1mo1vg1
ALL_ALL_Buy_MP_NFT_VOLUME_GRADE           mo1vg      mo1vg1           3d1mo1vg         3dmo1vg1
ALL_CryptoPunks_Buy_MP_NFT_VOLUME_GRADE   n1mo1vg    n1mo1vg1         3dn1mo1vg        3dn1mo1vg1
Blur_ALL_Buy_MP_NFT_VOLUME_GRADE          1mo1vg     1mo1vg1          3d1mo1vg         3d1mo1vg1

Blur_CryptoPunks_Buy_MP_NFT_VOLUME_RANK   1n1mo1vr   1n1mo1vr1        3d1n1mo1vr       3d1n1mo1vr1
ALL_ALL_Buy_MP_NFT_VOLUME_RANK            mo1vr      mo1vr1           3d1mo1vr         3dmo1vr1
ALL_CryptoPunks_Buy_MP_NFT_VOLUME_RANK    n1mo1vr    n1mo1vr1         3dn1mo1vr        3dn1mo1vr1
Blur_ALL_Buy_MP_NFT_VOLUME_RANK           1mo1vr     1mo1vr1          3d1mo1vr         3d1mo1vr1

Blur_CryptoPunks_Buy_MP_NFT_VOLUME_TOP    1n1mo1vt   1n1mo1vt1        3d1n1mo1vt       3d1n1mo1vt1
ALL_ALL_Buy_MP_NFT_VOLUME_TOP             mo1vt      mo1vt1           3d1mo1vt         3dmo1vt1
ALL_CryptoPunks_Buy_MP_NFT_VOLUME_TOP     n1mo1vt    n1mo1vt1         3dn1mo1vt        3dn1mo1vt1
Blur_ALL_Buy_MP_NFT_VOLUME_TOP            1mo1vt     1mo1vt1          3d1mo1vt         3d1mo1vt1

***********************************token dex*********************************
label_name                                label_type new_label_name   时间维度label_type 时间维度new_label_name
0x_USDC(0xa0b869)_ALL_ACTIVITY_DEX        1t1do1cg   1t1do1cg1        3d1t1do1cg       3d1t1do1cg1
ALL_USDC(0xa0b869)_ALL_ACTIVITY_DEX       t1do1cg    t1do1cg1         3dt1do1cg        3dt1do1cg1
1inch_ALL_ALL_ACTIVITY_DEX                1do1cg     1do1cg1          3d1do1cg         3d1do1cg1
ALL_ALL_ALL_ACTIVITY_DEX                  do1cg      do1cg1           3ddo1cg          3ddo1cg1

0x_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE    1t1do1vg   1t1do1vg1        3d1t1do1vg       3d1t1do1vg1
ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_GRADE   t1do1vg    t1do1vg1         3dt1do1vg        3dt1do1vg1
1inch_ALL_ALL_VOLUME_DEX_GRADE            1do1vg     1do1vg1          3d1do1vg         3d1do1vg1
ALL_ALL_ALL_VOLUME_DEX_GRADE              do1vg      do1vg1           3ddo1vg          3ddo1vg1

0x_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK     1t1do1vr   1t1do1vr1        3d1t1do1vr       3d1t1do1vr1
ALL_USDC(0xa0b869)_ALL_VOLUME_DEX_RANK    t1do1vr    t1do1vr1         3dt1do1vr        3dt1do1vr1
1inch_ALL_ALL_VOLUME_DEX_RANK             1do1vr     1do1vr1          3d1do1vr         3d1do1vr1
ALL_ALL_ALL_VOLUME_DEX_RANK               do1vr      do1vr1           3ddo1vr          3ddo1vr1

***********************************NFT*********************************
label_name                                      label_type new_label_name   时间维度label_type 时间维度new_label_name
CryptoPunks_NFT_BALANCE_GRADE                   n1bg       n1bg1
ALL_NFT_BALANCE_GRADE                           nbg        nbg1
CryptoPunks_NFT_BALANCE_RANK                    n1br       n1br1
ALL_NFT_BALANCE_RANK                            nbr        nbr1
CryptoPunks_NFT_BALANCE_TOP                     n1bt       n1bt1
ALL_NFT_BALANCE_TOP                             nbt        nbt1

ALL_CryptoPunks_Buy_NFT_ACTIVITY                n1o1cg     n1o1cg1         3dn1o1cg          3dn1o1cg1
ALL_ALL_Buy_NFT_ACTIVITY                        no1cg      no1cg1          3dno1cg           3dno1cg1

CryptoPunks_NFT_TIME_GRADE                      n1tg       n1tg1
CryptoPunks_NFT_TIME_SMART_NFT_EARLY_ADOPTER    n1ea       n1ea
CryptoPunks_NFT_TIME_SPECIAL                    n1ts       n1ts1

ALL_CryptoPunks_Buy_NFT_VOLUME_ELITE            n1o1ve     n1o1ve         3dn1o1ve           3dn1o1ve
ALL_ALL_Buy_NFT_VOLUME_ELITE                    no1ve      no1ve           3dno1ve           3dno1ve

ALL_CryptoPunks_Buy_NFT_VOLUME_GRADE            n1o1vg     n1o1vg1        3dn1o1vg1          3dn1o1vg1
ALL_ALL_Buy_NFT_VOLUME_GRADE                    no1vg      no1vg1         3dno1vg            3dno1vg1

ALL_CryptoPunks_Buy_NFT_VOLUME_RANK             n1o1vr     n1o1vr1        3dn1o1vr1          3dn1o1vr1
ALL_ALL_Buy_NFT_VOLUME_RANK                     no1vr      no1vr1         3dno1vr            3dno1vr1

ALL_CryptoPunks_Buy_NFT_VOLUME_TOP              n1o1vt     n1o1vt1        3dn1o1vt1          3dn1o1vt1
ALL_ALL_Buy_NFT_VOLUME_TOP                      no1vt      no1vt1         3dno1vt            3dno1vt1
*********************************************************dim_project_token_type.sql end*********************************************************
