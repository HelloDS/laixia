

--changelog：
--，cocos2dx 的bit 换了。所有 bit.bor() 出来的值是一个无符号的整数，所以Packet的 ID 也要用readUInt() 读取



local mod_name = ...;


--net  = net or  {};

local Packet = import(".Packet");
local Protocol = import(".PacketFiles");

local Parser = class("Parser")

function Parser:ctor()
    ----print("Parser ctor")

    self.stream = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
end

function Parser:packetToStream(packet)
    --printInfo("Parser:packetToStream")
    if(Protocol.Protocols[packet:getPacketID()] == nil)then
        return nil
    end



    self.stream:clear() --
    local dataStream = self:_generateDataStream(packet) --生成数据流
    self:_generateFinalStream(packet,dataStream) --生成最后的数据流

    -- 发送的原始数据


    ----printInfo("stream: %s %d",  self.stream:toString(),self.stream:getLen())
    local bav = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG);
    bav:writeBytes(self.stream) -- 写入另一个字符传流
    return bav;
end



function Parser:streamToPacket(rawBytes)
    --print("Parser:streamToPacket")

    --local wPacket = nil

    if(rawBytes ~= nil) then
        local packets = {};
        self:_readStream(rawBytes)
        --全部读完，pos 应该 dengyu  buf_len + 1
        while self.stream:getPos() < #self.stream._buf do
            --print("pos",self.stream:getPos());
            --print("buf_len",#self.stream._buf);
            local newPacket = self:_generatePacket()
            if newPacket.mName=="SCSendGetTaskList" then
                local test = 1
            end
            if(newPacket ~= nil)then
                ----print("pos",self.stream:getPos());
                self:_readPersonalToPacket(newPacket)
                ----print("pos",self.stream:getPos());
                table.insert(packets,newPacket);
            end
        end
        return packets;
    end
    return nil;
end


function Parser:_writeToStream(theDataStream,v,vType,DataType)
    ----print("Parser:_writeToStream :Type",vType)

    if(type(vType) == "table") then
    --  dump(vType)
    end

    if(vType == Protocol.dataType.Int) then
        theDataStream:writeInt(v)
    elseif (vType== Protocol.dataType.Byte) then
        theDataStream:writeByte(v)
    elseif (vType == Protocol.dataType.Short) then
        theDataStream:writeShort(v)
    elseif (vType == Protocol.dataType.Float) then
        theDataStream:writeFloat(v)
    elseif (vType == Protocol.dataType.Double) then
        theDataStream:writeDouble(v)
    elseif (vType == Protocol.dataType.LuaNumber)then
        theDataStream:writeInt(v)
    elseif (vType == Protocol.dataType.UTF8) then
        theDataStream:writeStringUShort(v)
    elseif (vType == Protocol.dataType.TypeArrayType)then
        self:_writeModelType(theDataStream,v,DataType)
    elseif(vType == Protocol.dataType.Array) then
        self:_writeArray(theDataStream,v,DataType)
    elseif(vType == Protocol.dataType.ByteArray) then --
        self:_writeByteArray(theDataStream, v)
    else
        error("Error WriteToStream")
    end
    return theDataStream
end

--
function Parser:_writeModelType(dataStream,value,DataType)
    --print("Parser:_writeModelType")

    if(type(value) == "table") then
        ----print("loop: writeModelType table")
        for i,v in ipairs(DataType) do
            local tKey = v[1] -- name
            local tType = v[2]
            local tDataType = v[3]
            --local tType = DataType[i]         --print("tType ",tType[1],tType[2])
            local tValue = value[tKey]
            self:_writeToStream(dataStream,tValue,tType,tDataType)
        end
    end
end

--字节数组类型
function Parser:_writeByteArray(dataStream, value)
    local size = #value
    dataStream:writeInt(size)

    if( size >0 )then
        dataStream:writeStringBytes(value)
    end
end

function Parser:_writeArray(dataStream,value,DataType)
    ----print("Parser:_writeArray")
    --dump(DataType)
    if(type(value) == "table") then
        local num = #value
        --print(num)
        self:_writeToStream(dataStream,num,Protocol.dataType.Int) -- 写入长度
        for i = 1,num do
            self:_writeToStream(dataStream,value[i],Protocol.dataType.TypeArrayType,DataType)
        end
    end
end
function Parser:_readToPacket(packet,v,Type,DataType)

    local data = self:_readFromStream(Type,DataType)
    packet:setValue(v,data)

    if(data ~= false) then
        return true
    end
    return false

end

function Parser:_readFromStream(Type,DataType)
    ----print("Parser:_readFromStream Type = ",Type,"DataType = ",DataType);
    if(self.stream:getPos() >self.stream:getLen()) then
        return false
    end

    if(Type == Protocol.dataType.Int) then
        return self.stream:readInt()
    elseif (Type == Protocol.dataType.Byte) then
        return self.stream:readByte()
    elseif (Type == Protocol.dataType.Short) then
        return self.stream:readShort()
    elseif (Type == Protocol.dataType.Float) then
        return self.stream:readFloat()
    elseif (Type == Protocol.dataType.Double) then
        return self.stream:readDouble()
    elseif (Type == Protocol.dataType.LuaNumber)then
        return self.stream:readInt()
    elseif (Type == Protocol.dataType.UTF8) then
        return self.stream:readStringUShort()
    elseif (Type == Protocol.dataType.TypeArrayType) then
        return self:_readModelType(DataType)
    elseif (Type == Protocol.dataType.Array) then
        return self:_readArrayData(DataType)
    else
        error("Error _readFromStream: ",Type)
    end
    --return true
end

function Parser:_readArrayData(DataType)
    ----print("Parser:_readArrayData")
    --dump(DataType)
    local dataArray = {}
    local num = self.stream:readInt()
    ----print("_readArrayData:num",num)
    for i = 1,num do
        local data = self:_readModelType(DataType)
        --table.insert(dataArray,data)
        --dump(data)
        dataArray[i] = data;
    end

    return dataArray
end

function Parser:_readModelType(DataType)
    ----print("Parser:_readModelType");
    if(type(DataType)== "number") then
        return self:_readFromStream(DataType) --
    else
        local Data = {}
        for i,v in ipairs(DataType) do
            ----print("_readModelType:",i)
            Data[v[1]] = self:_readFromStream(v[2],v[3])

        end
        --dump(Data)
        return Data
    end
end

function Parser:_readStream(rawDataBytes)
    self.stream:clear()
    self.stream:writeBuf(rawDataBytes)
    self.stream:setPos(1)
end


function Parser:_generateFinalStream(packet,dataStream)
    self.stream:setPos(1)                           -- 刷新流指针
    self.stream:writeInt(dataStream:getLen())       --
    self.stream:writeInt(packet:getPacketID())      -- PacketID 4
    self.stream:writeInt(packet:getPlayerID())      -- PlayerID
    self.stream:writeInt(packet:getVersion())      -- 1
    self.stream:writeInt(packet:getExtension())    -- 1

    dataStream:setPos(1)                            -- 刷新流指针
    self.stream:writeBytes(dataStream)              -- 写入另一个字符传流
end

function Parser:_generateDataStream(packet)    --生成数据流
    local id = packet:getPacketID()
    ----print("PacketID",id)
    local theDataStream = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
    local fmt = Protocol.Protocols[id].data_array
    for i,v in ipairs(fmt) do
        ----print("i",i,"v",v[1],v[2],v[3])
        local name =  v[1]
        local type = v[2]
        local DataType = v[3]
        self:_writeToStream(theDataStream,packet.data[name],type,DataType)
    end
    ----print("len "..theDataStream:getLen())
    theDataStream:setPos(1)

    return theDataStream

end

function Parser:_generatePacket()
    --printInfo("Parser:_generatePacket")

    --判断长度防止log打印报错

    local packet = Packet.new()
   
    local msgLen =  self.stream:readInt() -- 消息包的长度 --
    --print("msgLen: ",msgLen)
    local id = self.stream:readUInt();
    local id_p = bit.band(id,0xffffffff);


    --print("Generate Packet: ID = ",id);
    local varInfo = string.format("recv packet = 0x%X(%u)",id,id);
    laixiaddz.loggame(varInfo);
    if(Protocol.getProtocol(id) == nil)then
        --
        laixia.logError("Error Generate Packet ID :"..id)
        --ObjectEventDispatch:pushEvent(EVENT_RE_CONNECT_REQ)
        if id == 40 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "账号登陆异常请重启", OnCallFunc = function() os.exit() end })
        elseif msgLen<0 then
        --ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "网络异常，点击尝试重新连接", OnCallFunc = function() laixia.net.readyForReConnect(); end })
        else
        --			--兼容德州的消息
        --			self.stream:setPos(self.stream:getPos()+msgLen+12)
        end
        return nil;
    end

    packet:setPacketName(Protocol.Protocols[id].name)
    print("前端SC调用"..Protocol.Protocols[id].name)
    --print("Generate Packet: ",packet:getPacketName());
    packet:setPacketID(id);
    packet:setPlayerID(self.stream:readInt())
    packet:setVersion(self.stream:readInt())
    packet:setExtension(self.stream:readInt())


    --print("Gen Packet:",packet:getPacketID(),"Name:",packet:getPacketName());
    return packet

end

function Parser:_readPersonalToPacket(packet)
    ----printInfo("Parser:_readPersonalToPacket")
    local ptl  = Protocol.Protocols[packet:getPacketID()].data_array --
    for _,v in ipairs(ptl) do
        if(self:_readToPacket(packet,v[1],v[2],v[3])) then
        -- break
        end
    end
end

return Parser.new();
