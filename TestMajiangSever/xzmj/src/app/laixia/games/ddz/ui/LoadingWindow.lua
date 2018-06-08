
local laixia = laixia;  --
local LoadingWindow = class("LoadingWindow", import(".CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg    
local Packet = import("..net.Packet") 
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local isForceUpdate = false
local RemoteVersion
local CurVersion
local version
function LoadingWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
end

function LoadingWindow:getName()
    return "LoadingWindow"
end

function LoadingWindow:onInit()
    self.super:onInit(self)   
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_LOADIN_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_GETVERSION,handler(self,self.getVersion))
    -- self.isclick = false
end

function LoadingWindow:doLoad()
    local idx = 1;
    local count = laixia.resLoader:getTotalCount();

    local function resourceLoad(...)

        local function  resLoadEnd()
            ---原版逻辑 直接进入游戏 
            --            laixia.net.Net:readyForGame()       
            --            laixia.net.start()
            self:showLogin()
        end
        local args = {...}               
        idx = idx+1;

        local per = math.floor((idx/count) * 100)
        self:setProgressBarPercent(per);        
        if(idx == count) then        
            resLoadEnd()
        end 
    end

    laixia.resLoader:registerLoadingCallback(resourceLoad)
    laixiaddz.ani:doLoad();
    self:setProgressBarPercent(0)
    --plist注释掉之后
     -- if count == 0 then
     --     self:showLogin()
     -- else
     --     laixia.resLoader:doLoad(); 
     -- end
    laixia.resLoader:doLoad();
    

end
--function updateUserCoin(data)
--    print("LobbyWindow")
--    local json = json or require("framework.json");
--    local info = json.decode(data);
--    laixiaddz.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
--end
--显示登陆界面 
function LoadingWindow:showLogin()
    print("alexnwag --- showLogin ")
    -- self.txt_tips = self:GetWidgetByName("txt_tips")
    -- self.txt_tips:setString("抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。")
    self.loadingNum:setVisible(false)
    self.loadingProgress:setVisible(false)
    self.LoginPanel = self:GetWidgetByName("LoginPanel")
    self.x_ = self.LoginPanel:getContentSize().width/2
    self.LoginPanel:setVisible(true)
     -- add by cxf channelid 判断登录
     -- 微信登录
     self.wxLogin = self:GetWidgetByName("wxLogin")
     self.wxLogin:setOpacity(0)
     self:AddWidgetEventListenerFunction("wxLogin",handler(self,self.weChatLogin))--微信登录
     --进入游戏
     self.ykLogin = self:GetWidgetByName("ykLogin")
     self.ykLogin:setOpacity(0)
    if device.platform ~= "windows" then
        self.wxLogin:setVisible(false)
        --进入游戏
        self.ykLogin:setVisible(false)
        self:AddWidgetEventListenerFunction("ykLogin",handler(self,self.JoinGame))
    else
        self.wxLogin:setVisible(true)
        self.ykLogin:setVisible(true)  
        self:showYKLogin()
        self:showWXLogin()
        self:AddWidgetEventListenerFunction("ykLogin",handler(self,self.visiterLogin))
    end

    if device.platform ~= "windows" then
         -- laixiaddz.LocalPlayercfg.PluginChannel =require("app.laixia.game.PluginChannel").create()
         -- laixiaddz.LocalPlayercfg.PluginChannel:startSession()

         if laixiaddz.LocalPlayercfg.CHANNELID ~= nil and laixiaddz.LocalPlayercfg.CHANNELID ~= "" then
             if tonumber(laixiaddz.LocalPlayercfg.CHANNELID) < 200000 then -- 渠道商店包
                 if tonumber(laixiaddz.LocalPlayercfg.CHANNELID) == 160186 or tonumber(laixiaddz.LocalPlayercfg.CHANNELID) == 111267 then --官网安卓和官网苹果包
                     --显示微信登录
                     --在这获取按钮 并设置按钮的位置居中(只有一种登录方式的情况)
                     self:showWXLogin(2)
                     self.wxLogin:setVisible(true)
                     self.ykLogin:setVisible(false)
                     self.wxLogin:setPositionX(self.x_)
                 else
                     --显示进入游戏*******
                     self:showYKLogin(2)
                     self.ykLogin:setPositionX(self.x_)
                     self.ykLogin:setVisible(true)  
                     self.wxLogin:setVisible(false)
                 end
             elseif tonumber(laixiaddz.LocalPlayercfg.CHANNELID) >= 200000 and tonumber(laixiaddz.LocalPlayercfg.CHANNELID) < 300000 then -- 自定义渠道包
                 if laixiaddz.LocalPlayercfg.CHANNELID == 201010 then --映客渠道包 
                     --自动登录 --微信自动登录还是 直接进入游戏？？？？

                 else
                     --只显示微信登录
                     self:showWXLogin(2)
                     self.wxLogin:setVisible(true)
                     self.wxLogin:setPositionX(self.x_)
                 end
             elseif tonumber(laixiaddz.LocalPlayercfg.CHANNELID) >= 300000 then --苹果渠道包
                 --只显示微信登录
                 self:showWXLogin(2)
                 self.wxLogin:setVisible(true)
                 self.wxLogin:setPositionX(self.x_)
             end
         else
             self:showWXLogin(2)
             self.wxLogin:setVisible(true)
             self.wxLogin:setPositionX(self.x_)
         end
     end

    if laixiaddz.kconfig.isYingKe == true then
        self.LoginPanel:setVisible(false)

        --屏蔽掉状态栏
        if device.platform == "ios" then
        elseif device.platform == "android" then
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "showStatusBar"
            local javaParams = { }
            local javaMethodSig = "()V"--"()Ljava/lang/String;"        
            local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        end
        co = nil;
        laixia.net.Net:readyForGame()       
        laixia.net.start()
        return
    end
    self.LoginPanel:setVisible(true)     
    self:GetWidgetByName("loadingNode"):setVisible(false)
    
    ---暂时自动登录
    if laixia.config.isAutoLogin then
        co = nil;
        laixia.net.Net:readyForGame()       
        laixia.net.start()
    end
end

--进入游戏
function LoadingWindow:JoinGame(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        function JoinGameCallFunc(sign)
            if sign == true then
                --登录成功
                co = nil
                laixia.net.Net:readyForGame()       
                laixia.net.start()
            else
                --登录失败
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, { Text = "登陆失败"})
            end
        end
        laixiaddz.LocalPlayercfg.PluginChannel =require("app.laixia.game.PluginChannel").create()
        laixiaddz.LocalPlayercfg.PluginChannel:setEndCallBack(JoinGameCallFunc)
        laixiaddz.LocalPlayercfg.PluginChannel:login() 
    end
end

--游客登陆
function LoadingWindow:showVisiterLogin()
    self:AddWidgetEventListenerFunction("btn_vister",handler(self,self.visiterLogin))
    self.visiterLogina = self:GetWidgetByName("btn_vister")
    self.visiterLogina:setVisible(false)
end

--进入登录
function LoadingWindow:showYKLogin(poss)

    -- ##########
    if poss == 2 then
        local system = laixiaddz.ani.CocosAnimManager
        self.yingke_entry = system:playAnimationAt(self.LoginPanel,"yingke_entry")
        self.yingke_entry:setPositionX(self.x_)
        self.yingke_entry:setPositionY(self.ykLogin:getPositionY())
    else
        local system = laixiaddz.ani.CocosAnimManager
        self.yingke_entry = system:playAnimationAt(self.LoginPanel,"yingke_entry")
        self.yingke_entry:setPositionX(self.ykLogin:getPositionX())
        self.yingke_entry:setPositionY(self.ykLogin:getPositionY())
    end
end

--微信登录 调用这个方法的时候才将微信登录按钮设置成显示
function LoadingWindow:showWXLogin(poss)
    if poss == 2 then
        local system = laixiaddz.ani.CocosAnimManager
        self.entry = system:playAnimationAt(self.LoginPanel,"entry")
        self.entry:setPositionX(self.x_)
        self.entry:setPositionY(self.wxLogin:getPositionY())
    else
        local system = laixiaddz.ani.CocosAnimManager
        self.entry = system:playAnimationAt(self.LoginPanel,"entry")
        self.entry:setPositionX(self.wxLogin:getPositionX())
        self.entry:setPositionY(self.wxLogin:getPositionY())
    end

    if laixiaddz.LocalPlayercfg.CHANNELID~=nil and ((tostring(laixiaddz.LocalPlayercfg.CHANNELID) == "160186" or tostring(laixiaddz.LocalPlayercfg.CHANNELID) == "111267") or (tonumber(laixiaddz.LocalPlayercfg.CHANNELID)>200000 and tonumber(laixiaddz.LocalPlayercfg.CHANNELID)<300000)) then
        if laixiaddz.kconfig.isYingKe == true then
        else
            local system = laixiaddz.ani.CocosAnimManager
            self.yingke_entry = system:playAnimationAt(self.LoginPanel,"yingke_entry")
            self.wxLogin:setPositionX(self.x_)
            self.entry:setPositionX(self.wxLogin:getPositionX())
            self:GetWidgetByName("ykLogin"):setVisible(false)
            self.yingke_entry:setVisible(false)
        end
    end
   
--    local weixinLogin = laixiaddz.Layout.loadNode("entry.csb"):addTo(self.LoginPanel)

   -- local action = cc.CSLoader:createTimeline("entry.csb")
   -- weixinLogin:runAction(action)
   -- action:gotoFrameAndPlay(0,true)


--    local funAction = cc.CallFunc:create(function()
      
--    end)

--    local funAction2 = cc.CallFunc:create(function()
--            weixinLogin:removeFromParent()
--            weixinLogin=nil
--
--    end)
--    self.wxLogin:runAction(
--        cc.Sequence:create(
--            funAction ,
--            cc.DelayTime:create(2),
--            funAction2
--        ))
    
    -- self.agreementCheck = self:GetWidgetByName("agreementCheck")

   
    self.loadingNode:setVisible(false)

    self.txt_tips = self:GetWidgetByName("txt_tips")
    self.txt_tips:setVisible(false)

    if cc.UserDefault:getInstance():getBoolForKey("isauto") == true or (cc.UserDefault:getInstance():getStringForKey("access_token")~="" and cc.UserDefault:getInstance():getStringForKey("openid")~="") and self.isChange~=true then
          if PLATFORM_OS_ANDROID == targetPlatform then
            local access_token = cc.UserDefault:getInstance():getStringForKey("access_token")
            local openid = cc.UserDefault:getInstance():getStringForKey("openid")

            laixiaddz.LocalPlayercfg.LaixiaUserID = openid
            laixiaddz.LocalPlayercfg.LaixiaTokenID = access_token
            cc.UserDefault:getInstance():setStringForKey("uid", openid)
            cc.UserDefault:getInstance():setStringForKey("token", access_token)
            cc.UserDefault:getInstance():setBoolForKey("isauto", true)
            cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 5)
            laixiaddz.LocalPlayercfg:WriteData()
            laixia.net.Net:readyForGame()       
            laixia.net.start()
        else
            local sender = ""
            local eventType = ccui.TouchEventType.ended 
            self:weChatLogin(sender,eventType)
        end
    end
    -- self.gameAgreement = self:GetWidgetByName("gameAgreement")
    -- self.gameAgreement:addTouchEventListener(handler(self,self.showAgreement)) 
    -- self.xieyiPanel = self:GetWidgetByName("xieyiPanel")
    -- self.txtPanel = self:GetWidgetByName("txtPanel")
    -- self.confirmBut = self:GetWidgetByName("confirmBut")
    -- self.confirmBut:addTouchEventListener(handler(self,self.closeAgreement)) 
end


function LoadingWindow:showAgreement(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open) 
        self.xieyiPanel:setVisible(true)
        if self.webView == nil then
            if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then  
                self.webView = ccexp.WebView:create()
                self.txtPanel:addChild(self.webView)
                self.webView:setJavascriptInterfaceScheme("lua")
                self.webView:setPosition(487, 210)
                self.webView:setAnchorPoint(0.5,0.5)
                self.webView:loadURL(laixia.config.AGREEMENT_URL)

                self.webView:setContentSize(cc.size(974,422)) -- 一定要设置大小才能显示
                self.webView:setScalesPageToFit(true)
                self.webView:setOnJSCallback(function(sender, url)
                    if url == "lua://close" then
                        self.xieyiPanel:setVisible(false)
                    end
                end)
            end 
        else
            self.webView:setVisible(true)
        end
    end
end


function LoadingWindow:closeAgreement(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open) 
        self.xieyiPanel:setVisible(false)
        self.webView:setVisible(false)
    end
end

--java调用的lua方法
local function luaWeChatfun(param)
    print("luaWeChatfun=================================="..param.uid)
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

    laixiaddz.LocalPlayercfg.LaixiaUserID = array.uid
    laixiaddz.LocalPlayercfg.LaixiaTokenID = array.token
    laixiaddz.LocalPlayercfg.HEAD_URL = array.headimgurl
    laixiaddz.LocalPlayercfg.LaixiaPlayerGender = array.sex - 1

    cc.UserDefault:getInstance():setStringForKey("uid", array.uid)
    cc.UserDefault:getInstance():setStringForKey("token", array.token)
    cc.UserDefault:getInstance():setStringForKey("unionid", array.unionid)
    cc.UserDefault:getInstance():setStringForKey("headimgurl",array.headimgurl)
    cc.UserDefault:getInstance():setBoolForKey("isauto", true)
    cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 5)
    laixiaddz.LocalPlayercfg:WriteData()
    laixia.net.Net:readyForGame()       
    laixia.net.start()
end

--lua函数注册给微信调用
local function funToWeChatJava()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        -- local luaj = require "cocos.cocos2d.luaj"
        local className = APP_PACKAGE_NAME.."wxapi/WXEntryActivity"
        local args={ luaWeChatfun }
        local sigs = "(I)V"
        local payState = luaj.callStaticMethod(className,"wxSetLuaFun",args,sigs)
    end      
end
--游客登陆
function LoadingWindow:visiterLogin(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    
        if device.platform == "windows" then
            co = nil;
            laixia.net.Net:readyForGame()       
            laixia.net.start()
        else
             local sender = ""
             local eventType = ccui.TouchEventType.ended 
             self:weChatLogin(sender, eventType)
        end
    end
end
--微信登录
function LoadingWindow:weChatLogin(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)  
        -- if not self.agreementCheck:isSelected() then 
        --     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"请勾选同意下方的\"服务协议\"，即可进入游戏哦") 
        --     return
        -- end     
        -- funToWeChatJava()
         if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
--             -- local luaj = require "cocos.cocos2d.luaj"
--             local className = APP_ACTIVITY
--             local args={}
--             local sigs = "()V"
--             local payState = luaj.callStaticMethod(className,"wxLogin",args,sigs)
--             if payState  then
--                 print("shouquan success")
--                 --self.GamePlatformID = 5
--             else
--                 print("shouquan error")
--                 cc.UserDefault:getInstance():setBoolForKey("isauto", false)
--             end
             local function  registerWeixin()
                -- 微信授权登录
                self.luaBridge = require("cocos.cocos2d.luaj")
                self.luaBridge.callStaticMethod(APP_ACTIVITY, "sendAuthRequest", {}, "()V")
                self.luaBridge.callStaticMethod(APP_ACTIVITY, "registerGetAuthCodeHandler", { pushWXAuthCode}, "(I)V")
             end
             local player_loginTime = cc.UserDefault:getInstance():getStringForKey("player_loginTime")
             local player_lastTime = cc.UserDefault:getInstance():getStringForKey("player_lastTime")

             if  player_loginTime == nil or  player_loginTime == "" then
                 cc.UserDefault:getInstance():setStringForKey("player_loginTime", os.time())
                 cc.UserDefault:getInstance():setStringForKey("player_lastTime", os.time() +  24 * 60 * 60)
                 registerWeixin()
             elseif player_loginTime ~= "" and  tonumber(player_loginTime) ~= nil and tonumber(player_loginTime) > 0 and (os.time() >= tonumber(player_lastTime)) then
                  registerWeixin()
             else
                  registerWeixin()
             end
         elseif(cc.PLATFORM_OS_IPHONE == targetPlatform or cc.PLATFORM_OS_IPAD == targetPlatform) then
             local arg = {callBack = luaWeChatfun}
             local result, value1 = luaoc.callStaticMethod("WXinShareManager", "wxLogin", arg)
             --self.GamePlatformID = 5
         end
       

     
    end
end


function pushWXAuthCode(authCode)
    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    local appID;
    -- if gt.isIOSPlatform() then
    --     local ok, ret = self.luaBridge.callStaticMethod("AppController", "getAppID")
    --     appID = ret
    -- -- elseif gt.isAndroidPlatform() then
    -- --  local ok, ret = self.luaBridge.callStaticMethod("org/cocos2dx/lua/AppActivity", "getAppID", nil, "()Ljava/lang/String;")
    -- --  appID = ret
    -- else
        appID = "wx180878753802393c"
    -- end
    local secret = "32f6a194e092cc934854acb162fc2e0b"
    -- release version
    -- local secret = "889433291901b4f5d3e53e414e78f661"
    local accessTokenURL = string.format("https://api.weixin.qq.com/sns/oauth2/access_token?appid=%s&secret=%s&code=%s&grant_type=authorization_code", appID, secret, authCode)
    

    print(accessTokenURL)

    xhr:open("GET", accessTokenURL)
    local function onResp()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response = xhr.response
            require("json")
            local respJson = json.decode(response)
            if respJson.errcode then
                print("拉起失败1")
                ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, {Text = "你没有安装微信！"})
                -- 申请失败
                --require("app/views/NoticeTips"):create(gt.getLocationString("LTKey_0007"), gt.getLocationString("LTKey_0030"), nil, nil, true)
            else
                 print("wangtianye   成功")
                -- laixiaddz.LocalPlayercfg.LaixiaTokenID = respJson.token
                -- laixiaddz.LocalPlayercfg.HEAD_URL = respJson.headimgurl
                -- laixiaddz.LocalPlayercfg.LaixiaPlayerGender = respJson.sex - 1

                laixiaddz.LocalPlayercfg.LaixiaTokenID = respJson.access_token
                print(laixiaddz.LocalPlayercfg.LaixiaTokenID)

                cc.UserDefault:getInstance():setStringForKey("refresh_token", respJson.refresh_token)
                cc.UserDefault:getInstance():setStringForKey("access_token", respJson.access_token)
                cc.UserDefault:getInstance():setStringForKey("unionid", respJson.unionid)
                cc.UserDefault:getInstance():setStringForKey("openid", respJson.openid)
                cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 5)
                loginWechat(respJson.access_token,respJson.openid)


            end
        elseif xhr.readyState == 1 and xhr.status == 0 then
            -- 本地网络连接断开
            print("网络GG")
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onResp)
    xhr:send()
end
--第二阶段 变身
function loginWechat(access_token,openid )
     local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    local accessTokenURL = string.format("https://api.weixin.qq.com/sns/userinfo?access_token=%s&openid=%s", access_token, openid)
    
    print(accessTokenURL)

    xhr:open("GET", accessTokenURL)
    local function onResp()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local response = xhr.response
            require("json")
            local respJson = json.decode(response)
            if respJson.errcode then
                print("拉起失败2")
                print(respJson.errcode )
                -- 申请失败
                --require("app/views/NoticeTips"):create(gt.getLocationString("LTKey_0007"), gt.getLocationString("LTKey_0030"), nil, nil, true)
            else
                print("aaaaa=================================")
                print(laixiaddz.LocalPlayercfg.LaixiaTokenID)


                laixiaddz.LocalPlayercfg.LaixiaUserID = respJson.openid
                laixiaddz.LocalPlayercfg.LaixiaTokenID = access_token
                laixiaddz.LocalPlayercfg.LaixiaPlayerNickname = respJson.nickName
                laixiaddz.LocalPlayercfg.HEAD_URL = respJson.headimgurl
                laixiaddz.LocalPlayercfg.LaixiaPlayerGender = respJson.sex - 1

                cc.UserDefault:getInstance():setStringForKey("uid", respJson.openid)
                cc.UserDefault:getInstance():setStringForKey("token", access_token)
                -- cc.UserDefault:getInstance():setStringForKey("unionid", respJson.unionid)
                cc.UserDefault:getInstance():setStringForKey("headimgurl",respJson.headimgurl)
                cc.UserDefault:getInstance():setBoolForKey("isauto", true)
                cc.UserDefault:getInstance():setIntegerForKey("GamePlatformID", 5)
                laixiaddz.LocalPlayercfg:WriteData()
                laixia.net.Net:readyForGame()       
                laixia.net.start()
            end
        elseif xhr.readyState == 1 and xhr.status == 0 then
            -- 本地网络连接断开
            print("网络GG")
        end
        xhr:unregisterScriptHandler()
    end
    xhr:registerScriptHandler(onResp)
    xhr:send()
end
--设置适配
function LoadingWindow:setAdaptation()
    --大厅需要设置自适应的所有设置

    self.loadingBG = self:GetWidgetByName("loadingBG")
    --修改的适配
    -- if display.widthInPixels > display.contentScaleFactor*display.width then
    --     local scaleX_ = display.widthInPixels/(display.contentScaleFactor*display.width)
    --     self.loadingBG:setScaleX(scaleX_)
    -- end
    self.loadingBG:setPosition(cc.p(display.cx,display.cy))
    --修1
    self.zs_ButtonBack = self:GetWidgetByName("Button_zhiShiFanhui")
    --修2
    self:GetWidgetByName("Button_zhiShiFanhui"):setPosition(cc.p(self.zs_ButtonBack:getPositionX(),display.top - self.zs_ButtonBack:getContentSize().height/2))
    -- self.icon = self:GetWidgetByName("gameIcon")
    -- self.icon:setPosition(30,display.height)

    -- self.loadingNode = self:GetWidgetByName("loadingNode")
    -- self.loadingNode:setPosition(cc.p(display.cx,display.bottom))
    -- self.loadingNode:setVisible(true)
    -- self.loadAinmNode = self:GetWidgetByName("loadAinmNode")
    -- self.loadAinmNode:setPosition(cc.p(display.cx,display.cy))
    if device.platform == "ios" then
        --暂时先 适配 iphoneX
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self.loadingBG:setScaleX(2436/3*2/1440)
            self.zs_ButtonBack:setPositionX(display.left +34+24)
        end
    end
end

function LoadingWindow:onShow(data)
    self:setAdaptation()
    self.isChange = false
    self.isHotUpdate = false
    --------
    -- 审核使用
    
    -- self.fengmian_biaoti = self:GetWidgetByName("loadingBG"):loadTexture("new_ui/isAudit/shenhe_loading.png")

    if laixia.config.isAudit then
        self.fengmian_biaoti = self:GetWidgetByName("fengmian_biaoti"):setTexture("new_ui/isAudit/shenhe_laixia.png")
    end

    if laixia.kconfig.isApple1 then
        self.fengmian_biaoti = self:GetWidgetByName("fengmian_biaoti"):setTexture("new_ui/Apple/Apple_shenhe_2.png")
        local panel = self:GetWidgetByName("loadingBG")
        local activity_dition = cc.Sprite:create("new_ui/Apple/Apple_shenhe_1.png")
        -- local activity_dition = cc.Sprite:createWithSpriteFrameName("res/new_ui/Apple/Apple_shenhe_1.png")  
        panel:addChild(activity_dition)
        activity_dition:setPosition(display.cx,display.cy-60)
    end
    --映客芝士专用
    if getAppVersion() == "1.3.10" or getAppVersion() == "1.3.20" or getAppVersion() == "1.3.21" then
        laixiaddz.kconfig.isYingKe = true
    end
    ----这里先检查 是否有更新 然后再加载资源
    if laixiaddz.kconfig.isYingKe ~= true then
        if device.platform == "windows" then
        else
            laixiaddz.LocalPlayercfg.PluginChannel =require("app.laixia.game.PluginChannel").create()
            laixiaddz.LocalPlayercfg.PluginChannel:startSession()
        end
    else
        laixiaddz.LocalPlayercfg.PluginChannel =require("app.laixia.game.PluginChannel").create()
        laixiaddz.LocalPlayercfg.PluginChannel:startSession()
    end
    
    self:AddWidgetEventListenerFunction("btn_vister",handler(self,self.JoinGame))
    self.visiterLogina = self:GetWidgetByName("btn_vister")
    self.visiterLogina:setVisible(false)
    if laixiaddz.kconfig.isYingKe == true then

        self.BG = self:GetWidgetByName("loadingBG"):loadTexture("new_ui/loading/zhishiLoading2.png")
    
        self.Panel_2 = self:GetWidgetByName("Panel_2")
        self.Panel_2:setVisible(false)
        self.Image_gxbg = self:GetWidgetByName("Image_gxbg")
        self.Image_gxbg:setVisible(false)
        

        self:GetWidgetByName("Text_gxjd"):setVisible(false)
        self.LoadingBar_gx = self:GetWidgetByName("LoadingBar_gx")
        self.Text_gxjd = self:GetWidgetByName("Text_gxjd")
        self.LoginPanel = self:GetWidgetByName("LoginPanel")
        self.LoadingBar_gx:setVisible(false)
        self.Text_gxjd:setVisible(false)
        self.LoginPanel:setVisible(false)
        self:GetWidgetByName("fengmian_biaoti"):setVisible(false)
        self:GetWidgetByName("loadAinmNode"):setVisible(false)
        

        self.Text_bt = self:GetWidgetByName("Text_bt", self.Panel_2)
        
        self.LoginPanel = self:GetWidgetByName("LoginPanel")
        self.LoginPanel:setVisible(false)
        
        self.loadingNode = self:GetWidgetByName("loadingNode")
        self.loadingNode:setVisible(false)

        self.loadingNum = self:GetWidgetByName("progressBarNum")  
        self.loadingProgress = self:GetWidgetByName("LoadingProgress");
        self:setProgressBarPercent(0);
        --按钮暂时先开开
        self:GetWidgetByName("Button_zhiShiFanhui"):setVisible(true)
        self:AddWidgetEventListenerFunction("Button_zhiShiFanhui",handler(self,self.TuiChu))
        laixiaddz.LocalPlayercfg.LaixiaMusicValue = cc.UserDefault:getInstance():getIntegerForKey("MusicValue")
        laixiaddz.LocalPlayercfg.LaixiaSoundValue = cc.UserDefault:getInstance():getIntegerForKey("SoundValue")
        laixiaddz.LocalPlayercfg.LaixiaIsShake = cc.UserDefault:getInstance():getIntegerForKey("Shake")   
    
        

        ----这里先检查 是否有更新 然后再加载资源
        
        version = cc.UserDefault:getInstance():getStringForKey("version")
        if version ~=nil and version~="" then
            local myVersionVector = self:stringSplit(version,".")
            local serverVersionVector = self:stringSplit(getAppVersion(),".")
            if tonumber(myVersionVector[1])<tonumber(serverVersionVector[1]) then
                cc.UserDefault:getInstance():setStringForKey("version",getAppVersion()) 
                version = cc.UserDefault:getInstance():getStringForKey("version")
            end
        elseif version==nil or version=="" then
                version = "2.0.21"
            cc.UserDefault:getInstance():setStringForKey("version",version) 
        end
       
        laixiaddz.LocalPlayercfg.mCurGameAppID =1 

        -- --正式时 这句需要去掉
        if data.data==nil then
            self.isChange = false
        else
            self.isChange = true
        end

        -- if laixia.config.isOpenUpdate and laixia.config.isAudit~=true then
        if laixia.config.isOpenUpdate and device.platform~="windows" and laixia.config.isAudit~=true then
            self:sendCurVersion(version)
        else
            self.loadingNode:setVisible(true)
            self.loadingNode:setOpacity(0)

            laixiaddz.ui.WindowManager:onRegisterAll()
            self.root:performWithDelay(handler(self,self.doLoad),0.01);
        end
    else
        self.Panel_2 = self:GetWidgetByName("Panel_2")
        self.Panel_2:setVisible(false)
        self.Image_gxbg = self:GetWidgetByName("Image_gxbg")
        self.Image_gxbg:setVisible(false)
        self.LoadingBar_gx = self:GetWidgetByName("LoadingBar_gx")
        self.LoadingBar_gx:setPercent(0)
        self.LoadingBar_gx:setVisible(false)
        self.Text_gxjd = self:GetWidgetByName("Text_gxjd")
        self.Text_gxjd:setVisible(false)

        self.Text_bt = self:GetWidgetByName("Text_bt", self.Panel_2)

        self.Text_b = cc.Label:createWithSystemFont("", "Arial", 30)
        self.Text_b:setAnchorPoint(cc.p(0,0))                   
        self.Text_b:setPosition(cc.p(0,0))     
        --self.Text_bt:setColor(cc.c4b(108,139,154,255))
        self.Text_b:enableOutline(cc.c4b(111,42,0,255), 2)
        self.Text_bt:addChild(self.Text_b)
     
        -- lb->enableShadow(Color4B::GREEN, Size(10, 10)); //阴影
        -- lb->enableOutline(Color4B::RED, 3);             //轮廓
        -- lb->enableGlow(Color4B::GREEN);            

        self.button_yes = self:GetWidgetByName("Button_yes", self.Panel_2)  
        self:AddWidgetEventListenerFunction("Button_yes",handler(self,self.isTransition))
        --------

        --映客登录
        self.LoginPanel = self:GetWidgetByName("LoginPanel")
        self.LoginPanel:setVisible(false)

        self.loadingNum = self:GetWidgetByName("progressBarNum")  
        self.loadingProgress = self:GetWidgetByName("LoadingProgress");
        self:setProgressBarPercent(0);


        --doload进度条
        self.loadingNode = self:GetWidgetByName("loadingNode")
        self.loadingNode:setVisible(false)
        --laixiaddz.LocalPlayercfg.LaixiaIsShake = true 
        --读取本地的设置，音量音乐，震动等
            -- cc.UserDefault:getInstance():setIntegerForKey("MusicValue", 1)
            -- cc.UserDefault:getInstance():setIntegerForKey(,1)
            -- cc.UserDefault:getInstance():setIntegerForKey("Shake",1)  
        laixiaddz.LocalPlayercfg.LaixiaMusicValue = cc.UserDefault:getInstance():getIntegerForKey("MusicValue")
        laixiaddz.LocalPlayercfg.LaixiaSoundValue = cc.UserDefault:getInstance():getIntegerForKey("SoundValue")
        laixiaddz.LocalPlayercfg.LaixiaIsShake = cc.UserDefault:getInstance():getIntegerForKey("Shake")    

        version = cc.UserDefault:getInstance():getStringForKey("version")
        if version ~=nil and version~="" then
            local myVersionVector = self:stringSplit(version,".")
            local serverVersionVector = self:stringSplit(getAppVersion(),".")
            if tonumber(myVersionVector[1])<tonumber(serverVersionVector[1]) then
                cc.UserDefault:getInstance():setStringForKey("version",getAppVersion()) 
                version = cc.UserDefault:getInstance():getStringForKey("version")
            end
        elseif version==nil or version=="" then
            version = getAppVersion()
            cc.UserDefault:getInstance():setStringForKey("version",version) 
        end
        laixiaddz.LocalPlayercfg.mCurGameAppID =1 
        
        
        -- --正式时 这句需要去掉
        if data.data==nil then
            self.isChange = false
        else
            self.isChange = true
        end
        -- if laixia.config.isOpenUpdate and laixia.config.isAudit~=true then
       if laixia.config.isOpenUpdate and device.platform~="windows" and laixia.config.isAudit~=true then
            self:sendCurVersion(version)
        else
            self.loadingNode:setVisible(true)
            laixiaddz.ui.WindowManager:onRegisterAll()
            self.root:performWithDelay(handler(self,self.doLoad),0.01);
        end
    end
    if device.platform == "android" then
         local javaClassName = APP_ACTIVITY
         local javaMethodName = "removeLaunchImage"
         local javaParams = { }
         local javaMethodSig = "()V"        
         local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
     end
end
function LoadingWindow:TuiChu()
    app:exit()()
end
--发送我本地版本号
function LoadingWindow:sendCurVersion(version)
    local stream = Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
    stream:setValue("Code", 0)
    stream:setValue("GameID", 1)
    stream:setValue("GameVersion",version)
    laixia.net.sendHttpPacketAndWaiting(stream,nil,2) 
end

function LoadingWindow:isTransition(sender,eventType)
    --self:GetWidgetByName("Panel_2"):setVisible(false)
    if eventType == ccui.TouchEventType.ended then
        -- if self.isclick == false  then
            print("======d点击确定按钮===")
            print("======d点击确定按钮==="..self.reTag )
            -- self.isclick = true
            if  self.reTag == 1 then
                print("======进去退出游戏判断==="..self.reTag )
                self.reTag = 0
                app:exit()()
                -- print("======进去退出游戏完成==="..self.reTag )
                return
            else
                if self.isForceUpdate == true then
                    cc.Application:getInstance():openURL("http://wx.laixia.com/download")
                else
                    version = cc.UserDefault:getInstance():getStringForKey("version")
                    if version==nil or version=="" then
                        version = getAppVersion()
                        cc.UserDefault:getInstance():setStringForKey("version",version) 
                    end
                    self:sendCurVersion(version)
                end
            end
            self.Panel_2:setVisible(false)
        -- end
    end
end

function LoadingWindow:getVersion(data)
    print("getVersion----")
    print(data.data.StatusID)
    print(data.data.Version)
    if data.data.StatusID~=0 then
        RemoteVersion = data.data.Version
        if RemoteVersion~=nil and RemoteVersion~="" then
            cc.UserDefault:getInstance():setStringForKey("version",RemoteVersion)
        end
        laixiaddz.ui.WindowManager:onRegisterAll()
        self.root:performWithDelay(handler(self,self.doLoad),0.01);
        self.Image_gxbg:setVisible(false)
        return
    end
    RemoteVersion = data.data.Version
    CurVersion = cc.UserDefault:getInstance():getStringForKey("version")
    print("CurVersion"..CurVersion)

    local pathToSave = cc.FileUtils:getInstance():getWritablePath() .. "update_new/"
    if not cc.FileUtils:getInstance():isFileExist(pathToSave) then
        cc.FileUtils:getInstance():createDirectory(pathToSave)
    end

    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            print("no new version")
            --TODO 没新版本可更新了 更新的资源 隐藏 显示出loading
            --隐藏panel 和 更新进度条 显示出loading
            --self.Panel_2 = self:GetWidgetByName("Panel_2")
            self.Panel_2:setVisible(false)
            self.Image_gxbg = self:GetWidgetByName("Image_gxbg")
            self.Image_gxbg:setVisible(false)
            --self.LoadingBar_gx = self:GetWidgetByName("LoadingBar_gx")
            self.LoadingBar_gx:setVisible(false)
            --self.Text_gxjd = self:GetWidgetByName("Text_gxjd")
            self.Text_gxjd:setVisible(false)

            laixiaddz.ui.WindowManager:onRegisterAll()
            self.root:performWithDelay(handler(self,self.doLoad),0.01);
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            print("network error")
            self.Panel_2:setVisible(true)
            self.Image_gxbg:setVisible(false)
            self.Text_b:setString("网络失败导致更新失败的...")
        else
            print("error")
            self.Image_gxbg:setVisible(false)
            self.Panel_2:setVisible(true)
            self.Text_b:setString("其他错误...")
        end
    end

    local function onProgress( percent )
        if percent < 0 then
            percent = 0
        elseif percent > 100 then
            percent = 100

            self.LoadingBar_gx:setVisible(false)
            self.Text_gxjd:setVisible(false)
        else
            local progress = string.format("%d%%",percent)
            print(progress)
            --进度条设置TODO
            self.LoadingBar_gx:setVisible(true)
            self.LoadingBar_gx:setPercent(percent)
            self.Text_gxjd:setVisible(true)
            self.Text_gxjd:setString(progress )
        end

    end

    local function onSuccess()
        print("downloading ok")
        cc.FileUtils:getInstance():addSearchPath(pathToSave.."src",true)
        cc.FileUtils:getInstance():addSearchPath(pathToSave.."res",true)
--        cc.FileUtils:getInstance():addSearchPath(pathToSave .. "src/app/laixia/net",true)

        self.isHotUpdate = true
        cc.UserDefault:getInstance():setStringForKey("version",RemoteVersion)  
        print("RemoteVersion"..RemoteVersion)
        self:sendCurVersion(RemoteVersion) ---递归 各个版本进行迭代
        
    end
    if RemoteVersion==CurVersion then
        --不用更新
        --正式时 这句需要去掉
        ---为了修复内更新的bug 所以这里删除所有的luac文件
        
        local Protocols= require("app.laixia.net.PacketFiles")
        laixia.Protocols = Protocols
        print("jjjjjjjjzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
        if self.isHotUpdate == true then
            print("更新成功，请重启客户端000000000000000000000000")
            self.Panel_2:setVisible(true)
            self.Text_bt:setString("更新成功，请重启客户端...")
            self.Image_gxbg:setVisible(false)
            self.reTag = 1
            print("更新完000000000000000000000000")
            print("更新完000000000000000000000000")
            return 
        end
        laixiaddz.ui.WindowManager:onRegisterAll()
        if self.isChange==false then
            self.Image_gxbg:setVisible(false)
            self.LoadingBar_gx:setVisible(false)
            self.Text_gxjd:setVisible(false)
            self.loadingNode:setVisible(true)
            self.root:performWithDelay(handler(self,self.doLoad),0.01);
        else
            self.root:performWithDelay(handler(self,self.doLoad),0.01);
        end
    else
        --这里判断强更还是热更
        local isForceUpdate = false
        local myVersionVector = self:stringSplit(CurVersion,".")
        local serverVersionVector = self:stringSplit(RemoteVersion,".")
        if tonumber(myVersionVector[1])<tonumber(serverVersionVector[1]) then
            isForceUpdate = true
        end
        if isForceUpdate then--弹出一个跳转的界面
            --TODO
            self.Panel_2:setVisible(true)
            self.Text_bt:setString("有新版本哦，请前往更新...")
            self.Image_gxbg:setVisible(false)
        else
            --显示热更新的资源 --TODO
            self.Image_gxbg:setVisible(true)
             local assetsManager = cc.AssetsManager:new(
                -- "https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip", --更新包路径，等待正确的路径确认后再更改
                laixia.config.UPDATE_HOTUPDATE_DOWNLOADURL.."update_" ..RemoteVersion .. ".zip",
                --                        LOADBALANCE_URL .. "GetCurGameVersion",
                laixia.config.UPDATE_HOTUPDATE_DOWNLOADURL.."update_" ..RemoteVersion .. ".zip",
                pathToSave)
            print(laixia.config.UPDATE_HOTUPDATE_DOWNLOADURL.."update_" .. RemoteVersion .. ".zip")
            assetsManager:retain()
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(3)
--            VERSION = RemoteVersion
            -- assetsManager:setVersion(RemoteVersion)
            assetsManager:update()
            self.isHotUpdate =true
        end
    end
end

function LoadingWindow:setProgressBarPercent(per)
    self.loadingProgress:setPercent(per)
    if self.loadingNum ~= nil then
        self.loadingNum:setString(per.."%")
    end
end 

function LoadingWindow:onDestroy()
    -- self.isclick = false
    -- display.removeSpriteFramesWithFile( "LoadingWindow.plist") 
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey("LoadingWindow.png")
    -- local test = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
end

function LoadingWindow:onTick(dt)    
    if(co~= nil) then
        coroutine.resume(co,idx,count)
    end 
end
--- string split
function LoadingWindow:stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} 
    local i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
return LoadingWindow.new()
