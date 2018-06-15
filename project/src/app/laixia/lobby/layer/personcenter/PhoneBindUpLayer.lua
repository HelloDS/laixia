--
-- Author: Feng
-- Date: 2018-05-03 17:18:47
--

local scene = cc.Director:getInstance():getRunningScene()

local PhoneBindUpLayer = class("PhoneBindUpLayer" ,function()
        return display.newLayer()
    end)
local PHONECODE_TIME = 60;

function PhoneBindUpLayer:ctor(...)
    self:init(...)
end

function PhoneBindUpLayer:init(...)
    self.obj = ...
    local csbNode = cc.CSLoader:createNode("new_ui/PhoneBindLayer.csb")
    _G.adapPanel_root(csbNode)
     csbNode:setAnchorPoint(0.5, 0.5)
     csbNode:setPosition(display.cx,display.cy+200)
    self:addChild(csbNode)
    self.rootNode = csbNode
    

    self.Panel_root = _G.seekNodeByName(self.rootNode,"Panel_root")
    self.Image_bg_2 = _G.seekNodeByName(self.Panel_root,"Image_bg_2")

    self.Image_phonenumber_bg = _G.seekNodeByName(self.Panel_root,"Image_phonenumber_bg")
    self.Image_verification_code_bg = _G.seekNodeByName(self.Panel_root,"Image_verification_code_bg")

    self.TextField_phonenumber = _G.seekNodeByName(self.Panel_root,"TextField_phonenumber")
    self.TextField_phonenumber:setVisible(false)
    self.TextField_verification_code = _G.seekNodeByName(self.Panel_root,"TextField_verification_code")
    self.TextField_verification_code:setVisible(false)
    --获取验证码的按钮
    self.Button_getcode = _G.seekNodeByName(self.Panel_root,"Button_getcode")
    self.Image_getcode = _G.seekNodeByName(self.Panel_root,"Image_getcode")
    self.Button_getcode:setVisible(true)
    self.Image_getcode:setVisible(true)

    self.Button_getcode:addTouchEventListener(handler(self,self.getCode))
    --重新获取校验码的按钮
    self.Button_chongxinGet = _G.seekNodeByName(self.Panel_root,"Button_chongxinGet")
    self.Button_chongxinGet:setTouchEnabled(false)
    self.Button_chongxinGet:addTouchEventListener(handler(self,self.getCode))
    self.Label_Time_Over = _G.seekNodeByName(self.Button_chongxinGet,"Label_Time_Over")
    self.Label_Time_Over:setVisible(false)
    self.Button_chongxinGet:setVisible(false)
    -- 绑定手机的按钮
    self.Button_bindPhone = _G.seekNodeByName(self.Panel_root,"Button_bindPhone")
    self.Button_bindPhone:addTouchEventListener(handler(self,self.sendBindPacket))
    -- 返回的按钮
    self.Button_Back = _G.seekNodeByName(self.Panel_root,"Button_Back")
    self.Button_Back:addTouchEventListener(handler(self,self.onGotoBack))
    self.isschedu = false

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
            self.code = sender:getText()                                                    --当编辑框失去焦点并且键盘消失的时候被调用  
        elseif strEventName == "return" then  
            self.code = sender:getText()                                                           --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用  
        elseif strEventName == "changed" then  
            self.code= sender:getText()                                                           --输入内容改变时调用   
        end  
    end

    self.labelNewName1 = ccui.EditBox:create(cc.size(320,48),"new_ui/message/xinxikuang.png")
    --self.labelNewName1:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.phonenumber = ""
    self.labelNewName1:setFontSize(20)
    self.labelNewName1:setAnchorPoint(0,0)  
    self.labelNewName1:setPosition(0,0)   
    self.labelNewName1:setMaxLength(11)                             --设置输入最大长度为6  
    self.labelNewName1:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName1:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName1:setPlaceHolder("请输入手机号!")               --设置预制提示文本
    self.labelNewName1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName1:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle1(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.Image_phonenumber_bg:addChild(self.labelNewName1)

    self.labelNewName2 = ccui.EditBox:create(cc.size(160,48),"new_ui/message/xinxikuang.png")
    --self.labelNewName2:setPosition(self.labelNewName1:getContentSize().width/2+10,self.labelNewName1:getContentSize().height/2+5)
    self.code = ""
    self.labelNewName2:setFontSize(20)
    self.labelNewName2:setAnchorPoint(0,0)  
    self.labelNewName2:setPosition(0,0) 
    --self.labelNewName2:setMaxLength(50)                             --设置输入最大长度为6  
    self.labelNewName2:setFontColor(cc.c4b(69,63,96,255))         --设置输入的字体颜色  
    --self.labelNewName2:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) --设置数字符号键盘  
    self.labelNewName2:setPlaceHolder("验证码!")               --设置预制提示文本
    self.labelNewName2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE ) 
    self.labelNewName2:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle2(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
    self.Image_verification_code_bg:addChild(self.labelNewName2)
    
end

function PhoneBindUpLayer:close()
    self:removeAllChildren()
end

function PhoneBindUpLayer:onGotoBack(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:removeAllChildren()
    end
end

function PhoneBindUpLayer:getCode(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        
        local phonenumber = self.phonenumber
        if string.len(phonenumber) ~= 11  or tonumber(phonenumber) ==nil then
            print("请输入11位手机号!")
            scene:popUpTips("请输入11位手机号!")
            return
        end
        self.Button_getcode:setTouchEnabled(false)
        self.Button_chongxinGet:setTouchEnabled(false)
        self.phone_time = 60
        local function resetTime()
            self:onTick()
        end 
        local delay = cc.DelayTime:create(1)
        local sequence = cc.Sequence:create(delay, cc.CallFunc:create( resetTime ))
        self.Label_Time_Over:runAction(cc.Repeat:create(sequence,61))

        local stream =  laixia.Packet.new("phonebind", "MEDUSA_VERIFICATION_CODE")
        stream:setReqType("post")
        stream:setPostData("cv", 11)
        stream:setValue("region", "cn")
        local ph = "86" .. phonenumber
        stream:setValue("phone", ph)
        laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
            local data1 = event
            print("get code " .. data1.dm_error)
            if data1.dm_error == 0 then
                print("get code success")
                self.request_id = data1.request_id
            else
                print("get code error")
                scene:popUpTips(data1.error_msg)

            end
        end)
    end
end

function PhoneBindUpLayer:onTick(dt)
    self.Button_getcode:setVisible(false)
    self.Image_getcode:setVisible(false)
    self.Button_chongxinGet:setVisible(true)

    if (self.phone_time==0) then
        self.Button_chongxinGet:setVisible(true)
        self.Button_chongxinGet:setTouchEnabled(true)
        self.Button_getcode:setVisible(false)
        self.Image_getcode:setVisible(false)
        self.Label_Time_Over:setVisible(false)
    else
        self.phone_time = self.phone_time - 1
        self.Label_Time_Over:setVisible(true)
        self.Label_Time_Over:setString(self.phone_time .. "秒后重新获取")
    end
end

function PhoneBindUpLayer:sendBindPacket(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local phonenumber = self.phonenumber
        local code = self.code
        if string.len(phonenumber) < 11 or tonumber(phonenumber) ==nil then           
            print("请输入11位手机号!")
            scene:popUpTips("请输入11位手机号")
            return
        end
        if string.len(code) ~= 6 then
            print("请输入6位验证码!")
            scene:popUpTips("请输入6位验证码!")
            return
        end
        if self.request_id == nil or self.request_id == "" then
            print("request_id..     error")
        end
        local stream =  laixia.Packet.new("phonebind", "LXG_USER_PHONE_BIND")
        stream:setReqType("post")
        stream:setPostData("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
        stream:setPostData("cv", 11)
        local ph = "86" .. phonenumber
        stream:setValue("phone", ph)
        stream:setValue("code", code)
        stream:setValue("request_id", self.request_id)
        laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
            local data1 = event
            if data1.dm_error == 0 then
                laixia.LocalPlayercfg.PhoneNumber = phonenumber
                if self.isschedu then
                    schedule_time.unscheduleGlobal(self.sche)
                end
                self.obj:refreshPhone()
                self:removeAllChildren()
                print("phone_bind success")
                scene:popUpTips("绑定成功")
            else
                print("phone_bind error")
                scene:popUpTips(data1.error_msg)
            end   
        end)
    end
end

return PhoneBindUpLayer
