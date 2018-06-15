
local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketExtensionBindingRet(packet)
    if StatusCode.new(packet.data.StatusID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_EXTENSION, packet.data)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_ExtensionBindingRetID,
        name = "SCExtensionBindingRet",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "AllGold", Type.Double },-- 所有的金币
            { "AddGold", Type.Int },-- 增加金币
        },
        HandlerFunction = onPacketExtensionBindingRet,
    }


