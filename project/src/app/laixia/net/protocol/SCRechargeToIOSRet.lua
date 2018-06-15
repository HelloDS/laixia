--ios充值回调消息

local Type = import("..DataType")

local function onPacketSCRechargeToIOSRet(packet)
    if packet.data.StatuID ==  0  then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"购买成功")
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_RechargeToIOSRet,
        name = "SCRechargeToIOSRet",
        data_array =
        {
            {"StatuID", Type.Short},
        },
        HandlerFunction = onPacketSCRechargeToIOSRet,
    }


