-- 取消托管消息包

local Type = import("...DataType")

local function CancelHostingPacket(packet)
    laixiaddz.logGame("取消托管消息" )
    laixiaddz.logGame(packet.data.Seat)
    laixiaddz.logGame(packet.data.Trusteeship)
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true  then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MANDATE_LANDLORDTABLE_WINDOW,packet.data)
    end
end


SCCancelMandate =
    {
        ID = _laixiaddz_PACKET_SC_CancelMandateID,    -- 托管,
        name = "SCCancelMandate",
        data_array =
        {
            { "Status", Type.Short },   --状态码
            { "Seat",Type.Byte},         --座位号
            { "Trusteeship",Type.Byte}, --0：非托管1超时托管2退出托管3主动托管

        },
        HandlerFunction = CancelHostingPacket,
    };

return SCCancelMandate
