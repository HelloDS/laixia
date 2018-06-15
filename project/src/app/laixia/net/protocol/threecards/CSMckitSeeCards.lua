-- 玩家看牌请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitSeeCardsID,
        name = "CSMckitSeeCards",
        data_array =
        {
            {"roomId", Type.Byte},
            {"tableId", Type.Int},
        },
    }
