local PacketFiles= require("rebot/PacketFiles")
local DataType = require("rebot/DataType")
local Packet = class("Packet")

--[[
    构造函数
]]
function Packet:ctor(p_name,p_id)
    --数据包ID
    self.mPacketID         = p_id or 0
    --数据包名
    self.m_packetName       = p_name or "DummyPacket"
    --玩家ID
    self.m_playerId         = 0
    --协议版本号
    self.m_gameMsgVersion   = 4
    --客户端版本号
    self.m_clientVersion    = 4
    --包数据
    self.m_packetInfo       = {}

    if(PacketFiles.Protocols[p_id] ==nil) then
        return
    end

    self:loadPacketInfo()
end

--[[
    设置数据包信息
]]
function Packet:loadPacketInfo()
    if self.mPacketID and self.mPacketID ~= 0 then
        local info = PacketFiles.Protocols[self.mPacketID]
        if info and type(info.data_array) == "table" then
            local dataArray = info.data_array
            local format = DataType.Default
            for i,v in ipairs(dataArray) do
                local key = v[1]
                local value = (v[2] >= 0 and v[2] <= #format) and format[v[2]] or nil
                self.m_packetInfo[key] = value
            end
        end
    end
end

--[[
    设置数据包名
]]
function Packet:setPacketName(name)
    if not name then
        return
    end
    self.m_packetName = name
end

--[[
    返回数据包名
]]
function Packet:getPacketName()
    return self.m_packetName
end

--[[
    设置数据包ID
        @parme int  p_id      数据包ID
        @parme bool isRefresh 是否刷新数据
]]
function Packet:setPacketID(p_id, isRefresh)
    if not p_id then
        return
    end
    self.mPacketID = p_id
    if isRefresh then
        self:loadPacketInfo()
    end
end

--[[
    返回数据包ID
]]
function Packet:getPacketID()
    return self.mPacketID
end

--[[
    设置玩家ID
]]
function Packet:setPlayerID(playerID)
    if not playerID then
        return
    end
    self.m_playerId = playerID
end

--[[
    返回玩家ID
]]
function Packet:getPlayerID()
    return self.m_playerId
end

--[[
    设置协议版本号
]]
function Packet:setGameMsgVersion(version)
    if not version then
        return
    end
    self.m_gameMsgVersion = version
end

--[[
    返回协议版本号
]]
function Packet:getGameMsgVersion()
    return self.m_gameMsgVersion
end

--[[
    设置客户端版本号
]]
function Packet:setClientVersion(version)
    if not version then
        return
    end
    self.m_clientVersion = version
end

--[[
    返回客户端版本号
]]
function Packet:getClientVersion()
    return self.m_clientVersion
end

--[[
    设置数据包信息
]]
function Packet:setPacketInfo(key,value)
    if not key or not value then
        return
    end
    if self.m_packetInfo and self.m_packetInfo[key] then
        self.m_packetInfo[key] = value
    end
end

--[[
    通过键值返回数据包信息
]]
function Packet:getPacketInfoByKey(key)
    local ret = nil
    if self.m_packetInfo and self.m_packetInfo[key] then
        ret = self.m_packetInfo[key]
    end
    return ret
end

--[[
    返回数据包信息
]]
function Packet:getPacketInfo()
    return self.m_packetInfo
end

return Packet
