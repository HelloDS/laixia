--确认参加比赛

local Type = import("...DataType")

local CSMatchJoinIn = {

        ID = _laixiaddz_PACKET_CS_MatchJoinInID,

        name = "CSMatchJoinIn",

        data_array =
        {
            {"GameID",Type.Byte},
            {"PageType",Type.Byte},
            {"RoomID",Type.Int},
        },
}

return CSMatchJoinIn
