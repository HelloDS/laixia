local Type = import("..DataType")

local function onGCQuickBagRetPacket(packet)

    local StatusID = packet:getValue("StatusID")
    local FirstBuy = packet:getValue("FirstBuy")
    if FirstBuy == 0 then
        laixia.LocalPlayercfg.LaixiaShowActivyWindow = 1
    else
        laixia.LocalPlayercfg.LaixiaShowActivyWindow = 0
    end
end

local SCQuickSuperBag =
    {
        ID = _LAIXIA_PACKET_SC_QuickSuperBagID,
        name = "SCQuickSuperBag",
        data_array =
        {
            { "StatusID", Type.Short },           -- 0 成功  1  失败
            { "FirstBuy", Type.Int },-- 状态码  >0 已充值   ==0 未充值   ==-1 订单处理中
            { "QuickSuperItemID", Type.Int},
        },
        HandlerFunction = onGCQuickBagRetPacket,
    }

return SCQuickSuperBag