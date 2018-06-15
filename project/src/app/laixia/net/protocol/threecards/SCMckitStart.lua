-- 多人三张牌请求进入游戏返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitStart(packet)
    print("onPacketSCMckitStart  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_START_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitStartID,
        name = "SCMckitStart",
        data_array =
        {
            {"status",          Type.Short },
            {"bottomSeat",      Type.Byte},
            {"seatCount",       Type.Byte},
            {"players",         Type.Array,     Type.TypeArray.MckitPlayerInfo},       -- 校对玩家数据
        },
        HandlerFunction = onPacketSCMckitStart,
    }
