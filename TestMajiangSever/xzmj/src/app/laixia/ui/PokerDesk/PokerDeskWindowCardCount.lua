--region 购买记牌器

local PokerDeskWindowCardCount  = class ("PokerDeskWindowCardCount",import("..CBaseDialog"):new())  --
local soundConfig =  laixia.soundcfg
local laixia = laixia;


function PokerDeskWindowCardCount:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.isShow = false
end

function PokerDeskWindowCardCount:getName()
    return "BuyJipaiqi";
end

-- 初始化
function PokerDeskWindowCardCount:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_BUYRECORDER_WINDOW,handler(self,self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDE_BUYRECORDER_WINDOW,handler(self,self.destroy))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_CHANGE_BUYRECORDER_WINDOW,handler(self,self.change))
end

function PokerDeskWindowCardCount:onShow(aiData)
    if not self.isShow then
        self.isShow = true


        self:AddWidgetEventListenerFunction("BRM_Button_Close",handler(self,self.onClose))
        self:AddWidgetEventListenerFunction("BRM_Button_Buy",handler(self,self.onCardCount))


        self.labelDay = self:GetWidgetByName("BitmapLabel_DayNum")  --记牌器天数
        self.labelPrice = self:GetWidgetByName("BitmapLabel_Price")  --记牌器价格
        self.labelCoin = self:GetWidgetByName("BitmapLabel_Gold")   --赠送金币数
        self.labelAlreadyPerson = self:GetWidgetByName("BRMLabel_Already_Buy")

    end

    self.mRoomID = aiData.data.roomid
    self.mGoldNum = aiData.data.cardgold
    self.labelPrice:setString(self.mGoldNum)

    self.mInterfaceRes:setTouchEnabled(true)
    self.mInterfaceRes:addTouchEventListener(handler(self, self.onClose))

    if laixia.LocalPlayercfg.mAlreadyBuyJipaiqiUserNumber then
        local number = math.random(10,50)
        laixia.LocalPlayercfg.mAlreadyBuyJipaiqiUserNumber = laixia.LocalPlayercfg.mAlreadyBuyJipaiqiUserNumber+number
    else
        laixia.LocalPlayercfg.mAlreadyBuyJipaiqiUserNumber = math.random(5000,8000)
    end
    local str = "已有 " .. laixia.LocalPlayercfg.mAlreadyBuyJipaiqiUserNumber .. "人 购买记牌器"
    self.labelAlreadyPerson:setString(str)

end

function PokerDeskWindowCardCount:onDestroy()
    self.isShow = false
end

function PokerDeskWindowCardCount:onCardCount(sender,event)
    if  (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end
--改变记牌器弹窗状态
function PokerDeskWindowCardCount:change(aiState)
    if self.isShow then

    end
end

function PokerDeskWindowCardCount:onClose(sender,event)
    if  (event == ccui.TouchEventType.ended) then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end
return  PokerDeskWindowCardCount.new()

