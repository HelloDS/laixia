local TPFirstCharge = class("TPFirstCharge", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local laixia = laixia;
local db2 = laixiaddz.JsonTxtData;
local itemDBM  

function TPFirstCharge:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPFirstCharge:getName()
    return "TPFirstCharge"
end

function TPFirstCharge:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_FIRSTGIFT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SENDPACKET_FIRSTGIFT, handler(self, self.sendToSever))
end

function TPFirstCharge:sendToSever()
    local CSFirstSuperBag = Packet.new("CSFirstSuperBag", _LAIXIA_PACKET_CS_FirstSuperBagID)
    CSFirstSuperBag:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSFirstSuperBag:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSFirstSuperBag)
end


function TPFirstCharge:updateWindow(msg)
    itemDBM = db2:queryTable("items");
--    local data = msg.data 
--    self.mItemID = data.FirstSuperBag 
--    local isFirst = data.FirstBuy
    if device.platform == "android" then
        self.mItemID = 120018
    elseif device.platform == "ios" then
        if laixia.kconfig.isApple1 then
            self.mItemID = 1100018
        elseif laixia.kconfig.isApple2 then
            self.mItemID = 1200018
        else
            self.mItemID = 120018
        end
    else
        self.mItemID = 120018
    end

    local goods = laixiaddz.JsonTxtData:queryTable("items"):query("ItemID",self.mItemID)
    local price = goods.UmitPrice or 6
--    if goods.Type == 1 then 
--        self.mItemID = goods.itemsID
--        price = goods.price
--    else
--        self:destroy()
--        return 
--    end
    -- self:GetWidgetByName("BitmapLabel_Price"):setString("只需"..price.."元，即可获得")
    
    local Itemsdata = itemDBM:query("ItemID",self.mItemID)
    local coins = Itemsdata.ObtainItemCountList
    self:GetWidgetByName("BitmapLabel_IteamName"):setString(coins)
    self:GetWidgetByName("BitmapLabel_IteamName"):enableOutline(cc.c4b(65,0,0,255), 4)
    
    -- local extraItem = Itemsdata.PresentItemID2 
    -- local extraItemNum = Itemsdata.Length 
    -- self.extraDayNumber = 0 
    -- for i=1,#extraItem do  
    --     local itemId = extraItem[i] 
    --     local itemNum = extraItemNum[i] 
    --     if itemId == 20001 then 
    --         self.extraDayNumber = self.extraDayNumber + itemNum
    --     end 
    -- end 
    -- local mSongJPQ= self:GetWidgetByName("BitmapLabel_JPQ")
    -- mSongJPQ:setVisible(false)

    -- if self.extraDayNumber > 0 then 
    --      mSongJPQ:setVisible(true)
    --      mSongJPQ:setString(self.extraDayNumber)--("记牌器（"..self.extraDayNumber.."天）")
    -- end
    -- if isFirst < 0 then 
    --       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "订单处理中，请稍后再试！", OnCallFunc = function() self:destroy(); end })
    --     return  
    -- end

end


function TPFirstCharge:onShow(msg)
   laixiaddz.LocalPlayercfg.LaixiaIsSign = 0
   self.BG = self:GetWidgetByName("BG")
   self.BG:setTouchEnabled(true)
   self.BG:setTouchSwallowEnabled(true)
   
   self:AddWidgetEventListenerFunction("Button_GamePacksFirstrecharge_Quit", handler(self, self.onShutDown))
   self:AddWidgetEventListenerFunction("Button_Receive", handler(self, self.onShop))
   self:updateWindow(msg)
end

function TPFirstCharge:onShop(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if laixia.config.isAudit then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "暂时不能充值"})
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_ORDERINFO_WINDOW,{id=self.mItemID})
        end
        self:destroy()
    end
end


function TPFirstCharge:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end


return TPFirstCharge.new()


