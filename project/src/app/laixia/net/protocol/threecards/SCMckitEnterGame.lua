-- 多人三张牌请求进入游戏返回

local Type = import("...DataType")
local Model = Type.TypeArray

local function onPacketSCMckitEnterGame(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_ENTER_WINDOW, packet.data);

--ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_XIAOYOUXI_PEOGRESS)
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitEnterGameID,
        name = "SCMckitEnterGame",
        data_array =
        {
            {"status",          Type.Short},
            {"roomId",          Type.Byte},                 -- 房间ID
            {"roomType",        Type.Byte},                 -- 房间类型0,1,2 初中高
            {"cmpRound",        Type.Byte},                 -- 可以比牌轮次限制 1表示第一轮之后才能比牌
            {"gameState",       Type.Byte},                 --游戏状态
            {"stage",           Type.Byte},                 --牌桌阶段
            {"currentSeat",     Type.Byte},                 --当前操作玩家    curSeatId
            {"seatCnt",         Type.Byte},                 --座位数          seatTotalNum
            {"bottomSeat",      Type.Byte},                 --庄家座位号      bossSeatId
            {"tableId",         Type.Int},                  --牌桌id
            {"inning",          Type.Int},                  --玩家在该房间进行了n局游戏
            {"basisBet",        Type.Int},                  --底注      bottomBet
            {"maxBet",          Type.Int},                              -- 最高单注额
            {"remainOperTm",    Type.Int},                  --操作剩余时间
            {"totalOperTm",     Type.Int},                  --操作总时间
            {"round",           Type.Int},                  --轮次
            {"totalRound",      Type.Int},                  --总论次数
            {"betConfig",       Type.Array,     Type.Int},  --加注配置
            {"allChips",        Type.Array,     Type.Double},      --总下注
            {"players",         Type.Array,     Type.TypeArray.MckitPlayerInfo},--玩家信息
        },
        HandlerFunction = onPacketSCMckitEnterGame,
    }





-- endregion
