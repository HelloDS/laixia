--
-- Author: Feng
-- Date: 2018-05-05 12:07:42
--
--[[
    大厅主界面层

]]
local JsonTxtData = require("lobby.data.init")
local PopUpLayer = class("PopUpLayer" ,import("common.base.BaseDialog"))
local scene = cc.Director:getInstance():getRunningScene()
--[[
    构造函数
]]
function PopUpLayer:ctor(arg1,arg2, ItemType)
    self.super.ctor(self, "new_ui/PopUpLayer.csb")
    self:init(arg1,arg2, ItemType)
end

--[[
    初始化
]]
function PopUpLayer:init(arg1,arg2, ItemType)
--初始化界面
    self.m_itemType = ItemType
    JsonTxtData:init()
    local data = arg1
    self.obj = arg2.obj
    self.curItemID = arg2.ItemID
    self.curItemObjectID = arg2.ObtainItemIDList

    -- local csbNode = cc.CSLoader:createNode("new_ui/PopUpLayer.csb")
    -- csbNode:setAnchorPoint(0.5, 0.5)
    -- csbNode:setPosition(display.cx,display.cy)
    -- self:addChild(csbNode)
    -- self.rootNode = csbNode
    -- _G.adapPanel_root(csbNode)

    if self.m_itemType == 5 then    
        local Text_redpacket = _G.seekNodeByName(self.rootNode,"Text_redpacket")
        Text_redpacket:setString("兑换现金")
        local Text_gold = _G.seekNodeByName(self.rootNode,"Text_gold")
        Text_gold:setString("兑换金币")
        local itemMsg = JsonTxtData:queryTable("items"):query("ItemID",self.curItemID);
        if not itemMsg.ObtainItemIDList then
            _G.seekNodeByName(self.rootNode,"CheckBox_gold"):setVisible(false)
            _G.seekNodeByName(self.rootNode,"Text_gold"):setVisible(false)
        end
    end

    --返回按钮
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))

    --确定按钮
    self.Button_ok = _G.seekNodeByName(self.rootNode,"Button_ok")
    self.Button_ok:addTouchEventListener(handler(self,self.onSure))

    local duihuanText = _G.seekNodeByName(self.rootNode,"Text_gold")
    local duihuanArr = string.split(data, ",")

    self.CheckBox_hongbao = _G.seekNodeByName(self.rootNode,"CheckBox_redpacket")
    self.CheckBox_duihuan = _G.seekNodeByName(self.rootNode,"CheckBox_gold")

    self.CheckBox_hongbao:setSelected(true)
    self.index = 1
    self.CheckBox_duihuan:setSelected(false)


    --兑换金币/来豆数
    for index, value in pairs(duihuanArr) do
        local temp = string.split(value,":")
        if #temp>1 then
            self.duihuanNum = tonumber(temp[2])
            if temp[1] == "1001" then
                -- self.tag = 1
                duihuanText:setString(self.duihuanNum.."金币")
            elseif temp[1] == "1002" then
                -- self.tag = 0
                duihuanText:setString(self.duihuanNum.."来豆")
            end
        end
    end


    local function callback(sender, eventType)  
        _G.onTouchButton(sender, eventType)
        if sender ==  self.CheckBox_hongbao then
            if eventType == ccui.CheckBoxEventType.selected then
                print("1111")
                self.CheckBox_hongbao:setSelected(true)
                self.CheckBox_duihuan:setSelected(false)
            else
            end
        else 
            if eventType == ccui.CheckBoxEventType.selected then
                print("2222")
                self.CheckBox_duihuan:setSelected(true)
                self.CheckBox_hongbao:setSelected(false)
            else
            end
        end
    end  
    self.CheckBox_hongbao:addEventListener(callback)  
    self.CheckBox_duihuan:addEventListener(callback)

    self.isTouched = false

end

function PopUpLayer:onSure(sender,eventType)
    _G.onTouchButton(sender, eventType)
     if eventType == ccui.TouchEventType.ended then  
        if self.isTouched == true then
            return
        end
        self.isTouched = true
        local sender = {}
        sender.ItemID = self.curItemID
        sender.ItemObjectID  = self.curItemObjectID
        local itemMsg = JsonTxtData:queryTable("items"):query("ItemID",sender.ItemID);
        --点击确定必须有一个不为空
        if self.CheckBox_duihuan:isSelected() == true then  
            --这个是发起兑换金币/来豆请求************************
            if itemMsg.isDisapear == 1 then
                --发送请求

                -- self.obj:sendRequest()
                self:setUseThing(sender.ItemID, 1)
                self:removeAllChildren()
            end
        elseif self.CheckBox_hongbao:isSelected() == true then
            --发送请求

            -- self.obj:sendRequest()
            self:setUseThing(sender.ItemID, 2)
            self:removeAllChildren()
        end
        self.isTouched = false
    end
end

--[[
    使用红包 微信现金
]]
function PopUpLayer:setUseThing(itemid, useType)
    if not itemid then
        print("not itemid")
        return
    end
    local stream =  laixia.Packet.new("", "LXG_BAGPACK_USE")
    stream:setReqType("post")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("item_id", itemid)
    stream:setValue("use_type", useType)
    stream:setValue("item_ct", 1)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        if event.dm_error == 0 then
            print("OK")
            -- 更新金币
            if useType == 1 then
                local scene = cc.Director:getInstance():getRunningScene()
                if scene.updateGold then
                    scene:updateGold(self.duihuanNum)
                end
            end
            self.obj:sendRequest()
        else
            scene:popUpTips(data1.error_msg)
        end 
    end)
end

--[[
    --关闭界面
]]
function PopUpLayer:onBack(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then  
        self:removeAllChildren()  
    end
end

return PopUpLayer