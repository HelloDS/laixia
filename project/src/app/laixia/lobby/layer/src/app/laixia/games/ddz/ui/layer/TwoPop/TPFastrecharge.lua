local TPFastrecharge = class("TPFastrecharge", import("...CBaseDialog"):new())
local soundConfig = laixiaddz.soundcfg;

local laixia = laixia;
local db2 = laixiaddz.JsonTxtData;
local itemDBM 

function TPFastrecharge:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPFastrecharge:getZorder()
   return  20 
end

function TPFastrecharge:getName()
    return "TPFastrecharge"
end

function TPFastrecharge:onInit()
    self.super:onInit(self)
    
    if(4 == Platform  or 5 == Platform ) then
        ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_INCREASEGOLD_WINDOW, handler(self, self.iosFun))
    else
        ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_INCREASEGOLD_WINDOW, handler(self, self.show))
	end

    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_INCREASEGOLD_WINDOW, handler(self, self.destroy))
end

function TPFastrecharge:iosFun()
   --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"金币不够浪了，请充值再战！")
   ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,{Text= "金币不够浪了，请充值再战！ " , OnCallFunc= self.shutDownFun })

end


function TPFastrecharge:updateCoinInfo(idx,mode)
    local itemInfo = nil 
    local buttonBuyWeChat= self:GetWidgetByName("Button_WX_Btn",mode) --微信
    local buttonBuyZhiFuBao= self:GetWidgetByName("Button_ZFB_Btn",mode) --支付宝
    if self.shopItems[idx] and self.shopItems[idx] ~= nil then
        itemInfo = self.shopItems[idx] 
        local itemId = itemInfo.itemsID 
        local showType = itemInfo.Type
        local item = itemDBM:query("ItemID",itemId); 
        local lablePriceMessage = self:GetWidgetByName("BitmapLabel_Num",buttonBuyZhiFuBao)
        local lablePriceWeChat = self:GetWidgetByName("BitmapLabel_Num",buttonBuyWeChat)
        local lableCoin = self:GetWidgetByName("BitmapLabel_Title",mode)
        lableCoin:setVisible(true)
        local Image_jinbi = self:GetWidgetByName("Image_icon",mode)
        Image_jinbi:loadTexture(item.ImagePath, 1)
        
        buttonBuyWeChat:setVisible(true) 
        buttonBuyWeChat.itemsID = itemInfo.itemsID
        buttonBuyWeChat.mType =1
        buttonBuyWeChat:addTouchEventListener( function(sender, eventType)
            self:buyCoin(sender, eventType)
        end )
        buttonBuyZhiFuBao:setVisible(true) 
        buttonBuyZhiFuBao.itemsID = itemInfo.itemsID 
        buttonBuyZhiFuBao.mType =2
        buttonBuyZhiFuBao:addTouchEventListener( function(sender, eventType)
            self:buyCoin(sender, eventType)
        end )

        lablePriceWeChat:setString(itemInfo.price .. "元")
        lablePriceMessage:setString(itemInfo.price .. "元")
  
        local coinNums = item.ItemName:gsub("金币",laixia.utilscfg.CoinType())
        lableCoin:setString(coinNums)
        if item.PresentItemID2 ~= nil then
            local giftID = item.PresentItemID2[1] 
            local giftInfo = itemDBM:query("ItemID",itemId);
            if giftID == 20001 then 
                self:GetWidgetByName("Label_Tips",mode):setVisible(true)
                local dayLength = item.Length[1]
                self:GetWidgetByName("Label_Tips",mode):setString("送" .. dayLength .. "天记牌器") 
            end
        else
            self:GetWidgetByName("Label_Tips",mode):setVisible(false)
        end
    else 

    end
end

function TPFastrecharge:showCoinInfo()
    self.shopItems = {}

    local goods = laixiaddz.JsonTxtData:queryTable("shop").buf
    for i,v in ipairs(goods) do
        if  v.isShow and v.isShow ~= 1  then 
            table.insert(self.shopItems,v)
        end
    end

    for i=1,#self.shopItems do 
        local mode = self.listView_Cell:clone()  
        self:updateCoinInfo(i,mode)
        self.listView:pushBackCustomItem(mode)
    end
end

function TPFastrecharge:buyCoin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local itemId = sender.itemsID
        laixiaddz.LocalPlayercfg.LaixiaIsShowPayWindow =  false
        laixiaddz.LocalPlayercfg.LaixiaPayType = sender.mType
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_ORDERINFO_WINDOW,{id=itemId})
    end
end

function TPFastrecharge:shutDownFun()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_INCREASEGOLD_WINDOW)
    local checkCoins = laixiaddz.JsonTxtData:queryTable("common"):query("key","limitMoney");
    if laixiaddz.LocalPlayercfg.LaixiaPlayerGold < checkCoins.Num then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEF_WINDOW)
    end
end

function TPFastrecharge:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.callFunc ~= nil then
            self.callFunc(true)
        else
           self:shutDownFun()
        end
    end
end

function TPFastrecharge:onDestroy()
    self.callFunc = nil
    laixiaddz.LocalPlayercfg.LaixiaIsShowPayWindow =  true
    laixiaddz.LocalPlayercfg.LaixiaPayType = 0
end


function TPFastrecharge:onShow(data)
   ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_SELFBUILDING_WINDOW) --关闭自建桌

    itemDBM = itemDBM or db2:queryTable("items");
    if data and data.data then
        self.callFunc = data.data.OnCallFunc
    end

    self:AddWidgetEventListenerFunction("Button_GameFastrecharge_Quit", handler(self, self.onShutDown))
    self.listView = self:GetWidgetByName("ListView_Item")
    self.listView_Cell = self:GetWidgetByName("Image_GameFastrecharge_Item")

    self:showCoinInfo()
end


return TPFastrecharge.new()


