local Type = import("..DataType")

local function onSCSuperGiftPacket(packet)

    local msg = packet.data
    if msg.FirstBuySuperGif > 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"今日特惠礼包已经卖完啦，请前往商城购买其他礼包")
    end
end

local SCSuperGift =
    {
        ID = _LAIXIA_PACKET_SC_SuperGiftID,
        name = "SCSuperGift",
        data_array =
        {
            { "StatuID", Type.Short },           -- 0 成功  1  失败
            { "FirstBuySuperGift", Type.Int },   -- 0：今天未购买超级礼包   >0 今天已经购买过    <0  订单处理中
            { "SuperGiftItemID", Type.Int }       --礼包ID
        },
        HandlerFunction = onSCSuperGiftPacket,
    }

return SCSuperGift