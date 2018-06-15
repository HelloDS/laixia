
local Type = import("...DataType")

CGMatchRanking =
    {
        ID= _laixiaddz_PACKET_CS_MatchIntegralRankID ,
        name = "CGMatchRanking",
        data_array =
        {
            {"GameID",Type.Byte},
            {"MatchID",Type.Double},
        },

    };

return  CGMatchRanking