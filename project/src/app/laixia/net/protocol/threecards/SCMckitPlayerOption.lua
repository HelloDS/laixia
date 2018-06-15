-- 多人三张牌该某人操作通知

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitPlayerOption(packet)
    print("onPacketSCMckitPlayerOption  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_OPTBEGIN_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitPlayerOptionID,
        name = "SCMckitPlayerOption",
        data_array =
        {
            {"curSeadId", Type.Byte},
            {"optType", Type.Byte},
            {"roundId", Type.Int},
            {"totalOperTm", Type.Int},          -- 操作时间
            {"followBet", Type.Double},          -- 当前跟注额，加注的话要比这个高
        },
        HandlerFunction = onPacketSCMckitPlayerOption,
    }
