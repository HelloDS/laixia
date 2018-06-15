



local SettingLayerWebView = class("SettingLayerWebView" , function()
        return display.newLayer()
    end)

function SettingLayerWebView:ctor(delete)
    self.delete = delete
    self:init()
end


function SettingLayerWebView:init()
    local csbNode = cc.CSLoader:createNode("new_ui/SettingLayerWebView.csb")
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode
    _G.adapPanel_root(csbNode)

    self.Panel_middle = _G.seekNodeByName(self.rootNode,"Panel_middle")
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Panel_dialog = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self, self.onback))
    self.Panel_webview = _G.seekNodeByName(self.rootNode,"Panel_webview")
    self.Text_title = _G.seekNodeByName(self.rootNode,"Text_title")
    self.mWebviewSize = self.Panel_webview:getContentSize()


    if device.platform == "ios" then
      self:OpenWebView( self.delete.url )
    elseif device.platform == "android" then
      self:OpenWebView( self.delete.url )
    elseif device.platform == "windows"  then
    
    end

    self.Text_title:setString(self.delete.title)


end
 
--[[
  打开一个webview
]]--
function SettingLayerWebView:OpenWebView( url )

    self.Panel_webview:setBackGroundColor(cc.c4b(0,0,0,255))    -- 填充颜色
    self.Panel_webview:setBackGroundColorType(ccui.LayoutBackGroundColorType.none)              -- 填充方式
    self.Panel_webview:setBackGroundColorOpacity(100)         -- 颜色透明度
    
    self.webView = ccexp.WebView:create()
    self.webView:loadURL(url)
    self.webView:setVisible(true)
    self.webView:setContentSize(self.Panel_webview:getContentSize()) -- 一定要设置大小才能显示
    self.webView:setScalesPageToFit(true)
    self.webView:setAnchorPoint(0,0)
    self.Panel_webview:addChild( self.webView ) 
end


function SettingLayerWebView:onback(sender,eventType)
     _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:removeFromParent()
    end
end



return SettingLayerWebView


















