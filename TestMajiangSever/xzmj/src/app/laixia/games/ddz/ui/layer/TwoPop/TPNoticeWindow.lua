local TPNoticeWindow = class("TPNoticeWindow", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet")

function TPNoticeWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false 
end

function TPNoticeWindow:getName()
    return "TPNoticeWindow"
end

function TPNoticeWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BULLETINS_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_BULLETINS_WINDOW, handler(self, self.updateWindow))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_REQUEST_BULLETINS_WINDOW, handler(self, self.requestNotice))
end

function TPNoticeWindow:requestNotice()
    local CSServiceNotice = Packet.new("CSServiceNotice", _LAIXIA_PACKET_CS_ServiceNoticeID)
    CSServiceNotice:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSServiceNotice:setValue("GameID",  laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSServiceNotice)
end

function TPNoticeWindow:close(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onClose()
    end
end

function TPNoticeWindow:updateWindow(msg)
    if (self.mIsShow == true) then 
        local data = msg.data 
        self.callFunc = data.OnCallFunc
        local content = data.Content
        self.labelContent:setString(content)
    end 
end

function TPNoticeWindow:onClose()
   if self.callFunc then
       self.callFunc()
   end
   self:destroy()
end

function TPNoticeWindow:onDestroy()
    self.mIsShow = false
    self.callFunc = nil
end

function TPNoticeWindow:onShow()
    print("-------------------------------")
    if self.mIsShow == false then
        self.BG = self:GetWidgetByName("Image_17")
        self.BG:setTouchEnabled(true)
        self.BG:setTouchSwallowEnabled(true)
        
        self:AddWidgetEventListenerFunction("Button_Close", handler(self, self.close))
        self.labelContent = self:GetWidgetByName("Ntice_Text")
        self.labelContent:setString("") 
        self.mIsShow = true
    end
end


return TPNoticeWindow.new()


