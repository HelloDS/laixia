-- 玩家站起请求

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitFollowID,
        name = "CSMckitFollow",
        data_array =
        {
            {"roundId",	Type.Int},
        },
    }
