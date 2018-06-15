

--[[
    游戏内聊天的itemnode
]]--

local TalkEnjoyNode = class("TalkEnjoyNode", import("...BaseView"))

function TalkEnjoyNode:ctor( delete )
 	TalkEnjoyNode.super.ctor(self)
 	for i = 1,4 do
    	self:InjectView("Button_info"..i)
    	self["Button_info"..i].tag = i
	    self:OnClickForBuilding(self["Button_info"..i], function(node,sender)
	        if not delete:isTouchMoved() then
				print("ssssssssss==============="..sender.tag)            
	        end
	    end,{["isScale"] = false})
 	end
end



function TalkEnjoyNode:render( index )
	-- local index =  math.abs( index - 12 )
	-- 	print("=========="..index)
	local sum = index * 4
	local a = 1
	local fstr = "games/xzmj/talkview/emoji_"
	for i = sum - 4 + 1,sum do
		local name = i
		if i < 10 then
			name = "0"..i
		end
		local pathName = fstr..name..".png"
		self["Button_info"..a]:loadTextures(pathName,pathName,"")
		a = a + 1
	end
end

function TalkEnjoyNode:GetCsbName()
    return "TalkEnjoyNode"
end 

return TalkEnjoyNode

