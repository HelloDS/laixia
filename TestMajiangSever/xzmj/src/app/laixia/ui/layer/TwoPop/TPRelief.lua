
local TPRelief = class("TPRelief", import("...CBaseDialog"):new())-- 
local soundConfig = laixia.soundcfg;     
local Packet = import("....net.Packet") 

local laixia = laixia;
local localPlayer = laixia.LocalPlayercfg;

function TPRelief:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPRelief:getName()
    return "TPRelief"
end

function TPRelief:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_NOMONEY_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_RELIEF_WINDOW, handler(self, self.sendJiujiJinPacket)) 
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_RELIEFINFO_WINDOW, handler(self, self.sendReceiveGoldPacket)) 
end

function TPRelief:sendJiujiJinPacket()
    local stream = Packet.new("CSReliefFund", _LAIXIA_PACKET_CS_ReliefFundID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end

function TPRelief:onCallBackFunction()
    if self:GetWidgetByName("Relief_Button_Closee"):isVisible() then
        self:destroy()
    end
end

function TPRelief:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy();
    end
end

function TPRelief:buy(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_INCREASEGOLD_WINDOW, {OnCallFunc = function () 
        --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_INCREASEGOLD_WINDOW)
        -- end})
        self:destroy(); 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW) 
    end
end
 
function TPRelief:sendReceiveGoldPacket()
    local stream = Packet.new("CSReliefFundInfo", _LAIXIA_PACKET_CS_ReliefFundInfoID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end

function TPRelief:onQuickStart(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy();
        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" then
            -- if ui.CardTableDialog.mPokerDeskType == 1 then
            --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,0)
            -- elseif ui.CardTableDialog.mPokerDeskType == 2 then
            --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,1)
            -- else
            --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,1)
            -- end
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,2)
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,2)
            -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_QUICKGAME_WINDOW,0)
        end
    end
end


function TPRelief:onShow(data)
    self.BG = self:GetWidgetByName("Image_1")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    
    self.goBack = self:GetWidgetByName("Relief_Button_Closee")
    self:AddWidgetEventListenerFunction("Relief_Button_Closee",handler(self,self.onShutDown))    

    self.Relief_Button_QuickStart=self:GetWidgetByName("Relief_Button_QuickStart")
    self.Relief_Button_QuickStart:setVisible(true)
    -- self.AtlasLabel_gold = self:GetWidgetByName("Relief_BitmapLabel_GoldNum")
    -- self.AtlasLabel_gold:setString(0)
    self.Relief_Label_Extra = self:GetWidgetByName('Relief_Label_Extra');

        self.Relief_Label_Extra:hide()
        if data.data.StatusID == 0 then
            -- self.AtlasLabel_gold:setString(data.data.Gold) 
            self.Relief_Label_Extra:setString("为您准备了".. data.data.Gold ..laixia.utilscfg.CoinType().."，您本日还可以再领"..data.data.RemainCT.."次。")  
            self.Relief_Label_Extra:show()
            self:AddWidgetEventListenerFunction("Relief_Button_QuickStart",handler(self,self.onQuickStart))
            self.Relief_Button_QuickStart:setVisible(true)
        elseif data.data.StatusID == 1 then
            self.goBack:show();
        end
end

return TPRelief.new()


