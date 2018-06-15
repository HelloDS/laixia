local Type = import("...DataType")

return
    {
        ID = _LAIXIA_PACKET_CS_TurnTableLotteryID,
        name = "CSTurnTableLottery",
        data_array =
        {
            -- 校验码
            { "HttpCode", Type.Short },
            -- 选得哪个转盘
            { "TurnTableType", Type.Int },
        },
    }
