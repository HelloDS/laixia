
local Type = import("...DataType")

local function onPacketSCMatchFloatword(packet)
    local str = packet:getValue("Tips")
    local mtype = packet:getValue("Type")
    if mtype == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, str)
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, str)
    end

end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchFloatwordID,
        name = "SCMatchFloatword",
        data_array =
        {
            {"GameID", Type.Byte},
            {"Type",Type.Byte},-- 飘字类型，0 普通飘字，1 闪字
            {"Tips", Type.UTF8},
        },
        HandlerFunction = onPacketSCMatchFloatword,
    }

--endregion
