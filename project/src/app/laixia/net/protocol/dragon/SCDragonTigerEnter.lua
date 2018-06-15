
-- 进入龙虎斗游戏申请返回

local StatusCode = import("...StatusCode")


local Type = import("...DataType")

local function SCDragonTigerEnterFunction(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_XIAOYOUXI_PEOGRESS)
    if StatusCode.new(packet.data.status):isOK() then
        laixia.LocalPlayercfg.LHD.arrTime =packet.data.arrTime --时间对应关系为下注时间，开牌时间，休息时间
        laixia.LocalPlayercfg.LHD.arrChip =packet.data.arrChip --筹码
        laixia.LocalPlayercfg.LHD.rate =packet.data.rate --倍数
        laixia.LocalPlayercfg.LHD.rfSysChargeRateate =packet.data.rfSysChargeRateate
        laixia.LocalPlayercfg.LHD.bFirstTime = packet.data.bFirstTime -- 0 不是第一次 1 是第一次
        laixia.LocalPlayercfg.LHD.BetConfigPerRound = packet.data.BetConfigPerRound--筹码配置
        laixia.LocalPlayercfg.LHD.DefaultChipList = packet.data.DefaultChipList
        laixia.LocalPlayercfg.LHD.iPlayerMinChip = packet.data.iPlayerMinChip--
        laixia.LocalPlayercfg.LHD.listBetMax = packet.data.listBetMax --角色可下的最大筹码（对应10个）

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_DRAGON_WINDOW)
    end
end

local SCDragonTigerEnter =
    {
        ID = _LAIXIA_PACKET_SC_DragonTigerEnterID,

        name = "SCDragonTigerEnter",
        data_array =
        {
            { "status", Type.Short },
            { "bFirstTime", Type.Byte },
            { "iPlayerMinChip", Type.Int },
            { "rfSysChargeRateate", Type.UTF8 },
            { "arrTime", Type.Array,Type.Short },
            { "arrChip", Type.Array,Type.Int },
            { "listBetMax", Type.Array,Type.Int },
            { "rate", Type.Array,Type.UTF8 },
            { "DefaultChipList", Type.Array,Type.TypeArray.DefaultChipListMode },
            { "BetConfigPerRound", Type.Array,Type.TypeArray.BetConfigPerRoundMode },
        },
        HandlerFunction = SCDragonTigerEnterFunction

    }

return SCDragonTigerEnter









