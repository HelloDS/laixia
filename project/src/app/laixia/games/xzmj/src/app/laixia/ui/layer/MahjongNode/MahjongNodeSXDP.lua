--
-- Author: Feng
-- Date: 2018-04-18 11:06:43
--


--[[
    麻将牌  上下的出牌
]]--
local MahjongNodeSXDP = class("MahjongNodeSXDP", xzmj.ui.BaseView)
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig

function MahjongNodeSXDP:ctor( data)
    MahjongNodeSXDP.super.ctor(self)

    self:InjectView("Image_1")
    self:InjectView("Image_2")
    self:InjectView("Image_robot")
    self:InjectView("Panelbg")
	  	
end

function MahjongNodeSXDP:GetCsbName()
    return "MahjongNodeSXDP"
end 

--
function MahjongNodeSXDP:setStyde( _sty )
	if _sty == 1 then
		self.Image_2:setRotation(180)
	end
end

--[[
    获取牌值
]]--
function MahjongNodeSXDP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeSP:GetVal()")
   return -1
end

--[[
    _Pval 牌值
]]--
function MahjongNodeSXDP:UpdateDate( _Pval )
    self.datatb = pkModel:GetSPaiNum( _Pval )
    if self.datatb.mjSty == pkcf.MJSTYLE.TONG then
        self.Image_2:loadTexture(pkcf.TONG_HWPATH..self.datatb.Num..".png")
    elseif self.datatb.mjSty == pkcf.MJSTYLE.TIAO then
        self.Image_2:loadTexture(pkcf.TIAO_HWPATH..self.datatb.Num..".png")
    elseif self.datatb.mjSty == pkcf.MJSTYLE.WAN then
        self.Image_2:loadTexture(pkcf.WAN_HWPATH..self.datatb.Num..".png")
    end
end


return MahjongNodeSXDP

