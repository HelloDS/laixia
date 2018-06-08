-- 玩家弃牌请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitThrowCardsID,
        name = "CSMckitThrowCards",
        data_array =
        {
            {"roundId",		Type.Int}
        },
    }

