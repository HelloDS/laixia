--
-- Author: Feng
-- Date: 2018-04-19 18:13:08
--
--
-- Author: Feng
-- Date: 2018-04-18 11:39:44
--



local Poker_talk = class("Poker_talk", xzmj.ui.BaseDialog)

function Poker_talk:ctor( data )
    Poker_talk.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self:toShowPopupEffert(2)
   
end

function Poker_talk:GetCsbName()
    return "talklayer"
end

function Poker_talk:GotoPersonCenter(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("点击返回按钮")
      
    end
end 

function Poker_talk:Closebtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      
    end
end 


return Poker_talk

