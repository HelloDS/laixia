-- 进入游戏，这里显示大厅

local Type = import("..DataType")

local function onPacketHandler(packet)
    if laixia.net.Net.mProcessState == 2 then
        laixia.net.addSendWaitingPID(_LAIXIA_PACKET_CS_IsMatchID)
    end
    ----modify by wangtianye
    --新增获取任务列表
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_GETTASKLIST)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_TOOLBOX_WINDOW)     --发送背包盒消息
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

