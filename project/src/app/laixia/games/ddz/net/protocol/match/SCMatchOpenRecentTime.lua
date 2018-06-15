
local Type = import("...DataType")
local function onPacketRecentTimeRet(packet)
    local State = packet:getValue("State")
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchOpenRecentTimeID,
        name = "SCMatchOpenRecentTime",
        data_array =
        {
            {"GameID", Type.Byte }, -- 游戏ID
            {"PageType",Type.Byte}, -- 房间类型
            {"State", Type.Byte}, -- 状态0：不能参加1：已报名2：未报名
            {"RoomID", Type.Int },  -- 房间ID
            {"Time", Type.Int}, -- 倒计时
            {"Icon", Type.UTF8}, -- 比赛icone
        },
        HandlerFunction = onPacketRecentTimeRet,
    }

--endregion
