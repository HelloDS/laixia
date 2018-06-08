-- 斗地主快速开始

local Type = import("...DataType")
local CSQuickOpen =
    {
        ID = _LAIXIA_PACKET_CS_QuickOpenID ,
        name = "CSQuickOpen",
        data_array =
        {
            { "RoomType", Type.Byte },
        }
    }
return CSQuickOpen