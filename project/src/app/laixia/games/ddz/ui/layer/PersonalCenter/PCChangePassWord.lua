
local PCChangePassWord = class("PCChangePassWord", import("...CBaseDialog"):new()) 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 


function PCChangePassWord:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function PCChangePassWord:getName()
    return "PCChangePassWord"
end

function PCChangePassWord:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_REVISEPASSWD_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_REVISEPASSWD_WINDOW, handler(self, self.destroy))
end

--提交
function PCChangePassWord:onSendToSever(sender,event)
    if event == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if self.Old_PassWord:getString() == ""  then
           ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请输入当前密码！")
           return
        end
        local NewPw_1 = self.New_Password_1:getString()
        local NewPw_2 = self.New_Password_2:getString()

        local flag1 = laixia.UItools.stringMathPattern(NewPw_1)
        local flag2 = laixia.UItools.stringMathPattern(NewPw_2)

        if  flag1 == false or  string.len(NewPw_2)<6 or string.len(NewPw_2)>18  then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "密码无效，请输入6~18位数字、字母或下划线组合")
            return
        end
        if NewPw_2 == "" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"请再次输入密码")
            return
        end
        if NewPw_2 ~= NewPw_1 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,"两次密码不一致")
            return
        end

        local CSRevisePwd = Packet.new("CSRevisePwd",_LAIXIA_PACKET_CS_RevisePwdID)
        CSRevisePwd:setValue("Code",laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        CSRevisePwd:setValue("OldPassword",self.Old_PassWord:getString())
        CSRevisePwd:setValue("NewPassword",self.New_Password_2:getString())
        laixiaddz.LocalPlayercfg.LaixiaPasswordTMP = self.New_Password_2:getString();
        laixia.net.sendHttpPacket(CSRevisePwd)
    end
end 



function PCChangePassWord:onShow()

    self.Old_PassWord = self:GetWidgetByName("Revise_Input_OldPassWord")   
    self.New_Password_1 = self:GetWidgetByName("Revise_Input_NewPassWord")   
    self.New_Password_2 = self:GetWidgetByName("Revise_Input_NewPassWordAgain") 

    self:AddWidgetEventListenerFunction("Revise_Button_Submit", handler(self, self.onSendToSever))    
    self:AddWidgetEventListenerFunction("Revise_Button_Close", handler(self, self.onShutDown))
end


function PCChangePassWord:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_REVISEPASSWD_WINDOW)
    end
end


return PCChangePassWord.new()


