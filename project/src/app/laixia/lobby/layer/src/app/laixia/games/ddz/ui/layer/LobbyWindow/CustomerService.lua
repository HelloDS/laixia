
local CustomerService = class("CustomerService", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;  

function CustomerService:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function CustomerService:getName()
    return "CustomerService"
end

function CustomerService:onInit()
    self.super:onInit(self)
    
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_COMPLAIN_WINDOW, handler(self, self.show))
end

function CustomerService:onShow()

    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_SETUP_WINDOW);
    self:AddWidgetEventListenerFunction("Button_ComplaintWindow_Quit", handler(self, self.ShutDown))

end

function CustomerService:ShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        print("this is button shutdown")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end


return CustomerService.new()

