local Type = import("..DataType")
local function onPacketSCVersionOpen(packet)

end

return
    {
        ID = _LAIXIA_PACKET_SC_VersionOpenID,
        name = "SCVersionOpen",
        data_array =
        {
            { "Status", Type.Short },-- 状态码
            { "OpenOrClose", Type.UTF8 },-- 功能开关状态
        },
        HandlerFunction = onPacketSCVersionOpen,
    }

--endregion
