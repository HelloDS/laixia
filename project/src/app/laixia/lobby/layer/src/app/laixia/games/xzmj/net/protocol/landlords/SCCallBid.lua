--region 叫牌/抢地主
local Type = import("...DataType")
local StatusCode = import("...StatusCode")
local function CallLandlordretPacket(packet)
    laixiaddz.loggame("叫分抢地主消息" )

    if StatusCode.new(packet.data.StatusID):isOK() then
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog"  and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CALL_LANDLORDTABLE_WINDOW,packet.data)
        end
    end
end

return
    {
        ID= _LAIXIA_PACKET_SC_CallBidID ,--叫牌/抢地主
        name = "SCCallBid",
        data_array =
        {
            {"StatusID",Type.Short},         --状态码  0 失败 1 成功
            {"Type",Type.Byte},            --下注类型  0 叫分 1 抢地主
            {"Chip",Type.Int},             --倍数    BidType
            {"Seat",Type.Byte},            --座位号
            {"Constraint",Type.Byte}       --0主动强地主 1强行发地主 --这个不能删除
        },
        HandlerFunction = CallLandlordretPacket,
    }

