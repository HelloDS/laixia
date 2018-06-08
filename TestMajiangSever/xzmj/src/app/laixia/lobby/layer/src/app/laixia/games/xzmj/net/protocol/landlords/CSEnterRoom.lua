-- 进入房间

local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_EnterRoomID,
        name = "CGEnterRoom",
        data_array =
        {
            { "RoomID", Type.Byte }
        }
    }

