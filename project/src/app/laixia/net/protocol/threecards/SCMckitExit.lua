-- 多人三张牌请求离开游戏返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitExit(packet)
    print("onPacketSCMckitExit  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_EXIT_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitExitID,
        name = "SCMckitExit",
        data_array =
        {
            {"status", Type.Short },
            {"opId", Type.Int},
        },
        HandlerFunction = onPacketSCMckitExit,
    }
