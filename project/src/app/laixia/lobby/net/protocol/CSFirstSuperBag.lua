local Type = import("..DataType")

local CSFirstSuperBag =
    {
        ID = _LAIXIA_PACKET_CS_FirstSuperBagID ,
        name = "CSFirstSuperBag" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Byte}
        }
    }

return CSFirstSuperBag
