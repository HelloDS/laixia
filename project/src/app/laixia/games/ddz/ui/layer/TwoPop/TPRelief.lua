
local TPRelief = class("TPRelief", import("...CBaseDialog"):new())-- 
local soundConfig = laixiaddz.soundcfg;     
local Packet = import("....net.Packet") 

local laixia = laixia;
local localPlayer = laixiaddz.LocalPlayercfg;

function TPRelief:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function TPRelief:getName()
    return "TPRelief" -- csb = GameNoMoney
end

function TPRelief:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_NOMONEY_WINDOW, handler(self, self.show))
    -- ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_RELIEF_WINDOW, handler(self, self.sendJiujiJinPacket)) 
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_RELIEFINFO_WINDOW, handler(self, self.sendReceiveGoldPacket)) 
end

--[[
 * 请求发放救济金
 * @param  data = {data={StatusID,Gold,RemainCT}}
--]]
function TPRelief:onShow(data)
    self.BG = self:GetWidgetByName("Image_1")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)
    self.goBack = self:GetWidgetByName("Relief_Button_Closee")
    self:AddWidgetEventListenerFunction("Relief_Button_Closee",handler(self,self.onShutDown))    
    -- self.Relief_Button_QuickStart=self:GetWidgetByName("Relief_Button_QuickStart")
    -- self.Relief_Button_QuickStart:setVisible(true)
    self.Relief_Label_Extra = self:GetWidgetByName('Relief_Label_Extra');
    self.Relief_Label_Extra:hide()
    if data.data.StatusID == 1 then
        self.Relief_Label_Extra:setString("为您准备了".. data.data.Gold ..laixiaddz.utilscfg.CoinType().."，您本日还可以再领"..data.data.RemainCT.."次。")  
        self.Relief_Label_Extra:show()
        -- self:AddWidgetEventListenerFunction("Relief_Button_QuickStart",handler(self,self.onQuickStart))
        -- self.Relief_Button_QuickStart:setVisible(true)
    -- elseif data.data.StatusID == 1 then
    --     self.goBack:show()
    end
end

-- --[[
--  * 请求发放救济金
--  * @param  nil
-- --]]
-- function TPRelief:sendJiujiJinPacket()
--     -- if laixiaddz.LocalPlayercfg.LaixiaFreeGold and laixiaddz.LocalPlayercfg.LaixiaFreeGold == 1 then
--     --     -- local stream = Packet.new("CSReliefFund", _LAIXIA_PACKET_CS_ReliefFundID)
--     --     -- stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
--     --     -- stream:setValue("GameID", laixia.config.GameAppID)
--     --     -- laixia.net.sendHttpPacketAndWaiting(stream)
--     -- end
-- end

--[[
 * 关闭窗口
 * @param  sender    按钮
 * @param  eventType 事件
--]]
function TPRelief:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy();
    end
end

--[[
 * 请求救济金次数
 * @param  nil
--]]
function TPRelief:sendReceiveGoldPacket()
    local stream =  laixiaddz.Packet.new("reliefGet", "LXG_TASK_RELIEF_STATUS")
    stream:setReqType("get")
    print("laixiaddz.LocalPlayercfg.LaixiaPlayerID = ",laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("uid", laixiaddz.LocalPlayercfg.LaixiaPlayerID)
    laixiaddz.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        -- 查看是否可领取救济金
        if event.dm_error == 0 then 
            dump(event)
            if event.data then
                local data = event.data 
                if tonumber(data.status) == 1 then
                    -- 可领
                    local stream =  laixiaddz.Packet.new("reliefAdd", "LXG_TASK_RELIEF_ADD")
                    stream:setReqType("post")
                    stream:setValue("uid",laixiaddz.LocalPlayercfg.LaixiaPlayerID)
                    laixiaddz.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
                        dump(event)
                        if event.dm_error == 0 then 
                            local param = {}
                            param.StatusID = data.status
                            param.Gold = data.coin or 0
                            param.RemainCT = tonumber(data.max_receive) - tonumber(data.receive_count)
                            ObjectEventDispatch:pushEvent("ddz_scene_update_coin")
                            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_NOMONEY_WINDOW,param)
                        else
                            print(event.error_msg) 
                        end
                    end) 
                else
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"金币不足!")
                end
            end
        end
    end) 
end

-- --[[
--  * 关闭窗口
--  * @param  sender    按钮
--  * @param  eventType 事件
-- --]]
-- function TPRelief:onQuickStart(sender, eventType)
--     if eventType == ccui.TouchEventType.ended then
--         laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--         self:destroy();
--         if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" then
--             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,2)
--         else
--             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_QUICKGAME_WINDOW,2)
--         end
--     end
-- end

return TPRelief.new()


