--
-- Author: Feng
-- Date: 2018-04-17 17:44:04
--
local DefaultLayer = class("DefaultLayer", xzmj.ui.BaseDialog)

function DefaultLayer:GetCsbName()
    return "weedoutlayer"
end 

function DefaultLayer:ctor(...)
   DefaultLayer.super.ctor(self)

    self:InjectView("Button_back")
    self:InjectView("Button_share")

	self:AddWidgetEventListenerFunction(self.Button_back, handler(self,self.closeWindow))
	self:AddWidgetEventListenerFunction(self.Button_share, handler(self, self.shareWindow))
    self:setCanceledOnTouchOutside(true)

  	self:toShowPopupEffert(2)
end

function DefaultLayer:shareWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
     print("share_____")
  end
end

function DefaultLayer:closeWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print("close DefaultLayer")
    self:dismiss()
  end
end


function DefaultLayer:CutNode(data)

end

return DefaultLayer

