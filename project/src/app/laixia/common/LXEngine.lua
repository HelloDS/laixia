--[[
    来下引擎
    所有对接服务器接口，此处做统一处理
]]

local json = json or require("framework.json")
LXEngine = LXEngine or {}

local xzLxEngine = require("app.laixia.games.xzmj.src.app.laixia.net.LXEngine")
--[[
    接收广播消息
]]
function received(event)
	print("============接收到数据=========")
	if xzLxEngine then
		xzLxEngine.received(event)
		print("血战麻将全局函数调用成功")
	else
		print("血战麻将全局函数调用错误")
	end

--[[	local res = json.decode(event);
	local response
	for k,v in ipairs(res.ms) do
		response = v
		break
	end

	dump(response,"response")

	recieveSA(response)--]]
end

function recieveSA(response)
	if response.tp == "BC" then
		local param = {}
		param.noticeIds = response.action_id
		param.Param = response.paras

	    dump(param,"param")
	    local broadcastDBM = laixiaddz.JsonTxtData:queryTable("mail_mode");
	    local msg = broadcastDBM:queryMessageByID(param.noticeIds,param.Param);

	    dump(msg,"msg---")
	    if not msg then
	        return;
	    end
	    local shows = msg.show
	    local showArr = string.split(shows,"|")

	    dump(showArr,"showArr")
	    if #showArr <= 0 then
	        return
	    end
	    local tinsert = table.insert
	    for k,v in ipairs(showArr) do
	    	dump(v,"showArr")
	        local key = tonumber(v)
	        if key == 1 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall,msg)
	        elseif key == 2 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
	        elseif key == 3 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
	        elseif key == 4 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
	        elseif key == 5 then

	        elseif key == 6 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall,msg)
	        elseif key== 7 then

	        elseif key == 8 then

	        elseif key == 100 then
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoom,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomCoupon,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInPokerRoomMatch,msg)
	            tinsert(laixiaddz.LocalPlayercfg.LaixiaBroadCastInInHall,msg)


	        end
	    end
	    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BROADCASTS_WINDOW)
	end
end
--[[
    用户连接"ua"连接成功
]]
function socketDidConnected()
    print("用户连接\"ua\"连接成功")
end

--[[
    用户连接"ua"连接断开或者失败
]]
function socketDidDisconnect()
    print("用户连接\"ua\"连接断开或者失败")
end

