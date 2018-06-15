
local FriendItemNode = class("FriendItemNode", import("...BaseView"))

function FriendItemNode:ctor(...)
  FriendItemNode.super.ctor(self)

    self:InjectView("RkinNum")
    self.RkinNum:setString("sssssssss")


end


function FriendItemNode:onInit()
end

function FriendItemNode:GetCsbmemeber( ... )
	return  self.memeber
end


function FriendItemNode:GetCsbName()
    return "FriendItemNode"
end 

function FriendItemNode:resetData()

end 


function FriendItemNode:Closebtn(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" FriendItemNode--Ext ")
    end
end 
function FriendItemNode:CutNode(data)

end

return FriendItemNode

