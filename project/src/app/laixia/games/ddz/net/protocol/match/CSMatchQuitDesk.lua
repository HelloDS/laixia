--比赛退出牌桌

local Type = import("...DataType")

local CSMatchQuitDesk = {

        ID = _laixiaddz_PACKET_CS_MatchQuitDeskID,

        name = "CSMatchQuitDesk",

        data_array =
        {
            {"GameID",Type.Byte},
            {"MatchID",Type.Double},
        },
}

return CSMatchQuitDesk