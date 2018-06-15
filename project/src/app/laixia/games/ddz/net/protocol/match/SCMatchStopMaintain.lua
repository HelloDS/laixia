--服务器维护

local Type = import("...DataType")
local function onPacketSCMatchStopMaintain(packet)
    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,{Text ="服务器维护中！",OnCallFunc = function ()
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)

    end})
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchStopMaintainID,
        name = "SCMatchStopMaintain",
        data_array =
        {
            {"GameID", Type.Byte },
        },
        HandlerFunction = onPacketSCMatchStopMaintain,
    }

--endregion
