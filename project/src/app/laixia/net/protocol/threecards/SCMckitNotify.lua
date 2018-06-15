--led显示
local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketGCTLedRet(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_GUIDANCE_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitNotifyID,
        name = "SCMckitNotify",
        data_array =
        {
            {"status", Type.Short},
            {"str", Type.UTF8 },
        },
        HandlerFunction = onPacketGCTLedRet,
    }


