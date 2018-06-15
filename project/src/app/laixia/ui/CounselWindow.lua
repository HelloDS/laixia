--
-- Author: peter
-- Date: 2017-12-19 15:50:17
--
local CounselWindow = class("CounselWindow", import(".CBaseDialog"):new())

function CounselWindow:ctor()
	self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
end

function CounselWindow:getName()
    return "CounselWindow"
end

function CounselWindow:onInit()
	self.super:onInit(self)
	ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_COUNSEL_WINDOW, handler(self, self.show))
end

function CounselWindow:onShow()
	self.Text_3 = self:GetWidgetByName("Text_3")
	self.Text_3:performWithDelay(handler(self,self.showloading),3);

end

function CounselWindow:showloading()
	ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LOADIN_WINDOW)
end

return CounselWindow