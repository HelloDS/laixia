-- 进入龙虎斗游戏申请返回

local Type = import("...DataType")

local function SCDragonTigerSyncFunction(packet)
    if laixia.LocalPlayercfg.LHD == nil then
        return
    end
    laixia.LocalPlayercfg.LHD.state = packet.data.state
    laixia.LocalPlayercfg.LHD.restTime = packet.data.restTime
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_STATESYNC_WINDOW)
end

local SCDragonTigerSyncStage =
    {
        ID = _LAIXIA_PACKET_SC_DragonTigerSyncStageID,

        name = "SCDragonTigerSyncStage",
        data_array =
        {
            { "state", Type.Byte },
            { "restTime", Type.Int }
        },
        HandlerFunction = SCDragonTigerSyncFunction

    }

return SCDragonTigerSyncStage