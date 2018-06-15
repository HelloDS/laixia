



-- import(".BaseView"))
local GameTextTips = class("GameTextTips", xzmj.ui.BaseDialog )

function GameTextTips:ctor( detele )
   GameTextTips.super.ctor(self)

    self:InjectView("Text_des")
    self:InjectView("Button_effect_on")
    self:InjectView("Button_music_on")
    self:InjectView("Button_shake_on")



   



	self:setCanceledOnTouchOutside(true)

end




function GameTextTips:GetCsbName()
    return "GameTextTips"
end 


function GameTextTips:UpdateText( text )
	self.Text_des:setString( "text" )
end


return GameTextTips

