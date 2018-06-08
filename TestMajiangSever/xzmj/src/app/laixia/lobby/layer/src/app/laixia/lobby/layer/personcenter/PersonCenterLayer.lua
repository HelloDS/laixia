
--
-- Author: Feng
-- Date: 2018-05-03 12:53:49
--
local UItools = require("common.tools.UITools")
local isshow = false

local PersonCenterLayer = class("PersonCenterLayer" ,import("common.base.BaseDialog"))
local scene = cc.Director:getInstance():getRunningScene()

local MAX_NUM1 = 100000000; -- 1亿
local MAX_NUM2 = 10000;

function PersonCenterLayer:ctor()
    if isshow == true then
        return
    end
    
    self.super.ctor(self, "new_ui/PersonCenterLayer.csb")
    self:hide()
    self:requestPersonCenterData()
    

    local function onNodeEvent(event)
        if "enter" == event then
            isshow = true
        elseif "exit" == event then
            isshow = false
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

--[[
    个人中心
]]
function PersonCenterLayer:requestPersonCenterData()
    local stream =  laixia.Packet.new("person", "LXG_COUNT_INFO")
    stream:setReqType("get")
    stream:setValue("uids", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            self.isShow = true
            self:onGotoPersonCenter(data1)
            self:show()
        else
            scene:popUpTips(data1.error_msg)
            self:show()
            
        end  
    end)
end

function PersonCenterLayer:onGotoPersonCenter(packet)
    if #packet.data == 0 then
            packet.data[1] = {}
    end
    local data = packet.data[1]

    PrintTable(data)
    if data then
        laixia.LocalPlayercfg.LaixiaGameTotal = data.vices or 0  
        laixia.LocalPlayercfg.LaixiaBisaiNum = data.total or 0 
        laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = data.win_vices or 0
        laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = data.runnerup or 0
        laixia.LocalPlayercfg.LaixiaPlayerRate = data.probability or 0
        laixia.LocalPlayercfg.LaixiaBisaiSecond = data.champions or 0
    else
        laixia.LocalPlayercfg.LaixiaGameTotal = 0
        laixia.LocalPlayercfg.LaixiaBisaiNum = 0
        laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = 0
        laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = 0
        laixia.LocalPlayercfg.LaixiaPlayerRate = 0
        laixia.LocalPlayercfg.LaixiaBisaiSecond = 0
    end

    self:init()
end

function PersonCenterLayer:init()

    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onGotoBack))

    self.Image_icon = _G.seekNodeByName(self.rootNode,"Image_icon")
    self.Image_icon:setVisible(false)
    self.Image_icon_frame = _G.seekNodeByName(self.rootNode,"Image_icon_frame")
    self.Text_name = _G.seekNodeByName(self.rootNode,"Text_name")
    self.Text_ID = _G.seekNodeByName(self.rootNode,"Text_ID")
    self.Text_laidou = _G.seekNodeByName(self.rootNode,"Text_laidou")
    self.Text_phonebind = _G.seekNodeByName(self.rootNode,"Text_phonebind")
    self.Button_phonebind = _G.seekNodeByName(self.rootNode,"Button_phonebind")
    self.Button_phonebind:addTouchEventListener(handler(self,self.onGotoPhonebind))
    self.Image_phonebind = _G.seekNodeByName(self.rootNode,"Image_phonebind")
    self.Button_wenhao = _G.seekNodeByName(self.rootNode,"Button_wenhao")
    self.Button_wenhao:addTouchEventListener(handler(self,self.onGotoWenhao))

    -- self.Text_des_1 = _G.seekNodeByName(self.rootNode,"Text_des_1")
    -- self.Text_des_1:setString("游戏场总副数:")
    -- self.Text_des_2 = _G.seekNodeByName(self.rootNode,"Text_des_2")
    -- self.Text_des_2:setString("参赛总场次:")
    -- self.Text_des_3 = _G.seekNodeByName(self.rootNode,"Text_des_3")
    -- self.Text_des_3:setString("游戏胜利总数:")
    -- self.Text_des_4 = _G.seekNodeByName(self.rootNode,"Text_des_4")
    -- self.Text_des_4:setString("冠军总次数:")
    -- self.Text_des_5 = _G.seekNodeByName(self.rootNode,"Text_des_5")
    -- self.Text_des_5:setString("游戏场总胜率:")
    -- self.Text_des_6 = _G.seekNodeByName(self.rootNode,"Text_des_6")
    -- self.Text_des_6:setString("亚军总次数:")

    self.Text_yxc_total_number = _G.seekNodeByName(self.rootNode,"Text_yxc_total_number")
    self.Text_bsc_total_number = _G.seekNodeByName(self.rootNode,"Text_bsc_total_number")
    self.Text_yxc_win_number = _G.seekNodeByName(self.rootNode,"Text_yxc_win_number")
    self.Text_bsc_win_number = _G.seekNodeByName(self.rootNode,"Text_bsc_win_number")
    self.Text_yxc_win_rate = _G.seekNodeByName(self.rootNode,"Text_yxc_win_rate")
    self.Text_bsc_second_number = _G.seekNodeByName(self.rootNode,"Text_bsc_second_number")
    self.Text_tishi = _G.seekNodeByName(self.rootNode,"Text_tishi")

    print(",,,,,,,,,,,," .. laixia.LocalPlayercfg.PhoneNumber)
    laixia.LocalPlayercfg.PhoneNumber = "8613211118888"
    if laixia.LocalPlayercfg.PhoneNumber == nil or laixia.LocalPlayercfg.PhoneNumber == "" then
        self.Button_phonebind:setVisible(true)
        self.Image_phonebind:setVisible(true)
        self.Text_phonebind:setString("请绑定手机号")
        self.Text_tishi:setVisible(false)
    else
        self:refreshPhone()
        self.Text_tishi:setVisible(true)
        self.Button_phonebind:setVisible(false)
        self.Image_phonebind:setVisible(false)
    end

    self:initData()
    self:addHead()
end

function PersonCenterLayer:addHead()
    local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"
    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        path = localIconName
    end
    self:addHeadIcon(self.Image_icon_frame,path)
end

function PersonCenterLayer:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
    local templet = "images/touxiangkuang_now.png"
    UItools.addHead(head_btn, path, templet)
   
end

function PersonCenterLayer:refreshPhone()
    local numberstr = tostring(laixia.LocalPlayercfg.PhoneNumber)
    if string.sub(numberstr, 1,2 ) == "86" then
        local len = string.len(numberstr )
        numberstr = string.sub(numberstr,3,len)
    end
    self.Text_phonebind:setString(numberstr)
    self.Button_phonebind:setTouchEnabled(false)
end

function PersonCenterLayer:initData()
    self.Text_name:setString(tostring(laixia.LocalPlayercfg.LaixiaPlayerNickname))
    self.Text_ID:setString("用户ID：" .. tostring(laixia.LocalPlayercfg.LaixiaPlayerID))
    self.Text_laidou:setString(tostring(laixia.LocalPlayercfg.LaixiaLdCoin))
    --1
    self.Text_yxc_total_number:setString(tostring(laixia.LocalPlayercfg.LaixiaGameTotal))
    self.Text_bsc_total_number:setString(tostring(laixia.LocalPlayercfg.LaixiaBisaiNum))
    self.Text_yxc_win_number:setString(tostring(laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes))
    self.Text_bsc_win_number:setString(tostring(laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes)) 
    self.Text_yxc_win_rate:setString(tostring(laixia.LocalPlayercfg.LaixiaPlayerRate*100) .. "%")
    self.Text_bsc_second_number:setString(tostring(laixia.LocalPlayercfg.LaixiaBisaiSecond))
end

function PersonCenterLayer:onGotoWenhao(sender,eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.beganed then
        return true
    elseif eventType == ccui.TouchEventType.moveed then
    elseif eventType == ccui.TouchEventType.ended then
        local LaidouNode = cc.CSLoader:createNode("new_ui/LaidouTipsNode.csb")
        --LaidouNode:setAnchorPoint(0.5, 0.5)
        local size = self.Button_wenhao:getContentSize()
        LaidouNode:setPosition(cc.p(size.width,size.height))
        self.Button_wenhao:addChild(LaidouNode,10)
        self.Button_wenhao:runAction(cc.Sequence:create(
            cc.DelayTime:create(2),
            cc.CallFunc:create(
                function()
                    if LaidouNode then
                        LaidouNode:removeFromParent()
                        LaidouNode = nil
                    end                          
                end),nil))
    end
end

function PersonCenterLayer:onGotoPhonebind(sender,eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.beganed then
        return true
    elseif eventType == ccui.TouchEventType.moveed then
    elseif eventType == ccui.TouchEventType.ended then
        local PhoneBindLayer = require("lobby.layer.personcenter.PhoneBindLayer").new(self)
        self:addChild(PhoneBindLayer)
    end
end

function PersonCenterLayer:onGotoBack(sender,eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.beganed then
        return true
    elseif eventType == ccui.TouchEventType.moveed then
    elseif eventType == ccui.TouchEventType.ended then
        self:removeFromParent()
    end
end

return PersonCenterLayer