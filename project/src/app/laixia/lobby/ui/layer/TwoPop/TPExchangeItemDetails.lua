
local ExchangeItemDetails = class("ExchangeItemDetails", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg  
local Packet = import("....net.Packet")
local laixia = laixia;
local db2 = laixia.JsonTxtData;
local itemDBM 

function ExchangeItemDetails:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function ExchangeItemDetails:getName()
    return "ExchangeItemDetails"
end

function ExchangeItemDetails:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_REDEEMDETAILS_WINDOW, handler(self, self.show))
end

function ExchangeItemDetails:onShotDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end


function ExchangeItemDetails:onSendPacketToSever(msg)
    local exchange = Packet.new("ConversionCode", _LAIXIA_PACKET_CS_ExchangeID)
    exchange:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    exchange:setValue("GameID", laixia.config.GameAppID)
    exchange:setValue("ExchangeID", msg.ID)
    exchange:setValue("ItemObjID", 0)
    exchange:setValue("ExchangePos",0)
    laixia.net.sendHttpPacket(exchange)
end

function ExchangeItemDetails:onExchange(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.exchangeInfo.ItemCount > laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "奖券不足玩牌可以获取更多的奖券！")
            return
        end
        if self.exchangeInfo.ItemNum==0 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "今天已经换光啦，明天再来看看吧")
            return
        end
        local dataTable = { }
        dataTable.ID = self.Itemsdata.ItemID
        dataTable.page = "ExchangeWindow"
        if self.Itemsdata.delivery  == 1 then
            ObjectEventDispatch:dispatchEvent( { name = _LAIXIA_EVENT_SHOW_REDEEMENTITY_WINDOW, data = dataTable})
        elseif self.Itemsdata.delivery  == 2  then
            self:onSendPacketToSever(dataTable)
        else
            ObjectEventDispatch:dispatchEvent( { name = _LAIXIA_EVENT_SHOW_REDEEMVIRTUAL_WINDOW, data = dataTable})
        end
        self:destroy()
    end
end

function ExchangeItemDetails:onShow(mesginfo)
    itemDBM = db2:queryTable("items");
    self.exchangeInfo = mesginfo.Info
    self:AddWidgetEventListenerFunction("ED_Button_Close", handler(self, self.onShotDown))
    self:AddWidgetEventListenerFunction("ED_Button_Exchange", handler(self, self.onExchange))
    self.Itemsdata = itemDBM:query("ItemID",self.exchangeInfo.ItemID); 
    self:GetWidgetByName("ED_Label_Name"):setString(self.Itemsdata.ItemName)
    self:GetWidgetByName("ED_Image_Card"):loadTexture(self.Itemsdata.ImagePath, 1)

    if self.Itemsdata.PresentItemID1 == 1003 then
             local sicon =  "red_packet_"..self.Itemsdata.BaseCount..".png"
             local count = ccui.ImageView:create(sicon,1)
             count:setPosition(78,60)
             count:setLocalZOrder(100)
             count:addTo(self:GetWidgetByName("ED_Image_Card"))
    end

    self:GetWidgetByName("ED_Label_Price"):setString(self.exchangeInfo.ItemCount .. "奖券")
    self:GetWidgetByName("ED_Label_Assets"):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon .. "奖券")
    self:GetWidgetByName("ED_Label_Details"):setString(self.Itemsdata.ItemDesc)
end



return ExchangeItemDetails.new()

