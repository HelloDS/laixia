--牌桌阶段同步消息

local Type = import("...DataType")
local socket = require("socket")

local function TableSyncPacket(packet)
    laixiaddz.loggame("阶段同步消息 _LAIXIA_SCTableSyncStage   State："..packet.data.State  )
    dumpGameData(packet.data,"阶段同步数据")
    laixia.LocalPlayercfg.mStageStep = clone(packet.data )
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true  then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SYNTABLESTAGE_WINDOW,packet.data)
    end
end

SCTableSyncStage =  -- 牌桌阶段,
    {
        ID = _LAIXIA_PACKET_SC_TableSyncStageRetID,
        name = "SCTableSyncStage",
        data_array =
        {
            { "State", Type.Byte },--牌桌的状态
            { "Laizi",Type.Byte}, -- 癞子 -- 牌值默认为 -1 -- 牌值0~12对应3~2
            { "Times", Type.Double },--超时时间
            { "Seat", Type.Byte },--当前操作位

        },
        HandlerFunction = TableSyncPacket,
};

return  SCTableSyncStage

