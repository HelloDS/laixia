
local TPRetrievePassWord = class("TPRetrievePassWord", import("...CBaseDialog"):new())-- 
local schedulerPhone = require(cc.PACKAGE_NAME .. ".scheduler")
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local PHONECODE_TIME = 60;
local remainTime = PHONECODE_TIME;
local nowTime = PHONECODE_TIME 

function TPRetrievePassWord:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPRetrievePassWord:getName()
    return "zhaohuimima"
end

function TPRetrievePassWord:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_FINDPWD_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_FINDPWD_WINDOW, handler(self, self.destroy))
end

function TPRetrievePassWord:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
       laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_FINDPWD_WINDOW)
    end
end

function TPRetrievePassWord:onTick(dt)
 if self.mIsLoad == true then
        if laixiaddz.LocalPlayercfg.LaixiaMatchVerification then
            self.sendover:setVisible(true)
            self:GetWidgetByName("Label_TimeOver",self.sendover):setVisible(true)
            self:GetWidgetByName("PW_GetBack_Button_GetCode"):setVisible(false)

            if (nowTime-(math.round(remainTime))>=1 ) then
                self.LabelSend=self:GetWidgetByName("Label_TimeOver")
                self.LabelSend:setString(math.round( remainTime) .. "秒后重新获取")
                nowTime = remainTime
            end

            remainTime = remainTime - dt
            if (remainTime <= 0) then
                self.sendover:setVisible(false)
                self:GetWidgetByName("PW_GetBack_Button_GetCode"):setVisible(true)
               
                laixiaddz.LocalPlayercfg.LaixiaMatchVerification = false
                remainTime = PHONECODE_TIME -1
                nowTime = PHONECODE_TIME
            end
        end
    end
end

function TPRetrievePassWord:sendFindPswPacket(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
         if string.len(self.phonenumber:getString()) < 11 or tonumber(self.phonenumber:getString()) == nil then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入11位手机号")
            return
        end
        if string.len(self.verification:getString())  < 4 then
           ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入4位验证码！")
            return
        end
      
        local CSFindPwd = Packet.new("CSCodeBinding",_LAIXIA_PACKET_CS_FindPwdID)      
        CSFindPwd:setValue("Rdf",laixiaddz.LocalPlayercfg.LaixiaHttpCode) 
        CSFindPwd:setValue("GameID",laixia.config.GameAppID)
        CSFindPwd:setValue("Number",self.phonenumber:getString())
        CSFindPwd:setValue("Code",self.verification:getString())
        laixia.dump(CSFindPwd)
        laixia.net.sendHttpPacket(CSFindPwd)
    end
end

function TPRetrievePassWord:sendVerificationPacket(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print("this is sendVerificationPacket")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
       if string.len(self.phonenumber:getString()) < 11 or tonumber(self.phonenumber:getString()) == nil then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入11位手机号")
            return
        end

        local CSCodeBinding = Packet.new("CSCodeBinding",_LAIXIA_PACKET_CSCodeBindingID)      
        CSCodeBinding:setValue("Code",laixiaddz.LocalPlayercfg.LaixiaHttpCode) 
        CSCodeBinding:setValue("GameID",laixia.config.GameAppID)
        CSCodeBinding:setValue("PhoneNum",self.phonenumber:getString())
        dumpGameData(CSCodeBinding)
        laixia.net.sendHttpPacketAndWaiting(CSCodeBinding,nil,1)
    end

end

function TPRetrievePassWord:onShow()
    self.phonenumber = self:GetWidgetByName("PW_GetBack_Input_PhoneNum")
    self.verification = self:GetWidgetByName("PW_GetBack_Input_Verification")
    self.sendover = self:GetWidgetByName("Image_SendOver")
    self.sendover:setVisible(false)
    self:AddWidgetEventListenerFunction("PW_GetBack_Button_GetCode", handler(self, self.sendVerificationPacket))
    self:AddWidgetEventListenerFunction("PW_GetBack_Button_Submit", handler(self, self.sendFindPswPacket))
    self:AddWidgetEventListenerFunction("PW_GetBack_Button_Close", handler(self, self.onShutDown))

    remainTime = PHONECODE_TIME-1;
    nowTime =PHONECODE_TIME
end
 
function TPRetrievePassWord:onDestroy()
    laixiaddz.LocalPlayercfg.LaixiaMatchVerification = false
end


return TPRetrievePassWord.new()



