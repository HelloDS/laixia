-- 请求换桌

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_MckitChangeID,
        name = "CSMckitChange",
        data_array =
        {
            {"roomId", Type.Byte},
            {"tableId", Type.Int}
        },
    }
