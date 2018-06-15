
local ExchangeCode = class("ExchangeCode", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;   
local Packet = import("....net.Packet")

function ExchangeCode:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function ExchangeCode:getName()
    return "ExchangeCode"
end

function ExchangeCode:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_REDEEMGIFT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_REDEEMGIFT_WINDOW, handler(self, self.destroy))
end

function ExchangeCode:onSendToSever(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local RedeemCode = self.exchange_code:getString()

        if RedeemCode == "" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "请输入兑换码")
            return
        end
        local CSRedeemCode = Packet.new("CSRedeemCode", _LAIXIA_PACKET_CS_RedeemCodeID)
        CSRedeemCode:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        CSRedeemCode:setValue("ConversionCode", RedeemCode)
        CSRedeemCode:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacket(CSRedeemCode)
    end
end

function ExchangeCode:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_REDEEMGIFT_WINDOW)
    end
end


function ExchangeCode:onShow()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_SETUP_WINDOW);
    self:AddWidgetEventListenerFunction("GiftInside_Button_Submit", handler(self, self.onSendToSever))
    self:AddWidgetEventListenerFunction("GiftInside_Button_Close", handler(self, self.onShutDown))
    self.exchange_code = self:GetWidgetByName("GiftInside_Text_Input")

end



return ExchangeCode.new()
