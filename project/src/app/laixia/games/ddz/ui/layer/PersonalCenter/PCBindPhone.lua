
local PCBindPhone = class("PCBindPhone", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local PHONECODE_TIME = 60;
local remainTime = PHONECODE_TIME;
local nowTime = PHONECODE_TIME
function PCBindPhone:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function PCBindPhone:getName()
    return "BindPhone"
end

function PCBindPhone:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BINDPHONE_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_BINDPHONE_WINDOW, handler(self, self.destroy))
end

function PCBindPhone:onShow()
    self.BG = self:GetWidgetByName("Image_2")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    
    self:AddWidgetEventListenerFunction("PhoneBind_Button_GetCode",handler(self,self.getPhoneCode))
    self:AddWidgetEventListenerFunction("PhoneBind_Button_Submit",handler(self,self.sendBindPacket))
    self:AddWidgetEventListenerFunction("PhoneBind_Button_Close", handler(self, self.onShutDown))

    self.Btn_GetCode=self:GetWidgetByName("PhoneBind_Button_GetCode")
    self.Btn_GetCode:setEnabled(true)
    remainTime = PHONECODE_TIME-1;

    self.Btn_GetOver=self:GetWidgetByName("Image_SendVerification_Over")
    self.Btn_GetOver:setVisible(false)

    self:GetWidgetByName("Image_3"):setVisible(false)
    self:GetWidgetByName("Image_3_Copy"):setVisible(false)
    self.PhoneNumber1=self:GetWidgetByName("PhoneBind_Input_PhoneNum")
    self.PhoneNumber1:setVisible(false)

    self.PhoneNumber = ccui.EditBox:create(cc.size(420,50),"new_ui/PersonalCenterWindow/shurukuang1.png")
    self.PhoneNumber:setPosition(348,132)
    self.PhoneNumber:setPlaceHolder("请输入手机号码:")
    self.PhoneNumber:setFontSize(24)
    self.PhoneNumber:setFontColor(cc.c3b(69,63,56))
    self.PhoneNumber:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.PhoneNumber:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    local function editboxHandle( strEventName,sender ) 
        if strEventName == "began" then
        elseif strEventName == "ended" then
        elseif strEventName == "return" then
            sender:setText(sender:getText())
        elseif strEventName == "changed" then
            local test = 1
        end
    end
    self.PhoneNumber:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self:GetWidgetByName("Image_7"):addChild(self.PhoneNumber)
    
    -- self.NewPassword=self:GetWidgetByName("PhoneBind_Input_NewPassWord")
    self.PhoneCode1=self:GetWidgetByName("PhoneBind_Input_Verification")
    self.PhoneCode1:setVisible(false)
    
    self.PhoneCode = ccui.EditBox:create(cc.size(200,50),"new_ui/PersonalCenterWindow/shurukuang2.png")
    self.PhoneCode:setPosition(239,60)
    self.PhoneCode:setFontSize(24)
    self.PhoneCode:setFontColor(cc.c3b(69,63,56))
    self.PhoneCode:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
    self.PhoneCode:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    local function editboxHandle1( strEventName,sender ) 
        if strEventName == "began" then
        elseif strEventName == "ended" then
        elseif strEventName == "return" then 
            sender:setText(sender:getText())
        elseif strEventName == "changed" then
            local test = 1
        end
    end
    self.PhoneCode:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle1(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self:GetWidgetByName("Image_7"):addChild(self.PhoneCode)
end

function PCBindPhone:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_BINDPHONE_WINDOW)
    end
end

function PCBindPhone:sendBindPacket(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local phonenumber  =self.PhoneNumber :getText()
        -- local password =self.NewPassword:getString()
        local code = self.PhoneCode:getText()
        -- local flag = laixia.UItools.stringMathPattern(password)
        if string.len(phonenumber) < 11  or tonumber(phonenumber) ==nil then           
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入11位手机号")
            return
        end
        -- if flag == false or  string.len(password)<6 or string.len(password)>18 then 
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "密码无效，请输入6~18位数字、字母或下划线组合")
        --     return
        -- end 
        if string.len(code)  < 6 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入6位验证码")
            return
        end
        -- self:GetWidgetByName("PhoneBind_Button_Submit"):setTouchEnabled(false)
        local CSBindingPhone = Packet.new("CSBindingPhone",_LAIXIA_PACKET_CS_BoundPhoneID)      
        CSBindingPhone:setValue("Code",laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        CSBindingPhone:setValue("GameID",laixia.config.GameAppID)
        CSBindingPhone:setValue("PhoneCode",self.PhoneCode:getText())
        CSBindingPhone:setValue("Account",self.PhoneNumber:getText())
        CSBindingPhone:setValue("Passwd","")
        laixiaddz.LocalPlayercfg.LaixiaPhoneNumTMP = self.PhoneNumber:getText()
        laixiaddz.LocalPlayercfg.LaixiaPasswordTMP = ""
        laixia.net.sendHttpPacket(CSBindingPhone)
    end
end

function PCBindPhone:onTick(dt)
    if self.mIsLoad == true then
        if laixiaddz.LocalPlayercfg.LaixiaMatchVerification then
            self.Btn_GetOver:setVisible(true)
            self.Btn_GetCode:setVisible(false)
            if (nowTime-(math.round(remainTime))>=1 ) then
                self.LabelSend = self:GetWidgetByName("Label_Time_Over")
                self.LabelSend:setVisible(true)
                self.LabelSend:setString(math.round(remainTime) .. "秒后重新获取")
                nowTime = remainTime
            end

            remainTime = remainTime - dt
            if (remainTime <= 0) then

                self.Btn_GetOver:setVisible(false)
                self.Btn_GetCode:setVisible(true)
                self.LabelSend:setVisible(false)

                laixiaddz.LocalPlayercfg.LaixiaMatchVerification = false
                remainTime = PHONECODE_TIME -1
                nowTime = PHONECODE_TIME
            end
        end
    end
end

function PCBindPhone:getPhoneCode(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       
       local phonenumber  =self.PhoneNumber :getText()
       if string.len(phonenumber) < 11  or tonumber(phonenumber) ==nil then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入11位手机号")
            return
        end

        local CSCodeBinding = Packet.new("CSCodeBinding",_LAIXIA_PACKET_CSCodeBindingID)      
        CSCodeBinding:setValue("Code",laixiaddz.LocalPlayercfg.LaixiaHttpCode) 
        CSCodeBinding:setValue("GameID",laixia.config.GameAppID)
        CSCodeBinding:setValue("PhoneNum",self.PhoneNumber:getText())
        laixia.net.sendHttpPacketAndWaiting(CSCodeBinding,nil,1); 
    end
end


function PCBindPhone:onDestroy()
    --laixiaddz.LocalPlayercfg.LaixiaMatchVerification = false
end

return PCBindPhone.new()


