


local RuleTips = class("RuleTips",import("...BaseDialog"))

function RuleTips:ctor(...)
   RuleTips.super.ctor(self)

   self:InjectView("Button_close")
	 self:setCanceledOnTouchOutside(true)

   self:AddWidgetEventListenerFunction(self.Button_close, handler(self, self.closeWindow))

   self:toShowPopupEffert(2)
end




function RuleTips:GetCsbName()
    return "RuleTips"
end 

function RuleTips:closeWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print("close RuleTips")
    self:dismiss()
  end
end

return RuleTips

