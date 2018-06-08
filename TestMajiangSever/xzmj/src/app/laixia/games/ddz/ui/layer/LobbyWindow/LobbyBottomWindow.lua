
local laixia = laixia;

local Packet =  import("....net.Packet")  
local soundConfig =  laixiaddz.soundcfg; 
local EffectDict =  laixia.EffectDict; 
local EffectAni = laixia.EffectAni;    

local LobbyBottomWindow = class("LobbyBottomWindow", import("...CBaseDialog"):new())

function LobbyBottomWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_INNER_DIALOG
    self.mIsShow = false
end
 
function LobbyBottomWindow:getName()
    return "LobbyBottomWindow"
end

function LobbyBottomWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_COMMONFLOOR_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW, handler(self, self.sendQuickGame)) 
end

function LobbyBottomWindow:onShow(msg)
    if self.mIsShow == false then
        --快速开始
        -- local node = EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_QUICKSTART)
        -- node:addTo(self.mInterfaceRes,5)
        -- node:setPosition(cc.p(display.cx-162,display.bottom))
        self.Room_Button_Start = self:GetWidgetByName("Room_Button_Start")
        self.Room_Button_Start:setOpacity(0)

        local system1 = laixiaddz.ani.CocosAnimManager
        self.doudizhu_quick = system1:playAnimationAt(self.mInterfaceRes,"doudizhu_quick")
        self.doudizhu_quick:setPositionX(self.Room_Button_Start:getPositionX())
        self.doudizhu_quick:setPositionY(self.Room_Button_Start:getPositionY())

        self:AddWidgetEventListenerFunction("Room_Button_Start", handler(self, self.QuickGame))
        -- self:GetWidgetByName("Room_Button_Start"):setOpacity(0)
        self.mIsShow = true
    end
end

function LobbyBottomWindow:QuickGame(sender, eventtype)
    -- 快速开始按钮回调函数
    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        if  ui.GameRoomGround.mRoomType ~= nil then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,ui.GameRoomGround.mRoomType)
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW, 0)
        end
    end
end


function LobbyBottomWindow:sendQuickGame(msg)
    local stream = Packet.new("CsQuickStartPacket", _LAIXIA_PACKET_CS_QuickOpenID)
    stream:setValue("RoomType",msg.data)
    laixia.net.sendPacketAndWaiting(stream)
end

function LobbyBottomWindow:onDestroy()
    self.mIsShow = false
end
return LobbyBottomWindow.new()
