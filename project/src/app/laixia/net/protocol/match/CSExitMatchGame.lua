
local Type = import("...DataType")

return
    {
        name = "CSExitMatchGame",
        ID = _LAIXIA_PACKET_CS_ExitMatchGameID,
        data_array =
        {
            {"GameID",Type.Byte},
            {"PageType",Type.Byte},
            {"RoomID",Type.Int},
        },

    }

