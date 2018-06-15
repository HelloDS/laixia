-- 退出房间

local Type = import("...DataType")

return
    {
        ID=_laixiaddz_PACKET_CS_ExitRoomID,
        name = "CSExitRoom",
        data_array =
        {
            {"RoomID",Type.Byte},
            {"TableID",Type.Int},
        }
    }
