-- 多人三张牌请求弃牌返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitThrowCards(packet)
    print("onPacketSCMckitThrowCards  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_THROWCARDS_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitThrowCardsID,
        name = "SCMckitThrowCards",
        data_array =
        {
            {"status", Type.Short },
            {"opSeat", Type.Byte},
            {"roundId", Type.Int},
            {"opId", Type.Int},
        },
        HandlerFunction = onPacketSCMckitThrowCards,
    }
