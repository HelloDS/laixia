--
-- @Author: shegnli
-- @Date:   2018-05-08 18:23:28
-- 

local schedu = require("framework.scheduler")
local EmailLayer = class("EmailLayer" , import("common.base.BaseDialog"))
local isshow = false

--[[
 * 构造函数
 * @param  data
--]]
function EmailLayer:ctor(...)
    if isshow == true then
        return
    end
    self.super.ctor(self, "new_ui/EmailLayer.csb")
    self.addItemNum = 5
    self:init(...)
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
 * 初始化界面
 * @param  data = {{content,id,is_del,mail_id,send_time,status,type,uid}}
--]]
function EmailLayer:init(...)
    self.Panel_root = _G.seekNodeByName(self.rootNode, "Panel_root")
    self.Button_cleanup = _G.seekNodeByName(self.rootNode,"Button_cleanup")
    self.Text_desc = _G.seekNodeByName(self.rootNode,"Text_desc")
    self.Button_cleanup:addTouchEventListener(handler(self,self.onTouchEvent))
    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self, self.onTouchEvent))
    self.ListView_email = _G.seekNodeByName(self.rootNode,"ListView_email")
    self:updateWindow(...)
    self.__Timer = schedu.scheduleUpdateGlobal(handler(self,self.onTick))
    _G.adapPanel_root(csbNode)
end

--[[
 * 更新
 * @param  msg = {{content,id,is_del,mail_id,send_time,status,type,uid}}
--]]
function EmailLayer:updateWindow(data)
    self.letterArray = {}
    self.mIndex = 0
    if data and type(data) == "table" then
        self.letterArray = data
    end
    self.Text_desc:setVisible(#self.letterArray == 0)
end

function EmailLayer:onTick(dt)
    if self.letterArray ~= nil then
        if self.mIndex == #self.letterArray then
            self:stopTimer()
            return
        end
        local old = self.mIndex + 1
        if self.mIndex + self.addItemNum > #self.letterArray then
            self.mIndex = #self.letterArray
            self:stopTimer()
        else
            self.mIndex =self.mIndex + self.addItemNum
        end
        self:addLetterLiset(old, self.mIndex)
    end
end

--[[
 * 按钮点击事件
 * @param  begin 起始
 * @param  overChoose  结束
--]]
function EmailLayer:addLetterLiset(begin,overChoose)
    for i = begin, overChoose do
        local item = require "lobby.layer.email.EmailNode".new()
        item:loadData(self.letterArray[i])
        self.ListView_email:pushBackCustomItem(item)
    end
end

--[[
 * 按钮点击事件
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function EmailLayer:onTouchEvent(sender, eventType)
    _G.onTouchButton(sender, eventType)
    local senderName = sender:getName()
    if eventType == ccui.TouchEventType.ended then 
        if senderName == "Button_cleanup" then
            if self.letterArray and type(self.letterArray) == "table" and #self.letterArray == 0 then
                print("没有可清理的邮件！")
            else
                sender:setTouchEnabled(false)
                self:emailCleanReq()
            end
        elseif senderName == "Button_back" then
            self:onBack()
        end
    end
end

--[[
 * 清空邮件
 * @param  msg 
--]]
function EmailLayer:onCleanup(msg)
    self.Text_desc:setVisible(true)
    self.Button_cleanup:setTouchEnabled(true)
    self.ListView_email:removeAllItems()
end

--[[
 * 清空邮件请求
 * @param  nil 
--]]
function EmailLayer:emailCleanReq()


    local stream =  laixia.Packet.new("email", "LXG_MAIL_CLEAR")
    stream:setReqType("post")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            self:onCleanup(msg)
        else
            self.Button_cleanup:setTouchEnabled(true)
        end 
    end) 


    -- local sendPacket = cc.XMLHttpRequest:new()
    -- sendPacket.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- sendPacket:registerScriptHandler(function()
    --     local statusString = "Http Status Code:"..sendPacket.readyState  
    --     local data_json = sendPacket.response
    --     local data1 = json.decode(data_json)
    --     if data1.dm_error == 0 then
    --         self:onCleanup(msg)
    --     else
    --         self.Button_cleanup:setTouchEnabled(true)
    --     end 
    -- end)
    -- local URL1 = "47.93.102.58:9230/mail/clear_mail"
    -- local param = {}
    -- param["uid"] = laixia.LocalPlayercfg.LaixiaPlayerID
    -- local par = json.encode(param)
    -- sendPacket:open("POST",URL1,true)
    -- sendPacket:send(par)
end

--[[
 * 关闭邮件
 * @param  msg 
--]]
function EmailLayer:onBack()
    self.rootNode = nil
    self:stopTimer()
    self:onDestroy()
    self:removeFromParent() 
end

--[[
 * 关闭计时器
--]]
function EmailLayer:stopTimer()
    if self.__Timer then
        schedu.unscheduleGlobal(self.__Timer)
        self.__Timer = nil
    end 
end

--[[
 * 注销
 * @param  nil 
--]]
function EmailLayer:onDestroy()
    self.letterArray = nil
    self.mIndex = nil
    self.addItemNum = nil
end

return EmailLayer