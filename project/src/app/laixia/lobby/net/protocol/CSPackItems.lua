local Type = import("..DataType")

local CSPackItems =
    {
        ID = _LAIXIA_PACKET_CS_PackItemsID,
        name = "CSPackItems",
        data_array =
        {
            { "Code", Type.Short, },
            { "GameID", Type.Short },
        }
    }

return CSPackItems

