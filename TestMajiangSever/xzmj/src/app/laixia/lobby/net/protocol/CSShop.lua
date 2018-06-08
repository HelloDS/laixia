local Type = import("..DataType")

local CSShop =
    {
        ID = _LAIXIA_PACKET_CS_ShopID ,

        name = "CSShop" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
            {"LastModifyTm",Type.Double},
        }

    }

return CSShop

