
local DailyLoginWindow = class("DailyLoginWindow", import("...CBaseDialog"):new())
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 

local laixia = laixia;

local EffectDict =  laixia.EffectDict; 
local EffectAni = laixia.EffectAni; 
local db2 = laixia.JsonTxtData;
local itemMesg

function DailyLoginWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end
function DailyLoginWindow:getName()
    return "DailyLoginWindow"
end

function DailyLoginWindow:onInit()
    self.super:onInit(self)

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_DAILYSIGN_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_DAILYSIGN_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SIGNIN_DAILYSIGN_WINDOW, handler(self, self.onShowSign))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_QUICKBAG_WINDOW, handler(self, self.sendSuperBagPacket))
end


function DailyLoginWindow:sendSuperBagPacket()
    local CSQuickSuperBag = Packet.new("CSQuickSuperBag", _LAIXIA_PACKET_CS_QuickSuperBagID)
    CSQuickSuperBag:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSQuickSuperBag:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSQuickSuperBag)  
end

function DailyLoginWindow:alreadyReceived(dayBase)
    self:GetWidgetByName("Image_Received_Icon",dayBase):setVisible(true)
--    self:GetWidgetByName("Image_Received_Mengban",dayBase):setVisible(true)
end

function DailyLoginWindow:onShowUI(dataArray ,TypeInfo)
    local count = 0
   for i, v in ipairs(dataArray) do
        count = count + 1
        local path = "new_ui/everydaylogin/day"..count..".png"
        local node_Name = "Image_Everyday_0" .. i 
        local node_Day = self:GetWidgetByName(node_Name)
        node_Day:setTouchEnabled(true)
        node_Day:addTouchEventListener(handler(self, self.sendSignToSever)) --添加触摸效果
        local mLabelMoney = self:GetWidgetByName("BitmapLabel_Money_Num",node_Day)
        local itemInfo = v.RewardArray[1]

        mLabelMoney:setString("X"..itemInfo.ItemCount)
        mLabelMoney:enableOutline(cc.c4b(51,1,28,255), 1);


        local Itemsdata = itemMesg:query("ItemID",itemInfo.ItemID)
        self.itemImage = Itemsdata.ImagePath
        self.icon =  self:GetWidgetByName("Image_Money_Icon",node_Day)
        self.icon:setVisible(true)
        
        if self.itemImage ~= nil then 
            self.icon:loadTexture(path)
        end
        self:GetWidgetByName("Image_Everyday_light",node_Day):setVisible(false)

        -------签到
        if i < laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay then 
            self:alreadyReceived(node_Day)
        else
            self.ReceiveIcon = self:GetWidgetByName("Image_Received_Icon",node_Day) 
            self.ReceiveIcon:setVisible(false)
        end 
        if i == laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay then 
            if  laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1 then   --签过了
                self.ReceiveIcon = self:GetWidgetByName("Image_Received_Icon",node_Day) 
                self.ReceiveIcon:setVisible(true)
                laixia.LocalPlayercfg.LaixiaIsSign = 0
            else 
                self.ImgLight = self:GetWidgetByName("Image_Everyday_light",node_Day)
                self.ImgLight:setVisible(true)
                -- local system = laixia.ani.CocosAnimManager
                -- local node = system:playAnimationAt(self.LoginPanel,"doudizhu_gold_a")
                -- node:setPositionX(display.cx)
                -- node:setPositionY(self:GetWidgetByName("denglu_diban"):getContentSize().height-300)

                -- local mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_COMMON_LIGHT)
                -- mbttonAnimation:addTo(node_Day ,4)
                -- mbttonAnimation:setPosition(cc.p(-50,-70))

                self.Today  = node_Day

--                self.ReceiveMenban = self:GetWidgetByName("Image_Received_Mengban",node_Day)
                self.ReceiveIcon = self:GetWidgetByName("Image_Received_Icon",node_Day) 
                self.ReceiveIcon:setVisible(false)
            end
        end 
--        --if  sign == true then 
--            --self:alreadyReceived(node_Day)
--        --end 
--        local sign = false 
--        if i == laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay then 
--            if  laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1 then   
--                sign = true 
--            else 
--                self.ImgLight = self:GetWidgetByName("Image_Everyday_light",node_Day)
--                self.ImgLight:setVisible(true)
--                local mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_COMMON_LIGHT)
--                mbttonAnimation:addTo(node_Day ,4)
--                mbttonAnimation:setPosition(cc.p(-50,-70))
--
--                self.Today  = node_Day
--
----                self.ReceiveMenban = self:GetWidgetByName("Image_Received_Mengban",node_Day)
--                self.ReceiveIcon = self:GetWidgetByName("Image_Received_Icon",node_Day) 
--            end
--        end 
--        if  sign == true then 
--            self:alreadyReceived(node_Day)
--        end 
--        if i < laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay then 
--            --if TypeInfo == 0 then  
--            self:alreadyReceived(node_Day)
--            --end
--        end 
    end
end


function DailyLoginWindow:onShow()
    self.BG = self:GetWidgetByName("denglu_diban")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    
    self:AddWidgetEventListenerFunction("Button_close", handler(self, self.onShutDown))
    self.mBTshutDown = self:GetWidgetByName("Button_close")
--    self.mBTshutDown :setVisible(false)

    self:AddWidgetEventListenerFunction("Button_Receive", handler(self, self.sendSignToSever))
    self.mBTreceive = self:GetWidgetByName("Button_Receive")
    --self:GetWidgetByName("Label_Describe"):setVisible(true)

    itemMesg = db2:queryTable("items");
    
   self:onShowUI(laixia.LocalPlayercfg.LaixiaContinuousLoginData.Shows , laixia.LocalPlayercfg.LaixiaContinuousLoginData.TypeSign)

--    self.mBTreceive:show():setEnabled(true);        

    if laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1  then 
        self.mBTshutDown:setVisible(true)
        self.mBTreceive:setVisible(true)
        self.mBTreceive:setBright(false)
--        self.mBTreceive:setEnabled(false)
    end

end


function DailyLoginWindow:onShutDown(sender, event)
    if (event == ccui.TouchEventType.began) then
    end
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy(); 
    end  
end

function DailyLoginWindow:sendSignToSever(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1 then
            return
        end
        self.mBTreceive:setEnabled(false)
        self.mBTreceive:setBright(false)  
        self.mBTshutDown:setVisible(false)

        local stream = Packet.new("SignPacket", _LAIXIA_PACKET_CS_SignID)
        stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(stream)
    end 
end


function DailyLoginWindow:onShowSign(data)
    if (not self.mIsLoad ) then
        if laixia.LocalPlayercfg.LaixiaShowActivyWindow == 1 then 
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW)
        end
        return
    end
    if self.Today ~= nil then 
        -- 签到获取金币的动画
         local iconpath = "new_ui/everydaylogin/day"..tonumber(laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay)..".png"
         local jinbiNum
         for i, v in ipairs(data.data.Items) do
            if v.ItemID == 1001 then
                jinbiNum = v.ItemCount
            end      
        end
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_EFFECTGOLD_WINDOW,{iconpath=iconpath,jinbiNum=jinbiNum})
--        self.ReceiveMenban:setVisible(true)


        local node_Name = "Image_Everyday_0" .. (laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay)
        local node_Day = self:GetWidgetByName(node_Name)
        local node_Day = self:GetWidgetByName("Image_Received_Icon",node_Day) 
        node_Day:setVisible(true)
        node_Day:setScale(2) 
        local action = cc.ScaleTo:create(0.1,1)
        local funAction = cc.CallFunc:create(function()
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_DAILYSIGN_WINDOW)  
        end)
        self.mBTreceive:setBright(false)
        node_Day:runAction(
            cc.Sequence:create(
                action,
                cc.DelayTime:create(0.75),
                funAction
            )
        )
    end 
end


function DailyLoginWindow:onDestroy()
    if laixia.LocalPlayercfg.LaixiaIsSign == 1 then 
       -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW)
        local CSPackItems = Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
        CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        CSPackItems:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(CSPackItems)
    end
end
return DailyLoginWindow.new()
