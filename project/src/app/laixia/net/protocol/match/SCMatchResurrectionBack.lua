--复活退出

local Type = import("...DataType")

local function onSCMatchResurrectionBackPacket(packet)
    print("onSCMatchResurrectionBackPacket")

    local data =packet.data
    laixia.LocalPlayercfg.LaixiaisConnectCardTable = false
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHEASTER_WINDOW,data)

end

local SCMatchResurrectionBack =
    {
        ID = _LAIXIA_PACKET_SC_MatchResurrectionBackID ,
        name = "SCMatchResurrectionBack",
        data_array =
        {
            {"GameID",Type.Byte}, -- 游戏ID
            {"Rank",Type.Int}, -- 排名
            {"RoomID",Type.Int}, -- 房间id
            {"Time",Type.Int},  -- 倒计时时间
            {"ResurCt",Type.Int}, -- 剩余复活次数
            {"MatchID",Type.Double}, --比赛 id
            {"Msg",Type.UTF8}, -- 消息内容
            {"Items", Type.Array, Type.TypeArray.ItemsForResurrection },

        },
        HandlerFunction = onSCMatchResurrectionBackPacket,

    }

return SCMatchResurrectionBack


