local Type = import("...DataType")


return
    {
        ID = _LAIXIA_PACKET_CS_TurnTableResultID,
        name = "CSTurnTableResult",
        data_array =
        {
            {"HttpCode",Type.Short},
        },
    }
