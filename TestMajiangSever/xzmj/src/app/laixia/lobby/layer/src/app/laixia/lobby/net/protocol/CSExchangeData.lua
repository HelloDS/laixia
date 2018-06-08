local Type = import("..DataType")

local CSExchangeData =
    {
        ID = _LAIXIA_PACKET_CS_ExchangeDataID ,

        name = "CSExchangeData" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Byte},
            {"LastTime",Type.Double},
        }

    }

return CSExchangeData