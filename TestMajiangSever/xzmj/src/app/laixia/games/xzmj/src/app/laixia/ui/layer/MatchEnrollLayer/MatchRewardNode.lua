

--[[
	比赛奖励的node
]]--


local MatchRewardNode = class("MatchRewardNode", import("...BaseView"))
function MatchRewardNode:ctor(...)
    MatchRewardNode.super.ctor(self)
    self:InjectView("MiaoShuText")
    self:InjectView("RkImage")
end

function MatchRewardNode:init()


end


function MatchRewardNode:GetCsbName()
    return "MatchRewardNode"
end


function MatchRewardNode:UpdateDate(data) 
	self.MiaoShuText:setString("ss")
	self.RkImage:loadTexture("")
end 


return MatchRewardNode

