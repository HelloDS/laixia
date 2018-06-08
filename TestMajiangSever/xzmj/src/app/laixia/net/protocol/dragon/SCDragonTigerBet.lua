-- 龙虎斗压注返回

local Type = import("...DataType")
local StatusCode = import("...StatusCode")
local function SCDragonTigerFunction(packet)
    if packet.data.nResult == 0 then
        laixia.LocalPlayercfg.LHD.myAddType = packet.data.type
        laixia.LocalPlayercfg.LHD.myAddChip = packet.data.chip
        laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold - packet.data.chip
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_BET_WINDOW)
    elseif packet.data.nResult == 1 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "金币不足!")
    elseif packet.data.nResult == 2 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "阶段错误，不能下注!")
    elseif packet.data.nResult == 3 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "压注已达上限!")
    elseif packet.data.nResult == 13 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "玩家不存在")
    elseif packet.data.nResult == 39 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, " 牌桌不存在!")
    end

end

local SCDragonTigerBet =
    {
        ID = _LAIXIA_PACKET_SC_DragonTigerBetID,

        name = "SCDragonTigerBet",
        data_array =
        {
            { "nResult", Type.Short },
            { "type", Type.Byte },
            { "chip", Type.Int }
        },
        HandlerFunction = SCDragonTigerFunction

    }

return SCDragonTigerBet