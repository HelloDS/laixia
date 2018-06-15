local TiShiyu = class("TiShiyu", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg

function TiShiyu:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TiShiyu:getZorder()
   return  20 
end

function TiShiyu:getName()
    return "TiShiYu"
end

function TiShiyu:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_MARKEDWORDS_WINDOW, handler(self, self.destroy))
end


function TiShiyu:onShow(data)
   
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Ok",handler(self,self.onFunctionOK)) 
    -- self:AddWidgetEventListenerFunction("TiShiYu_Button_Close", handler(self,self.onShutDown))
    self.tiShiyuBG = self:GetWidgetByName("Image_2")
    self.tiShiyuBG:setTouchEnabled(true)
    self.tiShiyuBG:setTouchSwallowEnabled(true)
    local content_text =self:GetWidgetByName("TiShiYu_Content_Text")
    content_text:setVisible(true)
    if type(data.data) ~= "table" then
        content_text:setString(data.data)
    else
        self:GetWidgetByName("TiShiYu_Button_Ok"):setVisible(true)
        -- self:GetWidgetByName("TiShiYu_Button_Close"):setVisible(true)
        content_text:setString(data.data.Text)
        self.callFunc = data.data.OnCallFunc
    end
end

function TiShiyu:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

function TiShiyu:onFunctionOK(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:closeFunction()
    end
end

function TiShiyu:closeFunction()
    if self.callFunc ~= nil then
        self.callFunc(true)
    end
    self:destroy()
end

function TiShiyu:onCallBackFunction()
    if self:GetWidgetByName("TiShiYu_Button_Close"):isVisible() then
        self:destroy()
    else
        self:closeFunction()
    end
end

function TiShiyu:onDestroy()
    self.callFunc = nil
end
return TiShiyu.new()


