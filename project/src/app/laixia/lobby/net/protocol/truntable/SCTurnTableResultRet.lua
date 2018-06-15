local Type = import("...DataType")
local StatusCode = import("...StatusCode")
-- 大转盘进入游戏回调
local function TurnTableResultCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        local data = packet.data
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DANMUMESG_TURNTABLE,data)
    end
end

local SCTurnTableResultRet =
    {
        ID = _LAIXIA_PACKET_SC_TurnTableResultRetID,
        name = "SCTurnTableResultRet",
        data_array =
        {
            {"StatID",Type.Short} ,
            { "turnTableRewards", Type.Array, Type.TypeArray.TurnTableRewards },
        },

        HandlerFunction = TurnTableResultCallBack
    }
return SCTurnTableResultRet
 