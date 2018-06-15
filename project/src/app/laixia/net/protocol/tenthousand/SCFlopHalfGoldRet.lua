local Type = import("...DataType")
local StatusCode = import("...StatusCode")


local function SCFlopHalfGoldRetCallBack(packet)
    if packet.data.StatID == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_HALF_CHIPRET,packet.data)
    end
end

local SCFlopHalfGoldRet =
    {
        ID = _LAIXIA_PACKET_SC_FlopHalfGoldRetID,
        name = "SCFlopHalfGoldRet",
        data_array =
        {
            --进入状态
            { "StatID", Type.Short },      --状态吗

            { "Remain", Type.Int },     --剩余的筹码

        },
        HandlerFunction = SCFlopHalfGoldRetCallBack
    }
return SCFlopHalfGoldRet
 