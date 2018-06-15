

--[[
    麻将牌  左右的出的牌
]]--
local MahjongNodeZYCP = class("MahjongNodeZYCP", xzmj.ui.BaseView)
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig

function MahjongNodeZYCP:ctor(...)
    MahjongNodeZYCP.super.ctor(self)

    self:InjectView("Image_1")
    self:InjectView("Image_2")
         
end

function MahjongNodeZYCP:GetCsbName()
    return "MahjongNodeZYCP"
end 

--[[
    1 左边
    2 右边
]]--
function MahjongNodeZYCP:setStyde( _sty )
	if _sty == 1 then
		self.Image_2:setRotation(90)
    elseif _sty == 2 then
        self.Image_2:setRotation(270)
	end
end


--[[
    获取牌值
]]--
function MahjongNodeZYCP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeSP:GetVal()")
   return -1
end


--[[
    _Pval 牌值
]]--
function MahjongNodeZYCP:UpdateDate( _Pval )
    self.datatb = pkModel:GetSPaiNum( _Pval )
    if self.datatb.mjSty == pkcf.MJSTYLE.TONG then
        self.Image_2:loadTexture(pkcf.TONG_HWPATH..self.datatb.Num..".png")
    elseif self.datatb.mjSty == pkcf.MJSTYLE.TIAO then
        self.Image_2:loadTexture(pkcf.TIAO_HWPATH..self.datatb.Num..".png")
    elseif self.datatb.mjSty == pkcf.MJSTYLE.WAN then
        self.Image_2:loadTexture(pkcf.WAN_HWPATH..self.datatb.Num..".png")
    end
end

return MahjongNodeZYCP

