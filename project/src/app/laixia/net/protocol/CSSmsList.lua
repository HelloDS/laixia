local Type = import("..DataType")

local CSSmsList =
    {
        ID = _LAIXIA_PACKET_CS_SmsListID ,

        name = "CSSmsList" ,
        data_array=
        {
            {"GameID",Type.Short},
            {"Type", Type.Byte},
        }

    }

return CSSmsList