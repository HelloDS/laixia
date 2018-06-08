local laixia = laixia;

local Packet =  import("....net.Packet") 
local soundConfig =  laixia.soundcfg; 
local DownloaderHead = import("..DownloaderHead")

local LobbyTopWindow = class("LobbyTopWindow", import("...CBaseDialog"):new()) -- 

function LobbyTopWindow:ctor(...)
    self.hDialogType = DialogTypeDef.DEFINE_INNER_DIALOG
    self.mIsShow = false
    self.mIsShowPic = false
    self.mWhisShow = false
end
 
function LobbyTopWindow:getName()
    return "LobbyTopWindow"
end

function LobbyTopWindow:onInit()
    self.super:onInit(self)
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_COMMONTOP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_ISONLINEROOM_WINDOW, handler(self, self.isInDesk))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_RECONNECTION_WINDOW, handler(self, self.enterToDesk))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_VERSIONOPEN_WINDOW, handler(self, self.sendVersionOpenPacket))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_HEARTTICK_WINDOW, handler(self, self.sendHeartBeat))

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_GETTASKLIST,handler(self, self.sendGetTaskList))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW,handler(self, self.updateTopInfo))
    
end

function LobbyTopWindow:updateTopInfo()    
--        if laixia.LocalPlayercfg.LaixiaPlayerGold ~=nil then
--            self:GetWidgetByName("Room_Title_Points_Text"):setString(laixia.helper.numeralRules_5(laixia.LocalPlayercfg.LaixiaPlayerGold))
--        end
--        self:GetWidgetByName("Room_Title_Points_Text1"):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)
--        self:GetWidgetByName("Text_zhishibi"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end

function LobbyTopWindow:setAdaptation()
    local Panel_1 = self:GetWidgetByName("Panel_1")
    local chazhi = display.heightInPixels - display.height*display.contentScaleFactor
    Panel_1:setPosition(cc.p(Panel_1:getPositionX(),chazhi))
end

function LobbyTopWindow:onShow(msg)
    if self.mIsShow == false then
-----------------------------------------------------------------------------------------------------
        -- self:setAdaptation()
        self.Panel_top = self:GetWidgetByName("Panel_1")
        self:GetWidgetByName("Room_Title_Points_Text",self.Panel_top):setString(laixia.helper.numeralRules_5(laixia.LocalPlayercfg.LaixiaPlayerGold))
        self:GetWidgetByName("Text_zhishibi",self.Panel_top):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
        self:GetWidgetByName("Room_Title_Points_Text1",self.Panel_top):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)
        self:AddWidgetEventListenerFunction("Room_Title_Button_Return", handler(self, self.goBack))
        self:AddWidgetEventListenerFunction("Room_Title_Points_Button", handler(self, self.goShop))



        if laixia.kconfig.isYingKe == true then
            self:GetWidgetByName("Image_7",self.Panel_top):setVisible(true)
            self:GetWidgetByName("Text_zhishibi",self.Panel_top):setVisible(true)
            self:GetWidgetByName("Image_2_Copy_1",self.Panel_top):setVisible(true)
            self:GetWidgetByName("Button_jiahao",self.Panel_top):setVisible(true)
            self:AddWidgetEventListenerFunction("Button_jiahao", handler(self, self.goShopNew))
           
            self:GetWidgetByName("Image_2_Copy_1",self.Panel_top):setVisible(true)
             if laixia.kconfig.isYingKe==true then
                if device.platform == "ios" then
                    local state ,value = luaoc.callStaticMethod("IKCRBridgeManager", "getCoin",{ callback = updateUserCoin_IOS_lobbyTop}, "(I)V");
                elseif device.platform == "android" then
                    local javaClassName = APP_ACTIVITY
                    local javaMethodName = "getUserCoin"
                    local javaParams = { }
                    local javaMethodSig = "()V"        
                    local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                    -- laixia.LocalPlayercfg.ZhiShiBiNum = value
                    -- self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
                end
            end
        else
            self:GetWidgetByName("Image_3",self.Panel_top):loadTexture("new_ui/common/new_common/jinbi.png")
        end

        -- self:GetWidgetByName("nickName"):setString(laixia.helper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname))
        -- self:AddWidgetEventListenerFunction("Button_shoujibangding",handler(self, self.shoujibangding))
        -- if laixia.LocalPlayercfg.LaixiaLastLoginPlatform == 1 then--游客登陆 木有手机绑定的按钮
        --     self:GetWidgetByName("Button_shoujibangding",self.top):setVisible(false)
        -- else
        --     self:GetWidgetByName("Button_shoujibangding",self.top):setVisible(true)
        -- end
        -- if laixia.LocalPlayercfg.LaixiaPhoneNum~="" then
        --     self:GetWidgetByName("Button_shoujibangding"):setVisible(false)
        -- end
        -- self:AddWidgetEventListenerFunction("Button_Lobby_ShouChong",handler(self, self.onShouchong))
        -- self:AddWidgetEventListenerFunction("Image_Head_Frame",handler(self, self.sendPersonalCenterPacket))

        -- self:updateHead()
        -- self:AddWidgetEventListenerFunction("Button_help",handler(self, self.goWenhao))
-----------------------------------------------------------------------------------------------------
        -- if msg.data.isDisableLaidou~=nil and msg.data.isDisableLaidou==true then
        --     self:GetWidgetByName("Image_3_Copy"):setVisible(false)
        --     self:GetWidgetByName("Room_Title_Points_Text1"):setVisible(false)
        --     self:GetWidgetByName("Image_2_Copy"):setVisible(false)
        --     self:GetWidgetByName("Button_help"):setVisible(false)
        -- end
        self:sendHallPacket()
        if msg.data.goBackFun then
            self.goBackFun = msg.data.goBackFun
        end
        self.mIsShow = true
    end
    -- self:updateHead()
end
function LobbyTopWindow:sendHallPacket() 
    local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end
--充值回调
function rechargeCallBack(data)
    print("rechargeCallBack=-------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
    self:GetWidgetByName("Text_zhishibi"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end

function updateUserCoin(data)
    print("LobbyWindow")
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)

    self:GetWidgetByName("Text_zhishibi"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end
function updateUserCoin_IOS_lobbyTop(status,data)
    print("LobbyWindow")
    if status == 0 then
        laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(data)

        self:GetWidgetByName("Text_zhishibi"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
    end
end
function LobbyTopWindow:goShopNew(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        if device.platform == "ios" then
            local luaoc = require("cocos.cocos2d.luaoc")
            local state ,value = luaoc.callStaticMethod("IKCRBridgeManager", "showPayView");
        elseif device.platform == "android" then
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "gotoChargePage"
            local javaParams = { }
            local javaMethodSig = "()V"        
            local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            if value=="" then
                value = 0
            end
        end
    end
end

function LobbyTopWindow:goWenhao()
    laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换奖励,可在比赛、游戏场中获得!")
end

function LobbyTopWindow:onShouchong(sender,eventtype)
  if eventtype == ccui.TouchEventType.ended then
    laixia.soundTools.playSound(laixia.soundcfg.BUTTON_SOUND.ui_button_open)
    -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDPACKET_FIRSTGIFT)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FIRSTGIFT_WINDOW)
   end
end
function LobbyTopWindow:sendPersonalCenterPacket(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
--        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    if eventtype == ccui.TouchEventType.ended then
        local stream = Packet.new("PersonalCenter", _LAIXIA_PACKET_CS_PersonalCenterID)
        stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(stream, nil, 1);
--    end
    end
end
function LobbyTopWindow:updateHead()
    --如果是苹果包
    if self.mIsShow then
        -- 默认头像图片路径
        local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID%10))..".png"
        local headIcon = laixia.LocalPlayercfg.LaixiaPlayerHeadPicture;
        local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的

        --微信渠道要看头像是否有变化
        if cc.Application:getInstance():getTargetPlatform() == 4 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
            headIcon = nil
            headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
            laixia.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
            laixia.LocalPlayercfg.LaixiaHeadPortraitPath = ""
            laixia.config.HEAD_URL = cc.UserDefault:getInstance():getStringForKey("headimgurl")
            
        end
        
        if headIcon ~= nil  and headIcon ~= "" then
            local testPath
            if string.find(headIcon,".png") then
                testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon
            else
                testPath = cc.FileUtils:getInstance():getWritablePath() .. headIcon..".png"
            end
            local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)
            if (fileExist) then
                path = testPath
            else
                laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
            end
        elseif headIcon_new ~= nil and headIcon_new ~= "" then
            local testPath
            if string.find(headIcon_new,".png") then
                testPath = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID
            else
                testPath = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
            end
            print(testPath)

            local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

            print(fileExist)
            if (fileExist) then
                path = testPath
            else
            --下载图片
                local headIconUrl = laixia.config.HEAD_URL .. laixia.LocalPlayercfg.LaixiaHeadPortraitPath

                print(headIconUrl)
                DownloaderHead:pushTask(laixia.LocalPlayercfg.LaixiaPlayerID, headIconUrl,2)
            end
        end
        self:addHeadIcon(path);

    end
end 

function LobbyTopWindow:addHeadIcon(path)
 
        local head_btn = self:GetWidgetByName("Image_Head_Frame")
        if (head_btn == nil or head_btn == "") then
            return
        end
        local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
        head_btn:removeAllChildren()
        --laixia.UItools.addHead(head_btn, path, templet)
        local sprite = cc.Sprite:create(path) 
        sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
        head_btn:addChild(sprite)
end


--手机绑定
function LobbyTopWindow:shoujibangding()
    laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BINDPHONE_WINDOW)
end
function LobbyTopWindow:enterToDesk(msg)
    local stream = Packet.new("EnterRoom", _LAIXIA_PACKET_CS_EnterRoomID)
    stream:setValue("RoomID", msg.data)
    if  msg.data == 50 then
       laixia.net.sendPacket(stream)
    else
       laixia.net.sendPacketAndWaiting(stream)
    end
end

function LobbyTopWindow:sendHeartBeat()
    local packet = laixia.Packet.new("CSHeartBeat", _LAIXIA_PACKET_CS_HeartBeatID);
    laixia.net.sendPacket(packet)
end

function LobbyTopWindow:isInDesk()
    local stream = Packet.new("CSOnlineRoom", _LAIXIA_PACKET_CS_OnlineRoomID)
    laixia.net.sendPacketAndWaiting(stream)
end      

function LobbyTopWindow:goShop(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_SHOPWINDOW)
    end
end
        

function LobbyTopWindow:goBack(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.goBackFun()
    end
end

function LobbyTopWindow:sendVersionOpenPacket()
    local CSVersionOpen = Packet.new("CSVersionOpen", _LAIXIA_PACKET_CS_VersionOpenID)
    CSVersionOpen:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSVersionOpen:setValue("GameType", laixia.config.GameType)
    laixia.net.sendHttpPacketAndWaiting(CSVersionOpen)
end
function LobbyTopWindow:sendGetTaskList()
    local CSSendGetTaskList = Packet.new("CSSendGetTaskList", _LAIXIA_PACKET_CS_GETTASKLIST)
    CSSendGetTaskList:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSSendGetTaskList:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSSendGetTaskList) 
end

function LobbyTopWindow:onTick(dt)
    self:GetWidgetByName("Room_Title_Points_Text"):setString(laixia.helper.numeralRules_2(laixia.LocalPlayercfg.LaixiaPlayerGold))  
    self:GetWidgetByName("Room_Title_Points_Text1"):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)  
    if laixia.kconfig.isYingKe==true then  
        self:GetWidgetByName("Text_zhishibi"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
    end
end

function LobbyTopWindow:onDestroy()
    self.mIsShow = false
end
return LobbyTopWindow.new()
