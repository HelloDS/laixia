-- 红包使用的弹窗

local ButtonLayer = class("ButtonLayer", import("...CBaseDialog"):new())
local soundConfig =  laixiaddz.soundcfg

function ButtonLayer:getName()
    return "ButtonLayer"
end

function ButtonLayer:ctor()
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
    self.mIsShow = false
end

function ButtonLayer:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BUTTONLAYER, handler(self, self.show))
end


function ButtonLayer:onShow(data)
    -- Button_15 关闭按钮
    -- Button_1   Button_1_Copy  Button_1_Copy_0  Button_1_Copy_1  Button_1_Copy_2    Button_1_Copy_3  六个按钮横着数   一二三  四五六
end

function ButtonLayer:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HIDEMONEY_WINDOW)
    end
end


return ButtonLayer.new()