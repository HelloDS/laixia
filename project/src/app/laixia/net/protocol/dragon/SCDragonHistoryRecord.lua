-- 龙虎斗走势返回

local Type = import("...DataType")

local function SCDragonHistoryFunction(packet)
    laixia.LocalPlayercfg.LHD.arrHistoryDetails = packet.data.arrHistoryDetails
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_RECORD_WINDOW)
end

local SCDragonHistoryRecord =
    {
        ID = _LAIXIA_PACKET_SC_DragonHistoryRecordID,

        name = "SCDragonHistoryRecord",
        data_array =
        {
            { "arrHistoryDetails",Type.Array, Type.UTF8 }
        },
        HandlerFunction = SCDragonHistoryFunction

    }

return SCDragonHistoryRecord