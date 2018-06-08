
local Type = import("...DataType")

CSShowCard =
    {
        ID=_laixiaddz_PACKET_CS_ShowCardID ,--明牌,
        name = "CSShowCard",
        data_array =
        {
            {"TableID",Type.Int},
            {"RoomID",Type.Byte},
        },

    };
return  CSShowCard


