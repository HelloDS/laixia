



--[[
    点击玩家头像的弹窗
]]--

local Poker_PersonCenter = class("Poker_PersonCenter",import("...BaseDialog"))

function Poker_PersonCenter:ctor( data )
    Poker_PersonCenter.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:toShowPopupEffert(1)
    self.mPopStyle = data

    self:InjectView("Panelbg")
    self:InjectView("Panel_1")
    self:InjectView("Image_head")
    self:InjectView("Text_name")
    self:InjectView("Text_gold_num")
    self:InjectView("Text_win")
    self:InjectView("Text_winner")
    self:InjectView("Image_sex")


    self:SetLayoutOpacity(self.Panelbg)
    self:SetLayoutOpacity(self.Panel_1)

    self:SetPopStyle()
end



--[[
    根据上下左右设置不同的位置
    type   1  2   3    4
          上  下  左   右
]]--
function Poker_PersonCenter:SetPopStyle( _pos )
    local typePos = 
    {
        [1] = cc.p( 550.31,500.00 ),
        [2] = cc.p( 39.33,83.00 ),
        [3] = cc.p( 39.33,384.00 ),
        [4] = cc.p( 760.33,345 )
    }
    local sty = self.mPopStyle
    sty = sty or _pos
    if sty >= 1  then
        self.Panelbg:setPosition( typePos[sty] )
    end
end



function Poker_PersonCenter:GetCsbName()
    return "Poker_PersonCenter"
end

function Poker_PersonCenter:GotoPersonCenter(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("点击返回按钮")
        
    end
end 

function Poker_PersonCenter:Closebtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      
    end
end 
--[[
{
    name = "sss" 名字
    sex = "sss"   性别
    gold_num = 8888 金币数量
    head = "xxx.png" 头像
    win = 9999  赢得场数
    loser = 8888 输得场数
    winner = 5555 比赛冠军数量

}
]]
function Poker_PersonCenter:UpdateDate( _data )
    if _data == nil then
        print("=====error=====Poker_PersonCenter:UpdateDate====")
        return
    end

    -- self.Image_head:loadTexture()
    -- self.Text_name:setString()
    -- self.Text_gold_num::setString()
    -- self.Text_win:setString()
    -- self.Text_winner:setString()

end

return Poker_PersonCenter

