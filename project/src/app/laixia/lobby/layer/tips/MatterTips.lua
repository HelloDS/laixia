--
-- Author: Feng
-- Date: 2018-05-13 12:46:52
--

--[[
	文字提示框
	#params table{
		文字
	    类型(1：移动,2：放大)
		}
	--{
	"word" = "tips",
	"w" = 360,
	"h" = "640",
	"type" = 1
	}
]]

local MatterTips = class("MatterTips", function()
	return cc.Node:create() 
end) 

-- local MatterTips = class("MatterTips" ,function()
--     return display.newLayer("MatterTips")
-- end)

function MatterTips:ctor( ... )
	self:init(...)
end

function MatterTips:init( ... )
	-- self.data = ...
	self.data = ...
	self:action1()
end

function MatterTips:action1()

	local sprite_di = display.newSprite("new_ui/LobbyScene/middle/guangbo.png")
	self:addChild(sprite_di)	
	local size = sprite_di:getContentSize()

	local label1 = cc.Label:createWithSystemFont(self.data.message, "Arial", 24)  
    label1:setPosition(cc.p(size.width/2, size.height/2))  
    sprite_di:addChild(label1, 1)

	sprite_di:setVisible(true)
	if self.data.type_ == 1 then
		sprite_di:setPosition(cc.p(0,0))
		local move = cc.MoveTo:create(0.3,cc.p(self.data.w,self.data.h+100))
		local fade = cc.FadeIn:create(1)
		local callfun = cc.CallFunc:create(function()
			self:destroy()
			end)
		local seq = cc.Sequence:create(move,fade,callfun)
		self:runAction(seq)
	elseif self.data.type_ == 2 then
		-- sprite_di:setPosition(cc.p(display.width,self.data.h))
		-- local move = cc.MoveTo:create(3,cc.p(self.data.w,self.data.h))
		-- local fade = cc.FadeIn:create(3)
		-- local callfun = cc.CallFunc:create(self:destroy())
		-- local seq = cc.Sequence:create(move,fade,callfun)
		-- self:runAction(seq)
	elseif self.data.type_ == 3 then
		-- sprite_di:setPosition(cc.p(self.data.w,self.data.h))
		-- local scale_big = cc.ScaleTo:create(3,1.2)
		-- local scale_small = cc.ScaleTo:create(3,1)
		-- local callfun = cc.CallFunc:create(self:destroy())
		-- local seq = cc.Sequence:create(scale_big,scale_small,callfun)
		-- self:runAction(seq)
	end
end

function MatterTips:destroy()
	self:removeAllChildren()
end

return MatterTips