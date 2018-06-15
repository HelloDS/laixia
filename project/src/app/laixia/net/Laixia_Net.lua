print("import Net")
local mod_name = ...;
local socket = require("socket")
local laixia = laixia;
print("laixia = " .. tostring(laixia))


local Protocols= import(".PacketFiles")
local Parser = import(".Parser")

laixia.Packet = import(".Packet")
laixia.Protocols = Protocols
local Queue = import(".Queue")
local TCP = import(".Laixia_TCP")

local Env = APP_ENV;
local luaj = Env.luaj;

local flag = 0x80000000
local mSendWaitingPID = {} --存放调用了等待圈圈的PID
local Packet =  laixia.Packet; --import(".Packet");
local laixiaconfig= laixia.config


--  检测并删除等待圈圈及对应的PID
local function checkRecvWaitingPID(pid)
    if #mSendWaitingPID ~= 0 then
        for i = 1, #mSendWaitingPID do
            local rid = (bit.bor(flag, mSendWaitingPID[i]))
            if rid == pid then
                table.remove(mSendWaitingPID, i)
                break
                --比赛协议的另一种返回情况
            elseif mSendWaitingPID[i] == _LAIXIA_PACKET_CS_MatchGameID and pid == _LAIXIA_PACKET_SC_MatchStopMaintainID then
                table.remove(mSendWaitingPID, i)
                break
                --定时赛拉牌桌的另一种返回情况
            elseif mSendWaitingPID[i] == _LAIXIA_PACKET_CS_MatchJoinInID and pid == _LAIXIA_PACKET_SC_MatchTimingID then
                table.remove(mSendWaitingPID, i)
                break
                --快速开始的另一种情况（返回牌桌同步）

            end
        end
        if #mSendWaitingPID == 0 then
            local id = string.format("%#x",pid)
            laixia.logPacketID("\t\t取消等待动画 \t"..id)
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
        end
    end
end

--ProcessState
local EProcessWait = 0;
local EProcessPrepare = 1;
local EProcessReady = 2;
local EProcessDead = 3; --


local Net = class("Net")
function Net:ctor(...)
    -- print("Net Constructor")
    self.mRecvMsgQueue = Queue:new()
    -- 所以收到的消息都走这里
    self.mSendMsgQueue = Queue:new()
    -- 发消息，主要是TCP的发消息走这里，按说该另起一个线程才对 。。- -
    self.mRecvMsgInfoQueue = Queue:new()
    --一个业务消息一个记录
    self.mWaitingTimer = 0;
    -- 发包收包的时间
    self.mWait = false;
    -- 发包之后开始等待计时
    self.mLostHeartBet = 0;
    -- 丢失的心跳包
    self.mReConnecting = false;
    -- 重新连接
    self.mHttpConnected = false;
    -- http链接
    self.mHttpPacket = nil
    -- http包


    self.mAwakeFlag = false;
    self.mAwakeDt = 0;
    self.mIsTcpReady = false;
    self.mProcessState = 0; --; 修改为状态为2的时候正常处理之
    -- 是否准备好了 --
    mSendWaitingPID = {}
end

function Net:init()
    --laixia.logVerbose("Net:init")

    ObjectEventDispatch:addEventListener(TCP.EVENT_GET_TCP_DATA, handler(self, self.addMsgData))
    ObjectEventDispatch:addEventListener(TCP.EVENT_TCP_CONNECTED, handler(self, self.onTcpStarted))
    ObjectEventDispatch:addEventListener(EVENT_RE_CONNECT_REQ, handler(self, self.start))
    self:initHTTP();
    self.mProcessState = 0;
end

function Net:initHTTP()
    cpp.NetSystem:getInstance():setHttpUrl(laixia.config.ServerURL);
    cpp.NetSystem:getInstance():registerLuaHttpCallbackHandler(handler(self, self.onHttpDataRecvHandler))
end

function Net:setProcessState(state)
    self.mProcessState = state;
end

function Net:handlePacket(packet)
    --不是心跳 则打印一下
    if packet:getPacketName() ~= "SCHeartBeat" then
        laixia.logGame("handle packet: " .. packet:getPacketName());
    end
    local ID = packet:getPacketID()
    print("packet "..ID)
    print(packet:getPacketName())
    if packet:getPacketName() ~= "SCHeartBeat" then
        laixia.logPacketID("\t收到消息 "..string.format("%#x",ID))
    end
    if (Protocols.Protocols[ID] ~= nil) then
        local func = Protocols.Protocols[ID].HandlerFunction
        if (func ~= nil) then
            --检测并删除等待圈圈及对应的PID
            checkRecvWaitingPID(ID)
            func(packet)
        end
    end
end

function Net:registerReadyFunc(func)
    self.mReadyFunc = func;
    return self;
end

function Net:readyForGame()

    self:setProcessState(2);
    if(self.mReadyFunc ~= nil) then
        self.mReadyFunc();
    end
end

function Net:popWarningAndDisconnect()
    self.mIsTcpReady = false;
    laixia.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_NET_ERROR_LOGIN),"http")
end

function Net:destroy()

end

--断网后消除所有的转圈
function Net:clearAllWaiting()
    mSendWaitingPID = {}
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_RECONNECTIONTIPS_WINDOW)
end

function Net:tick(dt)
    if(laixia.LocalPlayercfg.mCurGameAppID ~= laixia.config.GameAppID) then
        return;
    end

    TCP:tick(dt)
    --self:onTimeOut_BeatHeart();
    --self:onTimeOut_http(dt);
    self:onRecvPacket()
    self:onSendPacket(dt)
    self:heartBeat()

    if (self.mAwakeFlag) then
        -- 保护一下，唤醒两秒以后，标记为false
        self.mAwakeDt = dt + self.mAwakeDt;
        --
        if (self.mAwakeDt > 2) then
            -- 两秒
            self.mAwakeDt = 0;
            self.mAwakeFlag = false;
        end
    end
end

function Net:onTimeOut_http(dt)
    if (self.mWait) then
        self.mWaitingTimer = self.mWaitingTimer + dt;
        if (self.mWaitingTimer > laixia.config.LAIXIA_WAITINT_WINDOW_INTERVAL) then
            -- HTTP超时
            ObjectEventDispatch:dispatchEvent {
                name = _LAIXIA_EVENT_SHOW_RECONNECTIONTIPS_WINDOW,
                data = laixia.utilscfg.DICT(_ID_HTTP_CONNECTING),
                -- 这里稍后修正
                waitType = 1
            }
            -- .LocalPlayer.mIsNeedSign = false
            self.mWait = false;
            self.mWaitingTimer = 0
        end
    end
end

function Net:heartBeat()

end

function Net:startTcp()
    print("Net:startTcp")
    logError( laixiaconfig.LAIXIA_TCP_SERVER_ADDRESS )
    TCP:tcpConnect()

end


function Net:closeTcp()
    TCP:close()
end

function Net:isTcpConnected()
    return TCP:isConnected();
end

function Net:setHttpConnected(conn)
    self.mHttpConnected = conn;
end

function Net:isHttpConnected()
    return self.mHttpConnected;
end

function Net:setReConnecting(reConn)
    self.mReConnecting = reConn
end

function Net:SendVE()
    --记录log的服务器Ip
    if cc.Application:getInstance():getTargetPlatform() == 3 then
        local info={['appId']= laixia.config.GameAppID,["utdid"]=laixia.LocalPlayercfg:getUtdid(),["eventId"]=1}
        require "cocos.cocos2d.json";
        local jsonData = json.encode(info);
        cpp.NetSystem:getInstance():setHttpUrl(laixia.config.ServerURL);
        cpp.NetSystem:getInstance():sendHttpData(jsonData, #jsonData);
    end
end

function Net:readyForReConnect()
    self:SendVE()
    self:initHTTP()
    self:disconnect()
    self:recvHeartBeat()
    self.mSendMsgQueue:Clear()
    self.mRecvMsgQueue:Clear()
    self.mRecvMsgInfoQueue:Clear()
    TCP:readyForReConnect()
    self.mReConnecting = true;
end
-- disconnect on user's own initiative.--断开用户的主动性
function Net:disconnect()
    TCP:disconnect()
end


function Net:onTcpStarted()
    print("Net:onTcpStarted")

    self.mAwakeFlag = false;
    self.mIsTcpReady = true;


    local CSEnterGamePacket = Packet.new("CSEnterGamePacket", _LAIXIA_PACKET_CS_EnterGameID)
        :setValue("GameID", laixia.config.GameAppID)
        :setValue("Key", laixia.LocalPlayercfg.LaixiaHttpCode)
    --:sendTo();
    --mProcessState == 2 说明玩家已进入游戏，属于断线重连情况，则增加转圈机制
    if self.mProcessState == 2 then
        laixia.net.sendPacketAndWaiting(CSEnterGamePacket);
    else
        laixia.net.sendPacket(CSEnterGamePacket);
    end


    if(self.mProcessState == 0) then -- 网络初始化之后是0 ，断线的话，就不再需要走这个了，还需要优化
        self:setProcessState(1);
    end
    -- 这个更新玩家属性  ？？？
end

function Net:endTCP()

    TCP:endTCP()
end


function Net:sendPacket(packet)
    -- print("sendPacket", packet:getPacketID(), packet:getPacketName());
    if (not self.mIsTcpReady) then
        return;
    end
    local id = packet:getPacketID();
    if id ~= 65541 then--心跳的log 屏蔽掉 by wangtianye
        logGame("send tcp packet : " .. packet:getPacketName() .." ID:　"..id);
    end
    --logGame("send tcp packet id: " .. packet:getPacketID());
    local stream = Parser:packetToStream(packet)
    if (stream == nil) then
        logError("Error Packet")
        return
    end
    self.mSendMsgQueue:Push(stream)
end

function Net:sendHttpPacket(packet)
    --laixia.logVerbose("send http packet: " .. packet:getPacketName());

    laixia.logPacketID("发送http消息 "..string.format("%#x",packet:getPacketID()))
    print("发送http消息 "..string.format("%#x",packet:getPacketID()))
    local packetStream = Parser:packetToStream(packet)
    if (packetStream == nil) then
        logError("Error Packet")
    end

    if (laixia.config.USING_CPP_HTTP) then
        -- c++ 中的
        print("Net:sendHttpPacket Mode: Cpp ")
        local len = packetStream:getLen()
        -- 最大传输4k,我日太小了点儿吧
        local MAX_SIZE = 4 * 1024
        -- 输出的时候有提示:log too long, max size is 16.00KB, actual size is 112.76KB
        -- 这个类是为socket通信设计的，我从来就没有考虑用它发送过大数据。
        -- 我们的游戏中，每条数据是用字节做单位的，最大也不会超过10K。100K以上的数据我实在是没有考虑过。
        -- 以前有网友提到用 ByteArray:toString() 来显示几百K的数据，说player会崩溃。这个我只能说，这么大的数据量print出来，作为人类的我很难看懂。

        if (len < MAX_SIZE) then
            -- 小于最大尺寸直接发http请求
            cpp.NetSystem:getInstance():sendHttpData(packetStream:getPack(), packetStream:getLen())
        else
            -- 大于最大尺寸，需要分包发给c++
            local loop = math.floor(len / MAX_SIZE)
            -- 分几个包
            local lastSize = MAX_SIZE
            -- 最后一个包的尺寸
            if (len % MAX_SIZE > 0) then
                -- 边界问题
                loop = loop + 1
                lastSize =(len % MAX_SIZE)
            end

            cpp.NetSystem:getInstance():packageDataInit(len)
            packetStream:setPos(1)

            for i = 1, loop do
                -- 当前的包尺寸
                local size = MAX_SIZE
                if (i == loop) then
                    -- 如果是最后一个包
                    size = lastSize
                end

                local tempBA = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG);
                for j = 1, size do
                    local b = packetStream:readByte()
                    -- printInfo(b .. ",")
                    tempBA:writeByte(b)
                end

                local f = 0

                cpp.NetSystem:getInstance():packageAddData(tempBA:getPack(), tempBA:getLen())
            end

            cpp.NetSystem:getInstance():packageSendHttpData()
        end
    else

    end
    print("send end")
    self.mWait = true;

end



function Net:onRecvPacket()
    --logGame("Net:onRecvPacket()");
    while (not self.mRecvMsgQueue:IsEmpty()) do
        local rawData = self.mRecvMsgQueue:Pop()
        local packets = Parser:streamToPacket(rawData)
        laixia.log("packet length = " .. #packets);
        for i = 1, #packets do
            self.mRecvMsgInfoQueue:Push(packets[i])
        end
    end

    local msgLen  = self.mRecvMsgInfoQueue:Len()
    if(msgLen > 0) then
    --laixia.logVerbose("RecvMsgInfoQueue len = " ..self.mRecvMsgInfoQueue:Len());
    end
    -- 准备状态，不处理消息包
    if(self.mProcessState == 1) then
        --laixia.logWarnning("PrepareState  Do Nothing");
        return;
    end

    if not self.mRecvMsgInfoQueue:IsEmpty() then
        --唤醒后消息堆积太多处理
        local len = self.mRecvMsgInfoQueue:Len()
        if (self.mAwakeFlag and laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and len > laixia.config.LAIXIA_MAX_AWAKE_MSG_LENGTH_POKERDESK) or
            (self.mAwakeFlag and len > laixia.config.LAIXIA_MAX_AWAKE_MSG_LENGTH_NOPOKERDESK) then
            --self.mSendMsgQueue:Clear()
            --self.mRecvMsgQueue:Clear()
            --self.mRecvMsgInfoQueue:Clear()
            printInfo("awake!!!RecvMsgInfoQueue.len is long!!readyForReConnect!!!!")
            self.mAwakeFlag = false;
            laixia.net.readyForReConnect();
            return;
        else
            local info = self.mRecvMsgInfoQueue:Pop()
            if info:getPacketID() ~= 2147549189 then
                laixia.log("recv Packet ID= ", info:getPacketID())
            end
            --G_HandlePacket(info)
            self:handlePacket(info);
        end
    end

end

function Net:onSendPacket(dt)
    if (self.mSendMsgQueue:IsEmpty()) then
        -- 心跳逻辑
        -- 消息队列没消息要发，才有可能需要发心跳
        if (laixia.config.LAIXIA_HEARTBEAT_SWITCH == true) then
            TCP:heart_beat_tick(dt)
        end
        return
    end

    -- 这里不做是否连接的检测，为连接上的话，也要把包交给TCP 发送，TCP做错误处理即可
    laixia.log("Net: onSendPacket ")
    repeat
        local dataStream = self.mSendMsgQueue:Pop()
        if dataStream then
            if (TCP:isConnected()) then
                TCP:send2Socket(dataStream)
            else
                laixia.net.clearAllWaiting()
                self:popWarningAndDisconnect();
            end
        end
    until self.mSendMsgQueue:IsEmpty()

end

function Net:addMsgData(event)

    self.mRecvMsgQueue:Push(event.data)
end

-- c++ 回调
-- 现在的样子比较丑陋，以后可以在C++里调用 EventData
function Net:onHttpDataRecvHandler(retCode, rawBytes)
    print("Net:onHttpDataRecv:" .. retCode)
    self.mWaitingTimer = 0;
    self.mWait = false;
    self.mHttpPacket = nil
    if retCode == -1 then
        -- -1 的情况是 机器没有网络连接
        laixia.net.clearAllWaiting()
        if(self.mProcessState ~= 2) then
            self:registerReadyFunc(function()
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, {msg = laixia.utilscfg.DICT(_ID_DICT_TYPE_NO_NET),msgType ="http"})
            end )
            return;
        end
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "SingleCardTableDialog" then
            ui.SingleCardTableDialog.mIsConnect = false
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, {msg = laixia.utilscfg.DICT(_ID_DICT_TYPE_NO_NET),msgType ="http"})
        end
        -- "无网络"
        return
    end


    if (retCode == 404) then
        -- 404 是服务器异常,
        laixia.net.clearAllWaiting()
        if(self.mProcessState ~= 2) then
            self:registerReadyFunc(function()
                ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, {msg = laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_ERROR),msgType ="http"})
            end )
            return;
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDJUMP_WINDOW, {msg = laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_ERROR),msgType ="http"})
        end
        -- "无网络"
        -- 暂时先这样。弹出重连的标记
        laixia.logGame("************************** retCode ===== " .. retCode)
        return;
    end
    if(retCode == 500) then
        print ("What is that");
    end
    --    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_RECONNECTIONTIPS_WINDOW, 1)
    if (string.len(rawBytes) ~= 0) then
        self.mRecvMsgQueue:Push(rawBytes)
    end
end




function Net:start()
    print("Net:startNet")
    --断线重连清理牌桌页面
    -- 进入游戏
    print("CurGameAppID ".. tostring(laixia.LocalPlayercfg.mCurGameAppID));
    local appID = laixia.config.GameAppID;
    laixia.LocalPlayercfg.mCurGameAppID = appID;

    local newGamePlatformID = 0
    local newPassWord = ""
    local newAccount = ""
    local newToken = ""
    local newChannelID = ""
    local newVersion = ""
    local newUnionID = ""
    local newDevices = laixia.LocalPlayercfg:getMobileInfo()

    local autoValue = cc.UserDefault:getInstance():getBoolForKey("isauto")
    print("autoValue")
    print(autoValue)
    if tonumber(laixia.LocalPlayercfg.CHANNELID) ~=nil and tonumber(laixia.LocalPlayercfg.CHANNELID) < 200000 then -- 渠道商店包
        if tonumber(laixia.LocalPlayercfg.CHANNELID) == 160186 or tonumber(laixia.LocalPlayercfg.CHANNELID) == 111267 then
        else
            cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID",10)
        end
    end
    if autoValue then
        local GamePlatformID = cc.UserDefault:getInstance():getIntegerForKey("GamePlatformID")
        print("GamePlatformID"..GamePlatformID)

         if GamePlatformID== 0 then
             GamePlatformID= 1
             cc.UserDefault:getInstance():setBoolForKey("isauto", false)
         end

        newGamePlatformID = GamePlatformID
        newPassWord =  cc.UserDefault:getInstance():getStringForKey("password")


        if GamePlatformID == 4 or GamePlatformID == 5  then --微博登录--微信登录
            newAccount =cc.UserDefault:getInstance():getStringForKey("uid")
            newToken =cc.UserDefault:getInstance():getStringForKey("token")
            newUnionID =cc.UserDefault:getInstance():getStringForKey("unionid")
        elseif GamePlatformID == 2  then  --手机登录
            newAccount =cc.UserDefault:getInstance():getStringForKey("phone_number")
            newToken = ""
        elseif GamePlatformID == 10 then --渠道商店登陆
            newAccount = laixia.LocalPlayercfg.LaixiaUserID
            newToken = laixia.LocalPlayercfg.LaixiaTokenID

        else
            newAccount = laixia.LocalPlayercfg:getAccountID()
            newToken = laixia.LocalPlayercfg.LaixiaTokenID
        end

    else
        newAccount = laixia.LocalPlayercfg:getAccountID()
        newGamePlatformID = laixia.config.GamePlatformID

        newPassWord =  laixia.LocalPlayercfg:getPassword()
        newToken =  laixia.LocalPlayercfg.LaixiaTokenID
    end
    print("newAccount"..newAccount)
    print("newGamePlatformID"..newGamePlatformID)

    newChannelID = laixia.LocalPlayercfg:getumengChannelID()
    print("newChannelID"..newChannelID)

 	 local version = cc.UserDefault:getInstance():getStringForKey("version")
    if version==nil or version=="" then
        version = getAppVersion()
    end
    newVersion =  version

    --接映客
    local imei = laixia.LocalPlayercfg:getIMEI()
    if laixia.kconfig.isYingKe == true then
        local state,value=""
        local state2,value2=""
        if device.platform == "android" then
             local javaClassName = APP_ACTIVITY
             local javaMethodName = "getNativeInfo"
             local javaParams = { }
             local javaMethodSig = "()Ljava/lang/String;"        
             state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        elseif device.platform == "ios" then
            state,value = luaoc.callStaticMethod("IKCRBridgeManager", "userInfo");
            state2,value2 = luaoc.callStaticMethod("IKCRBridgeManager", "getToken");
        end
        newGamePlatformID = 9
        print("value")
        print(value)
        if value == "" or value == nil then
            --get Data
            if device.platform == "windows" then
            else
                local array = {}
                array.uid=  cc.UserDefault:getInstance():getStringForKey("zhishi_uid")
                array.icon= cc.UserDefault:getInstance():getStringForKey("zhishi_icon")
                array.name = cc.UserDefault:getInstance():getStringForKey("zhishi_name")
                array.token = cc.UserDefault:getInstance():getStringForKey("zhishi_token")
                array.sex = cc.UserDefault:getInstance():getStringForKey("zhishi_sex")
                if array.uid ==nil or array.uid == "" then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "账号登陆异常请重启", OnCallFunc = function() os.exit() end })
                end
                print(array.uid)
                print(array.icon)
                print(array.name)
                print(array.token)
                print(array.sex)
    
                newAccount = array.uid
                newPassWord = array.name
                if device.platform == "android" then
                    newToken = array.token
                end
                imei = array.icon
                laixia.LocalPlayercfg.LaixiaHeadPortraitPath = array.icon
                if tonumber(array.sex)~=nil and tonumber(array.sex)~="" then
                    laixia.LocalPlayercfg.LaixiaPlayerGender = 2-tonumber(array.sex)
                end
                laixia.LocalPlayercfg.LaixiaUserID = array.uid
                laixia.LocalPlayercfg.HEAD_URL = array.icon
                if device.platform == "android" then
                    laixia.LocalPlayercfg.LaixiaTokenID =array.token
                else
                    if value2~="" and value2~=nil then
                        laixia.LocalPlayercfg.LaixiaTokenID = value2
                    end
                end
                laixia.LocalPlayercfg.LaixiaPlayerNickname = array.name
            end
        end
        if value ~="" and value~=nil then
            local json = json or require("framework.json");
            local array = json.decode(value)
            print(array.uid)
            print(array.icon)
            print(array.name)
            print(value2)
            newAccount = array.uid
            newPassWord = array.name
            if device.platform == "android" then
                newToken = array.token
            else
                newToken = value2
            end
            imei = array.icon
            laixia.LocalPlayercfg.LaixiaHeadPortraitPath = array.icon
            if tonumber(array.sex)~=nil and tonumber(array.sex)~="" then
                laixia.LocalPlayercfg.LaixiaPlayerGender = 2-tonumber(array.sex)
            end
            laixia.LocalPlayercfg.LaixiaUserID = array.uid
            laixia.LocalPlayercfg.HEAD_URL = array.icon
            if device.platform == "android" then
                laixia.LocalPlayercfg.LaixiaTokenID =array.token
            else
                if value2~="" and value2~=nil then
                    laixia.LocalPlayercfg.LaixiaTokenID = value2
                end
            end
            laixia.LocalPlayercfg.LaixiaPlayerNickname = array.name
            --首次登陆 缓存
            cc.UserDefault:getInstance():setStringForKey("zhishi_uid",array.uid)
            cc.UserDefault:getInstance():setStringForKey("zhishi_icon",array.icon)
            cc.UserDefault:getInstance():setStringForKey("zhishi_name",array.name)
            cc.UserDefault:getInstance():setStringForKey("zhishi_token",array.token)
            cc.UserDefault:getInstance():setStringForKey("zhishi_sex",array.sex)

         end
    elseif GamePlatformID == 10 then ---TODO 渠道商店登陆
        if laixia.LocalPlayercfg.HEAD_URL~=nil then
            imei = laixia.LocalPlayercfg.HEAD_URL
        end
        if laixia.LocalPlayercfg.newPassWord~=nil then
            newPassWord = laixia.LocalPlayercfg.newPassWord
        end
    end
    print("newPassWord"..newPassWord)
    print("newToken"..newToken)
    print("imei"..imei)
    

    local CSPacketLogin = Packet.new("CSPacketLogin", _LAIXIA_PACKET_CS_Login_ID)
    CSPacketLogin:setValue("Code", 0)
    CSPacketLogin:setValue("GameID", laixia.config.GameAppID)
    
    print(laixia.config.GameAppID)
    CSPacketLogin:setValue("GameType",laixia.config.GameType);
    print(laixia.config.GameType)
    CSPacketLogin:setValue("GameVersion", "0")

    CSPacketLogin:setValue("VersionName",newVersion);
    CSPacketLogin:setValue("ChannelID",newChannelID);
    print(newChannelID)
    CSPacketLogin:setValue("Devices", newDevices)
    print(newDevices)
    CSPacketLogin:setValue("PlatformID",newGamePlatformID)
    print(newGamePlatformID)
    CSPacketLogin:setValue("Account",newAccount)
    print(newAccount)

    CSPacketLogin:setValue("UnionID",newUnionID)
    print(newUnionID)
    CSPacketLogin:setValue("Passwd",newPassWord )
    print(newPassWord)
    CSPacketLogin:setValue("IMEI",imei);
    print(imei)
    CSPacketLogin:setValue("Token",newToken)
    print(newToken)

    --versionName=&channelId=&mobileInfo=&platform=&account=
    local versionName = crypto.md5(newVersion)
    local channelId = crypto.md5( newChannelID )
    local mobileInfo = crypto.md5( newDevices)
    local platform = crypto.md5(  newGamePlatformID )
    local account =  crypto.md5(  newAccount )

    local str  = "versionName="..newVersion.."&channelId="..newChannelID.."&mobileInfo="..newDevices.."&platform="..newGamePlatformID.."&account="..newAccount
    local md5msg = crypto.md5(  str )
    --"versionName=1.0.0&channelId=0&mobileInfo=huawei-6p&platform=1&account=00-01-6C-D6-01-F6"
    CSPacketLogin:setValue("Md5msg",md5msg)

    print(md5msg)

    if self.mProcessState == 2 then
        laixia.net.sendHttpPacketAndWaiting(CSPacketLogin, nil, 1);
    else
        laixia.net.sendHttpPacket(CSPacketLogin, nil, 1);
    end
    laixia.logGame('send packet ****************** :CSPacketLogin ');
    print(laixia.LocalPlayercfg.LaixiaPhoneNum)
    print(laixia.LocalPlayercfg.LaixiaPassword)
    CPPLog:info("send login package")

end

-- 后台到前台的时候，唤醒一次
function Net:awake()
    self.mAwakeFlag = true;
    self.mLostHeartBet = laixia.config.LAIXIA_MAX_LOST_BEAT_HEART_PACKET_NUM-1;
    self:sendHeartBeatPacket()
    -- 发送 一个心跳包
end

function Net:recvHeartBeat()
    -- 收到心跳
    self.mLostHeartBet = 0;
end


function Net:sendHeartBeatPacket(packet)
    --如果超出心跳规范数量，则自动进行重新连接
    if (self.mLostHeartBet >= laixia.config.LAIXIA_MAX_LOST_BEAT_HEART_PACKET_NUM) then
        printInfo("LostHeartBet:%d||||LostHeartBet is long!!readyForReConnect!!!!",self.mLostHeartBet)
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "SingleCardTableDialog" then
            ui.SingleCardTableDialog.mIsConnect = false
        else
            laixia.net.readyForReConnect()
            self:recvHeartBeat()
        end

    else
        -- 发送心跳
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_HEARTTICK_WINDOW)
        self.mLostHeartBet = 1 + self.mLostHeartBet
    end
end

function Net:addSendWaitingPID(sid)
    --添加调用了等待圈圈的PID
    table.insert(mSendWaitingPID, sid)
end

return Net.new()


