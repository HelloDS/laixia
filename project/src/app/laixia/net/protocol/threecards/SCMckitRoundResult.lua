-- 多人三张牌游戏结算结果推送

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitRoundResult(packet)
    print("onPacketSCMckitRoundResult  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_RESULT_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitRoundResultID,
        name = "SCMckitRoundResult",
        data_array =
        {
            {"endType", Type.Byte },
            {"winId", Type.Int },                     -- 赢家的id
            {"winCardType", Type.Byte},                     -- 赢家牌型
            {"winCards", Type.Array,     Type.Int},      -- 赢家牌
            {"myCardType", Type.Byte},                     -- 我的牌型
            {"myCards", Type.Array,     Type.Int},      -- 我的牌
            {"tableAllBetNum", Type.Double},                    -- 桌子总下注
            {"winCoins", Type.Double},                   -- 赢家的总数
            {"winTotalCoins", Type.Double},                   -- 赢家的总金币数
            {"losSeat", Type.Array,     Type.Byte},     -- 需要回收金币的玩家座位数组
            {"losCoins", Type.Array,     Type.Double},   -- 失败玩家剩余金币数
            {"losRetunCoins", Type.Array,     Type.Double},   -- 失败玩家回收余金币数
        },
        HandlerFunction = onPacketSCMckitRoundResult,
    }
