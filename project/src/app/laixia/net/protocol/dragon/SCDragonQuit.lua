-- 龙虎斗退出返回

local Type = import("...DataType")

local function SCDragonQuitFunction(packet)
    if packet.data.status == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_EXIT_WINDOW)
    elseif packet.data.status == 1 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"压注状态下无法退出!")
        return
    end
end

local SCDragonQuit =
    {
        ID = _LAIXIA_PACKET_SC_DragonQuitID,
        name = "SCDragonQuit",
        data_array =
        {
            { "status", Type.Short }
        },
        HandlerFunction = SCDragonQuitFunction

    }

return SCDragonQuit