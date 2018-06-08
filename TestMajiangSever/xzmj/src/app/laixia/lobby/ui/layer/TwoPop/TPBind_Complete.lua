local TPBind_Complete = class("TPBind_Complete", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg   


function TPBind_Complete:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPBind_Complete:getName()
    return "TPBind_Complete"
end

function TPBind_Complete:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_BINDTRUE_WINDOW, handler(self, self.show))
end

function TPBind_Complete:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end


function TPBind_Complete:onShow()
    self:AddWidgetEventListenerFunction("BindComplete_Button_OK", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("BindComplete_Button_Close", handler(self, self.onShutDown))
    self:GetWidgetByName("BindComplete_Label_PhoneNumber"):setString("手机号码："..laixia.LocalPlayercfg.LaixiaPhoneNum)
    self:GetWidgetByName("BindComplete_Label_PassWorld"):setString("密码："..laixia.LocalPlayercfg.LaixiaPassword)
    
end


return TPBind_Complete.new()


