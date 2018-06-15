local TPReconnect = class("TPReconnect", import("...CBaseDialog"):new())
local soundConfig =  laixiaddz.soundcfg 
local Packet = import("....net.Packet")

function TPReconnect:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPReconnect:getName()
    return "TPReconnect"
end

function TPReconnect:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MARKEDJUMP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_MARKEDJUMP_WINDOW, handler(self, self.onDestroys))
end


function TPReconnect:onShow(data)
    self.time = 0
    -- self:AddWidgetEventListenerFunction("TiShiYu_Button_Ok",handler(self,self.goReConnect)) 
    -- self:GetWidgetByName("TiShiYu_Button_Close"):setVisible(false)   
    -- self.mMsg = data.data.msg or ""    

    -- self.bindphonefirst=self:GetWidgetByName("TiShiYu_Content_Text")
    -- self.bindphonefirst:setVisible(true)
    -- self.bindphonefirst:setString(self.mMsg)
    laixia.net.readyForReConnect();

    self.Panel_3 = self:GetWidgetByName("Panel_3")
    local function touchBegan()
        return true
    end
    local function touchMoved()
    end
    local function touchEnded()
        self:destroy()
    end

    local listener = cc.EventListenerTouchOneByOne:create()  
    listener:registerScriptHandler(touchBegan, cc.Handler.EVENT_TOUCH_BEGAN)  
    listener:registerScriptHandler(touchMoved, cc.Handler.EVENT_TOUCH_MOVED)  
    listener:registerScriptHandler(touchEnded, cc.Handler.EVENT_TOUCH_ENDED)  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self.Panel_3)  
    listener:setSwallowTouches(true)
end

function TPReconnect:onDestroys()
    self:destroy()
end

function TPReconnect:onTick(dt)
    self.time = self.time + dt
    if self.time>=2 then
        self:destroy()
    end
end

-- function TPReconnect:goReConnect(sender, eventType)
--     if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--         laixia.net.readyForReConnect();
--         self:destroy();
--     end
-- end


return TPReconnect.new()


