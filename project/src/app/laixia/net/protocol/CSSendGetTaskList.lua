local Type = import("..DataType")
local CSGetTaskList =
    {
        ID = _LAIXIA_PACKET_CS_GETTASKLIST,
        name = "CSGetTaskList",
        data_array =
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
        }
    }

return CSGetTaskList