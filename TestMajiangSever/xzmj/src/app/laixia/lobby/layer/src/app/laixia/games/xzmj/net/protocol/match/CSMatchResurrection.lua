--复活新添加的协议

local Type = import("...DataType")

local CSMatchResurrection =
    {
        ID = _LAIXIA_PACKET_CS_MatchResurrectionID ,
        name = "CSMatchResurrection" ,
        data_array=
        {
            {"GameID",Type.Byte},
            {"MatchID",Type.Double},
        }
    }

return CSMatchResurrection
