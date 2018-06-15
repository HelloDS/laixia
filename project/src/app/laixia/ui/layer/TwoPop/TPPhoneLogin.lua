
local TPPhoneLogin = class("TPPhoneLogin", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg    
local Packet = import("....net.Packet") 


function TPPhoneLogin:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPPhoneLogin:getName()
    return "PhoneLogin"
end

function TPPhoneLogin:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_PHONELOGIN_WINDOW, handler(self, self.show))
end


function TPPhoneLogin:onLogin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        local phonenumber = self.phonenumber:getString()
        local password = self.password:getString()
        
        if string.len(phonenumber) < 11 or tonumber(phonenumber) == nil then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请输入11位手机号")
            return
        end
        if  string.len(password)<6 then 
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "请输入6位位数密码")
            return
        end 

        local versionName =   getAppVersion()
        local channelId  =  laixia.LocalPlayercfg:getumengChannelID()
        local mobileInfo =  laixia.LocalPlayercfg:getMobileInfo()
        local account =  self.phonenumber:getString()


        local stream = Packet.new("CS_Login", _LAIXIA_PACKET_CS_Login_ID)
        stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
		stream:setValue("GameType",laixia.config.GameType);
        stream:setValue("GameVersion", "0")

        stream:setValue("VersionName",versionName)
        stream:setValue("ChannelID",channelId )
        stream:setValue("Devices",mobileInfo ) 
        stream:setValue("PlatformID", 2)
        stream:setValue("Account", account)  -- 游客Mac号码         

        stream:setValue("UnionID","")
        stream:setValue("Passwd", self.password:getString())
        stream:setValue("IMEI",laixia.LocalPlayercfg:getIMEI());
        stream:setValue("Token",laixia.LocalPlayercfg.LaixiaTokenID)

        local str  = "versionName="..versionName.."&channelId="..channelId.."&mobileInfo="..mobileInfo.."&platform="..2 .."&account="..account
        local md5msg = crypto.md5(  str )
      --"versionName=1.0.0&channelId=0&mobileInfo=huawei-6p&platform=1&account=00-01-6C-D6-01-F6"
        stream:setValue("Md5msg",md5msg)
        
        laixia.net.sendHttpPacket(stream)

        laixia.LocalPlayercfg.LaixiaPhoneNum = self.phonenumber:getString()
        laixia.LocalPlayercfg.LaixiaPassword = self.password:getString()
        self:onclose()
    end
end

function TPPhoneLogin:forgetPassWord(sender, eventType)
    -- 找回密码
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FINDPWD_WINDOW)
    end

end

function TPPhoneLogin:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onclose()
    end
end

function TPPhoneLogin:onclose()
    cc.UserDefault:getInstance():setStringForKey("phone_number", self.phonenumber:getString())
    cc.UserDefault:getInstance():setStringForKey("password", self.password:getString())
    self:destroy()
end


function TPPhoneLogin:onShow()
    self:AddWidgetEventListenerFunction("PhoneLogin_Button_Submit", handler(self, self.onLogin))    
    self:AddWidgetEventListenerFunction("PhoneLogin_Button_Close", handler(self, self.onShutDown))  
    self:AddWidgetEventListenerFunction("PhoneLogin_Button_Forget", handler(self, self.forgetPassWord))
    self.phonenumber = self:GetWidgetByName("PhoneLogin_Input_PhoneNum") 
    self.password = self:GetWidgetByName("PhoneLogin_Input_NewPassWord")  
end


return TPPhoneLogin.new()


