--[[
    来下引擎
    所有对接服务器接口，此处做统一处理
]]

LXEngine = LXEngine or {}

--[[
    发送大厅数据包
]]
function LXEngine.sendHallPacket()
    local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
    stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end
