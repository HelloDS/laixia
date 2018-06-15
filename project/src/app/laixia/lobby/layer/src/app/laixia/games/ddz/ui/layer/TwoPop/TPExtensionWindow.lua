--推广金
local TPExtensionWindow = class("TPExtensionWindow", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg
local Packet = import("....net.Packet")

function TPExtensionWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPExtensionWindow:getZorder()
   return  20 
end

function TPExtensionWindow:getName()
    return "TPExtensionWindow"
end

function TPExtensionWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_EXTENSION_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_EXTENSION_WINDOW, handler(self, self.destroy))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_EXTENSION, handler(self, self.onUpdataButton))
end

--参数是table 
    --Text：显示的提示文字
    --OnCallFunc：点击确定时回调函数
function TPExtensionWindow:onShow(data)

    self:AddWidgetEventListenerFunction("Button_TuiGuangBG_Close", handler(self,self.onShutDown))  --关闭

    self:AddWidgetEventListenerFunction("Button_TuiGuang_Receive", handler(self,self.onReceive))  --领取推广金
    self.mReceiveTitle = self:GetWidgetByName("Label_TuiGuangReceive")  --领取救济金金额

    self.mBindingTitle = self:GetWidgetByName("Label_TuiGuang_BindingTitle")  --绑定title
    self.mBindingID = self:GetWidgetByName("Label_TuiGuangID")    --绑定的ID
    self.mTexfidld =  self:GetWidgetByName("TextField_BindingID") --ID的输入框

    self.mMsg01 =  self:GetWidgetByName("Label_TuiGuang_Msg01") --消息
    self.mMsg02 =  self:GetWidgetByName("Label_TuiGuang_Msg02") --消息
    self.mMsg03 =  self:GetWidgetByName("Label_TuiGuang_Msg03") --消息

    local BindingGold =  data.data.BindingGold
    local Per = data.data.Per
    local BindingPid = data.data.BindingPid
    local AwardGold = data.data.AwardGold

    self.AwardGold = AwardGold
    self.bindPid =   BindingPid
    if BindingGold ~= 0 then
       self.mMsg02 :setString("2 绑定ID后,即可一次性领取"..BindingGold.."金币奖励.")
    end

    if Per ~= 0 then
       self.mMsg03 :setString("3 被绑定后,可领取绑定账号充值"..Per.."%返还的金币奖励.")
    end

    if BindingPid ~= 0 then
       self:GetWidgetByName("Image_TuiGuang_InPutBG"):setVisible(false)
       self.mBindingID:setVisible(true)
       self.mBindingID:setString(BindingPid)
    end

    if AwardGold ~= 0 then
       self.mReceiveTitle:setString("领取（"..AwardGold..")")
    else
       self.mReceiveTitle:setString("领取(0)")
    end
    

end

function TPExtensionWindow:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end



function TPExtensionWindow:onReceive(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local str = self.mReceiveTitle:getString()


        if str == "领取(0)" then
           if self.bindPid  ~= 0 then
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "暂无可领取金币") 
           else
                self:onBindPID()
           end
        else
           self:onReceiveGold()
        end

    end
end



function TPExtensionWindow:onUpdataButton(data)
    local AwardGold = data.data.AddGold  --增加的金币

    if AwardGold ~= 0 then
    
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_EXTENSION_WINDOW) 
       ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "绑定成功，获得"..AwardGold.."金币") 
    else
       self.mReceiveTitle:setString("绑定")
    end
    laixiaddz.LocalPlayercfg.LaixiaPlayerGold = data.data.AllGold
end

function TPExtensionWindow:onBindPID()
      local playerID = tonumber( self.mTexfidld:getString() )

      if playerID == 0  or playerID == nil  then
         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW, "请输入有效的玩家ID") 
      else
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local CSExtensionBinding = Packet.new("CSExtensionBinding", _LAIXIA_PACKET_CS_ExtensionBindingID)
        CSExtensionBinding:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        CSExtensionBinding:setValue("BuindID",playerID)
        laixia.net.sendHttpPacket(CSExtensionBinding)
      end

end

function TPExtensionWindow:onReceiveGold()
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local CSReceiveExtension = Packet.new("CSReceiveExtension", _LAIXIA_PACKET_CS_ReceiveExtensionID)
        CSReceiveExtension:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        laixia.net.sendHttpPacket(CSReceiveExtension)
end

function TPExtensionWindow:onDestroy()
 
end

return TPExtensionWindow.new()


