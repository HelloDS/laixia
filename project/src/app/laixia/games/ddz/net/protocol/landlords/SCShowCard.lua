
local Type = import("...DataType")

local function OpenPokerPacket(packet)

    laixiaddz.logGame("明牌消息")
    laixiaddz.logGame("After Clone OpenPokerPacket");
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOWCARD_LANDLORDTABLE_WINDOW, packet.data)
    end
end

SCShowCard =
    {
        ID = _laixiaddz_PACKET_SC_ShowCardID,
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


