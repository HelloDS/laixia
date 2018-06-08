--
-- Author: Feng
-- Date: 2018-04-18 11:06:43
--


--[[
  点击游戏右上角的设置界面
]]--
local Poker_Menu = class("Poker_Menu",import("...BaseDialog"))
local pkModel = xzmj.Model.PokerDeskModel
function Poker_Menu:ctor(...)
    Poker_Menu.super.ctor(self)
    self:toShowPopupEffert(1)
    self:setCanceledOnTouchOutside(true)

    self:InjectView("Image_set")
    self:InjectView("Image_rule")
    self:InjectView("Image_robot")
    self:InjectView("Panelbg")

    self:InjectView("Panel_1")

	  self:SetLayoutOpacity(self.Panelbg)
    self:SetLayoutOpacity(self.Panel_1)


  	self:AddWidgetEventListenerFunction(self.Image_set, handler(self, self.setWindow) )
  	self:AddWidgetEventListenerFunction(self.Image_rule, handler(self, self.ruleBtnf) )
    self:AddWidgetEventListenerFunction(self.Image_robot, handler(self, self.robotBtnf))

  	
end

function Poker_Menu:GetCsbName()
    return "Poker_Menu"
end 

--[[ 设置按钮 ]]
function Poker_Menu:setWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print(" --ruleBtnf")
    self:dismiss()
     local SetTips = xzmj.layer.SetTips.new()
     SetTips:Show()
  end
end

--[[ 规则按钮 ]]
function Poker_Menu:ruleBtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" --ruleBtnf ")
        self:dismiss()
        xzmj.MainCommand:InTypeJumpView(9)
    end
end 
--[[ 托管按钮 ]]
function Poker_Menu:robotBtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" --robotBtnf ")
        pkModel.mPlayPoptyTb[2]:setTuoGuan( true )
        self:dismiss()
        ObjectEventDispatch:dispatchEvent( { name = xzmj.evt[3], data = true })
    end
end 

function Poker_Menu:CutNode(data)

end

return Poker_Menu

