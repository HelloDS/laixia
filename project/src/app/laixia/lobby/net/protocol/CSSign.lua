local Type = import("..DataType")

local CSSign =
    {
        ID = _LAIXIA_PACKET_CS_SignID ,

        name = "CSSign" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
        }

    }

return CSSign
