local Type = import("..DataType")

local function onSCActivityPacket(packet)
    dumpGameData(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW,packet.data)
end

local SCActivity =
    {
        ID = _LAIXIA_PACKET_SC_ActivityID,
        name = "SCActivity",
        data_array =
        {
            {"StatusID", Type.Short },-- 状态码
            {"ActivityItems" , Type.Array, Type.TypeArray.ActivityItems},
        },
        HandlerFunction = onSCActivityPacket,
    }

return SCActivity