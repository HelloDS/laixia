local DebuggerLayer =  class("DebuggerLayer", import("...BaseView"))

function DebuggerLayer:ctor()
    DebuggerLayer.super.ctor(self)

    self.layout = ccui.Layout:create()
    local winSize = cc.Director:getInstance():getWinSize()
    self.layout:setContentSize(winSize.width, winSize.height)
    self.layout:setBackGroundColor(cc.c4b(0,0,0,125))    -- 填充颜色
    self.layout:setBackGroundColorType(1)              -- 填充方式
    self.layout:setBackGroundColorOpacity(100)         -- 颜色透明度
    self.layout:setTouchEnabled(true)
    self:addChild(self.layout, -1)
    
    -- 点击透明区域可关闭
    self:OnClick(self.layout, function()
        print("eeeeerr")
        self:setVisible(false)
        self.totalMesg = ""
    end,{["isScale"] = false, ["hasAudio"] = false})


    self:InjectView("contentTxt")
    
    self.contentTxt:ignoreContentAdaptWithSize(false); 
    self.contentTxt:setContentSize(1000,600)


    self.totalMesg = ""
    self:setVisible(false)
end
function DebuggerLayer:GetCsbName()
    return "DebuggerLayer"
end
function DebuggerLayer:showBugMesg(mesg)
    self:setVisible(true)
    self.totalMesg = self.totalMesg..tostring(mesg).."\n"
    self.contentTxt:setString(self.totalMesg)
end

return DebuggerLayer
