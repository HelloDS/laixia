
local SocketTCP = require("framework.cc.net.SocketTCP")
local TcpConnect = class("TcpConnect")

TcpConnect.EVENT_GET_TCP_DATA = "EVENT_GET_TCP_DATA"

TcpConnect.ConnectType =
{
    Status  = 1,
    Data    = 2,
}
--[[
    构造函数
]]
function TcpConnect:ctor(cb)
    --事件类型
    self.m_eventType = nil
    --事件列表
    self.m_eventList = { }
    --tcp连接地址
    self.m_tcpAddress = ""
    --机器人账号
    self.m_account = ""
    --tcp
    self.m_socketTcp = nil
    --connect
    self.m_isConntected = false
    --cb
    self.m_dataCallBack = cb
end

--[[
    设置tcp连接地址
]]
function TcpConnect:setTcpAddress(address)
    if not address then
        return
    end
    self.m_tcpAddress = address
end

--[[
    SocketTcp连接
]]
function TcpConnect:creaetTcpConnect(account)
    self.m_account = account
    local url = require("socket.url")
    local urlTable =
    {
        path = "",
        scheme = 0,
    }
    urlTable = url.parse(self.m_tcpAddress)
    if not self.m_socketTcp then
        self.m_socketTcp = SocketTCP.new(urlTable.scheme, urlTable.path, false)
        self.m_socketTcp:addEventListener(SocketTCP.EVENT_CONNECTED,        handler(self, self.addListByStatus))
        self.m_socketTcp:addEventListener(SocketTCP.EVENT_CLOSE,            handler(self, self.addListByStatus))
        self.m_socketTcp:addEventListener(SocketTCP.EVENT_CLOSED,           handler(self, self.addListByStatus))
        self.m_socketTcp:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE,  handler(self, self.addListByStatus))
        self.m_socketTcp:addEventListener(SocketTCP.EVENT_DATA,             handler(self, self.addListByData))
    end
    self.m_eventList = {}
    self.m_socketTcp:connect()
end

--[[
    添加SocketTcp返回事件类型到事件列表中
]]
function TcpConnect:addListByStatus(__event)
    __event.eventType = TcpConnect.ConnectType.Status
    table.insert(self.m_eventList, __event)
    return
end

--[[
    添加SocketTcp返回事件数据到事件列表中
]]
function TcpConnect:addListByData(__event)
    __event.eventType = TcpConnect.ConnectType.Data
    table.insert(self.m_eventList, __event)
    return
end

function TcpConnect:isConnected()
    return self.m_socketTcp and self.m_isConntected
end

function TcpConnect:send2Socket(data)
    if not self.m_socketTcp or not self.m_isConntected then
        return
    end
    local str = data:toString()
    local mid = string.sub(str,16,17)
    local sid = string.sub(str,22,23)
    local pack = data:getPack()
    self.m_socketTcp:send(pack)
end

--[[
    定时器
]]
function TcpConnect:tick(dt)
    if type(self.m_eventList) == "table" and #self.m_eventList > 0 then
        self.m_eventType = table.remove(self.m_eventList, 1)
        if self.m_eventType.eventType == TcpConnect.ConnectType.Status then
            if (self.m_eventType.name == SocketTCP.EVENT_CONNECTED) then
                self.m_isConntected = true
                _G.EventDispatch:pushEvent("Req_Rebot_EnterGame", {account = self.m_account})
            elseif (self.m_eventType.name == SocketTCP.EVENT_CLOSE) then
                self.m_isConntected = false
            elseif (self.m_eventType.name == SocketTCP.EVENT_CONNECT_FAILURE) then

            elseif (self.m_eventType.name == SocketTCP.EVENT_CLOSED) then

            end
        elseif self.m_eventType.eventType == TcpConnect.ConnectType.Data then
--            local temp = cc.utils.ByteArray.toString(self.m_eventType.data)
--            local size = string.len(temp)
--            -- 判断长度防止log打印报错
--            print("recv packet len: %d", size)
--            if size > 1024 then
--                print("recv packet: %s", string.sub(temp, 1, 1024))
--            else
--                print("recv packet: %s", temp)
--            end
            self.m_dataCallBack(self.m_eventType.data)
        end
    end
end

--[[
    关闭当前的scoket的连接
    被动断开tcp，所以需要弹出对话框
]]
function TcpConnect:close(...)
    if self.m_socketTcp then
        self.m_isConntected = false
        self.m_eventType = nil
        self.m_eventList = {}
        self.m_socketTcp:close(...)
    end
end

--[[
    结束SocketTcp连接
]]
function TcpConnect:endTCP()
    self:disconnect()
    if self.m_socketTcp ~= nil then
        self.m_socketTcp:removeEventListenersByEvent(SocketTCP.EVENT_CONNECTED)
        self.m_socketTcp:removeEventListenersByEvent(SocketTCP.EVENT_CLOSE)
        self.m_socketTcp:removeEventListenersByEvent(SocketTCP.EVENT_CLOSED)
        self.m_socketTcp:removeEventListenersByEvent(SocketTCP.EVENT_CONNECT_FAILURE)
        self.m_socketTcp:removeEventListenersByEvent(SocketTCP.EVENT_DATA)
        self.m_socketTcp = nil
    end
end

--[[
    用户主动导致的断开tcp
]]
function TcpConnect:disconnect(...)
    if self.m_socketTcp then
        self.m_isConntected = false
        self.m_eventType = nil
        self.m_eventList = {}
        self.m_socketTcp:disconnect()
        self.m_socketTcp:close(...)
    end
end

return TcpConnect
