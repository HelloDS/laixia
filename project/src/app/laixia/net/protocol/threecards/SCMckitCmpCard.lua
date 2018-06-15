-- 多人三张牌请求进入游戏返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitCmpCard(packet)
    print("onPacketSCMckitCmpCard  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_COMPARE_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitCompareCardID,
        name = "SCMckitCmpCard",
        data_array =
        {
            {"status",          Type.Short },
            {"comType",     Type.Byte},                             -- 0 正常比牌，1、孤注一掷
            {"opSeat",          Type.Byte},
            {"roundId",      Type.Int},
            {"costCoin",        Type.Double},                           -- pk的时候花销多少
            {"remainCoin",      Type.Double},                           -- 剩余多少金币
            {"tbTotal",  Type.Double},                           -- 桌子上所有的下注额
            {"betTotal",     Type.Double},                           -- 发起孤注一掷的玩家总下注
            {"cmpInfos",         Type.Array,     Type.TypeArray.TCPKItem},
        },
        HandlerFunction = onPacketSCMckitCmpCard,
    }
