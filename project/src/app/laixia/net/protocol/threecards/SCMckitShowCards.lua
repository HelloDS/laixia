-- 多人三张牌秀牌请求

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketSCMckitShowCards(packet)
    print("onPacketSCMckitShowCards  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_SHOWCARDS_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitShowCardsID,
        name = "SCMckitShowCards",
        data_array =
        {
            {"status", Type.Short },
            {"opSeat", Type.Byte},
            {"cardType", Type.Byte},
            {"roundId", Type.Int},
            {"cards", Type.Array, Type.Int},
        },
        HandlerFunction = onPacketSCMckitShowCards,
    }
