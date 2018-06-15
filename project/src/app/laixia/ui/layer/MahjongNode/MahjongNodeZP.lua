


--[[
    玩家左右自己的牌
]]--
local MahjongNodeZP = class("MahjongNodeZP", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig
function MahjongNodeZP:ctor( delete )
    MahjongNodeZP.super.ctor(self)
    self:InjectView("Image_2")
    self.delete = delete
end

function MahjongNodeZP:GetCsbName()
    return "MahjongNodeZP"
end


function MahjongNodeZP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeZP:GetVal()")
   return -1
end

function MahjongNodeZP:UpdateDate( _data, _gang )

    self.datatb = pkModel:GetSPaiNum( _data )

end
--[[
]]--
function MahjongNodeZP:loadPStyde( _st )
    if _st == 1 then
        self.Image_2:loadTexture("games/xzmj/Mahjong/you.png")
    elseif _st == 2 then
        self.Image_2:loadTexture("games/xzmj/Mahjong/bei.png")
    end
end


return MahjongNodeZP

