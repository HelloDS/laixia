local socket = require("socket")
local PacketFiles= require("rebot/PacketFiles")
local SeverRequest = class("SeverRequest")

--[[
    构造函数
]]
function SeverRequest:ctor(index)
    --索引
    self.m_index = index
    --tcp
    self.m_tcpConnect = require("rebot/TcpConnect").new(handler(self, self.addMsgData))
    --流
    self.m_parser = require("rebot/parser").new()
    -- 所以收到的消息都走这里
    self.m_recvMsgQueue = require("rebot.Queue").new()
    -- 发消息，主要是self.m_tcpConnect的发消息走这里，按说该另起一个线程才对
    self.m_sendMsgQueue = require("rebot.Queue").new()
    --一个业务消息一个记录
    self.m_recvMsgInfoQueuee = require("rebot.Queue").new()

    self:init()
end

function SeverRequest:init()
    self:initHTTP()
    _G.setStartSchedule(handler(self, self.tick))
end

--[[
    初始化Http请求
]]
function SeverRequest:initHTTP()
    cpp.NetSystem:getInstance():setHttpUrl(_G.rebot_config.ServerURL)
    cpp.NetSystem:getInstance():registerLuaHttpCallbackHandler(handler(self, self.respHttpData))
end

--[[
    响应Http请求回调
]]
function SeverRequest:respHttpData(retCode, rawBytes)
    -- -1的情况是 机器没有网络连接
    if retCode == -1 then
        return
    end
    -- 404 是服务器异常,
    if (retCode == 404) then
        return
    end
    if (string.len(rawBytes) ~= 0) then
        self.m_recvMsgQueue:Push(rawBytes)
    end
end

function SeverRequest:addMsgData(event)
    self.m_recvMsgQueue:Push(event)
end

function SeverRequest:tick(dt)
    self.m_tcpConnect:tick(dt)
    self:onRecvPacket()
    self:onSendPacket(dt)
end

function SeverRequest:onRecvPacket()
    while (not self.m_recvMsgQueue:IsEmpty()) do
        local rawData = self.m_recvMsgQueue:Pop()
        local packets = self.m_parser:streamToPacket(rawData)
        for i = 1, #packets do
            self.m_recvMsgInfoQueuee:Push(packets[i])
        end
    end
    if not self.m_recvMsgInfoQueuee:IsEmpty() then
        local info = self.m_recvMsgInfoQueuee:Pop()
        self:handlePacket(info)
    end
end

function SeverRequest:handlePacket(packet)
    local ID = packet:getPacketID()
    local packfile = PacketFiles.getProtocolById(ID)
    if packfile then
        local func = packfile.HandlerFunction
        if (func ~= nil) then
            func(packet)
        end
    end
end

function SeverRequest:onSendPacket(dt)
    if (self.m_sendMsgQueue:IsEmpty()) then
        return
    end
    repeat
        local dataStream = self.m_sendMsgQueue:Pop()
        if dataStream then
            if (self.m_tcpConnect:isConnected()) then
                self.m_tcpConnect:send2Socket(dataStream)
            end
        end
    until self.m_sendMsgQueue:IsEmpty()
end

function SeverRequest:startTcp(account)
    self.m_tcpConnect:creaetTcpConnect(account)
end

function SeverRequest:closeTcp()
    self.m_tcpConnect:close()
end

function SeverRequest:setTcpAddress(url)
    self.m_tcpConnect:setTcpAddress(url)
end

function SeverRequest:isTcpConnected()
    return self.m_tcpConnect:isConnected()
end

function SeverRequest:disconnect()
    self.m_tcpConnect:disconnect()
end

function SeverRequest:endTCP()
    self.m_tcpConnect:endTCP()
end

function SeverRequest:sendPacket(packet)
    local stream = self.m_parser:packetToStream(packet)
    if (stream == nil) then
        return
    end
    self.m_sendMsgQueue:Push(stream)
end

function SeverRequest:sendHttpPacket(packet)
    local packetStream = self.m_parser:packetToStream(packet)
    local len = packetStream:getLen()
    local MAX_SIZE = 4 * 1024
    if (len < MAX_SIZE) then
        cpp.NetSystem:getInstance():sendHttpData(packetStream:getPack(), packetStream:getLen())
    else
        local loop = math.floor(len / MAX_SIZE)
        local lastSize = MAX_SIZE
        if (len % MAX_SIZE > 0) then
            loop = loop + 1
            lastSize =(len % MAX_SIZE)
        end
        cpp.NetSystem:getInstance():packageDataInit(len)
        packetStream:setPos(1)
        for i = 1, loop do
            local size = MAX_SIZE
            if (i == loop) then
                size = lastSize
            end
            local tempBA = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
            for j = 1, size do
                local b = packetStream:readByte()
                tempBA:writeByte(b)
            end
            local f = 0
            cpp.NetSystem:getInstance():packageAddData(tempBA:getPack(), tempBA:getLen())
        end
        cpp.NetSystem:getInstance():packageSendHttpData()
    end
end

return SeverRequest


