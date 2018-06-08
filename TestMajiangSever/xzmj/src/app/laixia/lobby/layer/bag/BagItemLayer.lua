--
-- Author: Feng
-- Date: 2018-05-05 12:07:42
--
--[[
    大厅主界面层

]]
local BagItemLayer = class("BagItemLayer" ,function()
    return display.newLayer("BagItemLayer")
end)
--[[
    构造函数
]]
function BagItemLayer:ctor()
    self:init()
end

--[[
    初始化
]]
function BagItemLayer:init()
--初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/PopUpLayer.csb")
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.cx,display.cy)
	self:addChild(csbNode)
	self.rootNode = csbNode

    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))

    self.Button_ok = _G.seekNodeByName(self.rootNode,"Button_ok")
    self.Button_ok:addTouchEventListener(handler(self,self.onSure))


end

function BagItemLayer:onSure()
	if eventType == ccui.TouchEventType.ended then  
		
	end
end

function BagItemLayer:()
end

function BagItemLayer:()
end

--[[
    --关闭界面
]]
function BagItemLayer:onBack(sender,eventType)
	if eventType == ccui.TouchEventType.ended then  
		self:removeAllChildren()  
	end
end
return BagItemLayer