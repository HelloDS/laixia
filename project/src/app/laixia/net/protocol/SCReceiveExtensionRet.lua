
local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketReceiveExtensionRet(packet)
    if StatusCode.new(packet.data.StatusID):isOK() then
        laixia.LocalPlayercfg.LaixiaPlayerGold =  packet.data.AllGold
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_EXTENSION_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "领取金币"..packet.data.AddGold)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_ReceiveExtensionRetID,
        name = "SCReceiveExtensionRet",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "AllGold", Type.Double },-- 状态码
            { "AddGold", Type.Int },-- 增加金币
        },
        HandlerFunction = onPacketReceiveExtensionRet,
    }


