-- 多人三张牌请求看牌返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketGCTCSeedCardsRet(packet)
    print("onPacketGCTCSeedCardsRet  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_CARDS_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitSeeCardsID,
        name = "SCMckitSeeCards",
        data_array =
        {
            {"status", Type.Short },
            {"opSeat", Type.Byte},
            {"cardType", Type.Byte},
            {"roundId", Type.Int},
            {"opId", Type.Int},
            {"cards",  Type.Array, Type.Int},
        },
        HandlerFunction = onPacketGCTCSeedCardsRet,
    }


