--[[
    对话框基类
    --data 2018-5-13
    --author zl
]]
local BaseDialog = class("BaseDialog", function()
    return display.newLayer()
end)

function BaseDialog:ctor(csbName, percent)
    if type(csbName) ~= "string" or not cc.FileUtils:getInstance():isFileExist(csbName) then
        return
    end
    local csbNode = cc.CSLoader:createNode(csbName)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode

    if self.onCreate then self:onCreate() end

    _G.adapPanel_root(csbNode, percent)

    local Panel_root = _G.seekNodeByName(self.rootNode, "Panel_root")
    Panel_root:addTouchEventListener(handler(self, self.onBtnTouchEvent))
end

function BaseDialog:onCreate()
--    print("进入对话框需要处理的，派生类自行继承")
end

function BaseDialog:onBtnTouchEvent(sender, event)
    if sender == nil or not sender:isVisible() then
        return
    end

    if event == ccui.TouchEventType.ended then
        self:close()
    end
end

function BaseDialog:onClose()
--    print("退出对话框需要处理的，派生类自行继承")
end

function BaseDialog:close()
    if self.onClose then self:onClose() end
    self:removeFromParent()
end

return BaseDialog