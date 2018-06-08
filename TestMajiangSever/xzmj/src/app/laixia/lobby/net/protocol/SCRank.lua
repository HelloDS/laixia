-- 排行榜

local Type = import("..DataType")

local function onSCRankPacket(packet)
    local StatusID = packet:getValue("StatusID")
    local rankType =  packet:getValue("RankType")
    laixia.LocalPlayercfg.SelfRank = packet:getValue("SelfRank")
    laixia.LocalPlayercfg.LaixiaRankingData = packet:getValue("UserRanklist") --金币榜

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_RANK_WINDOW)
end

local SCRank =
    {
        ID = _LAIXIA_PACKET_SC_RankID,
        name = "SCRank",
        data_array =
        {
            { "StatusID", Type.Short },
            { "RankType", Type.Byte },
            { "SelfRank", Type.Int },
            { "SelfLevel", Type.Int },
            { "UserRanklist", Type.Array, Type.TypeArray.Rank },
        },
        HandlerFunction = onSCRankPacket,
    }

return SCRank