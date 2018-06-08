

--[[
    牌桌里面得东南西北动画
]]--
local Poker_wind = class("Poker_wind", xzmj.ui.BaseView)
local pkcf = xzmj.layer.PokerDeskConfig
local pkModel = xzmj.Model.PokerDeskModel

function Poker_wind:ctor(...)
    Poker_wind.super.ctor(self)

    self:InjectView("FWNodeS")
    self:InjectView("FWNodeX")
    self:InjectView("FWNodeZ")
    self:InjectView("FWNodeY")
    self:InjectView("ShengYuText")
    self:InjectView("DiText")
    self:InjectView("Image_middle_4")

    self.ShengYuText:setVisible(false)
    self.DiText:setVisible(false)


    self.dataTable = 
    {
        self.FWNodeS,
        self.FWNodeX,
        self.FWNodeZ,
        self.FWNodeY,

    }


    for k,v in pairs(self.dataTable) do
        self.dataTable[k]:setPosition(0,0)
    end

   self:initSeatAc()

   self:initText()
end

function Poker_wind:GetCsbName()
    return "Poker_wind"
end 



function Poker_wind:initSeatAc( ... )
    self.mSeatACtb = {}
    for i = 1,4 do
        self.mAcnode = self:playAnimationAt( self.dataTable[i],pkcf.SEATSTY[ i ] )
        table.insert(self.mSeatACtb,self.mAcnode)
        self.mAcnode:setVisible(false)

    end
end


function Poker_wind:UpdateDate(  )

    self.ShengYuText:setString( #pkModel.mSYGbValTb )

end

--[[

]]--
function Poker_wind:UpdateAcStyle( _Style )
    if _Style > 4  or _Style <= 0 then
        print("--------error---Poker_wind:UpdateAcStyle")
    end
    for i = 1,4 do
        self.mSeatACtb[i]:setVisible(false)
    end
    self.mSeatACtb[ _Style ]:setVisible(true)

    self.DjsTimeText:stopAllActions()
    local sum = 10
    self.DjsTimeText:setString( sum )
    local delay = cc.DelayTime:create(1)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(function( )
        sum = sum - 1 
        if sum <= 0 then
            self.DjsTimeText:stopAllActions()
        end
        self.DjsTimeText:setString( sum )
    end))
    self.DjsTimeText:runAction(cc.RepeatForever:create(sequence))

end



function Poker_wind:initText()

    local label = display.newBMFontLabel({
        text = "0",
        font = "Font/1.fnt",
    })
    label:setPosition(self.ShengYuText:getPosition())
    self:addChild( label )
    self.ShengYuText = label  



    local label = display.newBMFontLabel({
        text = "0",
        font = "Font/1.fnt",
    })
    label:setPosition(self.DiText:getPosition())
    self:addChild( label )  
    self.DiText = label  



    local label = display.newBMFontLabel({
        text = "0",
        font = "Font/1.fnt",
    })
    label:setPosition(self.Image_middle_4:getPosition())
    self:addChild( label )  
    self.DjsTimeText = label  



end

return Poker_wind

