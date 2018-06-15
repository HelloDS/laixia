--
-- Author: Feng
-- Date: 2018-05-08 15:56:58
--


--[[
    大厅主界面层
]]
local scene = cc.Director:getInstance():getRunningScene()

local MessageLayer = class("MessageLayer" ,function()
        return display.newLayer()
    end)

--[[
    构造函数
]]
function MessageLayer:ctor(...)
    self:init(...)
end

--[[
    初始化
]]
function MessageLayer:init(...)
    self.data = ...
    --初始化界面
    -- local csbNode = cc.CSLoader:createNode("new_ui/MessageLayer.csb")
    -- csbNode:setAnchorPoint(0.5, 0.5)
    -- csbNode:setPosition(display.cx,display.cy)
    -- self:addChild(csbNode)
    -- self.rootNode = csbNode
    -- _G.adapPanel_root(csbNode)

    self.Button_ok = _G.seekNodeByName(self.rootNode,"Button_ok")
    self.Button_ok:addTouchEventListener(handler(self, self.onTure))

    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))

    self.Button_ok_two = _G.seekNodeByName(self.rootNode,"Button_ok_two")
    self.Button_ok_two:addTouchEventListener(handler(self,self.SendPacketToServer))
    self.Button_ok_two:setVisible(false)

    self.Panel_accountmessage = _G.seekNodeByName(self.rootNode,"Panel_accountmessage")
    self.TextField_name = _G.seekNodeByName(self.Panel_accountmessage,"TextField_name")
    self.TextField_address = _G.seekNodeByName(self.Panel_accountmessage, "TextField_address")
    self.TextField_phonenumber = _G.seekNodeByName(self.Panel_accountmessage, "TextField_phonenumber")


    --Panel_confirmmessage 下的节点
    self.Panel_confirmmessage = _G.seekNodeByName(self.rootNode,"Panel_confirmmessage")
    self.Panel_confirmmessage:setVisible(false)
        --名字
    self.Text_name = _G.seekNodeByName(self.Panel_confirmmessage,"Text_name")
        --地址
    self.Text_address = _G.seekNodeByName(self.Panel_confirmmessage, "Text_address")
        --电话
    self.Text_phonenumber = _G.seekNodeByName(self.Panel_confirmmessage, "Text_phonenumber")


end

function MessageLayer:onInput(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.name = self.TextField_name:getString()
        self.address = self.TextField_address:getString() 
        self.phonenumber = self.TextField_phonenumber:getString()
        if self.name == "" or self.name == nil then
            print("请输入收货人姓名!")
            scene:popUpTips("请输入收货人姓名!")
        elseif self.address == "" or self.address == nil then
            print("请输入收货人地址!")
            scene:popUpTips("请输入收货人地址!")
        elseif string.len(self.phonenumber) < 11  or tonumber(self.phonenumber) ==nil then
            print("请输入11位手机号!")
            scene:popUpTips("请输入11位手机号!")
            return
        end
    end
end

function MessageLayer:onTure(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.name = self.TextField_name:getString()
        self.address = self.TextField_address:getString() 
        self.phonenumber = self.TextField_phonenumber:getString()
        if self.name == "" or self.name == nil then
            print("请输入收货人姓名")
            scene:popUpTips("请输入收货人姓名!")
            return
        elseif self.address == "" or self.address == nil then
            print("请输入收货人地址！")
            scene:popUpTips("请输入收货人地址!")
            return
        elseif string.len(self.phonenumber) < 11  or tonumber(self.phonenumber) ==nil then
            print("请输入11位手机号")
            scene:popUpTips("请输入11位手机号!")
            return
        end
        self.Text_name:setString(self.name)
        self.Text_address:setString(self.address)
        self.Text_phonenumber:setString(self.phonenumber)
        --确认之后 信息预览ui显示 确认之后 才发送请求
        self.Panel_accountmessage:setVisible(false)
        self.Panel_confirmmessage:setVisible(true)
        self.Button_ok_two:setVisible(true)
        self.Button_ok:setVisible(false)
    end
end

function MessageLayer:SendPacketToServer(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.data.page == "MyBagWindow" then
            --发送确认请求*************************************
            print("uid" .. laixia.LocalPlayercfg.LaixiaPlayerID)
            print("item_id" .. self.data.ID)
            print("item_ct" .. self.data.item_ct)
            print("realname" .. self.name)
            print("phonenum" .. self.phonenumber)
            print("address" .. self.address)
            local stream =  laixia.Packet.new("bag", "LXG_BAGPACK_USE")
            stream:setReqType("post")
            stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
            stream:setValue("item_id", self.data.ID)
            stream:setValue("item_ct", self.data.item_ct)
            stream:setValue("realname", self.name)
            stream:setValue("phonenum", self.phonenumber)
            stream:setValue("address", self.address)

            laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
                local data1 = event
                print("MessageLayer  data1.dm_error" .. data1.dm_error)
                if data1.dm_error == 0 then
                    scene:popUpTips("使用成功")
                    self.data.obj:sendRequest()
                    self:removeAllChildren()
                    print("request MessageLayer success")
                else
                    scene:popUpTips(data1.error_msg)
                    print("request MessageLayer error")
                end 
            end)
        end 
    end
end

--[[
    --关闭界面
]]
function MessageLayer:onBack()
    self:removeAllChildren()
    self.rootNode = nil
    self.name = nil
    self.address = nil
    self.phonenumber = nil
end

return MessageLayer
