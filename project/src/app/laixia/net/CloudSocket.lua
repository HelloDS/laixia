

local socket = require("socket")
CloudSocket = class("CloudSocket")

local ip = "127.0.0.1"
local port = 12345

function CloudSocket:socketInit()
    local socket = require("socket")
    local host = ip
    G_SOCKETTCP = socket.tcp()
    local n,e = G_SOCKETTCP:connect(host, port)
    local tb = {["msgid"] = 1001,["id"] = xzmj.Model.GameLayerModel:GetUid()}

    if n == 1 then
        print("服务器连接成功======",n,e)  --n = 1
        self:Send( xzmj.json.encode(tb)  )
    end

    G_SOCKETTCP:settimeout(0)
end

function CloudSocket:socketClose()
    G_SOCKETTCP:close()
end
--[[
如果成功，该方法将返回已发送的[i, j]中最后一个字节的索引。注意，如果我是1或不存在，
这实际上就是发送的字节总数。如果发生错误，该方法返回nil，然后是一条错误消息，
然后是已经发送的[i, j]中的最后一个字节的索引。您可能想从后面的字节中再尝试一次。
错误消息可以“关闭”，以防在传输完成之前关闭连接，或者在操作期间出现超时时，
字符串“超时”。
注意:输出没有缓冲。对于小字符串，最好将它们连接到Lua中(与…将结果发送到一个调用中，而不是多次调用该方法。
]]--
--[[
]]--
function CloudSocket:Send(sendStr)
	print("socketSend=====开始发送数据"..sendStr)
    local str = sendStr.."\n"
    local s,d = G_SOCKETTCP:send(str)
    -- if s then
    --     print("s======="..s) -- 5 ？？
    -- end
    -- if d then
    --     print("d======="..d)
    -- end
end

function CloudSocket:socketReceive()

    local recvt, sendt, status1 = socket.select({G_SOCKETTCP}, nil, 0)
    if #recvt > 0 then
        local lresponse, lreceive_status, lpartial = G_SOCKETTCP:receive("*a")
        if lreceive_status == "Socket is not connected" then
        end
        print("receive return:", lresponse or "nil" ,lreceive_status or "nil")
        print("lpartial:    ",lpartial or "nil")
        if receive_status ~= "closed" then
            xzmj.net.LXEngine.received(lpartial)
        else
            G_SOCKETTCP:close()
            if self.mScheduler then
                local scheduler = cc.Director:getInstance():getScheduler()
                scheduler:unscheduleScriptEntry(self.mScheduler)  
            end
        end
    end
    
end
--[[
    协议 1001 保存sokect channelid
    协议 1002 
    协议 1003 换三张 

]]--
function CloudSocket:socketInitandschedul()
    self:socketInit()
    local timePassed = 0
    local function myHandler(dt)
        timePassed= timePassed + dt
        if timePassed > 0.1 then
            self:socketReceive()
            timePassed= 0
        end
    end
	local scheduler = cc.Director:getInstance():getScheduler()
	self.mScheduler  = scheduler:scheduleScriptFunc(myHandler,1, false)


end

return CloudSocket





-- G_SOCKET = socket
-- -----------------------------------------------
-- CloudSocket = class("CloudSocket")
-- --CloudSocket.__index = CloudSocket
-- CloudSocket.m_host = nil          
-- CloudSocket.m_socket = nil 
-- CloudSocket.m_SockAddr = nil
-- CloudSocket.m_port = 0
 
-- function CloudSocket:send(msg)
-- 	if #msg>0 then
-- 		local returnInfo = self.m_socket:send(msg)
-- 		print("调用网络send（）函数成功===")
-- 		return returnInfo
-- 	end
-- end

-- function CloudSocket:receive()


 --    local recvt, sendt, status1 = socket.select({self.m_socket}, nil, 0)

	-- -- Print("#recvt, #sendt, status1 = ", #recvt, #sendt, status1)
	-- if #recvt > 0 then
	-- 	local lresponse, lreceive_status, lpartial = self.m_socket:receive("*a")
	-- 	-- Print("[CloudSocket:receive]", lreceive_status)
	-- 	if lreceive_status == "Socket is not connected" then
	-- 		G_CONNECT_STAGE = 0 
	-- 		-- Print("-----------------------------receive_status closed!")
	-- 	end
-- 		if lreceive_status ~= "closed" then			
-- 			if lresponse or lpartial then
-- 				-- 测试
-- 				-- return lresponse
				
-- 				if (lresponse and string.len(lresponse) == 0) or(lpartial and string.len(lpartial) == 0) then 
-- 				 	return
-- 				end
-- 				if not lresponse then
-- 					Print("not lresponse")
					
-- 					return lpartial 
-- 				elseif not lpartial then
-- 					Print("not lpartial")
-- 					Print("#lresponse:",#lresponse)
-- 					return lresponse
-- 				else
-- 					Print("lresponse .. lpartial ")
-- 					return lresponse .. lpartial 
-- 				end
-- 				--[[
-- 				if lresponse or lpartial then 
-- 					Print("lresponse:",lresponse)
-- 					lresponse = lresponse .. lpartial 
-- 					return  lresponse
-- 				end
-- 				]]
-- 			else
-- 				--G_CONNECT_STAGE = 0
-- 				-- Print("~~~~~~~~~~~not receive any content!!!")
-- 			end
-- 		elseif lreceive_status == "closed" then 			
-- --			PromptUI:Capion("在CloudSocket断开连接!~~",10)
--             return 4  ---断线重新连接！
-- 		end
--     end   
-- end		

-- function CloudSocket:getLinger ()
	
-- 	----没有找到相应获取函数
-- end	

-- function CloudSocket:setLinger (lingertime)
-- 	self.m_socket:setoption("linger",{true,lingertime})
-- end

-- function CloudSocket:setReuseAddr(b)
-- 	self.m_socket:setoption('reuseaddr', b);
-- end

-- function CloudSocket:closeConnect()
-- 	self.m_socket:close()
-- end	

-- function CloudSocket:settimeout( time )
-- 	self.m_socket:settimeout(time)
-- end

-- function CloudSocket:reconnect()
-- 	self.m_socket:close()
-- 	self.m_socket ,errorMsg = socket.tcp()
--     self.m_socket:settimeout(0.2)
-- 	 local __succ, __status = self.m_socket:connect(self.m_host, self.m_port)
-- 	Print("reconnect!~ host, port = __succ, __status = ", self.m_host, self.m_port, __succ, __status)
-- 	--本地记录账户信息	
-- --	if CurDupBattleUI then  --战斗处理
-- --		CurDupBattleUI:closeIllustrations()
-- --	end
-- 	local save =  cc.UserDefault:getInstance()
-- 	local UserAccount = save:getStringForKey("UserName");
-- 	local UserPwd = save:getStringForKey("UserPassWord");
-- 	if __succ == 1 then  --socket 链接成功
-- 		G_RECONNECT_STAGE = 1 --重新登陆
-- 		EventControl:dispatchevent(EventDefine.UI_LOGIN_DENGLU,UserAccount,UserPwd)
-- 	end
-- 	-- EventControl:dispatchevent(EventDefine.UI_LOGIN_DENGLU,UserAccount,UserPwd)
-- end			


-- function CloudSocket:InitSocket(host,port) ---------host为服务器IP字符串，格式“192.168.1.119”，port为端口号为number类型
--     local port = tonumber(port)
-- 	--self.m_socket = socket
-- 	local m_socket  = {}
-- 	if #m_socket > 0 then
-- 		for i=1,#m_socket do
-- 			m_socket[i]:close()
-- 		end
-- 	end
-- 	self.m_socket ,errorMsg = socket.tcp()
-- 	table.insert(m_socket, self.m_socket)
-- 	print("socket VERSION",socket._VERSION)
-- 	print ("--------------------",errorMsg)
-- 	print("m_socket:",self.m_socket,"errorMsg:",errorMsg)
-- 	self.m_socket:settimeout(0.2)
-- 	--Print(self.m_socket)

-- 	local __succ, __status = self.m_socket:connect(host, port)
-- 	G_SOCKET_ISABLED =  __succ
-- 	print("connect!~ __succ, __status = ", __succ, __status)
-- 	self.m_host = host
-- 	self.m_port = port
	
	
-- 	local xresult = self.m_socket:setoption('reuseaddr', true)
	
-- 	result = self.m_socket:setoption('keepalive',true)

-- 	return self.m_socket
-- end	
	
-- function CloudSocket:createSocket(host,port)
--     Socket = Socket or {}  
--    setmetatable(Socket,self)
--    self.__index = self

--    Socket:InitSocket(host,port)

--    return Socket 	
-- end




--socket = require("socket");
--host = host or "127.0.0.1";
--port = port or "8383";
--server = assert(socket.bind(host, port));
--ack = "ack\n";
--while 1 do
--    print("server: waiting for client connection...");
--    control = assert(server:accept());
--    while 1 do 
--        command,status = control:receive();
--  if status == "closed" then break end
--        print(command);
--        control:send(ack);
--    end
--end





