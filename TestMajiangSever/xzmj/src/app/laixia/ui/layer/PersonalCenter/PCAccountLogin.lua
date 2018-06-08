-- 账号登陆窗口
local PCAccountLogin = class("PCAccountLogin", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;
local Packet = import("....net.Packet")  
local is_weChat = false

function PCAccountLogin:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function PCAccountLogin:getName()
    return "PCAccountLogin"
end

function PCAccountLogin:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_ACCOUNTLOGIN_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SENDLOGINPACKET_TOSEVER, handler(self, self.loginToSever))
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local function luaWeiBofun(param)
    if nil == param then
        return
    end
     print("in luafun uid =  "..laixia.LocalPlayercfg.LaixiaUserID)
     local json = json or require("framework.json");
     local array = json.decode(param);  
     laixia.LocalPlayercfg.LaixiaUserID = array.uid
     laixia.LocalPlayercfg.LaixiaTokenID = array.token

     cc.UserDefault:getInstance():setStringForKey("uid", array.uid)
     cc.UserDefault:getInstance():setStringForKey("token", array.token)
     
     cc.UserDefault:getInstance():setBoolForKey("isauto", true)
     cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 4)
     laixia.LocalPlayercfg:WriteData()
     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDLOGINPACKET_TOSEVER)
end

-- 微信 回调方法
--添加了一个字段，unionid用于处理ar
local newUnionID =""
local function luaWeChatfun(param)

    if nil == param then
       return
    end
    local array = {}
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
    local json = json or require("framework.json");
      array = json.decode(param);
    elseif(cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform) then
     array = param
    end

    if array.unionid then
       cc.UserDefault:getInstance():setStringForKey("unionid",  array.unionid)
       newUnionID =  array.unionid
    end

     laixia.LocalPlayercfg.LaixiaUserID = array.uid
     laixia.LocalPlayercfg.LaixiaTokenID = array.token

     cc.UserDefault:getInstance():setStringForKey("uid", array.uid)
     cc.UserDefault:getInstance():setStringForKey("token", array.token)
     cc.UserDefault:getInstance():setBoolForKey("isauto", true)
     cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 5)
     laixia.LocalPlayercfg:WriteData()
     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDLOGINPACKET_TOSEVER)
end

--lua函数注册给微博调用
local function  funToWeiBoJava()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local className = APP_PACKAGE_NAME.."weibo/AuthListener"
        local args={ luaWeiBofun }
        local sigs = "(I)V"
        local payState = luaj.callStaticMethod(className,"authSetLuaFun",args,sigs)

    end 
end
--lua函数注册给微信调用
local function funToWeChatJava()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local className = APP_PACKAGE_NAME.."wxapi/WXEntryActivity"
        local args={ luaWeChatfun }
        local sigs = "(I)V"
        local payState = luaj.callStaticMethod(className,"wxSetLuaFun",args,sigs)
    end 
end


function PCAccountLogin:onShow()

    self:AddWidgetEventListenerFunction("Account_Button_Mobile",handler(self,self.phoneLogin))--手机登陆
    self:AddWidgetEventListenerFunction("Account_Button_weixin",handler(self,self.weChatLogin))--微信登录
    self:AddWidgetEventListenerFunction("Account_Button_weibo",handler(self,self.weiBoLogin))--微博登录
    self:AddWidgetEventListenerFunction("Account_Button_Close", handler(self, self.shutDown))--关闭按钮
    self.mAccount =""
    self.GamePlatformID = cc.UserDefault:getInstance():getIntegerForKey("GamePlatformID")
    self:getAccount()
end

--获取账号
function PCAccountLogin:getAccount()
        local rcValue = "";
	  
	    if device.platform == "android" then
	        local luaj = require "cocos.cocos2d.luaj"
	        local javaClassName = APP_ACTIVITY
	        local javaMethodName = "jni_GetDeviceID"
	        local javaParams = { }
	        local javaMethodSig = "()Ljava/lang/String;"
	        local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	        rcValue = value 
	    else 
	        rcValue = device.getOpenUDID(); 
	    end
        self.mAccount = rcValue
end
--微信登录
function PCAccountLogin:weChatLogin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        local GamePlatformID = cc.UserDefault:getInstance():getIntegerForKey("GamePlatformID")
        if  GamePlatformID == 5  then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "已经是微信登录")
                self:onclose()
            return
        end
       
       funToWeChatJava()
       
       if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
            local luaj = require "cocos.cocos2d.luaj"
            local className = APP_ACTIVITY
            local args={}
            local sigs = "()V"
            local payState = luaj.callStaticMethod(className,"wxLogin",args,sigs)
            if payState  then
                print("shouquan success")
                self.GamePlatformID = 5
            else
                print("shouquan error")
                cc.UserDefault:getInstance():setBoolForKey("isauto", false)
            end
        elseif(cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform) then
            local arg = {callBack = luaWeChatfun}
            result, value1 = luaoc.callStaticMethod("WXinShareManager", "wxLogin", arg)
            self.GamePlatformID = 5
        end
    end
end
--微博登录
function PCAccountLogin:weiBoLogin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local GamePlatformID = cc.UserDefault:getInstance():getIntegerForKey("GamePlatformID")
        if  GamePlatformID == 4  then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "已经是微博登录")
                self:onclose()
            return
        end
        
        funToWeiBoJava()
        
       if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
            local luaj = require "cocos.cocos2d.luaj"
            local className = APP_ACTIVITY
            local args={}
            local sigs = "()V"
            local payState = luaj.callStaticMethod(className,"authorize",args,sigs)
            if payState then
                print("shouquan success")
                self.GamePlatformID = 4                
            else
                print("shouquan error")
                cc.UserDefault:getInstance():setBoolForKey("isauto", false)
            end
        end 

    end
end

function PCAccountLogin:loginToSever()
        
        local versionName =   getAppVersion()
        local channelId  =  laixia.LocalPlayercfg:getumengChannelID()
        local mobileInfo =  laixia.LocalPlayercfg:getMobileInfo()
        local account = laixia.LocalPlayercfg.LaixiaUserID
        local unionid = newUnionID
        if unionid == "" then
           unionid = cc.UserDefault:getInstance():getStringForKey("unionid") 
        end

        local stream = Packet.new("CS_Login", _LAIXIA_PACKET_CS_Login_ID)
        stream:setValue("Code", 0)  -- 默认
        stream:setValue("GameID", laixia.config.GameAppID) --
		    stream:setValue("GameType",laixia.config.GameType);
        stream:setValue("GameVersion", "0")

        stream:setValue("VersionName",versionName)
        stream:setValue("ChannelID",channelId )
        stream:setValue("Devices",mobileInfo ) 
        stream:setValue("PlatformID", self.GamePlatformID)
        stream:setValue("Account", account)  -- 游客Mac号码  


        stream:setValue("UnionID",unionid)
        stream:setValue("Passwd", laixia.LocalPlayercfg:getPassword())
        stream:setValue("IMEI",laixia.LocalPlayercfg:getIMEI());
        stream:setValue("Token",laixia.LocalPlayercfg.LaixiaTokenID)

      local str  = "versionName="..versionName.."&channelId="..channelId.."&mobileInfo="..mobileInfo.."&platform="..self.GamePlatformID.."&account="..account
      local md5msg = crypto.md5(  str )
      --"versionName=1.0.0&channelId=0&mobileInfo=huawei-6p&platform=1&account=00-01-6C-D6-01-F6"
      stream:setValue("Md5msg",md5msg)

        laixia.net.sendHttpPacket(stream)
        cc.UserDefault:getInstance():setBoolForKey("isauto", true) -- 防止游客登陆的时候本地文件影响
        cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", self.GamePlatformID)
        self:onclose()
end

--手机登录
function PCAccountLogin:phoneLogin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
         laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        if  laixia.LocalPlayercfg.LaixiaLastLoginPlatform == 2  then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "已经是手机登陆状态了")
            self:onclose()
            return
        end
        self.GamePlatformID = 2
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PHONELOGIN_WINDOW)
        self:onclose()
       
    end

end



function PCAccountLogin:shutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:onclose()
    end
end

function PCAccountLogin:onclose()
     self:destroy()
end

function PCAccountLogin:onTick()
    if is_weChat == true then
        is_weChat = false
        self:loginToSever()
    end
end


return PCAccountLogin.new()


