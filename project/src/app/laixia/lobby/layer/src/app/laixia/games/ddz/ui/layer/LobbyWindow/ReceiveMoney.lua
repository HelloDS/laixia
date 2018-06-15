-- 红包使用的弹窗

local ReceiveMoney = class("ReceiveMoney", import("...CBaseDialog"):new())
local soundConfig =  laixiaddz.soundcfg

function ReceiveMoney:getName()
    return "ReceiveMoney"
end

function ReceiveMoney:ctor()
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function ReceiveMoney:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MONEY_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_HIDEMONEY_WINDOW, handler(self, self.destroy))
end


function ReceiveMoney:onShow(data)
    self.Text_1 = self:GetWidgetByName("Text_1")
    self.Text_1:setVisible(true)
    if type(data.data) ~= "table" then
        local str  = data.data         
        self.Text_1:setString(str)
    else
        local str  = data.data.text 
        self.Text_1:setString(str)
    end

    self:AddWidgetEventListenerFunction("Button_quedinghongbao", handler(self,self.onShutDown))  --确定
end

function ReceiveMoney:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HIDEMONEY_WINDOW)
    end
end


return ReceiveMoney.new()