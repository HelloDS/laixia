local Type = import("..DataType")

local CSRedeemCode =
    {
        ID = _LAIXIA_PACKET_CS_RedeemCodeID ,
        name = "CSRedeemCode" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"ConversionCode",Type.UTF8,},
            {"GameID",Type.Short}
        }
    }

return CSRedeemCode