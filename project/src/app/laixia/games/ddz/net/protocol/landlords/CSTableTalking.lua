
local Type = import("...DataType")

CSTableTalking =
    {
        ID=_laixiaddz_PACKET_CS_TableTalkingID ,--聊天,
        name = "CSTableTalking",
        data_array =
        {
            {"RoomID",Type.Byte},
            {"Type",Type.Byte},
            {"TableID",Type.Int},
            {"Info",Type.UTF8},
        },

    };

return CSTableTalking


