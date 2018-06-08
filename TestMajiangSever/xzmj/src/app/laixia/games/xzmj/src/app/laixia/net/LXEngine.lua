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

	local res = json.decode(event);

	printTb(res.ms[1])

	local data = res.ms[1]
	local dtp = data.tp
	if dtp then 
		if dtp == "create_poker" then-- 创建牌桌
			xzmj.Model.PokerDeskModel:OpenMJLayer( data)
		elseif dtp == "get_card" then-- 吃碰杠胡操作定缺
        	xzmj.Model.PokerDeskModel:OperationInType( data )
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
	for k,v in ipairs(res.ms) do
		response = v
		break
	end
	dump(response,"response")
	
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