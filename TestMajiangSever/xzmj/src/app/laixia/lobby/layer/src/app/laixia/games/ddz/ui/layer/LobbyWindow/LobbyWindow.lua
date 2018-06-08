
local laixia = laixia;
local Env = APP_ENV;

local Packet =  import("....net.Packet")  
local soundConfig =  laixiaddz.soundcfg;   
local EffectDict =  laixia.EffectDict; 
--local EffectAni = laixia.EffectAni;    
local DownloadActivity = import("..DownloadActivity")
local DownloaderHead = import("..DownloaderHead")
local WebView = import(".WebView")

local LobbyWindow = class("LobbyWindow", import("...CSBBase"):new()) -- 
local userDefault = Env.userDefault;

local mBeganDown = false  --下载标记


---------------------------------------------------------------------------------------
function LobbyWindow:ctor(...)
    
    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
    self.mIsShow = false
    self.mButtonArray = {}
    self.mTime = 0
    self.mWhisShow = false
    self.LunBoflag = true
end

function LobbyWindow:getName()
    return "LobbyWindow"
end

function LobbyWindow:onInit()
    self.super:onInit(self)

    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_MAININTERFACE_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_MAININTERFACE_WINDOW,handler(self,self.updateWindow))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_HALL_WINDOW, handler(self, self.sendHallPacket))
    --删除小游戏的进度条
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDE_XIAOYOUXI_PEOGRESS, handler(self, self.clearProgress))
----------------------------------------------------------------------------------------------------
    -- 显示背包红点
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BAGRED_WINDOW, handler(self, self.showStationManageReda))
    -- 隐藏背包红点
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDES_BAGRED_WINDOW, handler(self, self.hideStationManageReda))
    -- 显示背包tips
    -- ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_BAGTIPS_WINDOW, handler(self, self.showBagTips))
    -- 隐藏背包tips
    -- ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDES_BAGTIPS_WINDOW, handler(self, self.hideBagTips))
    -- 发送礼品盒请求
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_TOOLBOX_WINDOW, handler(self, self.sendToMyBagPacket))
    --下载头像完成
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOADLOBBY_PICTURE_WINDOW, handler(self, self.onHeadDoSuccess)) 
    --轮播图下载
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOAD_LUNBO_WINDOW, handler(self, self.onLunBoDoSuccess)) 

    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_PICTURE_WINDOW, handler(self, self.addHead))--self.updateHead))
--    -- 显示站内信红点
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_LETTERRED_WINDOW, handler(self, self.showStationManageRed))
--    -- 隐藏站内信红点
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_HIDES_LETTERRED_WINDOW, handler(self, self.hideStationManageRed))
-----------------------------------------------------------------------------------------------------
----LobbyBottom Window
    -- 发送商城请求
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SEND_SHOPWINDOW, handler(self, self.sendShopPacket))
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_RETURN_FIRSTGIFT_WINDOW ,handler(self,self.showFirstGift))
    
    ---排行榜功能 begin wangtianye)
--    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_UPDATE_RANK_WINDOW, handler(self, self.updateRankWindow))
--    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_REQUEST_RANKLIST_WINDOW, handler(self, self.sendRankListPacket))
--    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOADRANK_PICTURE_WINDOW, handler(self,self.headDownloadSuccess))

   
    ---end

end



function LobbyWindow:sendHallPacket()
    self:show();  
    local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
    stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end

function LobbyWindow:setImgBut(item)
    local img = self:GetWidgetByName("Image_Button_BG",item)
    img:setSwallowTouches(false)
    self:addAnimationEventListener(img)
    return img
end

--游戏列表专用按钮放大缩小动画特效
function LobbyWindow:addAnimationEventListener(but)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(function(touch, event)
        local target = event:getCurrentTarget()

        local locationInNode = target:convertToNodeSpace(touch:getLocation())
        local s = target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        if cc.rectContainsPoint(rect, locationInNode) then
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            local sc = cc.ScaleTo:create(0.1, 1.1)
            target:getParent():runAction(sc)
            return true
         end
        return false
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function(touch, event)
        local touchPoint = touch:getLocation()
        if math.abs(touch:getPreviousLocation().x - touchPoint.x)>0.1 or math.abs(touch:getPreviousLocation().y - touchPoint.y)>0.1 then
            self.isMove = true
        end

    end, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(function(touch, event)
            local target = event:getCurrentTarget()
            local sc_back = cc.ScaleTo:create(0.1, 1)
            target:getParent():runAction(sc_back)   
            if self.isMove then
                self.isMove = false
            else
                --监听的函数
                if target.callFun ~= nil then
                    target.callFun(target:getParent())
                end
            end
    end, cc.Handler.EVENT_TOUCH_ENDED)
    but:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, but)
end


--按钮放大缩小动画特效
function LobbyWindow:addButAnimationEventListener(but,callFun)
    but.callFun = callFun
    but:addTouchEventListener(function(sender,eventtype)
       if eventtype == ccui.TouchEventType.began then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local sc = cc.ScaleTo:create(0.1, 1.1)
        sender:runAction(sc)
        elseif eventtype == ccui.TouchEventType.moved then
        elseif eventtype == ccui.TouchEventType.canceled then
            local sc_back = cc.ScaleTo:create(0.1, 1)
            sender:runAction(sc_back)
        elseif eventtype == ccui.TouchEventType.ended then 
            local sc_back = cc.ScaleTo:create(0.1, 1)
            sender:runAction(sc_back)   
            --监听的函数
            if sender.callFun ~= nil then
                sender.callFun()
            end
        end
    end)
end

function LobbyWindow:onGoMatchWindow(sender, eventtype)
    -- 比赛场按钮回调函数
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SENDDINGSHI_GOGAMELIST)
--    end
end

function LobbyWindow:onGoTurnTable(sender, eventtype) 
--
    local stream = Packet.new("CSTurnTableEnter", _LAIXIA_PACKET_CS_TurnTableEnterID)
    stream:setValue("HttpCode", laixiaddz.LocalPlayercfg.LaixiaHttpCode) 
    laixia.net.sendHttpPacketAndWaiting(stream)
            
--     ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "敬请期待")
end

--万人牛牛游戏
function LobbyWindow:onWanRenNiuNiu(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
        local pluginManager = pluginManager;
        if(not pluginManager.is_loading_plugin) then
            local t =self:getProgress(sender) 
            --local t =self:getProgress(self.lobby_WanRenniuniu)          
            pluginManager:loadPlugin("niuniu",t);
            pluginManager:updateLoadingIndex("niuniu",1)
        else
             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"其他游戏下载中，请耐心等待")
        end
--    end
end
--水果机游戏
function LobbyWindow:onFruit(sender, eventtype)

        local pluginManager = pluginManager;
        if(not pluginManager.is_loading_plugin) then
            local t =self:getProgress(sender) 
            pluginManager:loadPlugin("fruit",t);
            pluginManager:updateLoadingIndex("fruit",1)
        else
             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"其他游戏下载中，请耐心等待")
        end
end

--水果机游戏
function LobbyWindow:onThreePoker(sender, eventtype)

        local pluginManager = pluginManager;
        if(not pluginManager.is_loading_plugin) then
            local t =self:getProgress(sender) 
            pluginManager:loadPlugin("threecards",t);
            pluginManager:updateLoadingIndex("threecards",1)
        else
             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"其他游戏下载中，请耐心等待")
        end
end

-- 小游戏
function LobbyWindow:onSingle(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
--        local isClose = true
--        if isClose then
           --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"正在装修，马上开业") 
--        end

--    end

end

-- function LobbyWindow:addAnimationArray(mName , mButton)
--        if mButton == nil then
--           return 
--        end
--        local temp = {}
--        temp.Name = mName
--        temp.Button = mButton
--        table.insert(self.mButtonArray,temp)  
-- end

--设置适配
function LobbyWindow:setAdaptation()

    --屏幕宽、高分别和设计分辨率宽、高计算缩放因子，取较(小)者作为宽、高的缩放因子。
    --适用于控件的缩放
--    function setScaleMin(node)
--        local nodeX = node:getScaleX()
--        local nodeY = node:getScaleY()
--        nodeX = nodeX*minScale
--        nodeY = nodeY*minScale
--        node:setScaleX(nodeX) 
--        node:setScaleY(nodeY) 
--    end
    --屏幕宽、高分别和设计分辨率宽、高计算缩放因子，取较(大)者作为宽、高的缩放因子。
    --适用于背景的缩放
--    function setScaleMax(node)
--        local nodeX = node:getScaleX()
--        local nodeY = node:getScaleY()
--        nodeX = nodeX*maxScale
--        nodeY = nodeY*maxScale
--        node:setScaleX(nodeX) 
--        node:setScaleY(nodeY) 
--    end

    --修1
    local visiblesize = cc.Director:getInstance():getVisibleSize() -- winSize在手机屏幕中实际显示的部分的分辨率
    local origin = cc.Director:getInstance():getVisibleOrigin() -- 从画布的某个点显示
    local winsize = cc.Director:getInstance():getWinSize() -- 这几分辨率
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize() -- 设备分辨率
    
    --2config.lua中设置设计分辨率  一般设置和屏幕分辨率相等
        -- -- screen orientation
        -- CONFIG_SCREEN_ORIENTATION = "landscape"

        -- -- design resolution
    -- CONFIG_SCREEN_WIDTH  = 1280
        -- CONFIG_SCREEN_HEIGHT = 720

    --3图片高度 = 屏幕像素高度 / (屏幕像素宽度 / 图片像素宽度)
    --local BgWithScaleRatio = framesize.width/(framesize.height/self.BGIMG:getContentSize().height)
    --图片宽度缩放因子


    --大厅需要设置自适应的所有设置
    self.BGIMG = self:GetWidgetByName("BGIMG")
    -- if display.widthInPixels > display.contentScaleFactor*display.width then
    --     local scaleX_ = display.widthInPixels/(display.contentScaleFactor*display.width)
    --     self.BGIMG:setScaleX(scaleX_)
    -- end
    ----修2
    --local BgWithScaleRatio = 1/(display.height/(self.BGIMG:getContentSize().height))
    --print("000000000000000000000000" .. BgWithScaleRatio)
    self.BGIMG:setPosition(cc.p(display.cx,display.cy))
    --修3
    --self.BGIMG:setScaleX(display.contentScaleFactor)--display.height/self.BGIMG:getContentSize().height)
    --self.BGIMG:setScaleY(display.widthInPixels/display.width)
    --修4
    -- self.RightTopPanel = self:GetWidgetByName("RightTopPanel")
    -- self.RightTopPanel:setPosition(cc.p(display.right,display.top))
    self.top = self:GetWidgetByName("LobbyTop")
    --self.top:setPosition(cc.p(0,))
    self.top:setPosition(cc.p(0,display.top))
    -- self.LobbyListView = self:GetWidgetByName("Lobby_ListView")
    -- self.LobbyListView:setPosition(cc.p(display.cx,display.cy))
    self.bottom = self:GetWidgetByName("LobbyBottom")
    self.bottom:setPosition(cc.p(display.cx,display.bottom))
    -- 三个房间进行适配
    self.mainPanel = self:GetWidgetByName("mainPanel")
    self.mainPanel:setPositionY(display.cy-self.mainPanel:getContentSize().height/2)
    -- 轮播图进行适配
    self.LobbyLeft = self:GetWidgetByName("LobbyLeft")
    self.LobbyLeft:setPositionY(display.cy-self.LobbyLeft:getContentSize().height/2-20)

    --ui的适配
    if device.platform == "ios" then
        print("width----"..display.width)
        print("height -----"..display.height)

        print("display.cx" .. display.cx)
        print("display.cy"..display.cy)

        print("display.widthInPixels"..display.widthInPixels)
        print("display.widthInPixels"..display.heightInPixels)
        if display.widthInPixels  == 2436 and display.heightInPixels == 1125 then
            self.BGIMG:setScaleX(2436/3*2/1440)
            self.top:setPositionX(display.left+34+24)
            self.LobbyLeft:setPositionX(display.left +34+24)

        end
    end
end



--
function LobbyWindow:onShouchong(sender, event)
--        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SENDPACKET_FIRSTGIFT)
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FIRSTGIFT_WINDOW)
end

function LobbyWindow:onShow()
    print("onshowfunction")
    -----------------
    local BGIMG_ = self:GetWidgetByName("BGIMG")
    --local statusLabel = cc.Label:createWithSystemFont("没有键盘事件接受到!", "Arial", 25)
    --BGIMG_:addChild(statusLabel)   
    --键盘事件  
    local function onKeyPressed(keyCode, event) 
        local buf = string.format("%d键按下!", keyCode)  
        --local node = event:getCurrentTarget()  
        --statusLabel:setString(buf)  
        print(buf)
    end  
  
    local function onKeyReleased(keyCode, event)   
        local buf = string.format("%d键抬起!", keyCode)  
        print(buf)
        --local node = event:getCurrentTarget()  
        if keyCode == 47 then
            --statusLabel:setString(buf)
            --新加的界面
            --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BUTTONLAYER)
            --自建房
            laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_PACKET_CREATESELFBUILF
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PACKET_CREATESELFBUILF)
            -- self.mRoomType = 2 --经典场
            -- laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW
            
            -- local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
            -- stream:setValue("RoomType", self.mRoomType)
            -- laixia.net.sendPacketAndWaiting(stream)

        end
    end  
    --statusLabel:setPosition(cc.p(display.cx, display.cy))  
    local listener = cc.EventListenerKeyboard:create()  
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)  
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, BGIMG_) 
    -----------------------------

    laixiaddz.soundTools.playMusic(soundConfig.SCENE_MUSIC.lobby,true)
    if self.mIsShow == false then
        self:setAdaptation()
        self.mDownLoadApkProgressBG = nil 
        self.mDownLoadApkProgressNum  = nil
        self.mDownLoadApkProgress = nil
        
        --self.mPathArray = {}
        self:addPathArray()--self.mPathArray)

        self.mButtonArray ={}
------------------------------------------------------------------------------------------------
    laixiaddz.LocalPlayercfg.LaixiaPhoneNum=cc.UserDefault:getInstance():getStringForKey("phone_number")
    -- 首先载入
    self.LobbyTop = self:GetWidgetByName("LobbyTop")
    self.mainPanel = self:GetWidgetByName("mainPanel")
    self.Button_Lobby_Dayly = self:GetWidgetByName("Button_Lobby_Dayly")
    self.Button_Lobby_TurnTable = self:GetWidgetByName("Button_Lobby_TurnTable")
    self.Button_Lobby_ShouChong = self:GetWidgetByName("Button_Lobby_ShouChong")
    self.Button_Invitation = self:GetWidgetByName("Button_Invitation",self.LobbyTop)
    -- self.Button_fuhuo = self:GetWidgetByName("Button_fuhuo",self.LobbyTop) 
    -- 调节位置
    self.Button_Lobby_Dayly:setPositionX(self.Button_Lobby_Dayly:getPositionX()-5)
    self.Button_Lobby_ShouChong:setPositionX(self.Button_Lobby_ShouChong:getPositionX()-10)

    if laixia.config.isAudit then
        -- 隐藏
        self:GetWidgetByName("Button_Backpack"):setVisible(false)
        self:GetWidgetByName("Button_Lobby_TurnTable"):setVisible(false)  -- 只隐藏它
        self:GetWidgetByName("Button_Renwu"):setVisible(false)            -- 只隐藏它  
   
        -- 替换
        self:GetWidgetByName("Button_bisaichang"):loadTextureNormal("new_ui/isAudit/shenhe_bisai.png")
        self:GetWidgetByName("Button_bisaichang"):loadTexturePressed("new_ui/isAudit/shenhe_bisai.png")
        self:GetWidgetByName("Button_Lobby_ShouChong"):loadTextureNormal("new_ui/isAudit/shenhe_shouchong.png")
        self:GetWidgetByName("Button_Lobby_ShouChong"):loadTexturePressed("new_ui/isAudit/shenhe_shouchong.png")
        self:GetWidgetByName("Button_Lobby_ShouChong"):setPositionX(self.Button_Lobby_Dayly:getPositionX()-5)
        self:GetWidgetByName("Button_Lobby_ShouChong"):setPositionY(self.Button_Lobby_Dayly:getPositionY()-2)
        self:GetWidgetByName("Button_Lobby_Dayly"):loadTextureNormal("new_ui/isAudit/shenhe_qiandao.png")
        self:GetWidgetByName("Button_Lobby_Dayly"):loadTexturePressed("new_ui/isAudit/shenhe_qiandao.png")
        self:GetWidgetByName("Button_Lobby_Dayly"):setPositionX(self.Button_Lobby_TurnTable:getPositionX())


        -- 调整最下面按钮的位置(审核包的坐标)
        self:GetWidgetByName("Button_Rank"):setPositionX(display.cx-70)
        self:GetWidgetByName("Button_Mail"):setPositionX(display.cx+126)
    else    
        if laixia.kconfig.isYingKe == true then
            -- self:GetWidgetByName("Image_JiaoBiao"):setVisible(true)
            self.BGIMG:loadTexture("new_ui/lobbywindow/beijing_zhishi.jpg")
            --芝士签到
            self.Button_Lobby_ShouChong:setVisible(false)
            self:GetWidgetByName("Button_Lobby_Dayly"):loadTextureNormal("new_ui/lobbywindow/qiandao_zhishi.png")
            self:GetWidgetByName("Button_Lobby_Dayly"):loadTexturePressed("new_ui/lobbywindow/qiandao_zhishi.png")
            self:GetWidgetByName("Button_Lobby_Dayly"):setPositionX(self.Button_Lobby_Dayly:getPositionX()-20)
            self:GetWidgetByName("Button_Lobby_Dayly"):setOpacity(255)
            --芝士转盘
            self:GetWidgetByName("Button_Lobby_TurnTable"):loadTextureNormal("new_ui/lobbywindow/zhuanpan_zhishi.png")
            self:GetWidgetByName("Button_Lobby_TurnTable"):loadTexturePressed("new_ui/lobbywindow/zhuanpan_zhishi.png")
            self:GetWidgetByName("Button_Lobby_TurnTable"):setOpacity(255)
            self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_TurnTable"),handler(self, self.onGoTurnTable))
            local mShop = self:GetWidgetByName("Button_Shop",self.bottom)
            mShop:setOpacity(255)
            mShop:loadTextureNormal("new_ui/lobbywindow/shangdian.png")
            mShop:loadTexturePressed("new_ui/lobbywindow/shangdian.png")
            self:addButAnimationEventListener(mShop,handler(self, self.goShop))

            self:GetWidgetByName("Image_51",self.top):loadTexture("new_ui/PersonalCenterWindow/jinbi_xinban.png")
            self:GetWidgetByName("Image_51_Copy",self.top):loadTexture("new_ui/common/new_common/laidou.png")

            self.Button_ZhiShiBi = self:GetWidgetByName("Button_39_Copy")
            self:addButAnimationEventListener(self.Button_ZhiShiBi,handler(self, self.goZhishiShop)) -- 跳转到哪里（待定）
            
            local system3 = laixiaddz.ani.CocosAnimManager
            self.chest = system3:playAnimationAt(self.LobbyTop,"doudizhu_icon_chest")
            self.chest:setVisible(false)
            ---邀请码图标
            if os.time() >= 1524456000 and os.time() <= 1526572800 then
                self:GetWidgetByName("Button_Invitation"):loadTextureNormal("new_ui/lobbywindow/InvitationMenPiao.png")
                self:GetWidgetByName("Button_Invitation"):loadTexturePressed("new_ui/lobbywindow/InvitationMenPiao.png") 
                self.Button_Invitation:setPositionX(self.Button_Lobby_ShouChong:getPositionX()-20)
                self.Button_Invitation:setPositionY(self.Button_Lobby_ShouChong:getPositionY())
                self.Button_Invitation:setOpacity(255)
                -- self.Button_fuhuo:setPositionX(self.Button_Lobby_ShouChong:getPositionX()-120)
                -- self.Button_fuhuo:setPositionY(self.Button_Lobby_ShouChong:getPositionY())    
            else
                -- self.Button_fuhuo:setPositionX(self.Button_Lobby_ShouChong:getPositionX()-20)
                -- self.Button_fuhuo:setPositionY(self.Button_Lobby_ShouChong:getPositionY())    
                self.Button_Invitation:setVisible(false)
            end             
        elseif laixia.kconfig.isYingKe == false then
            -- self.Button_fuhuo:setVisible(false)
            --登录奖励
            self:GetWidgetByName("Button_Lobby_Dayly"):setOpacity(0)
            local system1 = laixiaddz.ani.CocosAnimManager
            self.sign = system1:playAnimationAt(self.LobbyTop,"doudizhu_icon_sign")
            self.sign:pos(self.Button_Lobby_Dayly:getPositionX()-8,self.Button_Lobby_Dayly:getPositionY()-2)
            
            --幸运转盘
            self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_TurnTable"),handler(self, self.onGoTurnTable))
            self:GetWidgetByName("Button_Lobby_TurnTable"):setOpacity(0)
            local system2 = laixiaddz.ani.CocosAnimManager
            self.turntable = system2:playAnimationAt(self.LobbyTop,"doudizhu_icon_turntable")
            self.turntable:pos(self.Button_Lobby_TurnTable:getPositionX(),self.Button_Lobby_TurnTable:getPositionY())
            --首充
            self:GetWidgetByName("Button_Lobby_ShouChong"):setOpacity(0)
            local system3 = laixiaddz.ani.CocosAnimManager
            self.chest = system3:playAnimationAt(self.LobbyTop,"doudizhu_icon_chest")
            self.chest:setVisible(true)
            self.chest:pos(self.Button_Lobby_ShouChong:getPositionX()-10,self.Button_Lobby_ShouChong:getPositionY())
            if laixiaddz.LocalPlayercfg.isShouchong == true then
                --self:GetWidgetByName("Button_Lobby_ShouChong"):setVisible(true)
                self.Button_Lobby_ShouChong:setVisible(true)
                self.chest:setVisible(true)
            elseif laixiaddz.LocalPlayercfg.isShouchong == false then
                --self:GetWidgetByName("Button_Lobby_ShouChong"):setVisible(false)
                self.Button_Lobby_ShouChong:setVisible(false)
                self.chest:setVisible(false)
            end
            -- ---邀请码图标
            if os.time() >= 1524456000 and os.time() <= 1526572800 then
                self:GetWidgetByName("Button_Invitation"):setOpacity(255)
                --邀请码动画
                print("邀请码动画---------------------------")
                -- local system3 = laixiaddz.ani.CocosAnimManager
                -- self.invitationAni = system3:playAnimationAt(self.LobbyTop,"doudizhu_icon_ticket")
                -- self.invitationAni:setVisible(true)
                -- self.invitationAni:setLocalZOrder(5)
                -- self.invitationAni:pos(self.Button_Lobby_ShouChong:getPositionX()-120,self.Button_Lobby_ShouChong:getPositionY())  
                self:GetWidgetByName("Button_Invitation"):loadTextureNormal("new_ui/lobbywindow/MenPiao1.png")
                self:GetWidgetByName("Button_Invitation"):loadTexturePressed("new_ui/lobbywindow/MenPiao1.png") 
                if laixiaddz.LocalPlayercfg.isShouchong == false then
                    self.Button_Invitation:setPosition(cc.p(self.Button_Lobby_ShouChong:getPositionX()-10,self.Button_Lobby_ShouChong:getPositionY()))
                elseif laixiaddz.LocalPlayercfg.isShouchong == true then
                    self.Button_Invitation:setPosition(cc.p(self.Button_Lobby_ShouChong:getPositionX()-120,self.Button_Lobby_ShouChong:getPositionY()))
                end               
            else
                self.Button_Invitation:setVisible(false)
            end    
        end
        -- 任务的监听(隐藏完了，就不能监听了)
        self:addButAnimationEventListener(self:GetWidgetByName("Button_Renwu",self.bottom),handler(self, self.onRenwu))
        -- 背包的监听放在这
        self.btBackpack = self:GetWidgetByName("Button_Backpack",self.bottom)
        self:addButAnimationEventListener(self.btBackpack,handler(self, self.onMyBag))
        self.Image_tips = self:GetWidgetByName("Image_tips",self.btBackpack)
        self.Image_tips:setVisible(false)
        if self:isHasTaskRedPack() and laixia.kconfig.isYingKe == false then
            self.Image_tips:setVisible(true)
        end
    end           
        -- self:addButAnimationEventListener(self.Button_fuhuo,handler(self.Button_fuhuo,self.fuHuoMa))
        self:addButAnimationEventListener(self:GetWidgetByName("Button_Invitation"),handler(self, self.yaoQingMa))
        self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_Dayly"),handler(self, self.onShowDayley))
        self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_ShouChong"),handler(self, self.onShouchong))
        self.Button_bisaichang = self:GetWidgetByName("Button_bisaichang",self.mainPanel)
        self.Button_bisaichang:setPositionX(self.Button_bisaichang:getPositionX()+180)
        self:addButAnimationEventListener(self.Button_bisaichang,handler(self,self.gotoBisaichang))
        

         --self:addButAnimationEventListener(self:GetWidgetByName("Button_Rank",self.bottom),handler(self, self.sendRankingPacket))
        --发送排行榜 获取排行榜数据

        -- self.btExchange = self:GetWidgetByName("Button_Exchange",self.bottom)
        -- self:addButAnimationEventListener(self.btExchange,handler(self, self.sendExchangePacket))

        

--        self.btForum = self:GetWidgetByName("Button_Forum",self.bottom)
--        self:addButAnimationEventListener(self.btForum,handler(self, self.sendGotoForum)) --论坛
--         local butOtherTable = {
--         {
--             csbButName = "new_ui/Lobby_Landlord.csb", --斗地主
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onShowGameType

--         },
--         {
--             csbButName = "new_ui/Lobby_Fight.csb", --龙虎斗
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onLHD

--         },
--         {
--             csbButName = "new_ui/Lobby_WanRenniuniu.csb", -- 万人斗牛牛
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onWanRenNiuNiu

--         },
--         {
--             csbButName = "new_ui/Lobby_2VS1.csb", -- 二打一 赢现金
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onUpdate2V1

--         },
--         {
--             csbButName = "new_ui/Lobby_Match.csb", -- 比赛场
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onGoMatchWindow

--         },
--         {
--             csbButName = "new_ui/Lobby_Fruitmachine.csb", -- 水果机
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onFruit

--         },
--         {
--             csbButName = "new_ui/Lobby_Threecard.csb", -- 三张牌
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onThreePoker

--         },
--         {
--             csbButName = "new_ui/Lobby_BuYu.csb", -- 捕鱼
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onBuYu

--         },
--         {
--             csbButName = "new_ui/Lobby_NiuNiu.csb", -- 斗牛牛
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onDouNiuniu

--         },
--         {
--             csbButName = "new_ui/Lobby_Majiang.csb", -- 麻将
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onMaJiang

--         },
--         {
--             csbButName = "new_ui/Lobby_Texas.csb", -- 德州扑克
--             isAction = true, --是否播放动画
--             isSoon = true, -- 是否即将上线
--             callFun = self.onTexas

--         },
--         {
--             csbButName = "new_ui/Lobby_Zijianzhuo.csb", -- 自建桌
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onSelfBuilding

--         },

--     }

-- --------------------------------------------------------------------------------------
--     local butIOSTable = {
--         {
--             csbButName = "new_ui/Lobby_Landlord.csb", --斗地主
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onShowGameType

--         },
--         {
--             csbButName = "new_ui/Lobby_Fight.csb", --龙虎斗
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onLHD

--         },
--         {
--             csbButName = "new_ui/Lobby_WanRenniuniu.csb", -- 万人斗牛牛
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onWanRenNiuNiu

--         },
--         {
--             csbButName = "new_ui/Lobby_Threecard.csb", -- 三张牌
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onThreePoker

--         },
                
--         {
--             csbButName = "new_ui/Lobby_Match.csb", -- 比赛场
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onGoMatchWindow

--         },
--         {
--             csbButName = "new_ui/Lobby_Fruitmachine.csb", -- 水果机
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onFruit

--         },
--         {
--             csbButName = "new_ui/Lobby_Zijianzhuo.csb", -- 自建桌
--             isAction = true, --是否播放动画
--             isSoon = false, -- 是否即将上线
--             callFun = self.onSelfBuilding

--         },
-- --        {
-- --            csbButName = "new_ui/Lobby_2VS1.csb", -- 二打一 赢现金
-- --            isAction = true, --是否播放动画
-- --            isSoon = false, -- 是否即将上线
-- --            callFun = self.onUpdate2V1

-- --        },

--     }
     -- if laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 7 then
     --     butOtherTable = butIOSTable
     -- end

        -- local targetPlatform = cc.Application:getInstance():getTargetPlatform()  
        -- if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or   
        --    (cc.PLATFORM_OS_MAC == targetPlatform) then  
        -- --苹果平台显示
        --     self:initGameBut(butIOSTable)
        --      self.btForum:setVisible(false)
        --      self.btExchange:setVisible(false)
        -- else
        -- --其他平台显示
        --     --
        --     --华为和苹果显示内容一致
        --     self:initGameBut(butOtherTable)
        -- end 



        self.AdvertisementPageView = self:GetWidgetByName("AdvertisementPageView")
        self.AdvertisementPageView:addEventListener(handler(self, self.onPageViewEvent))
        self:updatePageView()

        self.btEail = self:GetWidgetByName("Button_Mail",self.bottom)
        self:addButAnimationEventListener(self.btEail,handler(self, self.sendStatinMessagePacket))


        local mActivity = self:GetWidgetByName("Button_Activity",self.bottom)
        self:addButAnimationEventListener(mActivity,handler(self, self.sendActivity))

        self:addButAnimationEventListener(self:GetWidgetByName("Button_Setting",self.bottom),handler(self, self.GameSets))

        

        if laixia.kconfig.isYingKe == false then
            self.mShoping = self:GetWidgetByName("Button_Shop",self.bottom)
            self.mShoping:setOpacity(0)

            local system = laixiaddz.ani.CocosAnimManager
            self.shoppingAni = system:playAnimationAt(self.bottom,"doudizhu_shopping")
            self.shoppingAni:setLocalZOrder(1005)
            self.shoppingAni:setPosition(cc.p(self.mShoping:getPositionX(),self.mShoping:getPositionY()))

            self:addButAnimationEventListener(self.mShoping,handler(self, self.goShop))  
        end
        

        --排行
        self.mRanking = self:GetWidgetByName("Button_Rank",self.bottom)
        self:addButAnimationEventListener(self.mRanking,handler(self, self.sendRankingPacket))

        ---add by wangtianye 
        self.Button_youxichang = self:GetWidgetByName("Button_youxichang",self.mainPanel)
        self.Button_youxichang:setPositionX(self.Button_youxichang:getPositionX()+110)
        self:addButAnimationEventListener(self.Button_youxichang,handler(self,self.gotoYouxichang))
        

        self:GetWidgetByName("Button_haoyoufang",self.mainPanel):setVisible(false)
        self:addButAnimationEventListener(self:GetWidgetByName("Button_haoyoufang",self.mainPanel),handler(self,self.onSelfBuilding))
        --end by wangtianye
        --头部组件
        local lobbyTop = self:GetWidgetByName("LobbyTop") 

--        self:GetWidgetByName("Button_youxichang",self.mainPanel):setVisible(false)

        self:addButAnimationEventListener(self:GetWidgetByName("Image_Gold_ICO",lobbyTop),handler(self, self.goShop))

        self:addButAnimationEventListener(self:GetWidgetByName("Image_Head_Frame",lobbyTop),handler(self, self.sendPersonalCenterPacket))

        self.Whao = self:GetWidgetByName("Image_Wenhao_ICO",lobbyTop)
        self:addButAnimationEventListener(self.Whao,handler(self,self.goWenhao))

        -- --排行榜數據
        -- self.LobbyLeft = self:GetWidgetByName("LobbyLeft")
        -- self.mRankinglisview = self:GetWidgetByName("ListView_Ranking_List",self.LobbyLeft)
        -- self.mRankCell = self:GetWidgetByName("Image_Ranking_Item")
        -- self.mButton_Cfb = self:GetWidgetByName("Button_Cfb")   --财富榜
        -- self.mButton_Cfb:addTouchEventListener(handler(self, self.onShowGoldRank))
        -- self.mButton_Thb = self:GetWidgetByName("Button_Thb")  --土豪榜
        -- self.mButton_Thb:addTouchEventListener(handler(self, self.onRichRank))

        -- self.Image_wodepaiming = self:GetWidgetByName("Image_wodepaiming")
        -- self.Text_myRank = self:GetWidgetByName("Text_myRank",self.Image_wodepaiming)
        

        -- if laixiaddz.LocalPlayercfg.SelfRank==nil or laixiaddz.LocalPlayercfg.SelfRank==0 then
        --     self.Text_myRank:setString(" 未上榜" )
        -- else
        --     self.Text_myRank:setString(" "..laixiaddz.LocalPlayercfg.SelfRank )
        -- end
        -- self.Text_myRank:enableOutline(cc.c4b(187,63,39,255), 2);

        -- self.mImageCfb = self:GetWidgetByName("Button_Cfb_Down") 
        -- self.mImageCfb:setVisible(false)
        -- self.mImageThb = self:GetWidgetByName("Button_Thb_Down") 
        -- self.mImageThb:setVisible(false)
        
        -- self.rankTypeIndex =1 --默认
        -- 关闭
--        self:AddWidgetEventListenerFunction("Button_Panel_Close", handler(self, self.onShutDown))

--        self:GetWidgetByName("Label_Ranking_NoNum"):setVisible(false)
-- --      self:GetWidgetByName("Label_Ranking_Num"):setVisible(false)
--         self.rankIcon = {}
--         ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 0})
--         self:updateBtnStatu(1)
    
--         self.AllRankdata = nil
--         self.mIndex = 0
        --end
       
        laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MAININTERFACE_WINDOW
        self.mIsShow = true
        self.mTime  = 5

        self.top = self:GetWidgetByName("LobbyTop")
        self.Button_shoujibangding = self:GetWidgetByName("Button_shoujibangding",self.top)
        local system4 = laixiaddz.ani.CocosAnimManager
        self.phone = system4:playAnimationAt(self.top,"doudizhu_phone")
        self.phone:pos(self.Button_shoujibangding:getPositionX(),self.Button_shoujibangding:getPositionY()+7)
        -- self.phone:pos(self.Button_shoujibangding:getContentSize().width/2,self.Button_shoujibangding:getContentSize().height/2+7)
        self:addButAnimationEventListener(self:GetWidgetByName("Button_shoujibangding",self.top),handler(self, self.shoujibangding))

        self:sendWeekOrMonthCard()
    end
        print("ppppppppppppppppppppppppppppppppppppppppppppp")
        self:addHead() 
--        self:isShowBagRed() 
        self:initUI()
        self:setTopInfo()
end
--邀请码的回调函数
function LobbyWindow:yaoQingMa(sender, eventtype)
    print("邀请码的回调函数000000000000000000000000")
    ObjectEventDispatch:pushEvent("_laixiaddz_EVENT_SHOW_INVITATION_WINDOW")
end
function LobbyWindow:fuHuoMa(sender, eventtype)    
    ObjectEventDispatch:pushEvent("_laixiaddz_EVENT_SHOW_FUHUO_WINDOW")  
end
--获取轮播图下载路径
function LobbyWindow:onLunBoDoSuccess(msg) 
    self.data = msg.data
    local LunBoInUse = self.data.savePath
    local index = self.data.index
    local fileExist = cc.FileUtils:getInstance():isFileExist(LunBoInUse)
    if (fileExist) then
        if isTableEmpty(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) then
            if laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] == nil then
                laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] = {}
            end
            laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] = LunBoInUse 
            -- table.insert(laixiaddz.LocalPlayercfg.LaixiaLunBoPath,LunBoInUse)
        else
            local tagPath = 0
            for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                if v == LunBoInUse then
                    tagPath = 1
                end
            end
            if tagPath == 0 then
                if laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] == nil then
                    laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] = {}
                end
                laixiaddz.LocalPlayercfg.LaixiaLunBoPath[index] = LunBoInUse 
                -- table.insert(laixiaddz.LocalPlayercfg.LaixiaLunBoPath,LunBoInUse)
            end
        end
    end 
    -- self.isDiaoYong = true
    -- self:addPathArray()
    -- self:updatePageView()
end
--获得月卡的金币
function LobbyWindow:sendWeekOrMonthCard()
    local CSWeekOrMonthCard = Packet.new("CSWeekOrMonthCard", _LAIXIA_PACKET_CS_WeekOrMonthCardID)
    CSWeekOrMonthCard:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSWeekOrMonthCard:setValue("AppID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSWeekOrMonthCard) 
end
--打开游戏场
function LobbyWindow:gotoYouxichang(sender, eventtype)
        self.mRoomType = 2 --经典场
        laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW
        
        local stream = Packet.new("EnterListRoom", _LAIXIA_PACKET_CS_ListRoomID)
        stream:setValue("RoomType", self.mRoomType)
        laixia.net.sendPacketAndWaiting(stream)
end
function LobbyWindow:sendCurVersion(version)
    local stream = Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
    stream:setValue("Code", 0)
    stream:setValue("GameID", 1)
    stream:setValue("GameVersion",version)
    laixia.net.sendHttpPacketAndWaiting(stream,nil,2) 
end
--打开比赛场
function LobbyWindow:gotoBisaichang(sender, eventtype)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
        laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW

--        local CSMatchSignPacket = Packet.new("CSMatchSign", _LAIXIA_PACKET_CS_MatchSignID)
--        CSMatchSignPacket:setValue("GameID", laixia.config.GameAppID)
--        laixia.net.sendPacketAndWaiting(CSMatchSignPacket)  
            
         local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
         CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
         CSMatchListPacket:setValue("PageType", 1 )
         laixia.net.sendPacketAndWaiting(CSMatchListPacket)
end
--问号
function LobbyWindow:goWenhao()
    if laixia.config.isAudit then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换金币!")
    else
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换奖励,可在比赛、游戏场中获得!")
    end

    
    --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"可用于兑换奖励,可在比赛、游戏场中获得!")
   --  if self.mWhisShow == false  then
   --  self.mWhisShow = true
   --  local sprite = display.newSprite("#list_biaotibeijing.png")
   --  sprite:setPosition(cc.p(805,570))
   -- -- sprite:setLocalZOrder(10000)
   --  local ttf = cc.LabelTTF:create("可用于兑换奖励,可在比赛、游戏场中获得!", "Arial", 24)
   --  ttf:setColor(cc.c3b(65, 0, 0))
   --  ttf:setPosition(cc.p(805,570))
   --  self.BGIMG:addChild(ttf)
   --  self.BGIMG:addChild(sprite)
   --  local function removeAlll() 
   --  self.BGIMG:removeAllChildren()
   --      self.mWhisShow = false
   --  end

   --  local callfun = cc.CallFunc:create(removeAlll)
   --  local to2 = cc.DelayTime:create(3)
   --  self.BGIMG:runAction(cc.Sequence:create(to2,callfun,NULL));
   --  end

end
--任务
function LobbyWindow:onRenwu(sender,evenType)
    -- -- if eventType == ccui.TouchEventType.ended then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "敬请期待")
--        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW, "即将开放")

--    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_EFFECTGOLD_WINDOW)
--    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"充值成功")

--        local screenshotFileName = "screenShare.png"--string.format("wx-%s.png", os.date("%Y-%m-%d_%H:%M:%S", os.time()))
--        if device.platform == "android" then
--            -- local layerSize = self.mInterfaceRes:getContentSize()
--            -- local screenshot = cc.RenderTexture:create(layerSize.width, layerSize.height)
--            -- local scene = cc.Director:getInstance():getRunningScene()
--            -- screenshot:begin()
--            -- scene:visit()
--            -- screenshot:endToLua()
--            -- screenshot:saveToFile(screenshotFileName, cc.IMAGE_FORMAT_PNG, false)
--            local winsize = cc.Director:getInstance():getWinSize()
--            local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
--            cc.utils:captureScreen(function ( success,outputFile )
--                  if success then
--                        local luaj = require "cocos.cocos2d.luaj"
--                        local javaClassName = APP_ACTIVITY
--                        local javaMethodName = "shareImageToWX"
--                        local javaParams = {fileName}
--                        local javaMethodSig = "(Ljava/lang/String;)V"
--                        local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
--                  end
--            end,fileName)
--        else--苹果包
--            --分享链接
--            local winsize = cc.Director:getInstance():getWinSize()
--            local fileName = cc.FileUtils:getInstance():getWritablePath() .. "/screenShare.png"
--            cc.utils:captureScreen(function ( success,outputFile )
--                  if success then
--                        local luaoc = require("cocos.cocos2d.luaoc")
--                        local args = { imgFilePath = fileName }
--                        local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendImageContent", args);
--                    
--                  end
--            end,fileName)
--        end       
end
--初始化苹果版大厅游戏按钮
function LobbyWindow:initGameBut(butTable)
    local index = 1
    while( index <= #butTable )
    do
        local listItemLayout = ccui.Layout:create()
        listItemLayout:setContentSize(cc.size(280,466))
        
        local animationBut = laixiaddz.Layout.loadNode(butTable[index].csbButName):addTo(listItemLayout)
        animationBut:setPosition(cc.p(123,360))
        self:setImgBut(animationBut).callFun = handler(self, butTable[index].callFun)
        if butTable[index].isAction then
            local action = cc.CSLoader:createTimeline(butTable[index].csbButName)
            animationBut:runAction(action)
            table.insert(self.mButtonArray,action)
        end

        if butTable[index].isSoon then
            self:GetWidgetByName("Image_game_Coming",animationBut):loadTexture("images/game_coming.png")
        end
        index = index+1
        if index <= #butTable then
            local animationBut = laixiaddz.Layout.loadNode(butTable[index].csbButName):addTo(listItemLayout)
            animationBut:setPosition(cc.p(123,115))
            self:setImgBut(animationBut).callFun = handler(self, butTable[index].callFun)
            if butTable[index].isAction then
                local action = cc.CSLoader:createTimeline(butTable[index].csbButName)
                animationBut:runAction(action)
                table.insert(self.mButtonArray,action)
            end

            if butTable[index].isSoon then
                self:GetWidgetByName("Image_game_Coming",animationBut):loadTexture("images/game_coming.png")
            end
            index = index+1
        end

       self.LobbyListView:addChild(listItemLayout)
    end
end

--当前显示的页码(1 ~ pages)
local pageIdx = 1

function LobbyWindow:addPage(pIdx, iIdx, bClone)
 
    local newPage = nil
    if not bClone then
        newPage = self.AdvertisementPageView:getPage(0)
    else
        newPage = self.AdvertisementPageView:getPage(0):clone()
    end

    newPage:setTag(pIdx)

    local adImg = self:GetWidgetByName("Image_Advertisement_Icon",newPage)
    adImg.callFun = handler(self, self.sendActivityPacket)
    --adImg:loadTexture(self.mPathArray[pIdx],1)
    adImg:loadTexture(self.mPathArray[pIdx])
    
    adImg:setSwallowTouches(false)
    adImg:setTouchEnabled(true)
    
    adImg:addTouchEventListener(function(sender,eventtype)
       if eventtype == ccui.TouchEventType.began then
            laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            print("22222")
        elseif eventtype == ccui.TouchEventType.moved then
        elseif eventtype == ccui.TouchEventType.canceled then

        elseif eventtype == ccui.TouchEventType.ended then    
            --监听的函数
                laixiaddz.LocalPlayercfg.AdvermentIndex = tonumber(sender:getParent():getTag())
                if sender.callFun ~= nil then
                    sender.callFun()
                end
        end

    end)
    self.AdvertisementPageView:insertPage(newPage, iIdx)
 
end

--
function LobbyWindow:updatePageView()
    --sign_1 = 3
    --删除原来的页面(第一页保留用于clone)
    for i = #self.AdvertisementPageView:getPages() - 1, 1, -1 do
        self.AdvertisementPageView:removePageAtIndex(i) 
    end
    --添加新的页面(每页显示6个)
    local pages = #self.mPathArray
 
    pageIdx = 1
 
    if 1 == pages then
        self:addPage(1, 0, false)
    elseif 2 == pages then
        self:addPage(2, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.AdvertisementPageView:scrollToPage(1)
    elseif pages >= 3 then
        self:addPage(pages, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.AdvertisementPageView:scrollToPage(1)
    end
end


function LobbyWindow:onPageViewEvent(sender, eventType)
    if eventType == ccui.PageViewEventType.turning then
        local pages = #self.mPathArray
        local nextPageIdx = 0
        local curPageIndex = sender:getCurPageIndex()
        if pages >= 3 then
            if curPageIndex == 0 then
                pageIdx = pageIdx - 1
                if pageIdx <= 0 then pageIdx = pages end
 
                nextPageIdx = pageIdx - 1
                if nextPageIdx <= 0 then nextPageIdx = pages end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                sender:update(10)   
            elseif curPageIndex == 2 then
                pageIdx = pageIdx + 1
                if pageIdx > pages then pageIdx = 1 end
                nextPageIdx = pageIdx + 1
                if nextPageIdx > pages then    nextPageIdx = 1 end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
                sender:scrollToPage(1)
                -- sender:update(10)
            end
        elseif pages == 2 then
            if curPageIndex == 0 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(2)
                self:addPage(nextPageIdx, 0, true)
                --PageView的当前页索引为0,在0的位置新插入页后原来的页面0变为1;
                --PageView自动显示为新插入的页面0,我们需要显示为页面1,所以强制滑动到1.
                sender:scrollToPage(1)
                --解决强制滑动到1后回弹效果
                -- sender:update(10)   
 
            elseif curPageIndex == 2 then
                nextPageIdx = 0
                if 1 == pageIdx then
                    pageIdx = 2
                    nextPageIdx = 1
                else
                    pageIdx = 1
                    nextPageIdx = 2
                end
                sender:removePageAtIndex(0)
                self:addPage(nextPageIdx, 2, true)
            end
        end
    end
end
--手机绑定
function LobbyWindow:shoujibangding()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_BINDPHONE_WINDOW)
end
--设置大厅头部显示用户信息
function LobbyWindow:setTopInfo()
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ==  "LobbyWindow" then
        self:GetWidgetByName("AtlasLabel_Lable_Gold_Number",self.top):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGold)
        self:GetWidgetByName("AtlasLabel_Lable_JiangQuan_Number",self.top):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon)
        self:GetWidgetByName("nickName",self.top):setString(laixiaddz.helper.StringRules_6(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)) 
        -- if laixiaddz.LocalPlayercfg.LaixiaLastLoginPlatform == 1 then   --游客登陆 木有手机绑定的按钮
        --     self:GetWidgetByName("Button_shoujibangding",self.top):setVisible(false)
        --     self.phone:setVisible(false)
        -- else
            -- self.Button_shoujibangding = self:GetWidgetByName("Button_shoujibangding",self.top)
            self:GetWidgetByName("Button_shoujibangding",self.top):setOpacity(0)
            -- local system4 = laixiaddz.ani.CocosAnimManager
            -- self.phone = system4:playAnimationAt(self.Button_shoujibangding,"doudizhu_phone")
            -- self.phone:pos(self.Button_shoujibangding:getContentSize().width/2,self.Button_shoujibangding:getContentSize().height/2+7)
            -- self:addButAnimationEventListener(self:GetWidgetByName("Button_shoujibangding",self.top),handler(self, self.shoujibangding))
            if laixiaddz.LocalPlayercfg.LaixiaPhoneNum~="" then
                self.phone:setVisible(false)
            end
--        end

        if laixia.kconfig.isYingKe == true then
            self:GetWidgetByName("Panel_22"):setVisible(true)
            self:GetWidgetByName("Panel_23"):setVisible(false)

            self.Panel_YingKe = self:GetWidgetByName("Panel_22")
            self:GetWidgetByName("Text_jinbi_xinban", self.Panel_YingKe):setString(laixiaddz.helper.numeralRules_2(laixiaddz.LocalPlayercfg.LaixiaPlayerGold))
            self:GetWidgetByName("Text_laidou_xinban", self.Panel_YingKe):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon)
            self:GetWidgetByName("nickName_Copy", self.Panel_YingKe):setString(laixiaddz.helper.StringRules_6(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname)) 
            self.Button_tuichuyouxi = self:GetWidgetByName("Button_tuichuyouxi")
            self:addButAnimationEventListener(self.Button_tuichuyouxi,handler(self, self.TuiChu_Exit))
            self:addButAnimationEventListener(self:GetWidgetByName("Button_39"),handler(self, self.goShop)) -- 商场
            self:addButAnimationEventListener(self:GetWidgetByName("Button_40"),handler(self,self.goWenhao)) -- 问号
            self.Button_39_Copy = self:GetWidgetByName("Button_39_Copy")
            self.Image_297_Copy_0 = self:GetWidgetByName("Image_297_Copy_0")
            self:GetWidgetByName("Button_shoujibangding"):setPositionX(self.Button_39_Copy:getPositionX())
            self:GetWidgetByName("Button_shoujibangding"):setPositionY(self.Image_297_Copy_0:getPositionY())
            self.phone:pos(self.Button_shoujibangding:getPositionX(),self.Button_shoujibangding:getPositionY())
            -- 头像
            self.Image_HeadBg_zhishi = self:GetWidgetByName("Image_HeadBg_zhishi",self.Panel_YingKe)
            self:addButAnimationEventListener(self.Image_HeadBg_zhishi,handler(self, self.sendPersonalCenterPacket))
            -- 添加大厅的芝士币
            self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixiaddz.LocalPlayercfg.ZhiShiBiNum)
        end
    end

    -- self:GetWidgetByName("Level",self.top):setString("Lv." .. laixiaddz.LocalPlayercfg.LaixiaPlayerLevel) 
    -- self.progressbar_level = self:GetWidgetByName("ProgressBar_EXPBar",self.top)

    -- local levelData =  laixiaddz.JsonTxtData:queryTable("gradeArray").buf;
    -- local mNextExp = 0
    -- local mNowExp = 0
    -- if laixiaddz.LocalPlayercfg.LaixiaPlayerLevel+1>#levelData then
    --     mNextExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel].GradeExperience)
    -- else
    --     mNextExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel+1].GradeExperience)
    -- end
    -- if laixiaddz.LocalPlayercfg.LaixiaPlayerLevel == 1 or laixiaddz.LocalPlayercfg.LaixiaPlayerLevel == 0 then
    --     mNowExp = 0
    -- else
    --     mNowExp = tonumber(levelData[laixiaddz.LocalPlayercfg.LaixiaPlayerLevel].GradeExperience)
    -- end
    -- self.label_level_detail = self:GetWidgetByName("Label_EXPNum",self.top)
    -- if mNowExp==mNextExp then --等级到头的处理方法
    --     self.progressbar_level:setPercent(100)
    --     self.label_level_detail:setVisible(false)
    -- else
    --     if mNextExp == nil then  return end
    --     local per =(laixiaddz.LocalPlayercfg.LaixiaExperience - mNowExp) /(mNextExp - mNowExp)
    --     self.progressbar_level:setPercent(per * 100)
    --     self.label_level_detail:setString((laixiaddz.LocalPlayercfg.LaixiaExperience - mNowExp).."/"..(mNextExp - mNowExp));
    -- end
end

function LobbyWindow:TuiChu_Exit()
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "exitGame"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    else
        state,value = luaoc.callStaticMethod("IKCRLXBridgeManager", "dismiss");
    end
end

function LobbyWindow:sendSignInPacket()
    local stream = Packet.new("CSSignLanding", _LAIXIA_PACKET_CS_SignLandingID)
    stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end
                                      
function LobbyWindow:clearProgress()
   --local button  = self:GetWidgetByName("Button_Lobby_Fight")
   local button  = self.lobby_Fight
   if button == nil then
       return 
   end
   local mDownLoadProgressBG = self:GetWidgetByName("Image_DownloadProgress",button)
   if mDownLoadProgressBG == nil then
       return 
   end
   mDownLoadProgressBG:setVisible(false)
   --mDownLoadProgressBG:removeFromParent()
end

function LobbyWindow:getProgress(sender)
   local mDownLoadProgressBG = self:GetWidgetByName("Image_DownloadProgress",sender)
   mDownLoadProgressBG:setVisible(true)
   local mDownLoadProgress = display.newProgressTimer("images/icon_loading.png",display.PROGRESS_TIMER_RADIAL )
   mDownLoadProgress:setLocalZOrder(1099)
   mDownLoadProgressBG:addChild(mDownLoadProgress)
   mDownLoadProgress:setPosition(mDownLoadProgressBG:getContentSize().width/2,mDownLoadProgressBG:getContentSize().height/2)
   mDownLoadProgress:setPercentage(0)

   local progressNum = self:GetWidgetByName("BitmapLabel_Progress",sender) 
   progressNum:setLocalZOrder(100)
   progressNum:setString("0%")

  return {
            ['loadingbarBg'] = mDownLoadProgressBG,
            ['loadingbar'] = mDownLoadProgress,
            ["LoadingNum"] = progressNum,
         }
end

function LobbyWindow:onLHD(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
----        if laixiaddz.LocalPlayercfg.LaixiaPlayerLevel <2 then
----            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"高于2级才能玩龙虎斗哦!")
----            return
----        end
        
        if laixiaddz.LocalPlayercfg.LaixiaPlayerGold < 5000 then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"高于五千金币才能玩龙虎斗哦!")
            return
        end
        local pluginManager = pluginManager;
        if(not pluginManager.is_loading_plugin) then
            --local t =self:getProgress(self.lobby_Fight)    
            local t =self:getProgress(sender)         
            pluginManager:loadPlugin("lhd",t)
            pluginManager:updateLoadingIndex("lhd",1)
        else
             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"其他游戏下载中，请耐心等待")
        end
--    end
end

function LobbyWindow:onThreeCard(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
        local pluginManager = pluginManager;
        if(not pluginManager.is_loading_plugin) then
            local t =self:getProgress(sender)    
            --local t =self:getProgress(self.lobby_Threecard)        
            pluginManager:loadPlugin("threecards",t)
            pluginManager:updateLoadingIndex("threecards",1)
        else
             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"其他游戏下载中，请耐心等待")
        end
--    end
end

function  LobbyWindow:VisibleMore(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        self.more:setVisible(not  self.more:isVisible())
    end
end

----背包红点显示和隐藏
function LobbyWindow:hideStationManageReda()
    -- self:hideButtonRed(self.btMore)
    self:hideButtonRed(self.btBackpack)
end

function LobbyWindow:showStationManageReda(button)
    -- self:showButtonRed(self.btMore)
    self:showButtonRed(self.btBackpack)
end 


function LobbyWindow:hideButtonReda(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(false)
    end    
end 


function LobbyWindow:showButtonRed(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(true)
    end   
end 
----
function LobbyWindow:showBagTips()
    if self.mIsLoad and laixia.kconfig.isYingKe == false then
        self.Image_tips:setVisible(true)
    end   
end
function LobbyWindow:hideBagTips()
    if self.mIsLoad then
        self.Image_tips:setVisible(false)
    end   
end
----站内信红点显示和隐藏
function LobbyWindow:hideStationManageRed()
    -- self:hideButtonRed(self.btMore)
    self:hideButtonRed(self.btEail)
end

function LobbyWindow:showStationManageRed(button)
    -- self:showButtonRed(self.btMore)
    self:showButtonRed(self.btEail)
end 


function LobbyWindow:hideButtonRed(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(false)
    end    
end 


function LobbyWindow:showButtonRed(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(true)
    end   
end 
----    
function LobbyWindow:addHead()
    -- 默认头像图片路径
    self.rankIcon = {}
    --local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID%10))..".png"
    local headIcon_new = laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的

    print("===========================wangtianye===============")
    print(headIcon_new)
    if laixia.kconfig.isYingKe == true then
        self.Image_HeadBg = self:GetWidgetByName("Image_HeadBg_zhishi")
    else
        self.Image_HeadBg = self:GetWidgetByName("Image_HeadBg")
    end
    
    self.rankIcon[tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)] = self.Image_HeadBg
    local path = "images/ic_morenhead"..tostring(tonumber(laixiaddz.LocalPlayercfg.LaixiaPlayerID)%10)..".png"

    print("wangtianye")
    print(cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png")
    print("--------------------------")
    print(headIcon_new)

    -- if headIcon_new ~= nil and headIcon_new ~= "" then
        -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        -- local localIconName = cc.FileUtils:getInstance():getWritablePath() .. "head_image/" .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png"
        local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixiaddz.LocalPlayercfg.LaixiaPlayerID..".png"
        local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        if (fileExist) then
            path = localIconName
            self:addHeadIcon(self.Image_HeadBg,path)
            -- local sprite = cc.Sprite:create(localIconPath) 
            -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
            -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
            -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
            -- image:addChild(sprite)
            --image:loadTexture(localIconPath)
            --image:setScale(0.08)
        else
            -- local sprite = cc.Sprite:create(localIconPath) 
            -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
            -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
            -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
            -- image:addChild(sprite)
--            image:loadTexture(path)
--            image:setScale(1)
            -- self:addHeadIcon(self.Image_HeadBg,path)
            local netIconUrl = headIcon_new
            DownloaderHead:pushTask(laixiaddz.LocalPlayercfg.LaixiaPlayerID, netIconUrl,2)
        end
    -- else
        self:addHeadIcon(self.Image_HeadBg,path)
        -- local sprite = cc.Sprite:create(localIconPath) 
        -- sprite:setScaleX(image:getContentSize().width/sprite:getContentSize().width)
        -- sprite:setScaleY(image:getContentSize().height/sprite:getContentSize().height)
        -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
        -- image:addChild(sprite)
--        image:loadTexture(path)
--        image:setScale(1)
    -- end
end        

function LobbyWindow:addHeadIcon(head_btn,path)
    --local head_btn = self:GetWidgetByName("Image_Head_Frame")
    if (head_btn == nil or head_btn == "") then
        return
    end
    -- head_btn:removeAllChildren()
    local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
    if laixia.kconfig.isYingKe == true then
        local sprite = display.newSprite(path)
        sprite:setScaleX(head_btn:getContentSize().width/sprite:getContentSize().width)
        sprite:setScaleY(head_btn:getContentSize().height/sprite:getContentSize().height)
        sprite:setPosition(head_btn:getContentSize().width/2,head_btn:getContentSize().height/2)
        head_btn:addChild(sprite)
    else   
        laixia.UItools.addHead(head_btn, path, templet)
    end
end

function LobbyWindow:sendPersonalCenterPacket(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        local stream = Packet.new("PersonalCenter", _LAIXIA_PACKET_CS_PersonalCenterID)
        stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        stream:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(stream, nil, 1);
--    end
end


function LobbyWindow:sendExchangePacket(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SHOP_WINDOW,{buttonType =3}) 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_EXCHANGE_WINDOW)
--    end
end


function LobbyWindow:sendRankingPacket(sender, eventtype)
  -- if eventtype == ccui.TouchEventType.ended then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_RANK_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 0})
  -- end
end

function LobbyWindow:sendShopPacket()
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SHOP_WINDOW) 
   
--    local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_ShopID)
--    stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
--    stream:setValue("GameID", laixia.config.GameAppID)
--    stream:setValue("LastModifyTm", 0)
--    laixia.net.sendHttpPacketAndWaiting(stream)
end

function LobbyWindow:goShop(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        self:sendShopPacket()
--    end
end

function LobbyWindow:sendStatinMessagePacket(sender, eventtype)
    --if eventtype == ccui.TouchEventType.ended then
        -- 保证了点击结束的时候才开始执行
        if laixiaddz.LocalPlayercfg.LaixiaIsHaveEmil ~= 0 then
            local CSSmsList = Packet.new("CSSmsList", _LAIXIA_PACKET_CS_SmsListID)
            CSSmsList:setValue("GameID", laixia.config.GameAppID)
            CSSmsList:setValue("Type", laixiaddz.LocalPlayercfg.LaixiaIsHaveEmil)
            laixia.net.sendPacket(CSSmsList)
            laixiaddz.LocalPlayercfg.LaixiaIsHaveEmil = 0
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MAIL_WINDOW)
        elseif laixiaddz.LocalPlayercfg.LaixiaIsHaveEmil == 0 then
            
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MAIL_WINDOW)
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MAIL_WINDOW)
        end
    --end
end

function LobbyWindow:GameAbout(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        print("this is gameabout")
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_GAMEDESCRIBE_WINDOW)
--    end
end

function LobbyWindow:sendGotoForum(sender, eventtype)
    --if eventtype == ccui.TouchEventType.ended then
        local headIconUrl
        if laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath ~= "" then
            headIconUrl = laixia.config.HEAD_URL .. laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath
        else
            headIconUrl = laixiaddz.LocalPlayercfg.LaixiaHeadPortraitPath
        end
        
        local nickname = laixiaddz.LocalPlayercfg.LaixiaPlayerNickname
        local playerID = tostring (laixiaddz.LocalPlayercfg.LaixiaPlayerID )
        
        local json = json or require("framework.json");

        local array = {}
       array[1] ={["name"] ="等级",["value"] = "LV"..laixiaddz.LocalPlayercfg.LaixiaPlayerLevel}
       array[2] ={["name"] ="金币",["value"] = laixiaddz.LocalPlayercfg.LaixiaPlayerGold}
       array[3] ={["name"] ="胜率",["value"] = laixiaddz.LocalPlayercfg.LaixiaPlayerShengLv}


   
       local json_array = json.encode(array) --转换为json字符串
--       local urcode = string.urlencode(json_array)  --将字符串转换为urlencode
--       local array = json.decode(json_array) --将json字符串转化为数组

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ==  3 then 

        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "showBbs"
	    local javaParams = {playerID,nickname ,headIconUrl,json_array}
        local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        if value == -3 then
            javaParams = {playerID,nickname ,headIconUrl}
	        javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
           state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        end
    end 
    --end
end


function LobbyWindow:GameSets(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SETUP_WINDOW,2) 
--    end
end

function LobbyWindow:onMyBag(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_TOOLSBOX_WINDOW);
        self:sendToMyBagPacket()
        self.Image_tips:setVisible(false)
        --更新任务列表
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_GETTASKLIST)
--    end
end


function LobbyWindow:isInStallApk(mPacketName)
   local targetPlatform = cc.Application:getInstance():getTargetPlatform()
   
    if targetPlatform ==  3 then 
        local packetName = mPacketName
        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "isInstall"
	    local javaParams = {packetName}
	    local javaMethodSig = "(Ljava/lang/String;)Z"   
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return value;
    else    
        return false;
    end 
end

function LobbyWindow:downApk(apkPath)
   local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ==  3 then 
       local downApkPath = apkPath      
        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "downThreeApk"
	    local javaParams = {downApkPath}
	    local javaMethodSig = "(Ljava/lang/String;)V"   
        local state = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        mBeganDown  = true 
        self.mDownLoadApkProgress:setPercentage(0);
    end 
end


function LobbyWindow:updataProgressBar(mProgressBar)
     print("下载进度in lua" ..mProgressBar)
     if 100 ~= tonumber(mProgressBar) then
        self.mDownLoadApkProgressBG:setVisible(true)
        mBeganDown = true
        self.mDownLoadApkProgress:setPercentage(tonumber(mProgressBar))
        self.mDownLoadApkProgressNum :setString(tonumber(mProgressBar) .."%")
     else 
        self.mDownLoadApkProgress:setPercentage(tonumber(mProgressBar))
        self.mDownLoadApkProgressNum :setString(tonumber(mProgressBar) .."%")
        self.mDownLoadApkProgressBG:setVisible(false)
        self.mDownLoadApkProgress:setPercentage(100);
        self.mDownLoadApkProgress:removeFromParent()
        self.mDownLoadApkProgressNum :setString("100%")

        mBeganDown = false
       print("updataProgressBar  mProgressBar  100%");
     end
end


function LobbyWindow:startOtherApk(packgeName,appActity,gameId,pid,appKey)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
     if targetPlatform == 3 then
        local luaj = require "cocos.cocos2d.luaj"
        local javaClassName =  APP_ACTIVITY
        local javaMethodName = "startUpGameApp"
        local javaParams={ packgeName,appActity,gameId,pid,appKey}
        local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"
        local state,value =luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

        if value == -3 then
           state,value = self:startUpApp(packgeName,appActity)
        end
        return state,value
    end 
end

--下载apk
function LobbyWindow:downloadAPK(mButton,mDownPath)

    if mBeganDown then 
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"游戏下载中，请耐心等待")
        return;
    end
    
    self.mDownLoadApkProgressBG =  self:GetWidgetByName("Image_DownloadProgress",mButton)
    self.mDownLoadApkProgressNum = self:GetWidgetByName("BitmapLabel_Progress", mButton) 

    self.mDownLoadApkProgressBG:setVisible(true)
    self.mDownLoadApkProgress = display.newProgressTimer("images/icon_loading.png",display.PROGRESS_TIMER_RADIAL )
    self.mDownLoadApkProgress:setLocalZOrder(99)
    self.mDownLoadApkProgressBG:addChild(self.mDownLoadApkProgress)
    self.mDownLoadApkProgress:setPosition(self.mDownLoadApkProgressBG:getContentSize().width/2,self.mDownLoadApkProgressBG:getContentSize().height/2)
    self.mDownLoadApkProgress:setPercentage(0)
    self.mDownLoadApkProgressNum :setString("0%")
    self.mDownLoadApkProgressNum :setLocalZOrder(100)
    local downApkPath =  mDownPath
    self:downApk(downApkPath)
end

--获取下载进度
function LobbyWindow:getDownProgerss()
    print("getDownProgerss")
   local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ==  3 then 
        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_PACKAGE_NAME.."UpdateThreeApkManager"
	    local javaMethodName = "getDownProcess"
	    local javaParams = {}
	    local javaMethodSig = "()I"   
        local state,progerss = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        self:updataProgressBar(progerss)
    end 
end

--老的启动函数，为了兼容老版本
function LobbyWindow:startUpApp(packetName,appActity)

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
     if targetPlatform == 3 then
       
        local luaj = require "cocos.cocos2d.luaj"
        local javaClassName =  APP_ACTIVITY
        local javaMethodName = "startUpApp"
        local javaParams={ packetName,appActity }
        local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
        local state,value =luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return   state,value
    end 
end
--下载启动二打一
function LobbyWindow:onUpdate2V1(sender, eventtype)
    local targetPlatform = cc.Application:getInstance():getTargetPlatform() 
    if targetPlatform == cc.PLATFORM_OS_ANDROID then 
        
        local packetName =  "com.laixia.game.playAgainst.wyx"
        local isinstall =self:isInStallApk(packetName)

        local appActity = "com.excelliance.open.KXQP"
        local gameId = "1"
        local pid = tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)                                                         
        local appKey = "3568f744633f0e1c4e6568464f5f1cd8db16"
        local button = sender
        local downPath =  laixia.config.APK2VS1_URL
        if isinstall then
            self:startOtherApk(packetName,appActity,gameId,pid,appKey)
        else
            self:goGame()
            --self:downloadAPK(button,downPath)  
        end 
    elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
            local webView = WebView.new(ERVYI_URL)
            self.root:addChild(webView,10000)
    end 
end

function LobbyWindow:goGame()

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if targetPlatform ==  cc.PLATFORM_OS_ANDROID then 
        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "showGame"
        local javaParams = {ERVYI_URL}
        local javaMethodSig = "(Ljava/lang/String;)V"
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return state,value
    end 
end

--斗牛下载
function LobbyWindow:onDouNiuniu(sender, eventtype)

--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
        local packetName = "com.bailin.killbulls.sina"
        local isinstall =    self:isInStallApk(packetName)

        local appActity = "com.bailin.killbulls.laixia.KillBulls"
        local gameId = "20"
        local pid = tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)                                                         
        local appKey = "3568f744633f0e1c4e6568464f5f1cd8db16"

        local button = sender
        local downPath =  laixia.config.APKDOUNIUNIU_URL
        if isinstall ==false  then
            self:downloadAPK(button,downPath)
        else
            self:startOtherApk(packetName,appActity,gameId,pid,appKey)
        end
--    end
end

--麻将房间
function LobbyWindow:onMaJiang(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
              
        local packetName =  "com.bailin.errenmajiang.sina"
        local isinstall =    self:isInStallApk(packetName)

        local appActity = "com.bailin.errenmajiang.laixia.KillBulls"
        local gameId = "22"
        local pid = tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)                                                         
        local appKey = "26725d1b263568f744633f1604d689edab2b"

        --local button = sender
        local button = sender
        local downPath =  laixia.config.APKMAJIANG_URL
        if isinstall ==false  then
            self:downloadAPK(button,downPath)
        else
            self:startOtherApk(packetName,appActity,gameId,pid,appKey)
        end

--    end
end


--德州扑克
function LobbyWindow:onTexas(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)

        local packetName =  "com.bailin.dzpk.sina"
        local isinstall =    self:isInStallApk(packetName)

        local appActity = "com.bailin.dzpk.laixia.dzpoker"
        local gameId = "21"
        local pid = tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)                                                         
        local appKey = "e1c4e6568463568f744633f1604f5f1cd8db"

        --local button = sender
        local button = sender
        local downPath =  laixia.config.APKTEXAS_URL
        if isinstall ==false  then
            self:downloadAPK(button,downPath)
        else
            self:startOtherApk(packetName,appActity,gameId,pid,appKey)
        end

--    end
end
--捕鱼
function LobbyWindow:onBuYu(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)

        local packetName =  "com.zhidian.games.fishingMo2"
        local isinstall =    self:isInStallApk(packetName)

        local appActity = "com.unity3d.player.UnityPlayerActivity"
        local gameId = "31"
        local pid = tostring(laixiaddz.LocalPlayercfg.LaixiaPlayerID)                                                         
        local appKey = "41bda9b7ca0e914f05f457e344d60972"

        --local button = sender
        local button = sender
        local downPath =  laixia.config.APKFISH_URL
        if isinstall ==false  then
            self:downloadAPK(button,downPath)
        else
            self:startOtherApk(packetName,appActity,gameId,pid,appKey)
        end

--    end

end

--显示自建房间
function LobbyWindow:onSelfBuilding(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_PACKET_CREATESELFBUILF
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PACKET_CREATESELFBUILF)
--    end
end


--显示每日登陆的奖励
function LobbyWindow:onShowDayley(sender, eventtype)
--    if eventtype == ccui.TouchEventType.ended then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_DAILYSIGN_WINDOW)
--    end
end


function LobbyWindow:onShowGameType(sender, eventtype)
--    if eventtype == ccui.TouchEventType.began then
--        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
--        sender:setScale(1.1)
--    elseif eventtype == ccui.TouchEventType.canceled then
--        sender:setScale(1)
--    elseif eventtype == ccui.TouchEventType.ended then    
--        sender:setScale(1)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_GAMETYPE_WINDOW) --游戏类型
--    end
end

function LobbyWindow:addPathArray()
    self.mPathArray = {}
    -- self.mLunBoName = {}
    if #self.mPathArray > 0  then
        self.mPathArray = {}
    end
    -- if #self.mLunBoName > 0  then
    --     self.mLunBoName = {}
    -- end
    if #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 1 then
        for i=1,6 do
            for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
            -- for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
            --     table.insert(self.mLunBoName,v)    
            -- end    
        end
    elseif #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 2 then
        for i=1,3 do
            for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
            -- for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
            --     table.insert(self.mLunBoName,v)    
            -- end 
        end
    elseif #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 3 then   
        for i=1,2 do
            for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
            -- for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
            --     table.insert(self.mLunBoName,v)    
            -- end 
        end
    elseif #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 4 then
        for i=1,2 do
            for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
                if i == 2 and j == 2 then
                    break
                end
            end
            -- for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
            --     table.insert(self.mLunBoName,v)
            --     if i == 2 and j == 2 then
            --         break
            --     end
            -- end
        end      
    elseif #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 5 then
        for i=1,2 do
            for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
                if i == 2 and j == 1 then
                    break
                end
            end
            -- for j,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
            --     table.insert(self.mLunBoName,v)
            --     if i == 2 and j == 1 then
            --         break
            --     end
            -- end
        end         
    elseif #laixiaddz.LocalPlayercfg.LaixiaLunBoPath == 6 then
        for i,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoPath) do
            table.insert(self.mPathArray,v)
        end
        -- for i,v in ipairs(laixiaddz.LocalPlayercfg.LaixiaLunBoName) do
        --     table.insert(self.mLunBoName,v)
        -- end
    end
        -- -- table.insert(pathArray,"activity_redpacklv2_small.png")
        -- -- table.insert(pathArray,"activity_quanGuo_small.png")
        -- -- table.insert(pathArray,"activity_500yuan_small.png")
        -- -- table.insert(pathArray,"activity_tuiguang_small.png")
        -- -- table.insert(pathArray,"activity_selfBuilding_small.png")
        -- -- table.insert(pathArray,"activity_redpack_small.png")
        -- if laixia.config.isAudit then
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        --     table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        -- else
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
        --     table.insert(pathArray,"new_ui/lobbywindow/dajiangsai_guanggao.png")
           
        -- end
end

-- 精彩活动按钮回调函数 index 展示当前的第几个广告序号
function LobbyWindow:sendActivityPacket()
    --print(index)
    --if eventtype == ccui.TouchEventType.ended then

        local CSPackItems = Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
        CSPackItems:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
        CSPackItems:setValue("GameID", laixia.config.GameAppID)
        laixia.net.sendHttpPacketAndWaiting(CSPackItems)
        --原来是直接弹出活动的界面
        --ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_ACTIVITY_WINDOW)
    --end
end

-- 精彩活动按钮回调函数
function LobbyWindow:sendActivity(sender, eventtype)
    local CSPackItems = Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
    CSPackItems:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end


function LobbyWindow:sendToMyBagPacket()
    local CSPackItems = Packet.new("CSPackItems", _LAIXIA_PACKET_CS_PackItemsID)
    CSPackItems:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end


function LobbyWindow:updateWindow(msg)
    if self.mIsShow then
        self:sendHasLetterPacket()
        if laixia.kconfig.isYingKe == false then
             self:sendIsShouchong()
        end
        self:setTopInfo()
    end
end

function LobbyWindow:showFirstGift(msg)
    if self.mIsShow then
        if laixia.kconfig.isYingKe == true then
            self.Button_Lobby_ShouChong:setVisible(false)
        else
            if laixiaddz.LocalPlayercfg.isShouchong == true then
                self.Button_Lobby_ShouChong:setVisible(true)
                if laixia.config.isAudit == false then
                    self.chest:setVisible(true)
                    -- if self.invitationAn then
                        -- self.invitationAni:pos(self.Button_Lobby_ShouChong:getPositionX()-120,self.Button_Lobby_ShouChong:getPositionY())
                    -- end 
                    self.Button_Invitation:setPosition(cc.p(self.Button_Lobby_ShouChong:getPositionX()-120,self.Button_Lobby_ShouChong:getPositionY()))  
                end
            elseif laixiaddz.LocalPlayercfg.isShouchong == false then
                self.Button_Lobby_ShouChong:setVisible(false)
                if laixia.config.isAudit == false then
                    self.chest:setVisible(false)
                end
            end
        end
    end
end
--是否首充
function LobbyWindow:sendIsShouchong()
    local CSHasShouChong = Packet.new("CSFirstSuperBag", _LAIXIA_PACKET_CS_FirstSuperBagID)
    CSHasShouChong:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    CSHasShouChong:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSHasShouChong)
end
function LobbyWindow:updateRankWindow()
    --if self.mIsShow then
--        self:GetWidgetByName("Label_Ranking_NoNum"):setVisible(true)

        self.mSelfRank = 0
        self.AllRankdata = laixiaddz.LocalPlayercfg.LaixiaRankingData
        self.mSelfRank = laixiaddz.LocalPlayercfg.SelfRank 

   -- end
end
function LobbyWindow:sendHasLetterPacket()
    local CSHasMail = Packet.new("CSHasMail", _LAIXIA_PACKET_CS_HasMailID)
    CSHasMail:setValue("GameID", laixia.config.GameAppID)
    CSHasMail:setValue("Type", 3)
    laixia.net.sendPacket(CSHasMail)
end

function LobbyWindow:initUI()
    if not laixiaddz.LocalPlayercfg.LaixiaContinuousLoginData then
       self:sendSignInPacket()
       laixiaddz.LocalPlayercfg.LaixiaIsSign = 1
       cc.UserDefault:getInstance():setDoubleForKey("sign_time",os.time())
    else
        -- laixiaddz.LocalPlayercfg.LaixiaIsSign = 1
        local reSign_time = cc.UserDefault:getInstance():getDoubleForKey("sign_time")
        if tonumber(os.time()) - tonumber(reSign_time) >= 60*60 then
           self:sendActivity()
           cc.UserDefault:getInstance():setDoubleForKey("sign_time",os.time())
        elseif laixiaddz.LocalPlayercfg.isShouchong == true and laixia.kconfig.isYingKe == false then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FIRSTGIFT_WINDOW)
        end
    end
    print(laixiaddz.LocalPlayercfg.LaixiaIsDisplayGameNotice )
    if laixiaddz.LocalPlayercfg.LaixiaIsDisplayGameNotice then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REQUEST_BULLETINS_WINDOW)
        -- laixiaddz.LocalPlayercfg.LaixiaIsDisplayGameNotice = false
    end
    if laixia.kconfig.isYingKe==true then
        if device.platform == "ios" then

            local state ,value = luaoc.callStaticMethod("IKCRLXBridgeManager", "getCoin",{callback = updateUserCoin_IOS}, "(I)V");
        elseif device.platform == "android" then
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "getUserCoin"
            local javaParams = { }
            local javaMethodSig = "()V"        
            local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            -- laixiaddz.LocalPlayercfg.ZhiShiBiNum = value
            -- self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixiaddz.LocalPlayercfg.ZhiShiBiNum)
        end
    end
end
--充值回调
function rechargeCallBack(data)
    print("rechargeCallBack=-------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixiaddz.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
    self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixiaddz.LocalPlayercfg.ZhiShiBiNum)
end

function updateUserCoin(data)
    print("LobbyWindow")
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixiaddz.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)

end
function updateUserCoin_IOS(status, coinNum)
    print("LobbyWindow---test")
    if status == 0 then
        laixiaddz.LocalPlayercfg.ZhiShiBiNum = tonumber(coinNum)
    end
end
--function LobbyWindow:addGameAnimation(animationType)
--   local mbttonAnimation
--   local mBtton = animationType.Button
--   local mAniType= animationType.Name 

--   local progress = self:GetWidgetByName("Image_DownloadProgress",mBtton)
--   if progress ~= nil  and progress:isVisible() then   --防止有进度条的时候播放动画
--       return
--   end

--   if mAniType == "DDZ" then
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_LANDLORD)
--   elseif mAniType == "MATCH"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_MATCH)
--   elseif mAniType == "TEXAS"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_TEXAS)
--   elseif mAniType == "THREECARD"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_THREECARD)
--   elseif mAniType == "FIGHT"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_FIGHT)
--   elseif mAniType == "2VS1"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_2VS1)
--   elseif mAniType == "SELFBUILDING"  then 
--        mbttonAnimation= EffectAni:createAni(EffectDict._ID_DICT_TYPE_LOBBY_SELDBUILDING)     --
--   elseif mAniType == "DOUNIUNIU" then
--   --播放斗牛牛动画
--   elseif mAniType == "MAJIANG" then
--   --播放麻将动画 
--   end


--   mbttonAnimation:addTo(mBtton ,4)
--   mbttonAnimation:setPosition(cc.p(-28,-5))

--   if mAniType ~= "2VS1" then
--       local iconBG = self:GetWidgetByName("Image_Button_BG",mBtton)
--       local icon  =  self:GetWidgetByName("Image_Button_icon",mBtton)    --

--       local funAction = cc.CallFunc:create(function()
--              iconBG:setVisible(false)
--              icon:setVisible(false)
--       end)
--       local funAction2 = cc.CallFunc:create(function()
--              iconBG:setVisible(true)
--              icon:setVisible(true)
--              mbttonAnimation:removeFromParent()
--       end)
--          iconBG:runAction(
--           cc.Sequence:create(
--               funAction ,
--               cc.DelayTime:create(2.5),
--               funAction2
--           ))
--   end

--end



local m_time = 0
local m_timeNum = 0
local m_activityTime = 0
local m_activity = 0 
local m_tipTime = 0
local m_lunboTime = 0
function LobbyWindow:onTick(dt)
    
    if self.mIsShow then
        m_time = m_time+ dt
        m_tipTime = m_tipTime + dt
        
        if mBeganDown and m_time >0.5  then
            self:getDownProgerss()
            print(m_time)
            m_time = 0       
        end
        m_lunboTime = m_lunboTime + 1
        if m_lunboTime == 120 then
            self:addPathArray()
            self:updatePageView()
        end
    
        -- if self.LunBoflag == true then
        --     self:addPathArray()
        --     self:updatePageView()
        --     self.LunBoflag = false
        -- end                         
        
       -- if laixia.kconfig.isYingKe == true then
       --      self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixiaddz.LocalPlayercfg.ZhiShiBiNum)
       --      m_timeNum = m_timeNum+ dt
       --      if m_timeNum > 2 then
       --          self.Button_tuichuyouxi:setTouchEnabled(true)
       --          m_timeNum = 0       
       --      end
       --  end

        DownloaderHead:tick()
        DownloadActivity:tick()

        if laixiaddz.LocalPlayercfg.isShouchong == false or laixia.kconfig.isYingKe == true then
            self.Button_Lobby_ShouChong:setVisible(false)
            if laixia.config.isAudit == false and laixia.kconfig.isYingKe == false then
                self.chest:setVisible(false)
            end
        end
         --排行榜
        if m_time < 0.3  then
            return 
        end
        --如果有任务红包 显示tips ---@fuya
        if m_tipTime >= 1800 then
            if self:isHasTaskRedPack() then
                self:showBagTips()
            end 
            m_tipTime = 0    
        end
        if laixiaddz.LocalPlayercfg.LaixiaPlayerGold ~=nil and laixiaddz.LocalPlayercfg.LaixiaPlayerGold> 0 then
            --            self:setTopInfo()
            self:GetWidgetByName("AtlasLabel_Lable_Gold_Number",self.top):setString(laixiaddz.helper.numeralRules_2(laixiaddz.LocalPlayercfg.LaixiaPlayerGold))
            self:GetWidgetByName("Text_jinbi_xinban", self.Panel_YingKe):setString(laixiaddz.helper.numeralRules_2(laixiaddz.LocalPlayercfg.LaixiaPlayerGold))
        end
        if laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon ~= nil and laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon>=0 then
            self:GetWidgetByName("AtlasLabel_Lable_JiangQuan_Number",self.top):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon)
            self:GetWidgetByName("Text_laidou_xinban", self.Panel_YingKe):setString(laixiaddz.LocalPlayercfg.LaixiaPlayerGiftCoupon)
        end
        self:GetWidgetByName("nickName",self.top):setString(laixiaddz.helper.StringRules_6(laixiaddz.LocalPlayercfg.LaixiaPlayerNickname))
       if laixiaddz.LocalPlayercfg.LaixiaPhoneNum~="" then
           self:GetWidgetByName("Button_shoujibangding",self.top):setVisible(false)
           self.phone:setVisible(false)
       end

            m_activityTime = m_activityTime + dt
           if m_activityTime > 3 then

               local num  = #self.mPathArray
               m_activity = (m_activity )%num + 1
                self.AdvertisementPageView:scrollToPage(2)
               m_activityTime = 0
           end 
    end
end

function LobbyWindow:addRankCell(begin, over)
    for i = begin, over do
        local rankdate = self.AllRankdata[i]
        local rankCell = self.mRankCell:clone()
        rankCell:setVisible(true)

        rankCell.player = rankdate
        -- if rankdate.UserID  ==laixiaddz.LocalPlayercfg.LaixiaPlayerID then
        --     self:GetWidgetByName("Image_Item_HL", rankCell):setVisible(true)
        -- else
             self:GetWidgetByName("Image_Item_HL", rankCell):setVisible(false)
        -- end

        rankCell:setTouchEnabled(true)
        -- rankCell:addTouchEventListener(
        --     function(sender, eventType)
        --         self:onShowPersonal(sender, eventType)
        --     end
        -- )
        self.mRankinglisview:pushBackCustomItem(rankCell)
        self:GetWidgetByName("Label_Item_Name", rankCell):setString(rankdate["NickName"])
        if self.rankTypeIndex == 1 then
            self:GetWidgetByName("Label_Money_Num", rankCell):setString(rankdate["Coin"])
        else
            self:GetWidgetByName("Label_Money_Num",rankCell):setString(rankdate["Coin"].."次锦标赛")
        end
        --self:GetWidgetByName("Label_Item_Describe", rankCell):setString( rankdate["Signature"])

        local PlayerHead=self:GetWidgetByName("Image_Item_Photo", rankCell)
        self:addHead(PlayerHead ,rankdate["UserID"] ,rankdate["Sex"] ,rankdate["imgPath"] )

        local rank_ico = self:GetWidgetByName("Image_Item_Num", rankCell)  
        rank_ico:setVisible(false)

        local AtlasLabelRank = self:GetWidgetByName("BitmapLabel_Num", rankCell)

        -- if i <= 3 then
        --     local path = "rank_num_" .. i .. ".png"
        --     rank_ico:loadTexture("new_ui/lobbywindow/"..path)  
        --     rank_ico:setVisible(true)
        --     AtlasLabelRank:setVisible(false)
        -- else
        --     rank_ico:setVisible(false)
        --     AtlasLabelRank:setVisible(true)
        --     AtlasLabelRank:setString(i)
        -- end
        AtlasLabelRank:setString(i)
        if i == 1 then
            AtlasLabelRank:setColor(cc.c4b(255,186,0,255))
            AtlasLabelRank:enableOutline(cc.c4b(255,255,255,255), 2);
        elseif i == 2 then
            AtlasLabelRank:setColor(cc.c4b(108,139,154,255))
            AtlasLabelRank:enableOutline(cc.c4b(255,255,255,255), 2);
        elseif i == 3 then
            AtlasLabelRank:setColor(cc.c4b(208,106,15,255))
            AtlasLabelRank:enableOutline(cc.c4b(255,255,255,255), 2);
        else
            AtlasLabelRank:enableOutline(cc.c4b(255,255,255,255), 2);
        end
    end
end

function LobbyWindow:onDestroy()
    self.mButtonArray = {}
    self.mIsShow = false
end



function LobbyWindow:isShowBagRed()
--    if self.mIsShow then
--        if laixiaddz.LocalPlayercfg.LaixiaPropsData then
--            local itemDBM = laixiaddz.JsonTxtData:queryTable("items");
--            for i, v in ipairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
--                local ItemInfo = itemDBM:query("ItemID",v.ItemID)
--                if ItemInfo and ItemInfo.ItemType == 7 then
--                    if ItemInfo.GetLimit == 1 and ItemInfo.LimitNumber<=laixiaddz.LocalPlayercfg.LaixiaPlayerLevel then
--                            self:showButtonRed(self.btBackpack)
--                            -- self:showButtonRed(self.btMore)
--                        return
--                    end
--                end
--            end
--        end
--        self:hideButtonRed(self.btBackpack)
--        -- self:hideButtonRed(self.btMore)
--    end
end


function LobbyWindow:onHeadDoSuccess(msg)
    local data = msg.data

    -- 
    laixiaddz.LocalPlayercfg.LaixiaPlayerHeadPicture = nil
    --self:updateHead()
    --self:addHead()
    self:setTopInfo()
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv")
    local data = msg.data    
    local mHeadInUse = data.savePath
    -- local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. "head_image/" .. data.playerID..".png";
    local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. data.playerID..".png";
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconPath)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        -- local sprite = cc.Sprite:create(mHeadInUse) 
        -- sprite:setScaleX(image_rank_di:getContentSize().width/sprite:getContentSize().width)
        -- sprite:setScaleY(image_rank_di:getContentSize().height/sprite:getContentSize().height)
        -- sprite:setPosition(image_rank_di:getContentSize().width/2,image_rank_di:getContentSize().height/2)
        -- image_rank_di:addChild(sprite)
        self:addHeadIcon(self.Image_HeadBg,mHeadInUse)
        -- laixiaddz.LocalPlayercfg.LaixiaPlayerHeadUse = data.savePath
    end  

end

--排行榜 begin
function LobbyWindow:sendRankListPacket(msg)
    local rankType = 0 
    if msg.data and msg.data.rankType then 
        rankType = msg.data.rankType
    end 
    local stream = Packet.new("CSRank", _LAIXIA_PACKET_CS_RankID)
    stream:setValue("Code", laixiaddz.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    stream:setValue("RankType", rankType)
    laixia.net.sendHttpPacketAndWaiting(stream, nil, 1)
end 

-- function LobbyWindow:headDownloadSuccess(msg)
--     local data = msg.data    
--     local mHeadInUse = data.savePath
--     local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. mHeadInUse
--     local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
--     print(data.playerID)
--     local image_rank_di = self.rankIcon[tostring(data.playerID)]
--     if(fileExist) and image_rank_di~=nil then
--         image_rank_di:loadTexture(localIconPath)
--     end       
-- end

-- function LobbyWindow:addHead(image,userid,gender,iconPath)
--     -- 默认头像图片路径
--     self.rankIcon[tostring(userid)] = image
--     local path = "images/ic_morenhead"..tostring(tonumber(userid)%10)..".png"
--     local sprite 
--     if iconPath ~= nil and iconPath ~= "" then
--         local localIconName = cc.FileUtils:getInstance():getWritablePath()..userid..".png"--DownloaderHead:SplitLastStr(iconPath, "/")
--         local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
--         if (fileExist) then
--             path = cc.FileUtils:getInstance():getWritablePath()..userid..".png"
-- --            image:loadTexture(localIconPath)
--             sprite = cc.Sprite:create(path)
--         else
-- --            image:loadTexture(path)
--             sprite = cc.Sprite:create(path)
            
--             local netIconUrl = iconPath
--             DownloaderHead:pushTask(userid, netIconUrl,3)
--         end
--     else
--         sprite = cc.Sprite:create(path)
-- --        image:loadTexture(path)
--     end
    
--     local templet = soundConfig.IMG_HEAD_TEMPLET_RECT
--     laixia.UItools.addHead(image, path, templet)

--     -- sprite:setScale(image:getContentSize().width/sprite:getContentSize().width)
--     -- sprite:setPosition(image:getContentSize().width/2,image:getContentSize().height/2)
--     -- image:addChild(sprite)
-- end

--金币榜
function LobbyWindow:onShowGoldRank(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:updateBtnStatu(1)
        self.rankIcon = {}
        self.mRankinglisview:removeAllItems()
        self.AllRankdata = nil
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 0})
--        self:updateSelfRank()
        self.mIndex = 0
        self.rankTypeIndex = 1
    end
end
--冠军榜
function LobbyWindow:onRichRank(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self.rankIcon = {}
        self:updateBtnStatu(2)
        self.mRankinglisview:removeAllItems()
        self.AllRankdata = nil
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 1})
        self.mIndex = 0
        self.rankTypeIndex = 2
    end
end
function LobbyWindow:updateBtnStatu(status)
    if status == 1 then 
        self.mButton_Cfb:setVisible(false)
        self.mButton_Thb:setVisible(true)
        self.mImageCfb:setVisible(true)
        self.mImageThb:setVisible(false)
    elseif status ==2 then 
        self.mButton_Cfb:setVisible(true)
        self.mButton_Thb:setVisible(false)
        self.mImageCfb:setVisible(false)
        self.mImageThb:setVisible(true)
    end
end
--判断是否有任务红包
function LobbyWindow:isHasTaskRedPack()
    if laixiaddz.LocalPlayercfg.LaixiaPropsData~=nil then
        for key,value in pairs(laixiaddz.LocalPlayercfg.LaixiaPropsData) do
            if tostring(value.ItemID) == "13002" then --这里以后要改为判断任务红包类型
                return true
            end
        end
    end
    return false
end
--排行榜 end
function LobbyWindow:goZhishiShop(sender, eventType)
    -- if eventtype == ccui.TouchEventType.ended then
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
    -- end
end
return LobbyWindow.new()


