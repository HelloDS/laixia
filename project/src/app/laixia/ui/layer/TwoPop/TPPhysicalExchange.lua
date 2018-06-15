
local TPPhysicalExchange = class("TPPhysicalExchange", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg    
local Packet = import("....net.Packet") 

function TPPhysicalExchange:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPPhysicalExchange:getName()
    return "TPPhysicalExchange"
end

function TPPhysicalExchange:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_REDEEMENTITY_WINDOW, handler(self, self.show))
end

function TPPhysicalExchange:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onClose()
    end
end

function TPPhysicalExchange:onClose()
    self:destroy()
end

function TPPhysicalExchange:SendPacketToServer(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then

        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       -- local player_name = self.player_name:getString()
        if self.sttr1 == "" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请输入手机号！")
            return
        end
        if self.sttr2 == "" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请输入收货人姓名！")
            return
        end
        -- local phone_number = self.phone_number:getString()
        -- local player_address = self.player_address:getString()
        if self.sttr3 == "" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请输入收货地址！")
            return
        end
        if self.data.page == "ExchangeWindow" then
            local exchange = Packet.new("ConversionCode", _LAIXIA_PACKET_CS_ExchangeID)
            exchange:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            exchange:setValue("GameID", laixia.config.GameAppID)
            exchange:setValue("ExchangeID", self.data.ID)
            exchange:setValue("ReceiveName", self.sttr2)
            exchange:setValue("Number", self.sttr1)
            exchange:setValue("Address", self.sttr3)
            exchange:setValue("ExchangePos",0)
            laixia.net.sendHttpPacket(exchange)
        elseif self.data.page == "MyBagWindow" then
            local uesPacket = Packet.new("uesPacket", _LAIXIA_PACKET_CS_UsePackPropID)
            uesPacket:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            uesPacket:setValue("GameID", laixia.config.GameAppID)
            uesPacket:setValue("ItemObjID", self.data.ObjID)
            uesPacket:setValue("ItemID", self.data.ID)
            uesPacket:setValue("ItemCount", 1)
            uesPacket:setValue("ReceiveName", self.sttr2)
            uesPacket:setValue("PhoneNumber", self.sttr1)
            uesPacket:setValue("Address", self.sttr3)
            laixia.net.sendHttpPacket(uesPacket)

            if self.data.isDisapear == 1 then
                self:sendToMyBagPacket()
            end
        end
        self:onClose()
    end
end

function TPPhysicalExchange:onShow(mesg)
   
    function editboxHandle1(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.sttr1 = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.sttr1 = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.sttr1 = sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    function editboxHandle2(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.sttr2 = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.sttr2 = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.sttr2= sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    function editboxHandle3(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.sttr3 = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.sttr3 = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.sttr3 = sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    self.labelNewName1 = ccui.EditBox:create(cc.size(345,42),"new_ui/PersonalCenterWindow/tiao1.png")
    --self.labelNewName1:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.sttr1 = ""
    self.labelNewName1:setFontSize(24)
    self.labelNewName1:setAnchorPoint(0,0)  
    self.labelNewName1:setPosition(7,8)   
    self.labelNewName1:setMaxLength(11)                             --设置输入最大长度为6  
    self.labelNewName1:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName1:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName1:setPlaceHolder("请输入手机号！")               --设置预制提示文本
    self.labelNewName1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName1:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle1(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self:GetWidgetByName("Image_15"):addChild(self.labelNewName1)

    self.labelNewName2 = ccui.EditBox:create(cc.size(345,42),"new_ui/PersonalCenterWindow/tiao1.png")
    --self.labelNewName2:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.sttr2 = ""
    self.labelNewName2:setFontSize(24)
    self.labelNewName2:setAnchorPoint(0,0)  
    self.labelNewName2:setPosition(7,8) 
    --self.labelNewName2:setMaxLength(50)                             --设置输入最大长度为6  
    self.labelNewName2:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName2:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName2:setPlaceHolder("请输入收货人姓名！")               --设置预制提示文本
    self.labelNewName2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName2:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle2(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self:GetWidgetByName("Image_16"):addChild(self.labelNewName2)

    self.labelNewName3 = ccui.EditBox:create(cc.size(490,42),"new_ui/PersonalCenterWindow/tiao1.png")
    --self.labelNewName3:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.sttr3 = ""
    self.labelNewName3:setFontSize(24)
    self.labelNewName3:setAnchorPoint(0,0)  
    self.labelNewName3:setPosition(7,8) 
    --self.labelNewName3:setMaxLength(50)                             --设置输入最大长度为6  
    self.labelNewName3:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName3:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName3:setPlaceHolder("请输入收货地址！")               --设置预制提示文本
    self.labelNewName3:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName3:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle3(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self:GetWidgetByName("Image_17"):addChild(self.labelNewName3)

    self:AddWidgetEventListenerFunction("PE_Button_Close", handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("PE_Button_Submit", handler(self, self.SendPacketToServer))
    self:AddWidgetEventListenerFunction("PE_Button_Cancel", handler(self, self.onShutDown))

    -- self.player_name = self:GetWidgetByName("PE_Input_PhoneNum")
    -- self.phone_number = self:GetWidgetByName("PE_Input_NewPassWord")
    -- self.player_address = self:GetWidgetByName("PE_Input_Verification")
    self.data = mesg.data
end

function TPPhysicalExchange:sendToMyBagPacket()
    local CSPackItems = Packet.new("CSPackItems", _LAIXIA_PACKET_CS_PackItemsID)
    CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end


return TPPhysicalExchange.new()

