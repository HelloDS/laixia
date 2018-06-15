
local Type = import("...DataType")

return
    {
        ID=_LAIXIA_PACKET_CS_TablePlayerID ,
        name = "CSTablePlayer",
        data_array =
        {
            {"RoomID",Type.Byte},
            {"PlayerID",Type.Int},
        },

    };