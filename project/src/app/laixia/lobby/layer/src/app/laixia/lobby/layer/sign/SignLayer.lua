--
-- @Author: shegnli
-- @Date:   2018-05-08 16:43:08
-- 

local SignLayer = class("SignLayer" , import("common.base.BaseDialog"))
local isshow = false

--[[
 * 构造函数
 * @param  data = {playerInfo = {cur_day,days,first_time,has_get},signList = {{day,item_ct,item_id}}}
--]]
function SignLayer:ctor(...)
    self.super.ctor(self, "new_ui/SignLayer.csb")
    self:init(...)
end

--[[
 * 初始化界面
 * @param  data = {playerInfo = {cur_day,days,first_time,has_get},signList = {{day,item_ct,item_id}}}
--]]
function SignLayer:init(data)
    if isshow == true then
        return
    end
    self.itemNumMax = 7  -- 签到最大天数
    self.signDayNum = 1  -- 已经签到的天数
    self.stateType={GET = 1,UNGET = 2}-- 1 当天可  2领过
    self.signState = self.stateType.UNGET   
    self.Panel_root = _G.seekNodeByName(self.rootNode, "Panel_root")
    self.Button_Receive = _G.seekNodeByName(self.rootNode,"Button_Receive")
    self.Button_Receive:addTouchEventListener(handler(self,self.onTouchEvent))
    self.Button_close = _G.seekNodeByName(self.rootNode,"Button_close")
    self.Button_close:addTouchEventListener(handler(self, self.onTouchEvent))
    for i=1,self.itemNumMax do
        self["Panel_item"..i] = _G.seekNodeByName(self.rootNode,"Panel_item"..i)
        self["Panel_item"..i]:addTouchEventListener(handler(self,self.onTouchEvent))
    end
    self.signList = data.signList
    self:loadData(data)

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
 * 读取数据
 * @param  data = {playerInfo = {cur_day,days,first_time,has_get},signList = {{day,item_ct,item_id}}}
--]]
function SignLayer:loadData(data)
    if data.playerInfo and data.playerInfo.has_get then
        -- 当天是否可领取
        local playerInfo = data.playerInfo
        local has_get = playerInfo.has_get
        if has_get == 1 then
            self.Button_Receive:setBright(false)
            self.Button_Receive:setTouchEnabled(false)
            self.signState = self.stateType.UNGET
        else
            self.Button_Receive:setBright(true)
            self.Button_Receive:setTouchEnabled(true)
            self.signState = self.stateType.GET 
        end
        self.signDayNum = playerInfo.cur_day
        if self.signDayNum > self.itemNumMax then
            self.signDayNum = self.itemNumMax
        end
        -- 初始化全部节点
        local itemData
        local item
        for i=1,self.itemNumMax do
            itemData = self.signList[i]
            item = self["Panel_item"..i]
            local Text_Money_Num = _G.seekNodeByName(item,"Text_Money_Num")
            Text_Money_Num:setString(itemData.item_ct)
            if i < self.signDayNum then
                -- 领过
                local Image_Received_Icon = _G.seekNodeByName(item,"Image_Received_Icon")
                Image_Received_Icon:setVisible(true)
                item:setTouchEnabled(false)
                local Image_Everyday_light = _G.seekNodeByName(item,"Image_Everyday_light")
                Image_Everyday_light:setVisible(false)
                local Image_guang = _G.seekNodeByName(item,"Image_guang")
                if Image_guang then
                    Image_guang:setVisible(false)
                end
            elseif (i == self.signDayNum) then
                -- 当天
                if self.signState == self.stateType.GET then
                    -- 可领
                    item:setTouchEnabled(true)
                    local Image_Everyday_light = _G.seekNodeByName(item,"Image_Everyday_light")
                    Image_Everyday_light:setVisible(true)
                    local Image_guang = _G.seekNodeByName(item,"Image_guang")
                    if Image_guang then
                        Image_guang:setVisible(true)
                    end
                    local Image_Received_Icon = _G.seekNodeByName(item,"Image_Received_Icon")
                    Image_Received_Icon:setVisible(false)
                elseif self.signState == self.stateType.UNGET then
                    -- 领过
                    local Image_Received_Icon = _G.seekNodeByName(item,"Image_Received_Icon")
                    Image_Received_Icon:setVisible(true)
                    item:setTouchEnabled(false)
                    local Image_Everyday_light = _G.seekNodeByName(item,"Image_Everyday_light")
                    Image_Everyday_light:setVisible(false)
                    local Image_guang = _G.seekNodeByName(item,"Image_guang")
                    if Image_guang then
                        Image_guang:setVisible(false)
                    end
                end
            else
                -- 不能领
                local Image_Received_Icon = _G.seekNodeByName(item,"Image_Received_Icon")
                Image_Received_Icon:setVisible(false)
                local Image_Everyday_light = _G.seekNodeByName(item,"Image_Everyday_light")
                Image_Everyday_light:setVisible(false)
                local Image_guang = _G.seekNodeByName(item,"Image_guang")
                if Image_guang then
                    Image_guang:setVisible(false)
                end
            end
        end
    end
end

--[[
 * 按钮点击事件
 * @param  sender 点击按钮
 * @param  event  事件类型
--]]
function SignLayer:onTouchEvent(sender, eventType)
    _G.onTouchButton(sender, eventType)
    local senderName = sender:getName()
    if eventType == ccui.TouchEventType.ended then 
        if senderName == "Button_Receive" then
            if self.signState == self.stateType.GET then
                self:signReq()
            else
                print("没有可领取的！")
                local scene = cc.Director:getInstance():getRunningScene()
                scene:updateGold(self.signList[self.signDayNum].item_ct)
            end
        elseif senderName == "Button_close" then
            local scene = cc.Director:getInstance():getRunningScene()
            scene:onGotoNotice()
            self:close()
        else
            if self.signState == self.stateType.GET then
                self:signReq()
            else
                print("明天再来！")
                -- self.signDayNum = self.signDayNum + 1
                -- self:signSuccess()
            end
        end
    end
end

--[[
 * 签到请求
 * @param  nil 
--]]
function SignLayer:signReq()
    local item = self["Panel_item"..(self.signDayNum)]
    if not item then return end
    -- 协议发送过程不允许瞎点
    local stream =  laixia.Packet.new("signreq", "LXG_SIGN_PLAYER")
    stream:setReqType("post")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        local scene = cc.Director:getInstance():getRunningScene()
        if data1.dm_error == 0 then
            self:signSuccess()
            scene:popUpTips("签到成功")
        else
            self:signFail()
            scene:popUpTips(data1.error_msg)
        end
    end)
end

--[[
 * 签到失败
 * @param  nil 
--]]
function SignLayer:signFail()
    print("签到失败！")
    -- 失败后可以继续点击
    local item = self["Panel_item"..(self.signDayNum)]
    item:setTouchEnabled(true)
    self.Button_Receive:setBright(true)
    self.Button_Receive:setTouchEnabled(true)
end

--[[
 * 签到成功
 * @param  nil 
--]]
function SignLayer:signSuccess()
    -- 更新金币
    local scene = cc.Director:getInstance():getRunningScene()
    scene:updateGold(self.signList[self.signDayNum].item_ct)
    print("签到成功获得%s金币",self.signList[self.signDayNum].item_ct)
    self.signState = self.stateType.UNGET
    local item = self["Panel_item"..(self.signDayNum)]
    item:setTouchEnabled(false)
    self.Button_Receive:setBright(false)
    self.Button_Receive:setTouchEnabled(false)

    -- TODO 是否关闭当前界面
    -- TODO 特效
    self:showTip()
    self:addAnimation()
end

function SignLayer:showTip()
    self.csbNode_ = cc.CSLoader:createNode("new_ui/SignAniNode.csb")
    _G.adapPanel_root(self.csbNode_)
    self.csbNode_:setAnchorPoint(0.5, 0.5)
    self.csbNode_:setPosition(cc.p(self.rootNode:getContentSize().width/2,self.rootNode:getContentSize().height/3))
    self.rootNode:addChild(self.csbNode_)
    local Image_sign_ = _G.seekNodeByName(self.csbNode_,"Image_sign_")
    local Text_number = _G.seekNodeByName(self.csbNode_,"Text_number")
    print("mmmmmmmmmmmmmmmmmm" .. self.signDayNum)
    local path = "new_ui/sigin/jinbi" .. self.signDayNum .. ".png"
    Image_sign_:loadTexture(path)
    Text_number:setString(self.signList[self.signDayNum].item_ct .. "金币")
end

--[[
 * 添加特效
 * @param  msg 
--]]
function SignLayer:addAnimation()
    local item = self["Panel_item"..self.signDayNum]
    local icon = _G.seekNodeByName(item,"Image_Everyday_light")
    icon:setVisible(true)
    local path = "new_ui/lobby_qiandao.csb"
    local callback = function ()
        local img = _G.seekNodeByName(item,"Image_Everyday_light")
        img:setVisible(false)

        img = _G.seekNodeByName(item,"Image_Received_Icon")
        img:setVisible(true)
     
        img = _G.seekNodeByName(item,"Image_guang")
        if img then
            img:setVisible(false)
        end
    end
    local node = self:playAnimationAt(2,icon,path,false,callback)
    node:setPosition(cc.p(icon:getPositionX() + icon:getContentSize().width/2,icon:getPositionY() + icon:getContentSize().height/2))


    local icon = _G.seekNodeByName(item,"Image_Money_Icon")
    icon:setVisible(true)
    local path = "new_ui/lobby_qiandao_reward.csb"
    local callback = function ()
    end
    local node = self:playAnimationAt(1,self.rootNode,path,false,callback)
    -- node:setPosition(cc.p(icon:getPositionX() + icon:getContentSize().width/2,icon:getPositionY() + icon:getContentSize().height/2))
end

--[[
 * 播放特效特效
 * @param  parent 节点
 * @param  path   路径
 * @param  loop   循环
 * @param  callback 回调 
--]]
function SignLayer:playAnimationAt(type_,parent,path,loop,callback)
    local node = cc.CSLoader:createNode(path)
    node:setPosition(cc.p(parent:getContentSize().width/2,parent:getContentSize().height/3))
    node:addTo(parent);
    local action = cc.CSLoader:createTimeline(path)
    node:runAction(action)
    action:gotoFrameAndPlay(0,loop)
    local speed = action:getTimeSpeed()
    local startFrame = action:getStartFrame()
    local endFrame = action:getEndFrame()
    local frameNum = endFrame - startFrame
    local time = 1.0/(speed*60.0)*frameNum
    if loop == false then
        node:runAction(cc.Sequence:create(
                       cc.DelayTime:create(time),
                       cc.CallFunc:create(function()
                            node:removeFromParent()
                            if type_ == 1 then
                                self.csbNode_:removeFromParent()
                            end
                            if callback then callback() end
                       end
        ),nil))
    end
    return node
end

--[[
 * 关闭
 * @param  msg 
--]]
function SignLayer:onClose()
    self.rootNode = nil
    self.itemNumMax = nil
    self.signDayNum = nil
    self.haveDay = nil
    self.signList = nil
    self.stateType = nil
    self.signState = nil
end

return SignLayer