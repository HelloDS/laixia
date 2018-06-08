local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function SCFlopInitRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK()  and (packet.data.FlopCoin > 0)  then
        local  flopCoin = packet.data.FlopCoin
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_SHOW_DOUBLEWINDOW,flopCoin)
    end
end

local SCFlopInitRet =
    {
        ID = _LAIXIA_PACKET_SC_FlopInitRetID,
        name = "SCFlopInitRet",
        data_array =
        {
            --进入状态
            { "StatID", Type.Short },      --状态吗
            { "FlopCoin", Type.Int },      --带入金币

        },
        HandlerFunction = SCFlopInitRetCallBack
    }
return SCFlopInitRet
 