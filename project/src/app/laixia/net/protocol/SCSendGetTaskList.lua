local Type = import("..DataType")

local function onSCGetTaskListPacket(packet)
    dumpGameData(packet)
    laixia.LocalPlayercfg.LaixiaTaskList =packet.data.TaskItems --TODO ---alexwang
end

local SCSendGetTaskList =
    {
        ID = _LAIXIA_PACKET_SC_GETTASKLIST,
        name = "SCSendGetTaskList",
        data_array =
        {
            {"StatusID", Type.Short },-- 状态码
            {"TaskItems" , Type.Array, Type.TypeArray.TaskItems},
        },
        HandlerFunction = onSCGetTaskListPacket,
    }

return SCSendGetTaskList