
local TPRoomLevelDown = class("TPRoomLevelDown", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg; 

function TPRoomLevelDown:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end
function TPRoomLevelDown:getName()
    return "TPRoomLevelDown"
end

function TPRoomLevelDown:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_ROOMDEMOTE_WINDOW, handler(self, self.show))
end
function TPRoomLevelDown:onShow(msg)
    self:GetWidgetByName("RoomIndinside_Label_World"):setString("亲，您当前的"..lobby.utilscfg.CoinType().."不够"..msg.data.."浪了\n请前往低级场")
    self:AddWidgetEventListenerFunction("RoomInside_Button_GoLower", handler(self, self.onContinue))
    self:AddWidgetEventListenerFunction("RoomInside_Button_supplement", handler(self, self.onSupplement))
end 

function TPRoomLevelDown:onSupplement(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW) 
        self:destroy()
        -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_INCREASEGOLD_WINDOW)        
    end
end


function TPRoomLevelDown:onContinue(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CONTINUE_LANDLORDTABLE_WINDOW)
    end  
end


return TPRoomLevelDown.new()
