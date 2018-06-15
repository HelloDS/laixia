
--[[
	比赛赛制的node
]]--


local MatchInstitutionNode = class("MatchInstitutionNode", import("...BaseView"))
function MatchInstitutionNode:ctor(...)
    MatchInstitutionNode.super.ctor(self)
    self:InjectView("MiaoShuText")
end

function MatchInstitutionNode:init()


end


function MatchInstitutionNode:GetCsbName()
    return "MatchInstitutionNode"
end


function MatchInstitutionNode:UpdateDate(data) 
	self.MiaoShuText:setString("ss")
end 


return MatchInstitutionNode

