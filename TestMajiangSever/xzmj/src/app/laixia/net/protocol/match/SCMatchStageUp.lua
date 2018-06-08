
local Type = import("...DataType")
local laixia = laixia;

local EffectDict =  laixia.EffectDict
local EffectAni =  laixia.EffectAni

local function onPacketMatchStageUpdata(packet) --比赛阶段同步
    print("SCMatchStageUp");
    laixia.LocalPlayercfg.LaixiaMatchID = packet:getValue("MAtchID")
    laixia.LocalPlayercfg.LaixiaIsInMatch = true

    cc.UserDefault:getInstance():setDoubleForKey("matdchId",laixia.LocalPlayercfg.LaixiaMatchID)
    laixia.LocalPlayercfg.LaixiaMatchStage =  packet:getValue("Stage")

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MATCHBROADCAST_WINDOW,packet:getValue("Rds"))-- 添加第一名的奖励

    if packet:getValue("MatchName") ~= "" then
        laixia.LocalPlayercfg.LaixiaMatchName = packet:getValue("MatchName")
        laixia.LocalPlayercfg.LaixiaMatchName = laixia.LocalPlayercfg.LaixiaMatchName:gsub("金币",laixia.utilscfg.CoinType())
        -- 比赛名称
        cc.UserDefault:getInstance():setStringForKey("MatchName", laixia.LocalPlayercfg.LaixiaMatchName)
    end
    laixia.LocalPlayercfg.LaixiaMatchRoundNum = laixia.LocalPlayercfg.LaixiaMatchRoundNum + 1
    laixia.LocalPlayercfg.LaixiaMatchRoundNum = packet:getValue("RoundNum")

end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchStageUpID,

        name = "SCMatchStageUp",
        data_array =
        {
            {"GameID",Type.Byte},
            {"MAtchID",Type.Double},
            {"MatchName",Type.UTF8},
            {"Stage",Type.Byte}, -- 1打立出局，2加赛，3 定局积分  -1 结束
            {"Rds", Type.Array,Type.TypeArray.Rds},-- 参加比赛第一名奖励
            {"RoundNum",Type.Int}, --第几轮次了
        },

        HandlerFunction = onPacketMatchStageUpdata,
    }