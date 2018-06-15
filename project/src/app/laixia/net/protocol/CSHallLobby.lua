local Type = import("..DataType")

local CSHallLobby =
    {
        ID = _LAIXIA_PACKET_CS_HallLobbyID ,

        name = "CSHallLobby" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
        }

    }

return CSHallLobby