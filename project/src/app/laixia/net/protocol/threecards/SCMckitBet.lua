-- 多人三张牌下注返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitBet(packet)
    print("onPacketSCMckitBet  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_BET_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitBetID,
        name = "SCMckitBet",
        data_array =
        {
            {"status", Type.Short },
            {"opSeat", Type.Byte},         -- 操作玩家座位
            {"roundId", Type.Int},
            {"opId", Type.Int},          -- 操作玩家id
            {"betNum", Type.Double},
            {"remainChip", Type.Double},       -- 剩余金币数
            {"betTotal", Type.Double},       -- 该玩家总共下注多少
            {"tbTotal", Type.Double},       -- 桌子上所有的下注额
        },
        HandlerFunction = onPacketSCMckitBet,
    }
