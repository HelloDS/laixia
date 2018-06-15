local Type = import("...DataType")
local StatusCode = import("...StatusCode")
local function onPacketSCCreateDelRet(packet)
    if StatusCode.new(packet.data.Status):isOK() == true   then
        local delpid = packet.data.DelPid
        local roomId = packet.data.TableID
        local str = "房间已经解散"
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,str) --飘字提示
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_APPLYDISMISS_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW);   --返回大厅
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_CreateDelRetID,
        name = "SCCreateDelRet",
        data_array =
        {
            {"Status", Type.Short},
            {"DelPid", Type.Int},
            {"TableID", Type.Int},
        },
        HandlerFunction = onPacketSCCreateDelRet,
    }
