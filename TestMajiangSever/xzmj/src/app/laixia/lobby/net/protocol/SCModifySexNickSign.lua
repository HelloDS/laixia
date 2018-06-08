local Type = import("..DataType")

local function onModifySexNick(packet)
    local canMd = packet.data.CanMd
    local canMdNk = packet.data.CanMdNk
    if canMd == 0 and canMdNk == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SUCCESS_REVISESEXNICK_WINDOW)
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "包含敏感词！")
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_ModifySexNickSignID,
        name = "SCModifySexNickSign",
        data_array =
        {
            {"StatID",Type.Short},
            { "CanMd", Type.Byte },
            { "CanMdNk", Type.Byte }
        },
        HandlerFunction = onModifySexNick,
    }
