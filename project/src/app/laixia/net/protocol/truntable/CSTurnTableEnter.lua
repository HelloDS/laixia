local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_TurnTableEnterID,
        name = "CSTurnTableEnter",
        data_array =
        {
            -- 校验码
            { "HttpCode", Type.Short },
        },
    }