local RechargeTip = class("RechargeTip",import("...BaseDialog"))

function RechargeTip:ctor(...)
   RechargeTip.super.ctor(self)

    self:InjectView("quxiaoBtn")
    self:InjectView("zhifuBtn")
    self:InjectView("closebtn")
	self:setCanceledOnTouchOutside(true)

  	self:AddWidgetEventListenerFunction(self.quxiaoBtn, handler(self, self.quxiaoBtnf) )
  	self:AddWidgetEventListenerFunction(self.zhifuBtn, handler(self, self.zhifuBtnf) )
    self:AddWidgetEventListenerFunction(self.closebtn, handler(self, self.closeWindow))

  	self:toShowPopupEffert(2)
end




function RechargeTip:GetCsbName()
    return "RechargeTip"
end 

function RechargeTip:closeWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print("close RechargeTip")
    self:dismiss()
  end
end

function RechargeTip:quxiaoBtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" quxiaoBtn--Ext ")
        self:dismiss()
    end
end 

function RechargeTip:zhifuBtnf(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        print(" zhifuBtn--Ext ")
    end
end 

function RechargeTip:CutNode(data)

end

return RechargeTip

