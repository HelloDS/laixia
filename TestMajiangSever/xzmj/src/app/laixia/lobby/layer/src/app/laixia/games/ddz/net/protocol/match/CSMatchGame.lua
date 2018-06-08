
local Type = import("...DataType")
local CSMatchGame =
    {
        ID = _laixiaddz_PACKET_CS_MatchGameID ,
        name = "CSMatchGame",

        data_array =
        {
            {"GameID", Type.Byte},
            {"PageType",Type.Byte},
        }
    }
return CSMatchGame