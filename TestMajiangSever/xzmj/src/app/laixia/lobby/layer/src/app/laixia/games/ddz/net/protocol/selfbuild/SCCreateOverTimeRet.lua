--region 牌桌内购买记牌器

local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketSCCreateOverTimeRet(packet)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "房间超时！", OnCallFunc = function() ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW) end })

end

return
    {
        ID = _laixiaddz_PACKET_SC_CreateOverTimeRetID,
        name = "SCCreateOverTimeRet",
        data_array =
        {
            {"TableID",Type.Int},
        },
        HandlerFunction = onPacketSCCreateOverTimeRet,
    }

--endregion
