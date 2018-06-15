local Type = import("...DataType")
local StatusCode = import("...StatusCode")

-- 大转盘进入游戏回调
local function TurnTableEnterRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        local data = packet.data
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BIGTURNTABLE_WINDOW,data)
    end
end

local SCTurnTableEnterRet =
{
    ID = _LAIXIA_PACKET_SC_TurnTableEnterRetID,
    name = "SCTurnTableEnterRet",
    data_array =
    { 
        --进入状态
        {"StatID",Type.Short} ,
        { "CostSmall", Type.Int  },
        { "CostMid", Type.Int  },
        { "CostBig", Type.Int  },
        {"FreeTime",Type.Int},
        --转盘信息
        { "turnTableInfo", Type.Array, Type.TypeArray.TurnTableInfo },
        { "TurnTableRewards",Type.Array,Type.TypeArray.TurnTableRewards},
       
       
    },
    HandlerFunction = TurnTableEnterRetCallBack 
} 
return SCTurnTableEnterRet
 