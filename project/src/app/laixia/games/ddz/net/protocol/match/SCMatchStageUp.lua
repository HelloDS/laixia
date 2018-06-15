
local Type = import("...DataType")
local laixiaddz = laixiaddz;

local EffectDict =  laixiaddz.EffectDict
local EffectAni =  laixiaddz.EffectAni

local function onPacketMatchStageUpdata(packet) --比赛阶段同步
    print("SCMatchStageUp");
    laixiaddz.LocalPlayercfg.laixiaddzMatchID = packet:getValue("MAtchID")
    laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true

    cc.UserDefault:getInstance():setDoubleForKey("matdchId",laixiaddz.LocalPlayercfg.laixiaddzMatchID)
    laixiaddz.LocalPlayercfg.laixiaddzMatchStage =  packet:getValue("Stage")

    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHLISTDETAIL_WINDOW)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MATCHBROADCAST_WINDOW,packet:getValue("Rds"))-- 添加第一名的奖励

    if packet:getValue("MatchName") ~= "" then
        laixiaddz.LocalPlayercfg.laixiaddzMatchName = packet:getValue("MatchName")
        laixiaddz.LocalPlayercfg.laixiaddzMatchName = laixiaddz.LocalPlayercfg.laixiaddzMatchName:gsub("金币",laixiaddz.utilscfg.CoinType())
        -- 比赛名称
        cc.UserDefault:getInstance():setStringForKey("MatchName", laixiaddz.LocalPlayercfg.laixiaddzMatchName)
    end
    laixiaddz.LocalPlayercfg.laixiaddzMatchRoundNum = laixiaddz.LocalPlayercfg.laixiaddzMatchRoundNum + 1
    laixiaddz.LocalPlayercfg.laixiaddzMatchRoundNum = packet:getValue("RoundNum")

end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchStageUpID,

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