local Type = import("..DataType")

local CSRank = {

        ID = _LAIXIA_PACKET_CS_RankID,

        name = "CSRank",

        data_array =
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"RankType",Type.Byte},
        },
}

return CSRank