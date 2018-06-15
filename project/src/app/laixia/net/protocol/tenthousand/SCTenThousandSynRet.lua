local Type = import("...DataType")
local StatusCode = import("...StatusCode")


local function TenThousandSynRetCallBack(packet)
    local e_gold =  packet.data.OneTotalGold
    local s_gold =  packet.data.TwoTotalGold
    local w_gold =  packet.data.ThreeTotalGold
    local n_gold =  packet.data.FourTotalGold

    laixia.logPacketID("e_gold \t"..e_gold)
    laixia.logPacketID("s_gold \t"..s_gold)
    laixia.logPacketID("w_gold \t"..w_gold)
    laixia.logPacketID("n_gold \t"..n_gold)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENIUNIU_UPDATECHIP ,packet.data )
end

local SCTenThousandSynRet =
    {
        ID = _LAIXIA_PACKET_SC_TenThousandSynRetID,
        name = "SCTenThousandSynRet",
        data_array =
        {
            { "State", Type.Byte },                 --当前阶段
            { "Type", Type.Byte },                  --类型
            { "OtherPid", Type.Int },               --押注玩家ID
            { "AddGold", Type.Int } ,               --押注金币
            { "OneTotalGold", Type.Double },        --押1所有金币
            { "TwoTotalGold", Type.Double },        --押2所有金币
            { "ThreeTotalGold", Type.Double },      --押3所有金币
            { "FourTotalGold", Type.Double },       --押4所有金币
            { "RestTime", Type.Double },            --当前结算剩余时间
            { "CurTime", Type.Double },             --服务器时间
        },
        HandlerFunction = TenThousandSynRetCallBack
    }
return SCTenThousandSynRet
 