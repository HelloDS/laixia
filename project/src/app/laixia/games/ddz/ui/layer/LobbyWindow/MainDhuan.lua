--
-- Author: peter
-- Date: 2018-04-10 13:36:51
--
local MainDhuan= class("MainDhuan",import("...CBaseDialog"):new())   

function MainDhuan:ctor(...) 
     print("MainDhuan:ctor")
    self.hDialogType = DialogTypeDef.DEFINE_INNER_DIALOG
end

function MainDhuan:getName()
	return "MainDhuan"
end

function MainDhuan:onInit()
    print("MainDhuan:onInit")
    self.super:onInit(self)  
     ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DUIHUAN_SHOW_WINDOW, handler(self, self.show))
end

function MainDhuan:onShow(data1)  
    print("MainDhuan:onShow")
    if laixiaddz.kconfig.isYingKe == true then
        self:GetWidgetByName("Image_1_Copy"):setVisible(true)
        self:GetWidgetByName("Text_1_Copy"):setVisible(true)
        self:GetWidgetByName("Image_1"):setVisible(false)
        self:GetWidgetByName("Text_1"):setVisible(false)
        self:GetWidgetByName("Image_1"):setPositionX(self:GetWidgetByName("Image_1"):getPositionX()+30)
        self:GetWidgetByName("Text_1"):setPositionX(self:GetWidgetByName("Text_1"):getPositionX()+30)
    end

    local str = data1.data
    self.txtpic  = self:GetWidgetByName("Image_1")
    --self.txtpic:setVisible(true)
     --self.txtpic:setPosition(cc.p(150,587))
    if laixiaddz.kconfig.isYingKe == true then
        self.txt =  self:GetWidgetByName("Text_1_Copy")
    else
        self.txt =  self:GetWidgetByName("Text_1")
    end
     
    -- if laixia.config.isAudit then
    --     self.txt:setString("可在游戏场中获得")
    -- else
    --     self.txt:setString("可在比赛场、游戏场中获得")
    -- end
    self.txt:setString(str)
     --self.txt:setTextColor(cc.c3b(0,255,0))
    --self.txt:setString(data)
    --self.txt:setVisible(false)

   -- local moveto = cc.MoveTo:create(2,cc.p(640,540))
    local caf = cc.CallFunc:create(function() self:destroy() end)
    local req = cc.Sequence:create(cc.DelayTime:create(2),caf)--cc.DelayTime:create(1),
    self.txt:runAction(req)
end


return MainDhuan.new()
