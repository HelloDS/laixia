-- 多人三张牌站起请求返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitStandUp(packet)
    print("onPacketSCMckitStandUp  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_STANDUP_WINDOW, packet.data);
end

return
    {
        ID      = _LAIXIA_PACKET_SC_MckitStandUpID,
        name    = "SCMckitStandUp",
        data_array =
        {
            {"opId",            Type.Int},
            {"status",          Type.Short },
            {"cause",     Type.Byte},
        },
        HandlerFunction = onPacketSCMckitStandUp,
    }

-- endregion
