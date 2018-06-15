
local TPVirtualExchange = class("TPVirtualExchange", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg  
local Packet = import("....net.Packet")

function TPVirtualExchange:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPVirtualExchange:getName()
    return "Duihuandingdan"
end

function TPVirtualExchange:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_REDEEMVIRTUAL_WINDOW, handler(self, self.show))
end


function TPVirtualExchange:SendExchangePacket(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local str=self.phone_number:getString()
        if str == "" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "需要输入号码！")
            return
        end
        if self.data.page == "ExchangeWindow" then
            local exchange = Packet.new("ConversionCode", _LAIXIA_PACKET_CS_ExchangeID)
            exchange:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
            exchange:setValue("GameID", laixia.config.GameAppID)
            exchange:setValue("ExchangeID", self.data.ID)
            exchange:setValue("Number", str)
            exchange:setValue("ItemObjID", 0)
            exchange:setValue("ExchangePos",0)
            laixia.net.sendHttpPacket(exchange)
        elseif self.data.page == "MyBagWindow" then
            local uesPacket = Packet.new("uesPacket", _LAIXIA_PACKET_CS_UsePackPropID)
            uesPacket:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
            uesPacket:setValue("GameID", laixia.config.GameAppID)
            uesPacket:setValue("ItemObjID", self.data.ObjID)
            uesPacket:setValue("ItemID", self.data.ID)
            uesPacket:setValue("ItemCount", 1)
            uesPacket:setValue("ReceiveName", "laixia")
            uesPacket:setValue("PhoneNumber", str)
            uesPacket:setValue("Address", "laixia")
            laixia.net.sendHttpPacket(uesPacket)
        end 
        self:destroy()
    end
    
end

function TPVirtualExchange:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end
function TPVirtualExchange:onShow(mesg)
    self:AddWidgetEventListenerFunction("EO_Button_Close", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("EO_Button_Submit", handler(self, self.SendExchangePacket))
    self.data = mesg.data
    self.phone_number = self:GetWidgetByName("EO_TextField_PhoneNum")
end


return TPVirtualExchange.new()

