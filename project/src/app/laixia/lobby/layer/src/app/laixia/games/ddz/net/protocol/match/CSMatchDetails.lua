
local Type = import("...DataType")

return
    {
        name = "CSMatchDetails",
        ID = _laixiaddz_PACKET_CS_MatchDetailsID,
        data_array =
        {
            {"GameID",Type.Byte},
            {"PageType",Type.Byte},
            {"RoomID",Type.Int},
        }
    }

