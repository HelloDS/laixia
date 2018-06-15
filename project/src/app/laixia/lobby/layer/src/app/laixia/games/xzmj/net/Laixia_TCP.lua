local Env = APP_ENV;
local laixia = laixia;

cc.net = require("framework.cc.net.init")

local Net_TCP = class("Net_TCP")

Net_TCP.EVENT_GET_TCP_DATA = "EVENT_GET_TCP_DATA"
Net_TCP.EVENT_TCP_CONNECTED = "EVENT_TCP_CONNECTED"
EVENT_RE_CONNECT_REQ = "EVENT_RE_CONNECT_REQ"

function Net_TCP:ctor(...)
    self.isConntected = false
    self.freeTime = 0
    self.reConnect = false;
    self.mEvent = nil
    self.mEventList = { }
end

function Net_TCP:addListByStatus(__event)
    __event.eventType = 1
    table.insert(self.mEventList, __event)
    return
end

function Net_TCP:addListByData(__event)
    __event.eventType = 2
    table.insert(self.mEventList, __event)
    return
end

function Net_TCP:readyForReConnect()
    self.reConnect = true;
    self.mEvent = nil
    self.mEventList = { }
    self.freeTime = 0
    ObjectEventDispatch:pushEvent(EVENT_RE_CONNECT_REQ);
    laixia.LocalPlayercfg.reConnect = true --重连他们希望能够直接在X分钟内回到之前的“主界面中”
-- 开始重连
end

function Net_TCP:isConnected()
    return self._socket and self.isConntected;
end

function Net_TCP:_onConectClose()
    -- self:close()
    if (self.reConnect) then
        -- ObjectEventDispatch:pushEvent(EVENT_RE_CONNECT_REQ);
        self.reConnect = false;
    end
end
function Net_TCP:send2Socket(data)
    if not self._socket or not self.isConntected then
        printInfo("connect first")
        -- laixia.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_NET_ERROR_LOGIN))
        return
    end

    local str = data:toString()
    local mid = string.sub(str,16,17)
    local sid = string.sub(str,22,23)
    if mid =="01" and  sid == "05" then
    else
        printf("send packet: %s %d", data:toString(), data:getLen())
        laixia.logPacketID("发送消息 "..mid .."000"..sid)
    end
    self._socket:send(data:getPack())
    local a = data:getPack()
    self.lastFreeTime = 0
end

-- 心跳包发送逻辑
function Net_TCP:heart_beat_tick(dt)

    -- tcp都没连上，不心跳啊
    if (self.isConntected == false) then
        self.freeTime = 0
        return
    end
    self.freeTime = self.freeTime +(dt * 1000)

    if laixia.net.mAwakeFlag then
        return
        -- 睡眠不发送心跳
    end
    -- 空闲太久，就心跳一下
    if (self.freeTime >= laixia.config.LAIXIA_HEARTBEAT_INTERVAL) then
        self.freeTime = 0
        laixia.net.sendHeartBeatPacket()
    end
end


function Net_TCP:tcpConnect(appID)
    print("Net_TCP:tcpConnect")

    local url = require("socket.url")
    local urlTable =
        {
            path = "",
            scheme = 0,
        }


    laixia.LocalPlayercfg.mCurGameAppID = appID or laixia.config.GameAppID;
    local address = laixia.LocalPlayercfg.LaixiaTCPSever;
    urlTable = url.parse(address)
    print("TCP_Addres: ", address);

    dump(urlTable)

    if not self._socket then
        self._socket = cc.net.SocketTCP.new(urlTable.scheme, urlTable.path, false)
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self, self.addListByStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self, self.addListByStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self, self.addListByStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.addListByStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self, self.addListByData))
    end
    self.mEventList = { }
    self._socket:connect()
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "LoadingWindow" then

    end
end

function Net_TCP:tick(dt)
    if self.mEventList and #self.mEventList > 0 then
        self.mEvent = self.mEventList[1]
        table.remove(self.mEventList, 1)
        if self.mEvent.eventType == 1 then
            printInfo("socket status: %s", self.mEvent.name)
            if (self.mEvent.name == cc.net.SocketTCP.EVENT_CONNECTED) then
                self.isConntected = true

                ObjectEventDispatch:pushEvent(Net_TCP.EVENT_TCP_CONNECTED)
            elseif (self.mEvent.name == cc.net.SocketTCP.EVENT_CLOSE) then

                self.isConntected = false
                self:_onConectClose();
            elseif (self.mEvent.name == cc.net.SocketTCP.EVENT_CONNECT_FAILURE) then

                laixia.net.clearAllWaiting()
                if laixia.LocalPlayercfg.LaixiaCurrentWindow == "SingleCardTableDialog" then
                    ui.SingleCardTableDialog.mIsConnect = false
                else
                    if "fish" ~= laixia.config.smallGame then
                        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, { msg = "无法连接到服务器，点击重试", msgType = "http" });
                    --cc.UserDefault:getInstance():setBoolForKey("isauto", false)
                    end
                end
                -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW,"无法链接到服务器nettcp")
            elseif (self.mEvent.name == cc.net.SocketTCP.EVENT_CLOSED) then

                self:close()
            end
        elseif self.mEvent.eventType == 2 then
            local temp = cc.utils.ByteArray.toString(self.mEvent.data)
            local size = string.len(temp)
            -- 判断长度防止log打印报错
            printInfo("recv packet len: %d", size)
            if size > 1024 then
                printInfo("recv packet: %s", string.sub(temp, 1, 1024))
            else
                printInfo("recv packet: %s", temp)
            end

            ObjectEventDispatch:dispatchEvent( { name = Net_TCP.EVENT_GET_TCP_DATA, data = self.mEvent.data })
            -- end

        end
    end
end


-- 关闭当前的scoket的连接
-- 被动断开tcp，所以需要弹出对话框
function Net_TCP:close(...)
    print("Net_TCP:close")

    if self._socket then
        self.mEvent = nil
        self.mEventList = { }
        self._socket:close(...)
        self.isConntected = false
        laixia.net.clearAllWaiting()
        if (laixia.gameStatus == nil) then
            if laixia.LocalPlayercfg.LaixiaCurrentWindow == "SingleCardTableDialog" then
                ui.SingleCardTableDialog.mIsConnect = false
            else
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, { msg = "无法连接到服务器，点击重试", msgType = "http" });
            --cc.UserDefault:getInstance():setBoolForKey("isauto", false)
            end
        end
    end

end


-- disconnect on user's own initiative.
-- 用户主动导致的断开tcp
function Net_TCP:disconnect(...)
    if self._socket then
        self.mEvent = nil
        self.mEventList = { }
        self._socket:disconnect()
        self._socket:close(...)
        self.isConntected = false
    end
end

function Net_TCP:endTCP()
    self:disconnect()
    if self._socket ~= nil then
        self._socket:removeEventListenersByEvent(cc.net.SocketTCP.EVENT_CONNECTED)
        self._socket:removeEventListenersByEvent(cc.net.SocketTCP.EVENT_CLOSE)
        self._socket:removeEventListenersByEvent(cc.net.SocketTCP.EVENT_CLOSED)
        self._socket:removeEventListenersByEvent(cc.net.SocketTCP.EVENT_CONNECT_FAILURE)
        self._socket:removeEventListenersByEvent(cc.net.SocketTCP.EVENT_DATA)
        self._socket = nil
    end
end

return Net_TCP.new()
