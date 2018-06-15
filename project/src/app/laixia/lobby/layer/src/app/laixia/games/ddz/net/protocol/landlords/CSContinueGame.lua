--region 继续游戏

local Type = import("...DataType")

return
    {
        ID=_laixiaddz_PACKET_CS_ContinueGameID,  --继续游戏
        name = "ContinueGame",

        data_array =
        {
            {"RoomID",Type.Byte},
            {"TableID",Type.Int},
        }
    }


