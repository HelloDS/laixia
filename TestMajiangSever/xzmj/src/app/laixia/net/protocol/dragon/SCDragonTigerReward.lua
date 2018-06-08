-- 龙虎斗结算
local Type = import("...DataType")

local function SCLHDCheckoutRetFunction(packet)
    laixia.LocalPlayercfg.LHD.selfWinGold = packet.data.selfWinGold
    laixia.LocalPlayercfg.LHD.bankerWinGold = packet.data.bankerWinGold
    laixia.LocalPlayercfg.LHD.arrWinDetails = packet.data.arrWinDetails
    laixia.LocalPlayercfg.LHD.winRanks =packet.data.winRanks

    laixia.logPacketID("\tin packet获胜金币为 "..laixia.LocalPlayercfg.LHD.selfWinGold)
end

local SCDragonTigerReward =
    {
        ID = _laixia_PACKET_SC_DragonTigerRewardID,

        name = "SCDragonTigerReward",
        data_array =
        {
            { "selfWinGold", Type.Int }, --玩家战果
            { "arrWinDetails", Type.Array,Type.Int },-- 玩家每个位置的战果
            { "bankerWinGold", Type.Double },--庄家赢钱
            { "winRanks", Type.Array, Type.TypeArray.LHDRankers } -- 获胜玩家消息
        },
        HandlerFunction = SCLHDCheckoutRetFunction
    }

return SCDragonTigerReward









