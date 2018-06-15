
local UItools = require("common.tools.UITools")

local SettingLayer = class("SettingLayer" , import("common.base.BaseDialog"))
local path = "new_ui/setting/"
local kai = "kai.png"
local guan = "guan.png"
local AGREEMENT_URL = "http://wx.laixia.com/templates/terms.html" --游戏协议地址
local ZHISHI_AGREEMENT_URL = "http://wx.laixia.com/templates/service.html" -- 芝士服务协议  
local ERVYI_URL = "http://2v1.games.laixia.com.cn/h5game?from=ddz"
local userDefault = cc.UserDefault:getInstance()
local sharedEngine = cc.SimpleAudioEngine:getInstance() 

local isEffectOn = nil     -- 音效
local isBackgroundOn = nil -- 音乐
local isShockOn = nil      -- 震动


local APP_PACKAGE_NAME = "com/laixia/game/ddz/" 
local JAVA_SHAKE_CLASSPATH = APP_PACKAGE_NAME .."ShakeUtil"


local isshow = false

function SettingLayer:ctor()
    if isshow == true then
        return
    end    
    SettingLayer.super.ctor(self, "new_ui/SettingLayer.csb")
    self:init()
    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function SettingLayer:init()

    self.Panel_middle = _G.seekNodeByName(self.rootNode,"Panel_middle")
    self.Button_openmusic = _G.seekNodeByName(self.Panel_middle,"Button_openmusic")
    self.Button_openmusic:addTouchEventListener(handler(self, self.Button_openmusicf))

    self.Text_gamepermit = _G.seekNodeByName(self.rootNode,"Text_gamepermit")
    self.Text_gamepermit:addTouchEventListener(handler(self, self.Text_gamepermitf))

    self.Text_net = _G.seekNodeByName(self.rootNode,"Text_net")
    self.Text_net:addTouchEventListener(handler(self, self.Text_gamepermitf))


    self.Button_opensound = _G.seekNodeByName(self.Panel_middle,"Button_opensound")
    self.Button_opensound:addTouchEventListener(handler(self, self.Button_opensoundf))

    self.Image_background = _G.seekNodeByName(self.Panel_middle,"Image_background")


    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self, self.onback))

    self.Button_openshock = _G.seekNodeByName(self.Panel_middle,"Button_openshock")
    self.Button_openshock:addTouchEventListener(handler(self, self.Button_openshockf))


    self.Panel_webview = _G.seekNodeByName(self.rootNode,"Panel_webview")
    self.mWebviewSize = self.Panel_webview:getContentSize()

    self.Button_service = _G.seekNodeByName(self.rootNode,"Button_service")
    self.Button_service:addTouchEventListener(handler(self, self.Button_servicef))


    self.Text_zhishi_num = _G.seekNodeByName(self.Panel_middle,"Text_zhishi_num")

    self.Image_middle = _G.seekNodeByName(self.Panel_middle,"Image_middle")

    self.Text_weixin = _G.seekNodeByName(self.rootNode,"Text_weixin")

    self.Text_qq = _G.seekNodeByName(self.rootNode,"Text_qq")

    self.Image_frame = _G.seekNodeByName(self.rootNode,"Image_frame")
    self.Image_icon =  _G.seekNodeByName(self.rootNode,"Image_icon")
    self.Image_icon:setVisible(false)

    self.Text_privacy = _G.seekNodeByName(self.rootNode,"Text_privacy")


    self:initData()
    self:UpdateData()

end
 

function SettingLayer:initData(  )

    isEffectOn = userDefault:getIntegerForKey("isEffectOn", 1)==1 -- 音效
    isBackgroundOn = userDefault:getIntegerForKey("isBackgroundOn", 1)==1 -- 音乐
    isShockOn = userDefault:getIntegerForKey("isShockOn", 1)==1 -- 震动

end


function SettingLayer:UpdateData(  )
    local iconpath = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        iconpath = localIconName
    end
    self:addHeadIcon(self.Image_frame,iconpath)
    self.Text_zhishi_num:setString( "芝士号:"..laixia.LocalPlayercfg.LaixiaPlayerID )


    isEffectOn = not isEffectOn
    isBackgroundOn = not isBackgroundOn
    isShockOn = not isShockOn
    self:Button_openmusicf( self.Button_openmusic, ccui.TouchEventType.ended)
    self:Button_opensoundf( self.Button_opensound, ccui.TouchEventType.ended )

    -- 这里震动状态单独处理
    local state = isShockOn
    local pt = nil
    if state == true then
        userDefault:setIntegerForKey("isShockOn", 0)
        pt = path..guan 
        isShockOn = false
    else
        userDefault:setIntegerForKey("isShockOn", 1)
        isShockOn = true
        pt = path..kai
    end
    self.Button_openshock:loadTextures(pt, pt, pt, 0)  


end

function SettingLayer:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
    local templet = "images/touxiangkuang_now.png"
    UItools.addHead(head_btn, path, templet)
   
end


function SettingLayer:Button_servicef(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then  
        local SettingLayer = require("lobby.layer.setting.SettingLayerWebView").new()
        self:addChild( SettingLayer)

    end
end

function SettingLayer:Text_gamepermitf(sender,eventType)
     _G.onTouchButton(sender,eventType)     
    if eventType == ccui.TouchEventType.ended then  
        local delete = {}
        if sender:getName() == "Text_gamepermit" then --游戏许可协议
            delete.title = sender:getString()
            delete.url =  ZHISHI_AGREEMENT_URL
        elseif sender:getName() == "Text_net" then -- 网络用户协议
            delete.title = sender:getString()
            delete.url = AGREEMENT_URL
        end
        local SettingLayer = require("lobby.layer.setting.SettingLayerWebView").new(delete)
        self:addChild( SettingLayer)
    end
end

function SettingLayer:Button_openmusicf(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local state = isBackgroundOn
        local pt = nil
        if state == true then
            pt = path..guan 
            isBackgroundOn = false
            userDefault:setIntegerForKey("isBackgroundOn", 0)
            audio.pauseMusic( )
            --audio.pauseMusic()
        else
            userDefault:setIntegerForKey("isBackgroundOn", 1)
            isBackgroundOn = true
            pt = path..kai
            audio.resumeMusic()
            audio.resumeMusic()
            
        end
        sender:loadTextures(pt, pt, pt, 0)  
    end
end

function SettingLayer:Button_opensoundf(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then  

        local state = isEffectOn
        local pt = nil
        if state == true then
            pt = path..guan 
            isEffectOn = false
            userDefault:setIntegerForKey("isEffectOn", 0)
            audio.pauseAllSounds()
            audio.stopAllSounds()
        else
            userDefault:setIntegerForKey("isEffectOn", 1)
            isEffectOn = true
            pt = path..kai
            audio.resumeAllSounds()
        end
        sender:loadTextures(pt, pt, pt, 0)  
    end
end

function SettingLayer:Button_openshockf(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local state = isShockOn
        local pt = nil
        if state == true then
            pt = path..guan 
            isShockOn = false
            userDefault:setIntegerForKey("isShockOn", 0)

            if device.platform == "android" then
                local params = { 1000 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShakeCancel", params, "(I)V")
            elseif device.platform == "ios" then
               -- local state, value = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end
        else
            userDefault:setIntegerForKey("isShockOn", 1)
            isShockOn = true
            pt = path..kai
            if device.platform == "android" then
                local params = { 1000 }
                local state, value = luaj.callStaticMethod(JAVA_SHAKE_CLASSPATH, "gameShake", params, "(I)V")
            elseif device.platform == "ios" then
               -- local state, value = luaoc.callStaticMethod("GetGeneralInfo", "gameShake")
            end

        end
        sender:loadTextures(pt, pt, pt, 0)  
    end
end



function SettingLayer:onback(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.webView then
            self.webView:removeFromParent() 
            self.webView = nil
            return
        end
        self:removeFromParent()
    end
end



return SettingLayer


















