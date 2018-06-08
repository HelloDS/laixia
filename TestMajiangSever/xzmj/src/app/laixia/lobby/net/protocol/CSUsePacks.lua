local Type = import("..DataType")

local CSUsePacks =
    {
        ID = _LAIXIA_PACKET_CS_UsePacksID ,

        name = "CSUsePacks" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"ItemID",Type.Int},
        }

    }

return CSUsePacks
