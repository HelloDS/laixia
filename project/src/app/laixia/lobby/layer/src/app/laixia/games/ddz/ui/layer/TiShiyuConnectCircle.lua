local laixia = laixia;

local TiShiyuConnectCircle = class("TiShiyuConnectCircle", function()
    return ccs.GUIReader:getInstance():widgetFromBinaryFile("new_ui/Animation.csb")
end )

local EffectDict = import("..EffectAni.EffectDict")
local EffectAni = import("..EffectAni.EffectAni")

local TIMEOUT_NORMAL = 15

local EnumWaitingType =
{
    EWT_NORMAL = 0, -- 正常情况
    EWT_NET_HTTP = 1, -- 网络模块 HTTP
    EWT_NET_TCP = 2, -- 网络 TCP*
    EWT_SWITCH_TABLE = 3,
    EWT_ON_SUBAPP =4,
    EWT_ON_UPDATE =5,
}

function TiShiyuConnectCircle:ctor(...)
    self.mTimer = 0
    self.mWaitingType = 0;
    self.mTimeout = laixia.config.LAIXIA_WAITING_OUT;
    self.mIsWaiting = false;
    self.mTimeByShow = 3 -- 非牌桌页面触发转圈动画的时间
    self.mTimeByShow1 = 3 -- 牌桌页面触发转圈动画的时间
    
    

    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_RECONNECTIONTIPS_WINDOW, handler(self, self.showConnectCircleAni))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_RECONNECTIONTIPS_WINDOW, handler(self, self.destroyConnectCircleAni))
    

    self.mPanel = ccui.Helper:seekWidgetByName(self,"Panel_Animation")
    self.mAiAdder = ccui.Helper:seekWidgetByName(self,"Image_TiShiyuConnectCircle_center")

    local scheduler = require "framework.scheduler"    
    scheduler.scheduleUpdateGlobal(function(dt) self:tick(dt) end )

    self.layer= cc.LayerColor:create(cc.c4b(0,0,0,0),display.width, display.height)
    self.layer:setTouchEnabled(false)
    self.layer:setTouchMode(1);
    self.layer:setTouchSwallowEnabled(true)
	local function onTouch(eventType,x,y)
        return true;
    end
	self.layer:registerScriptTouchHandler(onTouch);
    self.layer:addTo(self) 
end

function TiShiyuConnectCircle:showConnectCircleAni(msg)
    if (self.mIsWaiting) then
        return;
    end
    self.layer:setTouchEnabled(true)
    self.data = msg.data

    self.mIsWaiting = true
    self.mTimer = 0
    self.mWaitingType = msg.waitType or 0; -- 默认为0还是啥呢？？
    self.mTimeout = msg.timeOut or laixia.config.LAIXIA_WAITING_OUT;
    if (self.colorlayer==nil) then
        self.colorlayer= cc.LayerColor:create(cc.c4b(0,0,0,100),display.width,display.height)
        self.colorlayer:addTo(self.mAiAdder)
        self.colorlayer:setVisible(false)
    end
    if (self.act0 == nil) then
        self.act0 = EffectAni:createAni(EffectDict._ID_DICT_TYPE_WATTING_CIRCLE)
        self.act0:addTo(self.mAiAdder)
        --:pos(display.cx,display.cy)
        self.act0:setVisible(false)
    end
    self.showOne = false
end

function TiShiyuConnectCircle:destroyConnectCircleAni()
    self.layer:setTouchEnabled(false)
    if (self.colorlayer ~= nil) then
        self.colorlayer:removeFromParent()
        self.colorlayer = nil
    end
    if (self.act0 ~= nil) then
        self.act0:stop();
        self.act0:removeFromParent()
        self.act0 = nil
    end
    self.mTimer = 0
    self.mWaitingType = 0;
    self.mIsWaiting = false;
end

function TiShiyuConnectCircle:tick(dt)
    if not self.mIsWaiting then
        return
    end
    self.mTimer = self.mTimer + dt
    if not self.showOne then -- 防止出现的太频繁
        if (laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "CardTableDialog" and self.mTimer >= self.mTimeByShow) or
            (laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and self.mTimer >= self.mTimeByShow1) then
            self.showOne = true
            self.act0:setVisible(true)
            self.colorlayer:setVisible(true)
        end
    elseif (self.mTimer > self.mTimeout) then
        local waitingType = self.mWaitingType;
        laixia.net.clearAllWaiting()
        if (waitingType == EnumWaitingType.EWT_NORMAL) then
            laixiaddz.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_TIMEOUT), "http")
        elseif (waitingType == EnumWaitingType.EWT_NET_HTTP) then
            laixiaddz.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_ERROR), "http")
        elseif waitingType == EnumWaitingType.EWT_NET_TCP then
            laixia.net.disconnect()
            laixiaddz.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_ERROR), "http")
        elseif waitingType == EnumWaitingType.EWT_ON_SUBAPP then
            laixiaddz.helper.popupReLoginWindow(laixia.utilscfg.DICT(_ID_DICT_TYPE_CONNECT_TIMEOUT), "http")
            laixiaddz.helper.failedLoadSubApp();
        elseif waitingType == EnumWaitingType.EWT_ON_UPDATE then

            return;
        end
        
        self:destroyConnectCircleAni();
    end
end

return TiShiyuConnectCircle

