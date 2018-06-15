--
-- Author: Feng
-- Date: 2018-05-16 16:52:13
--
--
-- Author: Feng
-- Date: 2018-05-05 12:07:42
--
--[[
    大厅主界面层

]]
local MessageUpLayer = class("MessageUpLayer", function()
        return display.newLayer()
    end)
local scene = cc.Director:getInstance():getRunningScene()


function MessageUpLayer:ctor(...)
    self:init(...)
end

function MessageUpLayer:init(...)
    self.data = ...

    local csbNode = cc.CSLoader:createNode("new_ui/MessageLayer.csb")
     _G.adapPanel_root(csbNode)
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy+200)
    self:addChild(csbNode)
    self.rootNode = csbNode
   
    
    self.Button_ok = _G.seekNodeByName(self.rootNode,"Button_ok")
    self.Button_ok:addTouchEventListener(handler(self, self.onTure))

    self.Button_back = _G.seekNodeByName(self.rootNode,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onBack))

    self.Button_ok_two = _G.seekNodeByName(self.rootNode,"Button_ok_two")
    self.Button_ok_two:addTouchEventListener(handler(self,self.SendPacketToServer))
    self.Button_ok_two:setVisible(false)

    self.Panel_accountmessage = _G.seekNodeByName(self.rootNode,"Panel_accountmessage")
    self.TextField_name = _G.seekNodeByName(self.Panel_accountmessage,"TextField_name")
    self.TextField_name:setVisible(false)
    self.TextField_address = _G.seekNodeByName(self.Panel_accountmessage, "TextField_address")
    self.TextField_address:setVisible(false)
    self.TextField_phonenumber = _G.seekNodeByName(self.Panel_accountmessage, "TextField_phonenumber")
    self.TextField_phonenumber:setVisible(false)

    --Panel_confirmmessage 下的节点
    self.Panel_confirmmessage = _G.seekNodeByName(self.rootNode,"Panel_confirmmessage")
    self.Panel_confirmmessage:setVisible(false)
    
       --名字
    self.Text_name = _G.seekNodeByName(self.Panel_confirmmessage,"Text_name")
        --地址
    self.Text_address = _G.seekNodeByName(self.Panel_confirmmessage, "Text_address")
        --电话
    self.Text_phonenumber = _G.seekNodeByName(self.Panel_confirmmessage, "Text_phonenumber")
    
    self.Image_inputname = _G.seekNodeByName(self.Panel_accountmessage,"Image_inputname")
    self.Image_inputaddress = _G.seekNodeByName(self.Panel_accountmessage,"Image_inputaddress")
    self.Image_inputphone = _G.seekNodeByName(self.Panel_accountmessage,"Image_inputphone")
    
    
   
    function editboxHandle1(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.phonenumber = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.phonenumber = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.phonenumber = sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    function editboxHandle2(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.name = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.name = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.name= sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    function editboxHandle3(strEventName,sender)  
        if strEventName == "began" then  
            sender:setText("")                                      --光标进入，清空内容/选择全部  
        elseif strEventName == "ended" then  
            self.address = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.address = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.address = sender:getText()                                                           --输入内容改变时调用   
        end  
    end
    self.labelNewName1 = ccui.EditBox:create(cc.size(336,39),"new_ui/message/xinxikuang.png")
    --self.labelNewName1:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.phonenumber = ""
    self.labelNewName1:setFontSize(24)
    self.labelNewName1:setAnchorPoint(0,0)  
    self.labelNewName1:setPosition(0,0)   
    self.labelNewName1:setMaxLength(11)                             --设置输入最大长度为6  
    self.labelNewName1:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName1:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName1:setPlaceHolder("请输入手机号！")               --设置预制提示文本
    self.labelNewName1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName1:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle1(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.Image_inputphone:addChild(self.labelNewName1)

    self.labelNewName2 = ccui.EditBox:create(cc.size(336,39),"new_ui/message/xinxikuang.png")
    --self.labelNewName2:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.name = ""
    self.labelNewName2:setFontSize(24)
    self.labelNewName2:setAnchorPoint(0,0)  
    self.labelNewName2:setPosition(0,0) 
    --self.labelNewName2:setMaxLength(50)                             --设置输入最大长度为6  
    self.labelNewName2:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName2:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName2:setPlaceHolder("请输入收货人姓名！")               --设置预制提示文本
    self.labelNewName2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName2:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle2(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.Image_inputname:addChild(self.labelNewName2)

    self.labelNewName3 = ccui.EditBox:create(cc.size(336,39),"new_ui/message/xinxikuang.png")
    --self.labelNewName3:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.address = ""
    self.labelNewName3:setFontSize(24)
    self.labelNewName3:setAnchorPoint(0,0)  
    self.labelNewName3:setPosition(0,0) 
    --self.labelNewName3:setMaxLength(50)                             --设置输入最大长度为6  
    self.labelNewName3:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName3:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName3:setPlaceHolder("请输入收货地址！")               --设置预制提示文本
    self.labelNewName3:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName3:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle3(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.Image_inputaddress:addChild(self.labelNewName3)

end

function MessageUpLayer:sendToMyBagPacket()
    local CSPackItems = Packet.new("CSPackItems", _LAIXIA_PACKET_CS_PackItemsID)
    CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end

--[[
    --关闭界面
]]
function MessageUpLayer:onBack(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then  
        self:removeAllChildren()  
    end
end

function MessageUpLayer:onClose()
    self:removeFromParent()
    self:removeFromParent()
end


function MessageUpLayer:onTure(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        -- self.name = self.TextField_name:getString()
        -- self.address = self.TextField_address:getString() 
        -- self.phonenumber = self.TextField_phonenumber:getString()
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

function MessageUpLayer:SendPacketToServer(sender, eventType)
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
                    self:removeFromParent()
                    print("request MessageLayer success")
                else
                    scene:popUpTips(data1.error_msg)
                    print("request MessageLayer error")
                end 
            end)
        end 
    end
end


return MessageUpLayer

