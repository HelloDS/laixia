--牌桌阶段同步消息

local Type = import("...DataType")
local socket = require("socket")

local function TableSyncPacket(packet)
    laixiaddz.logGame("阶段同步消息 _laixiaddz_SCTableSyncStage   State："..packet.data.State  )
    dumpGameData(packet.data,"阶段同步数据")
    laixiaddz.LocalPlayercfg.mStageStep = clone(packet.data )
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true  then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SYNTABLESTAGE_WINDOW,packet.data)
    end
end

SCTableSyncStage =  -- 牌桌阶段,
    {
        ID = _laixiaddz_PACKET_SC_TableSyncStageRetID,
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

