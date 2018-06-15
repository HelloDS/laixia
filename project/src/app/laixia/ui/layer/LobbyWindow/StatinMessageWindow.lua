
local StatinMessage = class("StatinMessage", import("...CBaseDialog"):new())--
local userDefault = cc.UserDefault:getInstance()
local soundConfig = laixia.soundcfg;

function StatinMessage:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function StatinMessage:getName()
    return "StatinMessage"
end

function StatinMessage:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_MAIL_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MAIL_WINDOW,handler(self,self.updateWindow))
end

function StatinMessage:onShutDown(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

function StatinMessage:onShow()
    if not self.mIsShow then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDES_LETTERRED_WINDOW) --隐藏红点
        self.background = self:GetWidgetByName("beijing")
        self.background:setTouchEnabled(true)
        self.background:setTouchSwallowEnabled(true)
        self.Image_Item = self:GetWidgetByName("Email_Image_Item")
        self.listview_Email = self:GetWidgetByName("Email_ListView_List")
        self.mListTitle = self:GetWidgetByName("Emal_Image_ListTitle") --保存多久，和领取物品提示

        self:AddWidgetEventListenerFunction("Emal_Button_Back", handler(self, self.onShutDown))
        self:AddWidgetEventListenerFunction("Button_cleanup",handler(self,self.onClearup))
        self:GetWidgetByName("Label_TitleContent"):setVisible(true)
        self:GetWidgetByName("Label_TitleContent"):setString("系统邮件只保留最近的7天记录")
        self.mIsShow = true
    end
    self.mIndex = 0
    self.letterArray = {}
end
function StatinMessage:onClearup(msg)
    userDefault:setIntegerForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "number", 0)
    self.listview_Email:removeAllItems()
end
function StatinMessage:updateWindow(msg)
    if self.mIsShow then
        if msg and msg.data then
            self.letterArray = msg.data
        end
        self:getLetterArray()
        self.listview_Email:removeAllItems()
        self:saveLetter()
    end
end

function StatinMessage:saveLetter()
    for i, v in ipairs(self.letterArray) do
        if i <= 30 then
            userDefault:setStringForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "sendTime" .. i,v.sendTime)
            userDefault:setStringForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "conText" .. i,v.Context)
        end
    end
    userDefault:setIntegerForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "number", #self.letterArray)
end

function StatinMessage:onTick()
    if not self.mIsShow then
        return
    end
    if self.mIndex == #self.letterArray then
        --此处存放为空的时候界面显示的逻辑
        return
    end
    local old = self.mIndex + 1
    if self.mIndex+5 > #self.letterArray then
        self.mIndex = #self.letterArray
    else
        self.mIndex =self.mIndex +5
    end
    self:addLetterLiset(old, self.mIndex)
end

function StatinMessage:addLetterLiset(begin,overChoose)
    for i = begin, overChoose do
        local letterCell = self.Image_Item:clone()
        local label_msg_time = self:GetWidgetByName("Label_Time", letterCell) --显示时间
        label_msg_time:enableOutline(cc.c4b(153, 108, 67, 255), 2)
        local time = self.letterArray[i].sendTime
        label_msg_time:setString( os.date("%X", time));

        local label_msg = self:GetWidgetByName("Label_Item_Title", letterCell)
        local context  = self.letterArray[i].Context:gsub("金币",laixia.utilscfg.CoinType());
        label_msg:setString(context)
        -- self:GetWidgetByName("Label_Item_Describe", letterCell):setString("这个是标签")
        -- self:GetWidgetByName("Label_Item_Describe", letterCell):setVisible(false)
        -- self:GetWidgetByName("Image_Circle",letterCell):setVisible(false)  --物品背景

        -- self:GetWidgetByName("Image_Icone", letterCell):setVisible(true) --这个是奖品图标
        self:GetWidgetByName("Image_Item_Photo", letterCell):setVisible(true) --发送者图标

        self.listview_Email:pushBackCustomItem(letterCell)
    end
end

function StatinMessage:getLetterArray()
    local number = userDefault:getIntegerForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "number")
    if number ~= nil and number > 0 then
        for i = 1, number do
            if laixia.LocalPlayercfg.LaixiaHeartBeatTime == 0 then
                local heartTime = userDefault:getStringForKey("heartTime")
                if heartTime~=nil then
                    laixia.LocalPlayercfg.LaixiaHeartBeatTime = tonumber(heartTime)
                end
            end
            local cha = (laixia.LocalPlayercfg.LaixiaHeartBeatTime/1000) - tonumber(userDefault:getStringForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "sendTime" .. i))
            if cha < (laixia.config.LAIXIA_SHOW_STATINMASSAGE*24*3600) then    --7天等于518400
                local letter = { }
                letter["sendTime"] = userDefault:getStringForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "sendTime" .. i)
                letter["Context"] = userDefault:getStringForKey(laixia.LocalPlayercfg.LaixiaPlayerID .. "conText" .. i)
                letter["Context"] = letter["Context"]:gsub("金币",laixia.utilscfg.CoinType());
                table.insert(self.letterArray, letter)
            end
        end
    end
end

function StatinMessage:onDestroy()
    self.mIsShow = false
    self.letterArray = {}
    self.mIndex = 0
end

return StatinMessage.new()

