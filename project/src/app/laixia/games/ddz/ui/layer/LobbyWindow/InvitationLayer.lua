
local InvitationLayer = class("InvitationLayer", import("...CBaseDialog"):new())-- 
local soundConfig =  laixiaddz.soundcfg

function InvitationLayer:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function InvitationLayer:getName()
    return "InvitationLayer"
end

function InvitationLayer:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener("_laixiaddz_EVENT_SHOW_INVITATION_WINDOW", handler(self, self.show))
    -- ObjectEventDispatch:addEventListener("_laixiaddz_EVENT_HIDE_INVITATION_WINDOW", handler(self, self.destroy))
end


function InvitationLayer:onShow(data)
    print("InvitationLayer000000000000000000000000")
    self.BG = self:GetWidgetByName("Image_bg")
    self.BG:setTouchEnabled(true)
    self.BG:setTouchSwallowEnabled(true)   

    self:AddWidgetEventListenerFunction("Button_Invitation_submit",handler(self,self.Submit))
    self:AddWidgetEventListenerFunction("Button_Invitation_close", handler(self, self.onShutDown))

    self.TextField_invitation=self:GetWidgetByName("TextField_invitation")
--    self.TextField_invitation:addEventListener(function(eventname,sender)
--        if eventname == ccui.TextFiledEventType.attach_with_ime then

--        elseif eventname == ccui.TextFiledEventType.detach_with_ime then
--            sender:setString(sender:getString())
--        elseif eventname == ccui.TextFiledEventType.insert_text then
--        elseif eventname == ccui.TextFiledEventType.delete_backward then
--        end  
--    end);
    self.TextField_invitation:setAttachWithIME(true)
    if laixiaddz.kconfig.isYingKe ~= true then
        self.TextField_invitation:setVisible(false)
        self.TextField_invitation1 = ccui.EditBox:create(cc.size(200,40),"new_ui/PersonalCenterWindow/shurukuang2.png")
        self.TextField_invitation1:setPosition(100,21)
        self.TextField_invitation1:setFontSize(24)
        self.TextField_invitation1:setLocalZOrder(1100)
        self.TextField_invitation1:setFontColor(cc.c3b(69,63,56))
        self.TextField_invitation1:setPlaceHolder("请输入:")
        self.TextField_invitation1:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
        self.TextField_invitation1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)     
        local function editboxHandle( strEventName,sender ) 
            if strEventName == "began" then
            elseif strEventName == "ended" then
                sender:setText(sender:getText())
            elseif strEventName == "return" then
                sender:setText(sender:getText())
            elseif strEventName == "changed" then
                local test = 1
            end
        end
        self.TextField_invitation1:registerScriptEditBoxHandler(function(eventname,sender) editboxHandle(eventname,sender) end) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
        self:GetWidgetByName("Image_yaoqingdi"):addChild(self.TextField_invitation1)
    end
end

function InvitationLayer:Submit(sender, eventType)
    if eventType == ccui.TouchEventType.ended then 
        local parentPid
        if laixiaddz.kconfig.isYingKe ~= true then
            parentPid = self.TextField_invitation1:getText()
        else
            parentPid = self.TextField_invitation:getString()
        end
        local str = "yu7#)"..parentPid..laixiaddz.LocalPlayercfg.LaixiaPlayerID.."54=%~m"
        local token = crypto.md5(str)
        print(token)
        local url = "http://wx.laixia.com/player?"  
        local request = network.createHTTPRequest(function(event)  
            self:onResponseGet(event)  
        end, url, "POST") 
        request:addPOSTValue("user_id",parentPid)
        request:addPOSTValue("user_id2",laixiaddz.LocalPlayercfg.LaixiaPlayerID)
        request:addPOSTValue("token",token)
        request:setTimeout(5)          
        request:start()  
    end
end
function InvitationLayer:onResponseGet(event)
    local request = event.request  
     if event.name == "failed" then
        print("failedfailedfailedfailedfailedfailedfailedfailedfailedfailed")
        return
    end
    if event.name ~= "completed" then -- 當為completed表示正常結束此事件  
        print("request:getErrorCode(), request:getErrorMessage() ", request:getErrorCode(), request:getErrorMessage())  
        return   
    end  
    local code = request:getResponseStatusCode()  
    if code ~= 200 then -- 成功  
        print("code ", code)  
        return 
    else
        local strResponse = request:getResponseData() 
        local json = json or require("framework.json")
        local array = json.decode(strResponse)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, array.MSG)   
    end  
end
function InvitationLayer:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy()
    end
end

function InvitationLayer:onDestroy()
    
end
return InvitationLayer.new()



