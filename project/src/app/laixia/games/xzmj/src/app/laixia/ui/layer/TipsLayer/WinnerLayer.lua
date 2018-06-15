--
-- Author: Feng
-- Date: 2018-04-17 17:43:41
--
local WinnerLayer = class("WinnerLayer",import("...BaseDialog"))

function WinnerLayer:GetCsbName()
    return "WinnerLayer"
end 

function WinnerLayer:ctor(...)
  WinnerLayer.super.ctor(self)
  self:init()
end

function WinnerLayer:init()
  --------初始化变量--------
  self:onShow()
end

function WinnerLayer:onShow()
  --------初始化界面--------
  self:setCanceledOnTouchOutside(true)
  self:toShowPopupEffert(2)

  self:InjectView("Button_back")
  self:InjectView("Button_share")
  self:AddWidgetEventListenerFunction(self.Button_back, handler(self,self.closeWindow))
  self:AddWidgetEventListenerFunction(self.Button_share, handler(self, self.shareWindow))
end


function WinnerLayer:shareWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
     print("share_____")
  end
end

function WinnerLayer:closeWindow(sender, eventType)
  if eventType == ccui.TouchEventType.ended then
    print("close WinnerLayer")
    self:dismiss()
  end
end


function WinnerLayer:CutNode(data)
end

return WinnerLayer

