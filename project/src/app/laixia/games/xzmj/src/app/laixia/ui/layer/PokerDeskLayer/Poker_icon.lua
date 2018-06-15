--
-- Author: Feng
-- Date: 2018-04-18 11:39:44
--



local Poker_icon = class("Poker_icon", import("...BaseView"))
local pkcf = xzmj.layer.PokerDeskConfig

function Poker_icon:ctor( data )
    Poker_icon.super.ctor(self)
    self:InjectView("Image_icon")
    self:InjectView("Image_lack")
    self:InjectView("Text_gold")
    self:InjectView("ZhuangText")
    self.ZhuangText:setVisible( false )
    self.mData = data
    self:AddWidgetEventListenerFunction(self.Image_icon,handler(self,self.GotoPersonCenter))

    self.Image_lack:setVisible( false )



    self:UpdateDate()

end

function Poker_icon:GetCsbName()
    return "Poker_icon"
end

--[[
    
]]--
function Poker_icon:UpdateDate( _data )
    self.Text_gold:setString(_data.goldnum)
end

function Poker_icon:UpdateDateIcon( _index )

    if _index <= 0 or _index >=4 then
        return
    end
    local pathtb = { "tong","tiao","wan" }
    self.Image_lack:setVisible( true )
    self.Image_lack:loadTexture(pkcf.TTWICONPATH..pathtb[_index]..".png")

end

--[[
   把庄的字体亮出来
]]--
function Poker_icon:ShowZhuangText(  )
    self.ZhuangText:setVisible( true )
end
--
function Poker_icon:UpdateDate(  )
    local da = self.mData
    self.Image_icon:loadTexture( "games/xzmj/common/headimage/ic_morenhead"..da.icon..".png"  )
    self.Image_icon:setContentSize(70,68)
    self.Text_gold:setString( da.jinbi )
end



function Poker_icon:GotoPersonCenter(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("点击返回按钮")
        local personcenter = xzmj.layer.Poker_PersonCenter.new(self.mData.seat)        
        personcenter:Show()
    end
end 

function Poker_icon:Closebtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      
    end
end 


return Poker_icon

