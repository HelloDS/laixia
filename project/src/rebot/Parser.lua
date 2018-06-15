local Packet = require("rebot.Packet")
local DataType = require("rebot.DataType")
local PacketFiles = require("rebot.PacketFiles")
local Parser = class("Parser")

--[[
    构造函数
]]
function Parser:ctor()
    self.m_stream = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
end

--[[
    数据包转换数据流
]]
function Parser:packetToStream(packet)
    local pid = packet:getPacketID()
    local packfile = PacketFiles.getProtocolById(pid)
    if not packfile then
        return nil
    end
    self.m_stream:clear()
    --生成数据流
    local dataStream = self:getStreamByPacket(packet)
    --生成最后的数据流
    self:getEndStream(packet,dataStream)
    local bav = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
    --写入另一个字符传流
    bav:writeBytes(self.m_stream) 
    return bav
end

--[[
    生成数据流
]]
function Parser:getStreamByPacket(packet)
    if not packet then
        return
    end
    local id = packet:getPacketID()
    local theDataStream = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
    local fmt = PacketFiles.getProtocolById(id).data_array
    for i,v in ipairs(fmt) do
        local name = v[1]
        local type = v[2]
        local dataType = v[3]
        self:writeStream(theDataStream,packet.m_packetInfo[name],type,dataType)
    end
    theDataStream:setPos(1)
    return theDataStream
end

--[[
    写入数据流
]]
function Parser:writeStream(theDataStream,v,vType,dataType)
    if(vType == DataType.Int) then
        theDataStream:writeInt(v)
    elseif (vType== DataType.Byte) then
        theDataStream:writeByte(v)
    elseif (vType == DataType.Short) then
        theDataStream:writeShort(v)
    elseif (vType == DataType.Float) then
        theDataStream:writeFloat(v)
    elseif (vType == DataType.Double) then
        theDataStream:writeDouble(v)
    elseif (vType == DataType.LuaNumber)then
        theDataStream:writeInt(v)
    elseif (vType == DataType.UTF8) then
        theDataStream:writeStringUShort(v)
    elseif (vType == DataType.TypeArrayType)then
        self:writeTypeArray(theDataStream,v,dataType)
    elseif(vType == DataType.Array) then
        self:writeArray(theDataStream,v,dataType)
    elseif(vType == DataType.ByteArray) then --
        self:writeByteArray(theDataStream, v)
    else
        error("Error WriteToStream")
    end
    return theDataStream
end

--[[
    写入TypeArrayType
]]
function Parser:writeTypeArray(dataStream,value,dataType)
    if(type(value) == "table") then
        for i,v in ipairs(dataType) do
            local tKey = v[1]
            local tType = v[2]
            local tDataType = v[3]
            local tValue = value[tKey]
            self:writeStream(dataStream,tValue,tType,tDataType)
        end
    end
end

--[[
    写入Array
]]
function Parser:writeArray(dataStream,value,dataType)
    if(type(value) == "table") then
        local length = #value
        --写入长度
        self:writeStream(dataStream,length,DataType.Int) 
        for i = 1,length do
            self:writeStream(dataStream,value[i],DataType.TypeArrayType,dataType)
        end
    end
end

--[[
    写入ByteArray
]]
function Parser:writeByteArray(dataStream, value)
    local size = #value
    dataStream:writeInt(size)
    if size > 0 then
        dataStream:writeStringBytes(value)
    end
end

--[[
    生成最后的数据流
]]
function Parser:getEndStream(packet,dataStream)
    --刷新流指针
    self.m_stream:setPos(1)                           
    self.m_stream:writeInt(dataStream:getLen())
    self.m_stream:writeInt(packet:getPacketID())
    self.m_stream:writeInt(packet:getPlayerID())
    self.m_stream:writeInt(packet:getGameMsgVersion())
    self.m_stream:writeInt(packet:getClientVersion())
    --刷新流指针
    dataStream:setPos(1)             
    --写入另一个字符传流               
    self.m_stream:writeBytes(dataStream)              
end

--[[
    数据流转换数据包
]]
function Parser:streamToPacket(rawBytes)
    if not rawBytes then
        return nil
    end
    local packets = {}
    self:readStream(rawBytes)
    --全部读完，pos 应该等于  buf_len + 1
    while self.m_stream:getPos() < #self.m_stream._buf do
        local newPacket = self:getPacket()
        if(newPacket ~= nil)then
            self:_readPersonalToPacket(newPacket)
            table.insert(packets,newPacket)
        end
    end
    return packets
end

--[[
    生成数据包
]]
function Parser:getPacket()
    local packet = Packet.new()
    -- 消息包的长度
    local msgLen =  self.m_stream:readInt()
    if msgLen == nil or msgLen == 0 then
        self.m_stream:setPos(self.m_stream:getPos() + 4)
        return nil
    end
    local id = self.m_stream:readUInt()
    local id_p = bit.band(id,0xffffffff)
    local varInfo = string.format("recv packet = 0x%X(%u)",id,id)
    if(PacketFiles.getProtocolById(id) == nil)then
        return nil
    end
    packet:setPacketName(PacketFiles.getProtocolById(id).name)
    packet:setPacketID(id, true)
    packet:setPlayerID(self.m_stream:readInt())
    packet:setGameMsgVersion(self.m_stream:readInt())
    packet:setClientVersion(self.m_stream:readInt())
    return packet
end

--[[
    读取数据流
]]
function Parser:readStream(rawDataBytes)
    self.m_stream:clear()
    self.m_stream:writeBuf(rawDataBytes)
    self.m_stream:setPos(1)
end

--[[
    读取个人信息到数据包
]]
function Parser:_readPersonalToPacket(packet)
    local ptl  = PacketFiles.getProtocolById(packet:getPacketID()).data_array
    for _,v in ipairs(ptl) do
        local type = v[2]
        local dataType = v[3]
        local data = self:readStreamByDataType(type,dataType)
        packet:setPacketInfo(v[1],data)
    end
end

--[[
    通过数据类型读取数据流
]]
function Parser:readStreamByDataType(Type,dataType)
    if(self.m_stream:getPos() >self.m_stream:getLen()) then
        return false
    end
    if(Type == DataType.Int) then
        return self.m_stream:readInt()
    elseif (Type == DataType.Byte) then
        return self.m_stream:readByte()
    elseif (Type == DataType.Short) then
        return self.m_stream:readShort()
    elseif (Type == DataType.Float) then
        return self.m_stream:readFloat()
    elseif (Type == DataType.Double) then
        return self.m_stream:readDouble()
    elseif (Type == DataType.LuaNumber)then
        return self.m_stream:readInt()
    elseif (Type == DataType.UTF8) then
        return self.m_stream:readStringUShort()
    elseif (Type == DataType.TypeArrayType) then
        return self:readTypeArray(dataType)
    elseif (Type == DataType.Array) then
        return self:readArray(dataType)
    else
        error("Error readStreamByDataType: ",Type)
    end
end

--[[
    读取Array
]]
function Parser:readArray(dataType)
    local dataArray = {}
    local num = self.m_stream:readInt()
    for i = 1,num do
        local data = self:readTypeArray(dataType)
        dataArray[i] = data
    end
    return dataArray
end

--[[
    读取TypeArrayType
]]
function Parser:readTypeArray(dataType)
    if type(dataType)== "number" then
        return self:readStreamByDataType(dataType)
    else
        local Data = {}
        for i,v in ipairs(dataType) do
            Data[v[1]] = self:readStreamByDataType(v[2],v[3])
        end
        return Data
    end
end

return Parser
