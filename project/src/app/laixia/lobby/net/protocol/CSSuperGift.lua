local Type = import("..DataType")

local CSSuperGift =
    {
        ID = _LAIXIA_PACKET_CS_SuperGiftID ,

        name = "CSSuperGift" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Byte}
        }

    }

return CSSuperGift