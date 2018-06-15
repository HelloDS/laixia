local Type = import("..DataType")

local CSUsePackProp =
    {
        ID = _LAIXIA_PACKET_CS_UsePackPropID,

        name = "CSUsePackProp",
        data_array =
        {
            { "Code", Type.Short, },
            { "GameID", Type.Short },
            { "ItemID", Type.Int },
            { "ItemCount", Type.Int },
            { "ItemObjID", Type.Double },
            { "ReceiveName", Type.UTF8 },
            { "PhoneNumber", Type.UTF8 },
            { "Address", Type.UTF8 }
        }

    }

return CSUsePackProp
