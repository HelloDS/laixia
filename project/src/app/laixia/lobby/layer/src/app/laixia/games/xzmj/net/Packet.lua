
local mod_name = ...;
local Protocol= import(".PacketFiles");
local Packet = class("Packet")


function Packet:ctor(PacketName,PacketID)
    --print("Packeter ctor")
    self.mPacketID = PacketID or 0
    self.mPlayerID =  laixia.LocalPlayercfg.LaixiaPlayerID;
    self.mVersion = laixia.config.GameMsgVersion or 1
    self.mExternsion = laixia.config.ClientVersion or 1
    self.data = {}
    self.mName = PacketName or "DummyPacket"   -- name 需要，方便debug
    --Protocol = Protocol or  import(".Protocols",mod_name);
    if(Protocol.Protocols[self.mPacketID] ==nil) then
        --printInfo("Packet %d is Nil",self.mPacketID)
        return
    end

    self:loadPacketData()

end

function Packet:loadPacketData()

    if (self.mPacketID~= nil)and(self.mPacketID ~= 0)then
        --Protocol = Protocol or  import(".Protocols",mod_name);
        local dataArray = Protocol.Protocols[self.mPacketID].data_array
        --dump(dataArray)
        for i,v in ipairs(dataArray) do

            self.data[v[1]] = Protocol.dataType.Default[v[2]]
        end
    end
    --dump(self)
end

function Packet:setPacketName(name)
    self.mName = name
end

function Packet:getPacketName()
    return self.mName
end


function Packet:setPacketID(ID)
    self:_setPacketID(ID)
    self:loadPacketData()
end

function Packet:_setPacketID(ID)
    self.mPacketID =  ID
end

function Packet:getPacketID()
    return self.mPacketID
end


function Packet:setPlayerID(playerID)
    self.mPlayerID = playerID
    return self;
end


function Packet:getPlayerID()
    print("Packet:getPlayerID ",self.mPlayerID);
    return self.mPlayerID
end

function Packet:setVersion(version)
    self.mVersion = version
end

function Packet:getVersion()
    return self.mVersion
end

function Packet:setExtension(extension)
    return self.mExternsion
end

function Packet:getExtension()
    return self.mExternsion
end

local logError = laixia.logError;
function Packet:setValue(key,value)
    if( self.data[key] ~= nil) then
        self.data[key] = value
    else
        laixia.logError("key: [\""..key .."\"]  not Exist")
    end
    return self; -- 方便连续调用
end


function Packet:getValue(key)

    if(type(self.data[key])== "table")then
    --    laixia.dump(self.data[key],"Packet:getValue "..key);
    else
        if key == "ServerTime" and DEBUG_ALEX then
            print("Packet:getValue:",key, self.data[key])
        end
    end

    return self.data[key]
end


function Packet:getValuesAll()
    return self.data;
end

function Packet:finishPack()


end

function Packet:dump()

    dump(self)
end

return Packet
