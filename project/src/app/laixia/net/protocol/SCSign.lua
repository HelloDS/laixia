local Type = import("..DataType")

local function onSCSignPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusID == 0 then
        local Items = packet:getValue("Items")
        laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign = 1
        laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay = laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay 
        for i, v in ipairs(Items) do
            if v.ItemID == 1001 then
                laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + v.ItemCount
            elseif v.ItemID == 1002 then
                laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon + v.ItemCount
            end
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SIGNIN_DAILYSIGN_WINDOW,packet.data)
    end
end

local SCSign =
    {
        ID = _LAIXIA_PACKET_SC_SignID,
        name = "SCSign",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "Items", Type.Array, Type.TypeArray.Items },
        },
        HandlerFunction = onSCSignPacket,
    }

return SCSign