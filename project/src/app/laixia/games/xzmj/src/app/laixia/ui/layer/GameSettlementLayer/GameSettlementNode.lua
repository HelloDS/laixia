



local GameSettlementNode = class("GameSettlementNode", import("...BaseView"))
local pkcf = xzmj.layer.PokerDeskConfig

function GameSettlementNode:ctor(...)
 	GameSettlementNode.super.ctor(self)
    self:InjectView("Text_fanshu")
    self:InjectView("Text_pl")
    self:InjectView("Text_addcoin")
end

function GameSettlementNode:UpdateDate( data )
    self.Text_pl:setString(pkcf.ENDHUPTEXT[data.SettlementOptype])
    self.Text_fanshu:setString(data.fanshu)
    local fuhao = "-"
    if data.addcoinnum >= 0 then
        fuhao = "+"
    end 
    self.Text_addcoin:setString( fuhao..data.addcoinnum )
end

function GameSettlementNode:GetCsbName()
    return "GameSettlementNode"
end 

return GameSettlementNode

