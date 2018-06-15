local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onGCExchangeRetPacket(packet)

    local StatusID = packet:getValue("StatusID")
    local Items = packet:getValue("Items")
    if StatusCode.new(packet.data.StatusID):isOK() then
        local addItems = {}
        for k, v in ipairs(Items) do
            v.noshowNum = false
            if v.ItemID == 1001 then
                laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
            elseif v.ItemID == 1002 then
                laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
            else
                v.noshowNum = true
            end
            if  v.ItemCount > 0  then
                table.insert(addItems , v)
            end
        end
        if #addItems > 0  then
            --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GETLAIDOU, addItems)
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAIN_WINDOW, addItems)
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "恭喜您兑换成功")
        end

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_PICTURE_WINDOW);
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_EXCHANGE_WINDOW)
    end
end

local SCExchange =
    {
        ID = _LAIXIA_PACKET_SC_ExchangeID,
        name = "SCExchange",
        data_array =
        {
            { "StatusID", Type.Short },
            { "SwitchID", Type.Int },
            { "Items", Type.Array, Type.TypeArray.Items },
        },
        HandlerFunction = onGCExchangeRetPacket,
    }

return SCExchange