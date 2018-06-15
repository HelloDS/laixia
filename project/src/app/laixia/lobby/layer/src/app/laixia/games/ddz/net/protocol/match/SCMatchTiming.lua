--定时开赛中间等待界面

local Type = import("...DataType")

local function onPacketMatchDingShi(packet)

    local status= packet:getValue("Status")
    print("定时开赛确认响应消息")
    laixiaddz.LocalPlayercfg.laixiaddzMatchRoomType =0
    if status == 0 then  -- 参赛成功
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHJOIN_WINDOW)
        local Ranks = packet:getValue("Ranks")
        local rank = -1
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_WAITSTATE_WINDOW, {
        --     RANKS = Ranks,
        --     RANK = rank       } )        -- 阶段等待
--        packet.data.RoomType = 4
--        packet.data.RoomID = 127 --这里暂时先改死 证明这里是要进入比赛
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
        --        laixiaddz.LocalPlayercfg.laixiaddzMatchShowbar = true
    else
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
    end

end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchTimingID,-- 定时开赛中间等待界面

        name = "SCMatchTiming",
        data_array =
        {
            {"GameID",Type.Byte},
            {"Status",Type.Short}, --1表示失败，0表示成功
            {"Ranks",Type.Array,Type.Int}
        },

        HandlerFunction = onPacketMatchDingShi,
    }