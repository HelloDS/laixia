--
-- Author: peter
-- Date: 2018-01-09 10:44:54
--
local TPPhysicalExchangeTishi = class("TPPhysicalExchangeTishi", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg    
local Packet = import("....net.Packet") 

function TPPhysicalExchangeTishi:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPPhysicalExchangeTishi:getName()
    return "TPPhysicalExchangeTishi"
end

function TPPhysicalExchangeTishi:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_EXCHANGETISHI_WINDOW, handler(self, self.show))
end

function TPPhysicalExchangeTishi:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onClose()
    end
end

function TPPhysicalExchangeTishi:onClose()
    self:destroy()
end

function TPPhysicalExchangeTishi:goBinding(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        local title = "请关注公众号"..laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum
        local Url = "http://wx.laixia.com/download"
        local description ="来下斗地主免费赢话费，时时赢微信红包！"
        local flag = 0 -- 0 分享好友  1 分享好友圈


        --分享链接
        if device.platform == "android" then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "wxShare"
            local javaParams = {title,Url ,description,flag }
            local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        else--苹果包
            local args = {title = title, Url =Url,description=description,flag = flag }
            local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
            print("wangtianye")
            print(state )
            print(value)
        end
    end
end

function TPPhysicalExchangeTishi:onShow(msg)
  	local data = msg
    self:AddWidgetEventListenerFunction("Button_close", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_cannel", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_gobinding", handler(self, self.goBinding))

    --前往绑定手机
	self.Text_tishi_1 = self:GetWidgetByName("Text_tishi_1")
	self.Text_tishi_2 = self:GetWidgetByName("Text_tishi_2")
	self.Text_xhx = self:GetWidgetByName("Text_xhx")
	self.Text_gzh = self:GetWidgetByName("Text_gzh")
	--复制按钮
	--self.Button_fuzhi = self:GetWidgetByName("Button_fuzhi")
    if data == 1 then
    	self.Text_tishi_1:setVisible(true) 
    	self.Text_tishi_2:setVisible(false)
    	self.Text_xhx:setVisible(false)
    	self.Text_gzh:setVisible(false)
    	--self.Button_fuzhi:setVisible(false)
    else--前往关注公众号
    	self.Text_tishi_1:setVisible(false)
    	self.Text_tishi_2:setVisible(true)
    	self.Text_xhx:setVisible(true)
    	self.Text_gzh:setVisible(true)
    	--self.Button_fuzhi:setVisible(true)
    end
end

return TPPhysicalExchangeTishi.new()


