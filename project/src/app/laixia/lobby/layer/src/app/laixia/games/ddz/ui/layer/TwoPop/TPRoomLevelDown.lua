
local TPRoomLevelDown = class("TPRoomLevelDown", import("...CBaseDialog"):new())-- 
local l_PacketObj = import("....net.Packet") 
local soundConfig = laixiaddz.soundcfg; 

function TPRoomLevelDown:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end
function TPRoomLevelDown:getName()
    return "TPRoomLevelDown"
end

function TPRoomLevelDown:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_ROOMDEMOTE_WINDOW, handler(self, self.show))
end
function TPRoomLevelDown:onShow(msg)
    self.msg = msg
    self:GetWidgetByName("RoomIndinside_Label_World"):setString("亲，您当前的"..laixia.utilscfg.CoinType().."不够"..self.msg.data[1].."浪了\n请前往低级场")
    self:AddWidgetEventListenerFunction("RoomInside_Button_GoLower", handler(self, self.onContinue))
    self:AddWidgetEventListenerFunction("RoomInside_Button_supplement", handler(self, self.onSupplement))
    --离开
    self:AddWidgetEventListenerFunction("Button_tuichu", handler(self, self.onExit))
end 

function TPRoomLevelDown:onSupplement(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SHOP_WINDOW) 
        self:destroy()
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_INCREASEGOLD_WINDOW)        
    end
end


function TPRoomLevelDown:onContinue(sender, event)
    if (event == ccui.TouchEventType.ended) then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CONTINUE_LANDLORDTABLE_WINDOW)
    end  
end

function TPRoomLevelDown:onExit(sender, event)
    if (event == ccui.TouchEventType.ended) then
        self:GameSendLeaveRoomFunction()
    end
end

--发--送--离开--房间消息
function TPRoomLevelDown:GameSendLeaveRoomFunction()
    local packet = l_PacketObj.new("CSExitRoom", _LAIXIA_PACKET_CS_ExitRoomID)
    packet:setValue("RoomID", self.msg.data[2])   --写入包数据
    local tableid = -1
    if self.msg.data[2] == 50 and self.msg.data[3] ~= nil then
        tableid = self.msg.data[3]
    end
    packet:setValue("TableID",tableid)   --写入包数据
    laixia.net.sendPacketAndWaiting(packet)
end


return TPRoomLevelDown.new()
