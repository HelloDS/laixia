


--[[
    麻将自己对牌和杠牌节点  用户对牌和杠牌节点
]]--
local MahjongNodeZYDP = class("MahjongNodeZYDP", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig

function MahjongNodeZYDP:ctor(...)
    MahjongNodeZYDP.super.ctor(self)
    self:InjectView("Image_1")
    self:InjectView("Image_Num")

    for i = 1,4 do
       self:InjectView("Image_"..i)
       self:InjectView("Image_t"..i)
    end
    self:setScale(pkcf.ZYDPSCALE)
end

function MahjongNodeZYDP:GetCsbName()
    return "MahjongNodeZYDP"
end

--[[
    获取牌值
]]--
function MahjongNodeZYDP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeSP:GetVal()")
   return -1
end
--[[
    _gang
    1 明杠
    2 暗杠
]]--
function MahjongNodeZYDP:UpdateDate( _data, _gang )

    local sum = 3
    if _gang == nil or _gang == 0 then
        _gang = 0
    elseif _gang  then
        sum = 4
    end

    self.datatb = pkModel:GetSPaiNum( _data )

    local path = nil
    if self.datatb.mjSty == pkcf.MJSTYLE.TONG then

        path = pkcf.TONG_HWPATH..self.datatb.Num..".png"

    elseif self.datatb.mjSty == pkcf.MJSTYLE.TIAO then

         path = pkcf.TIAO_HWPATH..self.datatb.Num..".png"
    
    elseif self.datatb.mjSty == pkcf.MJSTYLE.WAN then

        path = pkcf.WAN_HWPATH..self.datatb.Num..".png"
    end

    for i = 1 ,sum do
        self["Image_t"..i]:loadTexture(path)
    end
    if _gang == 0 then
        self["Image_"..4]:setVisible(false)
    elseif _gang == 1 then
        self["Image_"..4]:setVisible(true)
        self["Image_t"..4]:loadTexture(path)
    elseif _gang == 2 then
        for i = 1,3 do
            self["Image_"..i]:loadTexture(pkcf.ZYANGANGPATH)
            self["Image_t"..i]:setVisible(false)
        end
        self["Image_t"..4]:loadTexture(path)
        self["Image_"..4]:setPositionY(14.5)
    end
end



-- 1 是左边
-- 2是右边
function MahjongNodeZYDP:setStyde( _sty )
    local rosum = 0
    if _sty == 2 then
        rosum = 270
    elseif _sty == 1 then
        rosum = 90
    end
    for i = 1,4 do
        self["Image_t"..i]:setRotation(rosum)
    end

end



return MahjongNodeZYDP

