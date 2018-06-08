
local Type = import("..DataType")

local CSQuickSuperBag =
    {
        ID = _LAIXIA_PACKET_CS_QuickSuperBagID ,

        name = "CSQuickSuperBag" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Byte}
        }

    }

return CSQuickSuperBag
