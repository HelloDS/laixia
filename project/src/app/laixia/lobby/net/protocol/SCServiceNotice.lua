local Type = import("..DataType")

local function onSCServiceNoticePacket(packet)

    local msg = packet.data
    if msg.Type == 1 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BULLETINS_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_BULLETINS_WINDOW,msg)
    end
end

local SCServiceNotice =
    {
        ID = _LAIXIA_PACKET_SC_ServiceNoticeID,
        name = "SCServiceNotice",
        data_array =
        {
            { "StatuID", Type.Short },
            { "Type", Type.Short },
            { "Content", Type.UTF8}
        },
        HandlerFunction = onSCServiceNoticePacket,
    }

return SCServiceNotice