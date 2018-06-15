--服务器维护

local Type = import("...DataType")
local function onPacketSCMatchStopMaintain(packet)
    laixia.LocalPlayercfg.LaixiaIsInMatch = false
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,{Text ="服务器维护中！",OnCallFunc = function ()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)

    end})
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchStopMaintainID,
        name = "SCMatchStopMaintain",
        data_array =
        {
            {"GameID", Type.Byte },
        },
        HandlerFunction = onPacketSCMatchStopMaintain,
    }

--endregion
