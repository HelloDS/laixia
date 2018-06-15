local Type = import("...DataType")
local StatusCode = import("...StatusCode")


local function SCFlopEndRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_HIDE_DOUBLEWINDOW)
    end
end

local SCFlopEndRet =
    {
        ID = _LAIXIA_PACKET_SC_FlopEndRetID,
        name = "SCFlopEndRet",
        data_array =
        {
            --进入状态
            { "StatID", Type.Short },      --状态吗

        },
        HandlerFunction = SCFlopEndRetCallBack
    }
return SCFlopEndRet
 