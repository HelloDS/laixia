-- 多人三张牌请求坐下返回

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketGCTCTCSitDownRet(packet)
    print("onPacketGCTCTCSitDownRet  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_SITDOWN_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitSitDownID,
        name = "SCMckitSitDown",
        data_array =
        {
            {"status",          Type.Short },        --状态码
            {"seadId",          Type.Byte},
            {"player",          Type.TypeArrayType, Type.TypeArray.MckitPlayerInfo},
        },
        HandlerFunction = onPacketGCTCTCSitDownRet,
    }
