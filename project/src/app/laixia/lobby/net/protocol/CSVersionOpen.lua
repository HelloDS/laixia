local Type = import("..DataType")

local CSVersionOpen =
    {
        ID = _LAIXIA_PACKET_CS_VersionOpenID ,
        name = "CSVersionOpen" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"GameType", Type.Byte,},
        }
    }

return CSVersionOpen

--endregion
