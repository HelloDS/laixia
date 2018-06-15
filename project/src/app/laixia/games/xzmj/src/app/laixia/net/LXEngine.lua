--[[
    来下引擎
    所有对接服务器接口，此处做统一处理
]]

local json = json or require("framework.json")
LXEngine = LXEngine or {}


--[[
    接收java广播消息
	原类原型  全局回调函数
	public class RegisterMaeeageUA implements UserInfoInterface.MessageListener {
	    @Override
	    public void onMessage(String message){
	        Cocos2dxLuaJavaBridge.callLuaGlobalFunctionWithString("received",message);
	    }
	}
]]--


function LXEngine.received(event)
	if event == nil then
		return
	end 
	local res = json.decode(event);
	local dtp = nil
	local data = nil
    if device.platform == "android" or device.platform == "ios" then
		local data = res.ms[1]
		dtp = data.tp
	else
		dtp = res.tp
		data = res
    end
    printTb(data)
	if dtp then 
		if dtp == "create_poker" then-- 创建牌桌
			xzmj.Model.PokerDeskModel:OpenMJLayer( data)
		elseif dtp == "play_card"  then-- 吃碰杠胡操作定缺 收到玩家得实际操作
        	xzmj.Model.PokerDeskModel:OperationInType( data )
		elseif dtp == "get_card" then -- 摸牌
        	xzmj.Model.PokerDeskModel:OperationMoPaiInType( data )
        elseif dtp == "thinking" then -- 服务器通玩家该杠 碰 胡了
        	xzmj.Model.PokerDeskModel:ShowOperation( data )
        elseif dtp == "changemjinfo" then-- 换三张
        	xzmj.Model.PokerDeskModel:ChangeMJInfo( data )
        elseif dtp == "dingqueinfo" then-- 定缺
        	xzmj.Model.PokerDeskModel:DingQueInfo( data )
        elseif dtp == "tuoguaninfo" then-- 托管信息
        	xzmj.Model.PokerDeskModel:TuoGuanInfo( data )
        elseif dtp == "gameendinfo" then -- 游戏结束
        	xzmj.Model.PokerDeskModel:GameEnd( data )
		end
	end
	
	local response
    if device.platform == "android" or device.platform == "ios" then

		for k,v in ipairs(res.ms) do
			response = v
			break
		end
		dump(response,"response")
	else
		for k,v in ipairs(res) do
			response = v
			break
		end
		--dump(response,"response")
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

return LXEngine