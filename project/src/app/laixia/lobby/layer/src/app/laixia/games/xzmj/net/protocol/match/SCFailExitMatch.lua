-- 牌桌结果

local Type = import("...DataType")

local function onPacketMatchFailQuite(packet)  --比赛失败退出

    local Mesg = packet:getValue("Mesg")
    print(Mesg)
    local data={}
    data.mesg=packet:getValue("Mesg")
    data.rank=packet:getValue("Rank")
    data.roomID = packet:getValue("RoomID")
    data.GameType = packet:getValue("GameType")
    data.ISWin= false
    laixia.LocalPlayercfg.LaixiaIsInMatch = false
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHRESULT_WINDOW,data);

end


return
    {
        ID = _LAIXIA_PACKET_SC_FailExitMatchID,

        name = "SCFailExitMatch",
        data_array =
        {
            {"GameID",Type.Byte},
            {"RoomID",Type.Int},
            {"Rank",Type.Int},
            {"Mesg",Type.UTF8},
            {"GameType",Type.Int},
        },

        HandlerFunction = onPacketMatchFailQuite,
    }