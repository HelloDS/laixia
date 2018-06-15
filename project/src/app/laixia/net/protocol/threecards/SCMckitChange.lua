-- 多人三张牌请求进入游戏返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitChange(packet)
    print("onPacketSCMckitChange  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_CHANGEDESK_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitChangeID,
        name = "SCMckitChange",
        data_array =
        {
            {"status",          Type.Short },
            {"roomId",          Type.Byte},
            {"tableId",         Type.Int},
        },
        HandlerFunction = onPacketSCMckitChange,
    }

