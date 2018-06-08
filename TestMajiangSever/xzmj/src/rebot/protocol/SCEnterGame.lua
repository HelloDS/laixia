-- 进入游戏，这里显示大厅

local Type = require("rebot.DataType")

local function onPacketHandler(packet)
    _G.EventDispatch:pushEvent("Resp_Rebot_EnterGame", packet)
end

return
    {
        name = "SCEnterGame",
        ID = _LAIXIA_PACKET_SC_EnterGameID,
        data_array =
        {
            { "StatusID", Type.Short },
            { "Name", Type.UTF8 },
            { "CoinNum", Type.Double },
            { "GiftNum", Type.Int },
            { "Title", Type.UTF8 },
            { "Level", Type.Byte },
            { "NowExp", Type.Int },
            { "NextExp", Type.Int },
        },

        HandlerFunction = onPacketHandler,
    }

