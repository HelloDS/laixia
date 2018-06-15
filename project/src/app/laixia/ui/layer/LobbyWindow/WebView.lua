local laixia = laixia
local soundConfig =  laixia.soundcfg
local WebView = class("WebView", function()
    return cc.Layer:create()
end)

function WebView:ctor(url)
    self.url = url
    local function onNodeEvent(event)
        if "enter" == event then
            self:onEnter()
        elseif "exit" == event then
            self:onExit()
        end
    end

    self:registerScriptHandler(onNodeEvent)
    self.layer = cc.Layer:create()
    self:addChild(self.layer,1)

    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:loadTextures("closebutton.png", "", "", 1)
    button:setPosition(display.width - button:getContentSize().width / 2, display.height - button:getContentSize().height / 2)
    self:addChild(button,10000)
    laixia.soundTools:pauseMusic()
    button:addTouchEventListener(function(sender,eventtype)
        if eventtype == ccui.TouchEventType.began then
            laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        elseif eventtype == ccui.TouchEventType.ended then 
            laixia.soundTools:resumeMusic()   
            self:removeFromParent()
        end
    end)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function(touch, event)

        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(touch, event)
    end, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(touch, event)
    end, cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function WebView:onEnter()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()  
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) then  
        self.webView = ccexp.WebView:create()
        self.layer:addChild(self.webView,1)
        self.webView:setVisible(true)
        self.webView:setScalesPageToFit(true)
        self.webView:setContentSize(cc.size(display.width,display.height)) -- 一定要设置大小才能显示
        self.webView:setPosition(display.cx,display.cy)
        self.webView:setJavascriptInterfaceScheme("lua")
        self.webView:loadURL(self.url)

        self.webView:setOnJSCallback(function(sender, message)--setOnJSCallback
            if message == "lua://close" then
                self.webView:setVisible(false)
                laixia.soundTools:resumeMusic()   
                self:removeFromParent()
            end

        end)
    end

end


function WebView:onExit()

end


return WebView