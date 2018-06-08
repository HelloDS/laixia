--
-- Author: Feng
-- Date: 2018-05-03 17:18:47
--

local scene = cc.Director:getInstance():getRunningScene()

local PhoneBindLayer = class("PhoneBindLayer" ,function()
        return display.newLayer()
    end)
local PHONECODE_TIME = 60;

function PhoneBindLayer:ctor(...)
    self:init(...)
end

function PhoneBindLayer:init(...)
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
    self.TextField_verification_code = _G.seekNodeByName(self.Panel_root,"TextField_verification_code")
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
    
end

function PhoneBindLayer:close()
    self:removeAllChildren()
end

function PhoneBindLayer:onGotoBack(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:removeAllChildren()
    end
end

function PhoneBindLayer:getCode(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        
        local phonenumber = self.TextField_phonenumber:getString()
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

function PhoneBindLayer:onTick(dt)
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

function PhoneBindLayer:sendBindPacket(sender, eventType)
    _G.onTouchButton(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local phonenumber  =self.TextField_phonenumber:getString()
        local code = self.TextField_verification_code:getString()
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
        local stream =  laixia.Packet.new("phonebind", "LXG_USER_BIND_PHONE")
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

return PhoneBindLayer
