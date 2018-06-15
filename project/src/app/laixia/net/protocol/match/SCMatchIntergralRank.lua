
local Type = import("...DataType")

local function onPacketMatchIntergralRanking(packet)
    local table = { }
    table.Ranks = packet:getValue("Ranks")
    table.RankRds=packet:getValue("RankRds")

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHRANK_WINDOW, table);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchIntegralRankID,
        name = "SCMatchIntergralRank",
        data_array =
        {
            { "GameID", Type.Byte },
            { "RankRds", Type.Array, Type.TypeArray.MatchRankRd },-- 比赛奖励
            { "Ranks", Type.Array, Type.TypeArray.MatchRanks }--比赛排名
        },
        HandlerFunction = onPacketMatchIntergralRanking,
    }
