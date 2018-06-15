--
-- Author: Feng
-- Date: 2018-05-07 19:25:34
--

--[[
    大厅主界面层

]]
local ExchangeLayer = class("ExchangeLayer" ,import("common.base.BaseDialog"))
--[[
    构造函数
]]
function ExchangeLayer:ctor()
    self.super.ctor(self, "new_ui/ExchangeLayer.csb")
    self:init()
end

--[[
    初始化
]]
function ExchangeLayer:init()
--初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/ExchangeLayer.csb")
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode
    _G.adapPanel_root(csbNode)

    self.CheckBox_hongbao = self:GetWidgetByName("CheckBox_hongbao")
    self.CheckBox_duihuan = self:GetWidgetByName("CheckBox_duihuan")
    local function callback(sender, eventType)  
        if eventType == ccui.CheckBoxEventType.selected then  
            if sender == self.CheckBox_hongbao then  
                self.CheckBox_duihuan:setSelected(false) 
            else                      
                self.CheckBox_hongbao:setSelected(false)  
            end  
        elseif eventType == ccui.CheckBoxEventType.unselected then  
            if sender == self.CheckBox_hongbao then  
                self.CheckBox_duihuan:setSelected(true)  
            else      
                self.CheckBox_hongbao:setSelected(true)       
            end  
        end  
    end  
    self.CheckBox_hongbao:addEventListener(callback)  
    self.CheckBox_duihuan:addEventListener(callback)

    --确定按钮
    self:AddWidgetEventListenerFunction("Button_queding", handler(self, self.onTure))

    self.isTouched = false
end

function ExchangeLayer:onTure(sender,eventType)
    if eventType == ccui.TouchEventType.ended then 
        if self.isTouched == true then
            return
        end
        self.isTouched = true
        local sender = {}
        sender.ItemID = self.curItemID
        sender.ItemObjectID  = self.curItemObjectID
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local itemMsg = laixia.JsonTxtData:queryTable("items"):query("ItemID",sender.ItemID);
        if (self.CheckBox_duihuan:isSelected() == nil and self.CheckBox_hongbao:isSelected() == nil) or (self.CheckBox_duihuan:isSelected() == false and self.CheckBox_hongbao:isSelected() == false) then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"请选择领取红包的方式")
            self:onBack()
        end
        if self.CheckBox_duihuan:isSelected() == true then  
            --这个是发起什么请求???????????
            --京东卡？

            -- local CSUseProp = Packet.new("CSUseProp", _LAIXIA_PACKET_CS_UsePacksID)
            -- CSUseProp:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
            -- CSUseProp:setValue("GameID", laixia.config.GameAppID)
            -- CSUseProp:setValue("ItemID", itemMsg.ItemID)
            -- laixia.net.sendHttpPacketAndWaiting(CSUseProp);
            if itemMsg.isDisapear == 1 then
                self:onBack()
                --以前的清除数据的逻辑
            end
        elseif self.CheckBox_hongbao:isSelected() == true then
            if laixia.LocalPlayercfg.LaixiaPhoneNum=="" then
                self:onBack()
                self.isTouched = false
                return
            end
            local stream =  laixia.Packet.new("bag", "LXG_BAGPACK_GET")
            stream:setReqType("get")
            stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
            laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
                local data1 = event
                if data1.dm_error == 0 then
                    print("使用成功")
                    scene:popUpTips("使用成功")
                else
                    print("使用失败")
                    scene:popUpTips(data1.error_msg)
                end 
            end)
            
        end
        self.isTouched = false
    end
end

--[[
    --关闭界面
]]
function ExchangeLayer:onBack()
    self.rootNode:removeFromParent()
    self.rootNode = nil
end

return ExchangeLayer
