local TPWeekCard = class("TPWeekCard", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg


function TPWeekCard:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPWeekCard:getZorder()
   return  0 
end

function TPWeekCard:getName()
    return "TPLibao"
end

function TPWeekCard:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_WEEKCARD_WINDOW, handler(self, self.show))
end


function TPWeekCard:onShow(msg)
    self.BG = self:GetWidgetByName("diban")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    
    self:AddWidgetEventListenerFunction("Button_ShutDown", handler(self,self.onShutDown))  --关闭
    self:AddWidgetEventListenerFunction("Button_GotoShop", handler(self,self.onGoShop))  --购买
     
    self.mListView = self:GetWidgetByName("ListView_Item")
    self.mListView:setItemsMargin(10);
    self.mCell  = self:GetWidgetByName("Image_Cell")
    self.ItemID = msg.data.id 
    self:addItems(self.ItemID)

end

function TPWeekCard:addItems(id)
     local itemData = laixia.JsonTxtData:queryTable("items")
     local itemmsg = itemData:query("ItemID",id);

     --self:GetWidgetByName("Label_LibaoTitle"):setString(itemmsg.PropDesc)
     --local itemArray = itemmsg.PresentItemID2
     --local itemArray = itemmsg.ObtainItemIDList
     local itemArray = string.split(itemmsg.ObtainItemIDList,"|")
     local itemCount = string.split(itemmsg.ObtainItemCountList,"|")
     
     --local itemCount = itemmsg.Length 
     
     
     for i= 1,#itemArray do
        local cell = self.mCell:clone()
        self.mListView:pushBackCustomItem(cell)
        local cellMesg = itemData:query("ItemID",tonumber(itemArray[i]))
        self:GetWidgetByName("Label_ItemName",cell):setString(cellMesg.ItemName)
        self:GetWidgetByName("Label_ItemNum",cell):setString(itemCount[i])

        local baoming_Array = string.split(cellMesg.ImagePath ,'/')
        if #baoming_Array >1 then
            local sprite = display.newSprite(cellMesg.ImagePath)
            --sprite:setScale(0.6)  
            sprite:setAnchorPoint(cc.p(0.5,0.5))
            sprite:setPosition(cc.p(23,25))
            sprite:addTo(self:GetWidgetByName("Image_ItemIcon",cell))
           
        else
            self:GetWidgetByName("Image_ItemIcon",cell):removeAllChildren()
            --ImagePath字段 道具大icon############
            self:GetWidgetByName("Image_ItemIcon",cell):loadTexture(cellMesg.ImagePath, 1)
            --imageCoinIcon:setScale(0.8)            
        end
         
     end
end


function TPWeekCard:onGoShop(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_ORDERINFO_WINDOW,{id=self.ItemID})
    end
end

function TPWeekCard:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

function TPWeekCard:onCallBackFunction()
    self:destroy()
end

return TPWeekCard.new()


