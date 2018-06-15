


--[[
    麻将牌  用户自己的手牌
]]--
local MahjongNodeSP = class("MahjongNodeSP", import("...BaseView"))
local pkModel = xzmj.Model.PokerDeskModel
local pkcf = xzmj.layer.PokerDeskConfig
function MahjongNodeSP:ctor( delete )
    MahjongNodeSP.super.ctor(self)
    self:InjectView("Image_1")
    self:InjectView("Image_Num")

    self:setScale(0.95)

    self:OnClick(self.Image_1, function()
    	
        pkModel:SetMySt(pkcf.MYSTATE.KECAOZUO)
        if pkModel:GetMySt() == pkcf.MYSTATE.XPZ then
            if self.mIsXuanPai == true then
                self:UnChickXuanPai()
            else
                self:ChickXuanPai()
            end
            return
        end



        pkModel:UpdateMySPTbpos()
    	self.mIsChikNum = self.mIsChikNum + 1
    	if self.mIsChikNum >= 2 then
            if pkModel:GetMySt() == pkcf.MYSTATE.KECAOZUO then
                self:ChickChuPai()
            end
            self.mIsChikNum = 0
            return
    	end
        self:setPositionY( self:getPositionY()+30 )
    	
    end,{["isScale"] = false, ["hasAudio"] = false})

    self:initData()
end

function MahjongNodeSP:GetCsbName()
    return "MahjongNodeSP"
end

--[[
    被点击后触发出牌
]]--
function MahjongNodeSP:ChickChuPai()
    pkModel:ChuPai(self)
end


function MahjongNodeSP:getIndex()
    if self.Index then
        return self.Index
    end
    return 0
end

--[[
    获取牌值
]]--
function MahjongNodeSP:GetVal()
   if self.datatb and self.datatb.Num then
        return self.datatb.Num
   end
   print("------error------..MahjongNodeSP:GetVal()")
   return -1
end

function MahjongNodeSP:SetTouchEnabled( is )
    self:setTouchEnabled(is)
    self.Image_1:setTouchEnabled(is)
end


function MahjongNodeSP:initData()
	self.mIsChikNum = 0
    self.mIsXuanPai = false
end

--[[
    被选牌
]]--
function MahjongNodeSP:ChickXuanPai()
    self.mIsXuanPai = true
    self.mIsChikNum = 1
    self:setPositionY( self:getPositionY()+30 )
end
--[[
    去掉当前选牌状态
]]--
function MahjongNodeSP:UnChickXuanPai()
    self.mIsXuanPai = false
    self.mIsChikNum = 0
    self:setPositionY( self:getPositionY()-30 )
end


--[[
    玩家定缺类型等于现在的类型 就置灰
]]--
function MahjongNodeSP:ZhiHui( _type  )

    if _type == nil or _type > 3 then
        return
    end
    if self.datatb.mjSty == _type then
        local sum = pkcf.SPZHIHUI
        self.Image_1:setColor(cc.c3b(sum, sum, sum))
    end
end


function MahjongNodeSP:UpdateDate( _data )

    self.Image_1:setColor(cc.c3b(255, 255, 255))


    self.datatb = pkModel:GetSPaiNum( _data )
    if self.datatb.mjSty == pkcf.MJSTYLE.TONG then

        self.Image_Num:loadTexture(pkcf.TONG_HWPATH..self.datatb.Num..".png")

    elseif self.datatb.mjSty == pkcf.MJSTYLE.TIAO then

        self.Image_Num:loadTexture(pkcf.TIAO_HWPATH..self.datatb.Num..".png")
    
    elseif self.datatb.mjSty == pkcf.MJSTYLE.WAN then

        self.Image_Num:loadTexture(pkcf.WAN_HWPATH..self.datatb.Num..".png")
    end
end


return MahjongNodeSP

