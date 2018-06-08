local Type = import("..ProtoModel")

local CSLobbyMessage =
    {
        ID = _T_PACKET_CG_LobbyMessageID ,
        name = "CSLobbyMessage",

        data_array =
        {
            {"Rdf",Type.Short},
            {"GameID",Type.Short},
        }
    }
return CSMatchGame
