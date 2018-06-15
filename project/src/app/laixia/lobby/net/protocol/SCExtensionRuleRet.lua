--领取救济金

local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketExtensionRuleRet(packet)
    if StatusCode.new(packet.data.StatusID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_EXTENSION_WINDOW,packet.data)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_ExtensionRuleRetID,
        name = "SCExtensionRuleRet",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "Per", Type.Int },-- 百分比
            { "BindingGold", Type.Int },-- 绑定金币
            { "BindingPid", Type.Int },-- 绑定的pid 大于0则绑定了
            { "AwardGold", Type.Int },-- 可领取金，用于界面显示
        },
        HandlerFunction = onPacketExtensionRuleRet,
    }


