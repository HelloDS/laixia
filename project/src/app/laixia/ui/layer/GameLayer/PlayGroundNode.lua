--
-- Author: Feng
-- Date: 2018-04-17 15:11:28
--
--
-- Author: Feng
-- Date: 2018-04-13 10:14:49
--


local PlayGroundNode = class("PlayGroundNode", import("...BaseView"))

function PlayGroundNode:ctor(...)
    PlayGroundNode.super.ctor(self)
    self:init()
end

function PlayGroundNode:init()
	self:onShow()
end

function PlayGroundNode:onShow()
	self:InjectView("Button_close")
	self:AddWidgetEventListenerFunction(self.Button_close, handler(self,self.backGameLayer))
end

function PlayGroundNode:backGameLayer(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
        self:dismiss()
    end
end

function PlayGroundNode:GetCsbName(  )
    return "PlayGroundNode"
end

function PlayGroundNode:destroy()
end 

return PlayGroundNode
