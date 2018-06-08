--[[
    兼容原来Pactket数据模式
]]

local HttpRequest = require("games.ddz.net.HttpRequest")


-- reqType : "get"  "post"
function HttpRequest:sendPacket(packet, cb)
    HttpRequest.request(packet.key, packet, cb)
end

function HttpRequest:sendHttpPacket(packet)
    HttpRequest.request(packet.key, packet)
end

function HttpRequest:sendHttpPacketAndWaiting (packet,cb)
    HttpRequest.request(packet.key, packet, cb)
end

function HttpRequest:sendPacketAndWaiting (packet,msgID,waitID)
	dump(packet,"packet---ddz11111")
    HttpRequest.send( packet.key , packet.data)
end

function HttpRequest:sendSocketPacket(packet)
	dump(packet,"packet---ddz22222")
    HttpRequest.send( packet.key , packet)
	
end
return HttpRequest