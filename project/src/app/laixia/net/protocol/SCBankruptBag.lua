local Type = import("..DataType")

local function onSCBankruptBagPacket(packet)

    laixia.LocalPlayercfg.LaixiaBankruptItemID = packet:getValue("BankruptBagID")
end

local SCBankruptBag =
    {
        ID = _LAIXIA_PACKET_SC_BankruptBagID,
        name = "SCBankruptBag",
        data_array =
        {
            { "StatusID", Type.Short },           -- 0 成功  1  失败
            { "FirstBuy", Type.Int },-- 状态码  >0 已充值   ==0 未充值   ==-1 订单处理中
            { "BankruptBagID", Type.Int},
        },
        HandlerFunction = onSCBankruptBagPacket,
    }

return SCBankruptBag