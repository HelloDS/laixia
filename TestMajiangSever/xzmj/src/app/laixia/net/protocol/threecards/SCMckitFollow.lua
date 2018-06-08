-- 多人三张牌请求跟注返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitFollow(packet)
    print("onPacketSCMckitFollow  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_FOLLOW_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitFollowID,
        name = "SCMckitFollow",
        data_array =
        {
            {"status",          Type.Short},
            {"opSeat",          Type.Byte},         -- 操作者位置
            {"roundId",      Type.Int},
            {"opId",            Type.Int},
            {"curBetNum",       Type.Int},          -- 当前下了多少
            {"remainChip",     Type.Double},       -- 剩余筹码数
            {"betTotal",     Type.Double},       -- 总共下了多少
            {"tbTotal",  Type.Double},       -- 桌子上所有的下注额
        },
        HandlerFunction = onPacketSCMckitFollow,
    }
