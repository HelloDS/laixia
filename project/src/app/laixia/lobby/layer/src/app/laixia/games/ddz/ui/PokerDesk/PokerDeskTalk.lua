
-- 牌桌聊天
local PokerDeskTalk = class("PokerDeskTalk", import("..CBaseDialog"):new())--
local soundConfig =  laixiaddz.soundcfg
local Packet = import("...net.Packet")
local EffectDict = import("..EffectAni.EffectDict")
local EffectAni = import("..EffectAni.EffectAni")
local talkText = {
    [1] = "大家好，很高兴见到各位！",
    [2] = "和你合作真是太愉快了！",
    [3] = "快点啊，等到花儿都谢了",
    [4] = "你的牌打得也太好了",
    [5] = "不要吵了，有什么好吵的，专心玩游戏吧",
    [6] = "怎么又断线，网络太差了吧",
    [7] = "不好意思，我要离开一会儿",
    [8] = "不要走，决战到天亮",
    [9] = "交个朋友吧，能告诉我联系方式吗",
    [10] = "再见了，我会想念大家的",
}

function PokerDeskTalk:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function PokerDeskTalk:getName()
    return "FastInput"
end

function PokerDeskTalk:onInit()
    self.super:onInit(self)
    self:SetShowColorLayerFunc(false);
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_TALKING_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_TALKING_WINDOW, handler(self, self.destroy))

end
function PokerDeskTalk:sendsever(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)

        local talk_type = 1

        local str = self.DeskTalkString:getString()
        if str == "" then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"亲，还是说点啥吧！")
            return
        end
        --普通牌桌发送对话，新手牌桌不发送对话
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" then
            local talkpacket = Packet.new("talkpacket", _LAIXIA_PACKET_CS_TableTalkingID)
            talkpacket:setValue("RoomID", ui.CardTableDialog.mRoomID)
            talkpacket:setValue("TableID", ui.CardTableDialog.hDeskID)
            talkpacket:setValue("Type", talk_type)
            talkpacket:setValue("Info", str)
            laixia.net.sendPacket(talkpacket)
        end
        local mesg = { }
        mesg.seatId = laixiaddz.LocalPlayercfg.LaixiaMySeat
        mesg.chatType = talk_type
        mesg.info = str

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TALKINGINFO_WINDOW, mesg)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_TALKING_WINDOW)
    end
end
function PokerDeskTalk:getpatch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.expression_num = sender.ID
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" then
            local talkpacket = Packet.new("talkpacket", _LAIXIA_PACKET_CS_TableTalkingID)
            talkpacket:setValue("RoomID", ui.CardTableDialog.mRoomID)
            talkpacket:setValue("TableID", ui.CardTableDialog.hDeskID)
            talkpacket:setValue("Type", 0)
            talkpacket:setValue("Info", self.expression_num)
            laixia.net.sendPacket(talkpacket)
        end
        local mesg = { }
        mesg.seatId = laixiaddz.LocalPlayercfg.LaixiaMySeat
        mesg.chatType =0
        mesg.info = self.expression_num

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TALKINGINFO_WINDOW, mesg)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_TALKING_WINDOW)

    end
end

function PokerDeskTalk:onShow()
    self:GetWidgetByName("Image_ShutDown"):setTouchEnabled(true)
    self:GetWidgetByName("Image_ShutDown"):addTouchEventListener(handler(self, self.onShutDown))
    self:AddWidgetEventListenerFunction("Button_SendToSever", handler(self, self.sendsever))

    self.Button_TextChat = self:GetWidgetByName("Button_TextChat") --
    self.Button_TextChat:addTouchEventListener(handler(self, self.onShowTextChat))

    self.Button_TextChat_Front = self:GetWidgetByName("Button_TextChat_Front")
    self.Button_Expression = self:GetWidgetByName("Button_Expression")
    self.Button_Expression:addTouchEventListener(handler(self, self.onShowExpression))
    self.Button_Expression_Front = self:GetWidgetByName("Button_Expression_Front")

    self.expression = self:GetWidgetByName("Panel_Expression")
    self.talkMode = self:GetWidgetByName("Image_TextChatCell")
    for i = 1, 12 do
        local str = "Button_Expression" .. i
        local button = self:GetWidgetByName(str, self.expression)
        button.ID = i
        button:addTouchEventListener(handler(self, self.getpatch))
    end
    self.DeskTalkString = self:GetWidgetByName("TextField_Content")

    if laixia.config.isAudit  then
        self.DeskTalkString:setTouchEnabled(false)
    else
        self.DeskTalkString:addEventListener(handler(self, self.onInputText))
    end
    
    self.lisview = self:GetWidgetByName("ListView_Chat")
    self:addTalkIngMsg()
    self:changeBtnStatus(2)
end

-- 修改右侧按钮的状态 1：快捷语按钮不可点  2：表情按钮不可点
-- Button_TextChat:快速聊天   Button_Expression：表情
function PokerDeskTalk:changeBtnStatus(status)
    if status == 1 then
        self.Button_TextChat:setVisible(false)
        self.Button_TextChat_Front:setVisible(true)
        self.Button_Expression:setVisible(true)
        self.Button_Expression_Front:setVisible(false)

        self.expression:setVisible(false)
        self.lisview:setVisible(true)
    elseif status == 2 then
        self.Button_TextChat:setVisible(true)
        self.Button_TextChat_Front:setVisible(false)
        self.Button_Expression:setVisible(false)
        self.Button_Expression_Front:setVisible(true)

        self.expression:setVisible(true)
        self.lisview:setVisible(false)

    end
end


function PokerDeskTalk:addTalkIngMsg()
    for i = 1, #talkText do
        local mode2 = self.talkMode:clone()
        self.lisview:pushBackCustomItem(mode2)
        self:GetWidgetByName("Label_TextChat", mode2):setString(talkText[i])
        self.lisview:getItem(i - 1):addTouchEventListener( function(sender, eventType)
            -- 绑定触摸监听函数
            self:sendToSever(sender, eventType)
        end )
    end

end

function PokerDeskTalk:sendToSever(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        --普通牌桌发送对话，新手牌桌不发送对话
        if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" then
            local talkpacket = Packet.new("talkpacket", _LAIXIA_PACKET_CS_TableTalkingID)
            talkpacket:setValue("RoomID", ui.CardTableDialog.mRoomID)
            talkpacket:setValue("TableID", ui.CardTableDialog.hDeskID)
            talkpacket:setValue("Type", 1)
            talkpacket:setValue("Info", self:GetWidgetByName("Label_TextChat", sender):getString())
            laixia.net.sendPacket(talkpacket)
        end
        local mesg = { }
        mesg.seatId = laixiaddz.LocalPlayercfg.LaixiaMySeat
        mesg.chatType =1
        mesg.info = self:GetWidgetByName("Label_TextChat", sender):getString()

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TALKINGINFO_WINDOW, mesg)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_TALKING_WINDOW)
    end
end

function PokerDeskTalk:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_TALKING_WINDOW)
    end
end

function PokerDeskTalk:onShowTextChat(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:changeBtnStatus(1)
    end
end

function PokerDeskTalk:onShowExpression(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:changeBtnStatus(2)
    end
end



function PokerDeskTalk:onInputText(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        local talkpacket = Packet.new("talkpacket", _LAIXIA_PACKET_CS_TableTalkingID)
        talkpacket:setValue("RoomID", ui.CardTableDialog.mRoomID)
        talkpacket:setValue("TableID", ui.CardTableDialog.hDeskID)
        talkpacket:setValue("Type", 1)
        talkpacket:setValue("Info", self:GetWidgetByName("TextField_Content"):getString())
        laixia.net.sendPacket(talkpacket)
    end
end


function PokerDeskTalk:onDestroy()
    self.expression_num = nil
    self.Button_TextChat = nil
    self.Button_Expression = nil
    self.expression = nil
    self.lisview = nil
    self.DeskTalkString = nil
end


return PokerDeskTalk.new()
