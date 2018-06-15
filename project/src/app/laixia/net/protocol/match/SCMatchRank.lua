
local Type = import("...DataType")

local function onPacketMatchRanking(packet)

    local data={}

    laixia.LocalPlayercfg.LaixiaMatchRank=packet:getValue("Rank")
    laixia.LocalPlayercfg.LaixiaMatchTotalNum=packet:getValue("Totoal")
    data.TabNum = packet:getValue("TabNum")
    laixia.LocalPlayercfg.LaixiaIsInMatch = true

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, data);  --更新比赛等待界面数据
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchRankID,--获取当前排名和积分
        name = "SCMatchRank",
        data_array =
        {
            {"GameID",Type.Byte}, --游戏id
            {"Rank",Type.Int}, -- 当前排名
            {"Totoal",Type.Int}, -- 总人数
            {"TabNum",Type.Int}, -- 牌桌数量
        },
        HandlerFunction = onPacketMatchRanking,
    }

