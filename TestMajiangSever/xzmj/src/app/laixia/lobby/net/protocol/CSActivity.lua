local Type = import("..DataType")
local CSActivity =
    {
        ID = _LAIXIA_PACKET_CS_ActivityID,
        name = "CSActivity",
        data_array =
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
        }
    }

return CSActivity