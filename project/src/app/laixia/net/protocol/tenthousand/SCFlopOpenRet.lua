local Type = import("...DataType")
local StatusCode = import("...StatusCode")


local function SCFlopOpenRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_SHOW_OPENCADS,packet.data)
    end
end

local SCFlopOpenRet =
    {
        ID = _LAIXIA_PACKET_SC_FlopOpenRetID,
        name = "SCFlopOpenRet",
        data_array =
        {
            { "StatID", Type.Short },           --状态吗
            { "FlopNum", Type.Byte },           --发牌次数
            { "OpenCard", Type.Int },           --翻牌牌值
            { "ChangeCoin", Type.Int },         --筹码变化
            { "CardS",Type.Array, Type.Int},    --开牌牌值
        },
        HandlerFunction = SCFlopOpenRetCallBack
    }
return SCFlopOpenRet
 