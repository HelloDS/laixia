local Type = import("..DataType")

local CSRequestOrder =
    {
        ID = _LAIXIA_PACKET_CS_RequestOrderID ,

        name = "CSRequestOrder" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"ItemID",Type.Int} ,
        }

    }

return CSRequestOrder
