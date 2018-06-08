local TiShiYuweChat = class("TiShiYuweChat", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg
local Packet = import("....net.Packet")


function TiShiYuweChat:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TiShiYuweChat:getName()
    return "TiShiYuweChat"
end

function TiShiYuweChat:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_TISHIYUWECHAT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_TISHIYUWECHAT_WINDOW, handler(self, self.destroy))
end

function TiShiYuweChat:onShow(data)
   
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Ok",handler(self,self.onShutDown)) 
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Close", handler(self,self.onShutDown))
    local str00 = self:GetWidgetByName("TiShiPresent_Content_Text_00")
    local str01 = self:GetWidgetByName("TiShiPresent_Content_Text_01")

end

function TiShiYuweChat:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

function TiShiYuweChat:onGoBind(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local stream = Packet.new("CS_PersonalCenter", _LAIXIA_PACKET_CS_PersonalCenterID)
        stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(stream, nil, 1);

    end
end

function TiShiYuweChat:closeFunction()
    self:destroy()
end

return TiShiYuweChat.new()


