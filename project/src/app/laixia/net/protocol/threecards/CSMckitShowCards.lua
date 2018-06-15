-- 玩家秀牌请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitShowCardsID,
        name = "CSMckitShowCards",
        data_array =
        {
            {"roundId",	Type.Int}
        },
    }
