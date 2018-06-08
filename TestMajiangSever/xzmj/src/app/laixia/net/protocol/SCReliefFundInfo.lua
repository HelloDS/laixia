
local Type = import("..DataType")

local function onPacketGetBenefitsInfoRet(packet)
    laixia.LocalPlayercfg.LaixiaBenefitsMaxNum = packet.data.JiuJiJinALL
    laixia.LocalPlayercfg.LaixiaBenefitsReceiveNum = packet.data.JiuJiJinReceive
end

return
    {
        ID = _LAIXIA_PACKET_SC_ReliefFundInfoID,
        name = "SCReliefFundInfo",
        data_array =
        {
            {"StatusID", Type.Short },-- 状态码
            {"JiuJiJinReceive", Type.Byte },--还能领取救济金的次数
            {"JiuJiJinALL", Type.Byte }, --当天的最大次数
        },
        HandlerFunction = onPacketGetBenefitsInfoRet,
    }

