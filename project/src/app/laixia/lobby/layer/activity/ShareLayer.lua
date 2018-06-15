--
-- Author: Feng
-- Date: 2018-05-22 11:59:07
--

--
-- Author: Feng
-- Date: 2018-05-08 15:56:58
--


--[[
    大厅主界面层
]]
local scene = cc.Director:getInstance():getRunningScene()

local ShareLayer = class("ShareLayer" ,function()
        return display.newLayer()
    end)

--[[
    构造函数
]]
function ShareLayer:ctor(...)
    self:init(...)
end

--[[
    初始化
]]
function ShareLayer:init(...)
    self.data = ...
    --初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/ShareLayer.csb")
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode
    _G.adapPanel_root(csbNode)

    --分享到朋友圈
    self.Button_share_wx = _G.seekNodeByName(self.rootNode,"Button_share_wx")
    self.Button_share_wx:addTouchEventListener(handler(self, self.ShareWx))

    --分享到好友
    self.Button_share_friend = _G.seekNodeByName(self.rootNode,"Button_share_friend")
    self.Button_share_friend:addTouchEventListener(handler(self, self.ShareFriend))

    --返回按钮
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))
end

--[[
    分享到朋友圈
]]--
function ShareLayer:ShareWx(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then 
        --分享链接
        local str = laixia.LocalPlayercfg.LaixiaPlayerID .. "7kyn@,ey"
        local token = crypto.md5(str)
        if device.platform == "ios" then
            local args = {
                            platform = "timeline",
                            title = "您有一部OPPO R15未领取",
                            content = "你来分享我来送，OPPO R15、红包等你拿",
                            url = "http://wx.laixia.com/ma?a=share&user_id=".. laixia.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                            imageUrl = "http://img2.inke.cn/MTUxNTE1OTgzNzQ2MiMxNTcjanBn.jpg",
            }
            luaoc.callStaticMethod("IKCRBridgeManager", "shareToWX", args)
        elseif device.platform == "android" then
            local args = {
                            type = "1",
                            title = "您有一部OPPO R15未领取",
                            content = "你来分享我来送，OPPO R15、红包等你拿",
                            url = "http://wx.laixia.com/ma?a=share&user_id=".. laixia.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                            icon = "http://wx.laixia.com/images/iphonex/icon.png"
            }
            local jsonStr = json.encode(args)
            local result = {jsonStr}
            local sig = "(Ljava/lang/String;)V"
            local ok, value = luaj.callStaticMethod(APP_ACTIVITY, "wxShare", result, sig)
        end
    end
end  

--[[
    分享到好友
]]--
--分享到微信好友
function ShareLayer:ShareFriend(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then 
        local str = laixia.LocalPlayercfg.LaixiaPlayerID.."7kyn@,ey"
        local token = crypto.md5(str)
        if device.platform == "ios" then
            local args = {
                            platform = "wechat",
                            title = "您有一部iPhone X未领取",
                            content = "你来分享我来送，iPhone X、红包等你拿",
                            url = "http://wx.laixia.com/ma?a=share&user_id=".. laixia.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                            imageUrl = "http://img2.inke.cn/MTUxNTE1OTgzNzQ2MiMxNTcjanBn.jpg",
            }
            luaoc.callStaticMethod("IKCRLXBridgeManager", "shareToWX", args)
        elseif device.platform == "android" then
            local args = {
                            type = "2",
                            title = "您有一部iPhone X未领取",
                            content = "你来分享我来送，iPhone X、红包等你拿",
                            url = "http://wx.laixia.com/ma?a=share&user_id=".. laixia.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                            icon = "http://wx.laixia.com/images/iphonex/icon.png"
            }
            local jsonStr = json.encode(args)
            local result = {jsonStr}
            local sig = "(Ljava/lang/String;)V"
            local ok, value = luaj.callStaticMethod(APP_ACTIVITY, "wxShare", result, sig)
        end
    end
end

--[[
    --关闭界面
]]
function ShareLayer:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then 
        self:removeFromParent()
    end
end

return ShareLayer



