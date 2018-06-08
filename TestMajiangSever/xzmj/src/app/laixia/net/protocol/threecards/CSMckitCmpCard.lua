-- 玩家比牌请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitCompareCardID,
        name = "CSMckitCmpCard",
        data_array =
        {
            {"roundId", Type.Int},
            {"tpId",	Type.Int}
        },
    }
