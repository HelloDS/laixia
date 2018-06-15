--
-- Author: Feng
-- Date: 2018-05-04 20:57:25
--
local activityLayer = import(".ActivityLayer")
local activityNode = import(".ActivityNode")

local ActivityManager = class("ActivityManager" ,function()
    return display.newLayer("ActivityManager")
end)

function ActivityManager:ctor()
	self:init()
end

function ActivityManager:init()
	--导入node csb
	local csbNode_button = cc.CSLoader:createNode("new_ui/ActivityNode.csb")
	csbNode_button:setAnchorPoint(0.5, 0.5)
	csbNode_button:setPosition(display.cx,display.cy)
	self:addChild(csbNode_button)
	self.rootNode_button = csbNode_button
	self.rootNode_button:addTouchEventListener(handler(self,self.changePage))

	--导入layer csb 
	local csbNode = cc.CSLoader:createNode("new_ui/ActivityLayer.csb")
	csbNode:setAnchorPoint(0.5, 0.5)
	csbNode:setPosition(display.cx,display.cy)
	self:addChild(csbNode)
	self.rootNode = csbNode

	self.ListView_Acctivity_Button = _G.seekNodeByName(self.rootNode,"ListView_Acctivity_Button")
end

function ActivityManager:changePage(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		--切换page
	end
end

return ActivityManager