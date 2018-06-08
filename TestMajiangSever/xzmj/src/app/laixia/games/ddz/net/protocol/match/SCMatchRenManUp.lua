local Type = import("...DataType")

local function onPacketMatchRenManUpdaData(packet) --人满开赛数据实时更新
    laixiaddz.LocalPlayercfg.laixiaddzMatchLimit = packet.data.JoinLimit
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_PROGRESSBARMATCH_WINDOW,packet.data)
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchRenManUpID,
        name = "SCMatchRenManUp",
        data_array =
        {
            { "GameID", Type.Byte },
            { "CurJoin", Type.Int }, --当前参与的人数
            { "JoinLimit", Type.Int }, --人数最多限制
        },

        HandlerFunction = onPacketMatchRenManUpdaData,
    }