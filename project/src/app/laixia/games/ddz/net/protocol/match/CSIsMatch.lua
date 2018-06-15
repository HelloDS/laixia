--region 短线重连请求进入比赛

local Type = import("...DataType")

CSIsMatch =
    {
        ID=_laixiaddz_PACKET_CS_IsMatchID ,--领取救济金,
        name = "CSIsMatch",
        data_array =
        {
            {"GameID",Type.Byte},     --游戏ID 4
            {"Flag",Type.Byte},       --上线标记 固定0
        },

    };
return  CSIsMatch
--endregion
