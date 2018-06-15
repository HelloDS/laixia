-- 玩家下注请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitBetID,
        name = "CSMckitBet",
        data_array =
        {
            {"roundId",	Type.Int},
            {"addBet",		Type.Int},
        },
    }
