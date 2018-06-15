--排行榜单机某个玩家

local Type = import("..DataType")

local function onSCPlayerRankInfoPacket(packet)
    local player = {}
    player.signStr = packet:getValue("SignStr")
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_USERINFO_WINDOW,player)
end

local  SCPlayerRankInfo =
    {
        ID = _LAIXIA_PACKET_SC_PlayerRankInfoID,
        name = "SCPlayerRankInfo",
        data_array =
        {
            {"StatusID", Type.Short },
            {"SignStr", Type.UTF8 },-- 签名
        },
        HandlerFunction =  onSCPlayerRankInfoPacket,
    }

return SCPlayerRankInfo