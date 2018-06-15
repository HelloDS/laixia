
local Type = import("...DataType")

local function onPacketMatchRanking(packet)

    local data={}

    laixiaddz.LocalPlayercfg.laixiaddzMatchRank=packet:getValue("Rank")
    laixiaddz.LocalPlayercfg.laixiaddzMatchTotalNum=packet:getValue("Totoal")
    data.TabNum = packet:getValue("TabNum")
    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true

    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHWAITLOADING_WINDOW, data);  --更新比赛等待界面数据
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchRankID,--获取当前排名和积分
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

