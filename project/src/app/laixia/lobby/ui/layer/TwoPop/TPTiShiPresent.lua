
local TPTiShiPresent = class("TPTiShiPresent", import("...CBaseDialog"):new())-- 
local soundConfig =  laixia.soundcfg
local Packet = import("....net.Packet")

function TPTiShiPresent:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPTiShiPresent:getZorder()
   return  20 
end

function TPTiShiPresent:getName()
    return "TiShiPresent"
end

function TPTiShiPresent:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_PRESENT_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_PRESENT_WINDOW, handler(self, self.destroy))
end

function TPTiShiPresent:onShow(msg)
    self.data = msg.data  
    self.mMax = self.data.ItemNum
    self:AddWidgetEventListenerFunction("Image_Present_ShutDown", handler(self,self.onShutDown)) --关闭
    self:AddWidgetEventListenerFunction("TiShiPresent_Button_Close", handler(self,self.onShutDown)) --关闭
    self:AddWidgetEventListenerFunction("TiShiYu_Button_Present", handler(self,self.onPrensent)) --赠送
    self.mPresentNum = self:GetWidgetByName("Label_PresentNum")  --赠送数量

    self:AddWidgetEventListenerFunction("Button_Add", handler(self,self.onAdd)) --添加
    self:AddWidgetEventListenerFunction("Button_Minus", handler(self,self.onMinus)) --减少
    self:AddWidgetEventListenerFunction("Button_Max", handler(self,self.onMax)) --最大

    self.mFriendID = self:GetWidgetByName("TextField_FriendID")    --加入房间的ID输入框

end

function TPTiShiPresent:onAdd(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local num = tonumber( self.mPresentNum:getString() )
        if num > self.mMax then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"没有更多物品可赠送") 
        elseif num >= 999 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"最多只能赠送999个物品")  
        else
            num = num +1
            self.mPresentNum:setString(num)
        end

    end
end
function TPTiShiPresent:onMinus(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        local num = tonumber( self.mPresentNum:getString() )
        num = num - 1
        if num <= 0 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"赠送物品数量不能为空") 
        else
            self.mPresentNum:setString(num)
        end
    end
end
function TPTiShiPresent:onMax(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        
        if self.mMax > 999 then
            self.mPresentNum:setString(999) 
        else
            self.mPresentNum:setString(self.mMax)
        end
    end
end


function TPTiShiPresent:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

--加入游戏
function TPTiShiPresent:onPrensent(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
      
      local playerID = tonumber( self.mFriendID:getString() )
      local num = tonumber( self.mPresentNum:getString() )

      if playerID == 0  or playerID == nil  then
         ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW, "请输入有效的玩家ID") 
      else
          local mPresent = Packet.new("mPresent", _LAIXIA_PACKET_CS_PresentID)
            mPresent:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            mPresent:setValue("AppID", laixia.config.GameAppID)
            mPresent:setValue("ItemID", self.data.itemID)
            mPresent:setValue("ItemCount", num)
            mPresent:setValue("DoneeID", playerID)
            mPresent:setValue("ItemObjID", self.data.itemObjID)

            laixia.net.sendHttpPacket(mPresent)
      end
    end
end




function TPTiShiPresent:onTick()

end


function TPTiShiPresent:onDestroy()
    self.callFunc = nil
end

return TPTiShiPresent.new()


