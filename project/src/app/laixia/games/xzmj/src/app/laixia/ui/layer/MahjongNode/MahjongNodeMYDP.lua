


--[[
    麻将自己对牌和杠牌节点  用户对牌和杠牌节点
]]--
local MahjongNodeMYDP = class("MahjongNodeMYDP", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig
function MahjongNodeMYDP:ctor( delete )
    MahjongNodeMYDP.super.ctor(self)
    self:InjectView("Image_1")
    self:InjectView("Image_Num")

    for i = 1,4 do
       self:InjectView("Image_"..i)
       self:InjectView("Image_t"..i)
    end

    self:initData()
end

function MahjongNodeMYDP:GetCsbName()
    return "MahjongNodeMYDP"
end



--[[
    获取牌值
]]--
function MahjongNodeMYDP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeMYDP:GetVal()")
   return -1
end

function MahjongNodeMYDP:initData()
	self.mIsChikNum = 0
end


--[[
    _gang
    1 明杠
    2 暗杠
]]--
function MahjongNodeMYDP:UpdateDate( _data, _gang )

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
            self["Image_"..i]:loadTexture(pkcf.AN_GBGPATH)
            self["Image_t"..i]:setVisible(false)
        end
        self["Image_t"..4]:loadTexture(path)
        self["Image_"..4]:setPositionY(14.5)
    end
end



-- 1234 上下左右
function MahjongNodeMYDP:setStyde( _sty )
    if _sty == 2 then
        for i = 1,4 do
            self["Image_t"..i]:setRotation(180)
        end
    end
end


return MahjongNodeMYDP

