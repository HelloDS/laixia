local laixia = laixia;

local Packet =  import("....net.Packet") 
local soundConfig =  laixiaddz.soundcfg; 
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
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_COMMONTOP_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_ISONLINEROOM_WINDOW, handler(self, self.isInDesk))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_RECONNECTION_WINDOW, handler(self, self.enterToDesk))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_VERSIONOPEN_WINDOW, handler(self, self.sendVersionOpenPacket))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_HEARTTICK_WINDOW, handler(self, self.sendHeartBeat))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_GETTASKLIST,handler(self, self.sendGetTaskList))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW,handler(self, self.updateTopInfo))
    ObjectEventDispatch:addEventListener("update_coin_info", handler(self, self.setCoinInfo))
end

function LobbyTopWindow:updateTopInfo()   
   if laixiaddz.LocalPlayercfg.LaixiaGoldCoin ~=nil then
       self:GetWidgetByName("Room_Title_Points_Text"):setString(laixiaddz.helper.numeralRules_5(laixiaddz.LocalPlayercfg.LaixiaGoldCoin))
   end
   self:GetWidgetByName("Room_Title_Points_Text1"):setString(laixiaddz.LocalPlayercfg.LaixiaLdCoin)
   self:GetWidgetByName("Text_zhishibi"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
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
        self:GetWidgetByName("Room_Title_Points_Text",self.Panel_top):setString(laixiaddz.helper.numeralRules_5(laixiaddz.LocalPlayercfg.LaixiaGoldCoin))
        self:GetWidgetByName("Text_zhishibi",self.Panel_top):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
        self:GetWidgetByName("Room_Title_Points_Text1",self.Panel_top):setString(laixiaddz.LocalPlayercfg.LaixiaLdCoin)
        self:AddWidgetEventListenerFunction("Room_Title_Button_Return", handler(self, self.goBack))
        self:AddWidgetEventListenerFunction("Room_Title_Points_Button", handler(self, self.goShop))


        self:GetWidgetByName("Image_7",self.Panel_top):setVisible(true)
        self:GetWidgetByName("Text_zhishibi",self.Panel_top):setVisible(true)
        self:GetWidgetByName("Image_2_Copy_1",self.Panel_top):setVisible(true)
        self:GetWidgetByName("Button_jiahao",self.Panel_top):setVisible(true)
        self:AddWidgetEventListenerFunction("Button_jiahao", handler(self, self.goShopNew))
           
        self:GetWidgetByName("Image_2_Copy_1",self.Panel_top):setVisible(true)
            if laixiaddz.kconfig.isYingKe==true then
            if device.platform == "ios" then
                local state ,value = luaoc.callStaticMethod("IKCRLXBridgeManager", "getCoin",{ callback = updateUserCoin_IOS_lobbyTop}, "(I)V");
            elseif device.platform == "android" then
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "getUserCoin"
                local javaParams = { }
                local javaMethodSig = "()V"        
                local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                -- laixiaddz.LocalPlayercfg.LaixiaZsCoin = value
                -- self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
            end
        end

      
        self:sendHallPacket()
        if msg.data.goBackFun then
            self.goBackFun = msg.data.goBackFun
        end
        self.mIsShow = true
    end
    -- self:updateHead()
end
function LobbyTopWindow:sendHallPacket() 
    -- local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
    -- stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    -- stream:setValue("GameID", laixia.config.GameAppID)
    -- laixia.net.sendHttpPacketAndWaiting(stream)
end
--充值回调
function rechargeCallBack(data)
    print("rechargeCallBack=-------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixiaddz.LocalPlayercfg.LaixiaZsCoin = tonumber(info.zscoin)
    self:GetWidgetByName("Text_zhishibi"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
end

function updateUserCoin(data)
    print("LobbyWindow")
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixiaddz.LocalPlayercfg.LaixiaZsCoin = tonumber(info.zscoin)

    self:GetWidgetByName("Text_zhishibi"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
end
function updateUserCoin_IOS_lobbyTop(status,data)
    print("LobbyWindow")
    if status == 0 then
        laixiaddz.LocalPlayercfg.LaixiaZsCoin = tonumber(data)

        self:GetWidgetByName("Text_zhishibi"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
    end
end
function LobbyTopWindow:goShopNew(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        if device.platform == "ios" then
            local luaoc = require("cocos.cocos2d.luaoc")
            local state ,value = luaoc.callStaticMethod("IKCRLXBridgeManager", "showPayView");
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
    laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换奖励,可在比赛、游戏场中获得!")
end

function LobbyTopWindow:onShouchong(sender,eventtype)
  if eventtype == ccui.TouchEventType.ended then
    laixiaddz.soundTools.playSound(laixiaddz.soundcfg.BUTTON_SOUND.ui_button_open)
    -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SENDPACKET_FIRSTGIFT)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FIRSTGIFT_WINDOW)
   end
end
function LobbyTopWindow:sendPersonalCenterPacket(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    if eventtype == ccui.TouchEventType.ended then
        local stream = Packet.new("PersonalCenter", _LAIXIA_PACKET_CS_PersonalCenterID)
        stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(stream, nil, 1);
--    end
    end
end
function LobbyTopWindow:updateHead()
    --如果是苹果包
    if self.mIsShow then
        -- 默认头像图片路径
        local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID%10))..".png"
        local headIcon = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture;
        local headIcon_new = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse; --头像要用的

        --微信渠道要看头像是否有变化
        if cc.Application:getInstance():getTargetPlatform() == 4 and headIcon_new~=cc.UserDefault:getInstance():getStringForKey("headimgurl") then
            headIcon = nil
            headIcon_new = cc.UserDefault:getInstance():getStringForKey("headimgurl")
            laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse = headIcon_new
            laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath = ""
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
                laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture = nil                
            end
        elseif headIcon_new ~= nil and headIcon_new ~= "" then
            local testPath
            if string.find(headIcon_new,".png") then
                testPath = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID
            else
                testPath = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png"
            end
            print(testPath)

            local fileExist = cc.FileUtils:getInstance():isFileExist(testPath)

            print(fileExist)
            if (fileExist) then
                path = testPath
            else
            --下载图片
                local headIconUrl = laixia.config.HEAD_URL .. laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath

                print(headIconUrl)
                DownloaderHead:pushTask(laixiaddz.LocalPlayercfg.LaixiaPlayerID, headIconUrl,2)
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
    laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BINDPHONE_WINDOW)
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
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_SHOPWINDOW)
    end
end
        

function LobbyTopWindow:goBack(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.goBackFun()
    end
end

function LobbyTopWindow:sendVersionOpenPacket()
    local CSVersionOpen = Packet.new("CSVersionOpen", _LAIXIA_PACKET_CS_VersionOpenID)
    CSVersionOpen:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSVersionOpen:setValue("GameType", laixia.config.GameType)
    laixia.net.sendHttpPacketAndWaiting(CSVersionOpen)
end
function LobbyTopWindow:sendGetTaskList()
    local CSSendGetTaskList = Packet.new("CSSendGetTaskList", _LAIXIA_PACKET_CS_GETTASKLIST)
    CSSendGetTaskList:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSSendGetTaskList:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSSendGetTaskList) 
end

--[[
 * 更新货币信息
 * @param  nil
--]]
function LobbyTopWindow:setCoinInfo()
    local stream =  laixia.Packet.new("userInfo", "MEDUSA_CASH_ACCOUNT")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data = event
        if event.dm_error == 0 then
            laixia.LocalPlayercfg.LaixiaGoldCoin = data.gold_coin or 0
            laixia.LocalPlayercfg.LaixiaLdCoin   = data.laidou_coin or 0
            laixia.LocalPlayercfg.LaixiaZsCoin   = data.zscoin or 0    
            self:loadData()
            print("LobbyTopWindow MEDUSA_CASH_ACCOUNT===获取成功")    
        else
            print("LobbyTopWindow MEDUSA_CASH_ACCOUNT===获取失败")
        end 
    end) 
end

--[[
 * 用户信息设置
 * @param  nil
--]]
function LobbyTopWindow:loadData()
    self:GetWidgetByName("Room_Title_Points_Text"):setString(laixiaddz.helper.numeralRules_5(laixiaddz.LocalPlayercfg.LaixiaGoldCoin))  --laixiaddz.helper.numeralRules_2()
    self:GetWidgetByName("Room_Title_Points_Text1"):setString(laixiaddz.LocalPlayercfg.LaixiaLdCoin)   
    if laixiaddz.kconfig.isYingKe==true then  
        self:GetWidgetByName("Text_zhishibi"):setString(laixiaddz.LocalPlayercfg.LaixiaZsCoin)
    end
end

function LobbyTopWindow:onDestroy()
    self.mIsShow = false
end

return LobbyTopWindow.new()
