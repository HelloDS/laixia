local Type = import("..DataType")

local CSPlayerRankInfo = {

        ID = _LAIXIA_PACKET_CS_PlayerRankInfoID,
        name = "CSPlayerRankInfo",

        data_array =
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"UserID",Type.Int}
        },
}

return CSPlayerRankInfo