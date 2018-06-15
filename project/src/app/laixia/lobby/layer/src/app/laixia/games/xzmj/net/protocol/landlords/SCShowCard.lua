
local Type = import("...DataType")

local function OpenPokerPacket(packet)

    laixiaddz.loggame("明牌消息")
    laixiaddz.loggame("After Clone OpenPokerPacket");
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOWCARD_LANDLORDTABLE_WINDOW, packet.data)
    end
end

SCShowCard =
    {
        ID = _LAIXIA_PACKET_SC_ShowCardID,
        -- 明牌,
        name = "SCShowCard",
        data_array =
        {
            { "CardArray", Type.Array, Type.TypeArray.Card },
            { "Seat", Type.Byte },
        },
        HandlerFunction = OpenPokerPacket,
    };

return SCShowCard


