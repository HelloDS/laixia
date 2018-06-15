
--修改网络模块，改为直接调用NetSystem

local net = {}
local Net = import(".Laixia_Net")

function net.init()
	Net:init()
end

-- 发送 Http登录信息
function net.start()
	Net:start();
end

function net.startTcp(appID)
	Net:startTcp(appID)
end

function net:disconnect()
	Net:disconnect()
end

function net:endTCP()
	Net:endTCP()
end

function net.sendPacket(packet)
	Net:sendPacket(packet);
end

function net.sendHttpPacket(packet)
	Net:sendHttpPacket(packet);
end

function net.tick(dt)
	Net:tick(dt);
end

--发送消息包，并且弹出窗口

function net.sendHttpPacketAndWaiting(packet,msgID,waitID)
	msgID = msgID or _ID_DICT_TYPE_WAITING_FOR_SWITCH
	waitID = waitID or 1
    if waitID == 2 then
	else
    	ObjectEventDispatch:dispatchEvent{
    		name = _LAIXIA_EVENT_SHOW_RECONNECTIONTIPS_WINDOW,
    		data = msgID,
    		waitType = waitID
    	}
	end
	Net:sendHttpPacket(packet);
	Net:addSendWaitingPID(packet:getPacketID())
end

--发送等待消息

function net.sendPacketAndWaiting(packet,msgID,waitID)
	msgID = msgID or _ID_DICT_TYPE_WAITING_FOR_SWITCH
	waitID = waitID or 2
	ObjectEventDispatch:dispatchEvent{
		name = _LAIXIA_EVENT_SHOW_RECONNECTIONTIPS_WINDOW,
		data = msgID,
		waitType = waitID
	}
	Net:sendPacket(packet);
	Net:addSendWaitingPID(packet:getPacketID())
end


function net.recvHeartBeat()
	Net:recvHeartBeat();
end

function net.isTcpConnected()

	return Net:isTcpConnected();
end

function net.setHttpConnected(conn)
	return Net:setHttpConnected(conn);
end
function net.isHttpConnected()
	return Net:isHttpConnected();
end
function net.setReConnecting(conn)
	Net:setReConnecting(conn);
end
function net.readyForReConnect()
	Net:readyForReConnect()
end

function net.closeTcp()
	Net:closeTcp()
end

function net.sendHeartBeatPacket(packet)
	Net:sendHeartBeatPacket(packet)
end

function net.recvHeartBeat()
	Net:recvHeartBeat()
end

function net.clearAllWaiting()
	Net:clearAllWaiting()
end

function net.addSendWaitingPID(msg)
	Net:addSendWaitingPID(msg)
end
function net.awake()
	Net:awake()
end

--恢复
function net:resume()
	Net:initHTTP() -->把HTTP 注册回来
	Net:startTcp(laixia.config.GameAppID);
end

--挂起
function net:PauseFun()
	Net:disconnect() --> 断开 斗地主的网络
end



net.Net = Net;

return net




