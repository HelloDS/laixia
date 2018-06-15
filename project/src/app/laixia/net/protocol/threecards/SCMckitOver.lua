-- 多人三张牌游戏结束推送

local Type = import("...DataType")
local Model = Type.TypeArray
local function onPacketGCTCGameOverkRet(packet)
    print("onPacketGCTCGameOverkRet  ~~~~~~~~~~~~~~~~")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MCKIT_GAMEOVER_WINDOW, packet.data);
end

return
    {
        ID = _LAIXIA_PACKET_SC_MckitOverID,
        name = "SCMckitOver",
        data_array =
        {
        },
        HandlerFunction = onPacketGCTCGameOverkRet,
    }
