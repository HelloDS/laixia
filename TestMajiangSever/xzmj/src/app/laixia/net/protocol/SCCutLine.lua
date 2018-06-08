local Type = import("..DataType")

local function onPacketSCCutLine(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "服务器开始维护。",OnCallFunc = function() os.exit()  end})
end

return
    {
        ID = _LAIXIA_PACKET_SC_CutLineID,
        name = "SCCutLine",
        data_array =
        {
            {"GameID", Type.Byte },
        },
        HandlerFunction = onPacketSCCutLine,
    }
--endregion
