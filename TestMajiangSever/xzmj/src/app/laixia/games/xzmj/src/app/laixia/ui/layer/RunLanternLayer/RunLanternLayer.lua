



local RunLanternLayer = class("RunLanternLayer", import("...BaseView"))

function RunLanternLayer:ctor(...)
    RunLanternLayer.super.ctor(self)
    self:InjectView("ShowText")
    self:InjectView("ShowText_Copy")
    self:InjectView("ScrollView_1")
    if self.ShowText  == nil then

        local Text =  ccui.Text:create()
        Text:setString("11")
        Text:setFontSize(24)
        Text:setPosition(855,29)
        self.ScrollView_1:addChild( Text )
        self.ShowText = Text
    end
    self.ShowTextPosX = 800
    self.ShowText:setPositionX(self.ShowTextPosX)

    self:RunText()



    ObjectEventDispatch:addEventListener(xzmj.evt[1], handler(self, self.onCallBackFunction));


end

function RunLanternLayer:onCallBackFunction( datatext )
    print("onCallBackFunction=============")
    
    self:RunText(datatext.data)
end


function RunLanternLayer:GetCsbName()
    return "RunLanternLayer"
end 

function RunLanternLayer:RunText( text )
    if text == nil or text == "" then
        self.ShowText:setString( "我是跑马灯" )       
    else
        self.ShowText:setString( text )       
    end



    local time = 4
	local act2_1 = cc.MoveTo:create(time, cc.p(0,29))
    local delay = cc.DelayTime:create(0.1)
    local sequence = cc.Sequence:create(act2_1,delay, cc.CallFunc:create(function ( ... )
    	self.ShowText:setPositionX(self.ShowTextPosX)
    end))

	self.ShowText:runAction(cc.RepeatForever:create(sequence))



end



return RunLanternLayer

