-- 牌桌结果

local Type = import("...DataType")

local function onPacketMatchDetails(packet)
    local data = packet.data

    laixiaddz.LocalPlayercfg.laixiaddzMatchLimit = packet:getValue("JoinLimit")
    if laixiaddz.LocalPlayercfg.laixiaddzMatchLimit== 9999 then
        laixiaddz.LocalPlayercfg.laixiaddzMatchLimit =0
    end

    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "CardTableDialog" then
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "LoadingWindow" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MAININTERFACE_WINDOW)
        end
    end
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLISTDETAIL_WINDOW, data)

end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchDetailsID,
        name = "SCMatchDetails",
        data_array =
        {
            { "GameID", Type.Byte },-- 游戏ID
            { "RoomType", Type.Byte },-- 房间类型，1，人满开赛 。0，定时开赛
            { "SelfJoin", Type.Byte },-- 1:已报名0：未报名
            { "State", Type.Byte },-- 1：报名前2报名中3比赛开始4比赛结束5报名人满
            { "RoomName", Type.UTF8 },-- 房间名字
            { "RoomID", Type.Int },-- 房间ID
            { "JoinLimit", Type.Int },-- 人数限制
            { "JoinLimitMax",Type.Int},
            { "CurNum", Type.Int },-- 当前比赛人数
            { "StartTime", Type.Int },-- 开赛时间
            { "JoinTime", Type.Int },-- 可报名时间
            { "CurTime", Type.Int },-- 服务器时间
            { "InitCoin", Type.Int },-- 比赛积分
            { "Stages", Type.Array, Type.UTF8 },-- 比赛赛制
            { "Cost", Type.Array, Type.TypeArray.DetailInfoPair },-- 报名花费
            { "Conds", Type.Array, Type.TypeArray.DetailInfoPair },-- 报名条件    11003 经验值   11004 level   11005 vip
            { "RankRds", Type.Array, Type.TypeArray.MatchRankRd },-- 比赛奖励
            { "match_des", Type.UTF8}, --比赛介绍
            { "match_format", Type.UTF8},   --
            { "match_careful", Type.UTF8},--注意事项
            { "End_Time", Type.Int}, --比赛结束时间 显示用
            { "Start_Time",Type.UTF8},--比赛开始时间 显示用
        },
        HandlerFunction = onPacketMatchDetails,
    }