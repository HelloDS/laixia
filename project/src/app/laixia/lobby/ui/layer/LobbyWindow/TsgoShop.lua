--
-- Author: peter
-- Date: 2017-11-21 10:52:29
--

local TsgoShop = class("TsgoShop", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg  

function TsgoShop:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false  
end

function TsgoShop:getName()
    return "TsgoShop"  
end  

function TsgoShop:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_TSGOSHOP_SHOPWINDOW, handler(self, self.show))
end

function TsgoShop:onShow(msg)
    
    self:GetWidgetByName("Text_2"):setString("您的金币不足")
    self:GetWidgetByName("Text_2"):enableOutline(cc.c4b(161,92,51,255), 2)
    self:AddWidgetEventListenerFunction("likai", handler(self, self.onSupplement))
    self:AddWidgetEventListenerFunction("qianwang", handler(self,self. onContinue))
end 

function TsgoShop:onContinue(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType =1}) 
   		ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW)
    end
end

function TsgoShop:onSupplement(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
    
end




return TsgoShop.new()