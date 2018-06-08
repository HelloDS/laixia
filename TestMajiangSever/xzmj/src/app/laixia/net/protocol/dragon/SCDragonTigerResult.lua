-- 龙虎斗开牌

local Type = import("...DataType")

local function SCDragonTigerResultFunction(packet)
    if laixia.LocalPlayercfg.LHD == nil then
        return
    end
    laixia.LocalPlayercfg.LHD.Cards = packet.data.Cards
    laixia.LocalPlayercfg.LHD.details = packet.data.details
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_RESULT_WINDOW)
end

local SCDragonTigerResult =
    {
        ID = _LAIXIA_PACKET_SC_DragonTigerResultID,

        name = "SCDragonTigerResult",
        data_array =
        {
            { "Cards", Type.Int },
            { "details", Type.UTF8 },
        },
        HandlerFunction = SCDragonTigerResultFunction

    }

return SCDragonTigerResult






