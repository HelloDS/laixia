--[[
********************************************************
    @date:       2018-3-14
    @author:     zl
    @version:    1.0
    @describe:   来下-公共-主大厅
********************************************************
]]

--local laixia = laixia
--local Env = APP_ENV
--local soundConfig =  laixia.soundcfg
--local EffectDict =  laixia.EffectDict
--local DownloaderHead = import("..DownloaderHead")
--local WebView = import(".WebView")
--local userDefault = Env.userDefault
----下载标记
--local mBeganDown = false

--local CSBBase = require("app.laixia.lobby.ui.CSBBase")
local MainLayer = class("MainLayer", import("..base.BaseLayer"))
MainLayer.CSB_NAME = "lobby/LobbyMainLayer.csb"
MainLayer.CSB_CHILD = 
{
    panel_root                                                      = {varname = "panel_root"},
    ["panel_root.panel_center.panel_center_middle"]                 = {varname = "panel_center_middle"},
    ["panel_root.panel_right.panel_right_middle.panel_gamelist"]    = {varname = "panel_gamelist"},
}

--[[
    构造函数
]]
function MainLayer:ctor(...)
    MainLayer.super.ctor(self)
    app.m_mainLayer = self
    
--    self.hDialogType = DialogTypeDef.DEFINE_SINGLE_DIALOG
--    self.mIsShow = false
--    self.mButtonArray = {}
--    self.mTime = 0
--    self.mWhisShow = false
end

--[[
    初始化
]]
function MainLayer:init()
    self:show()
end

function MainLayer:addEventDispatch()
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_MAININTERFACE_WINDOW, handler(self, self.show))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_MAININTERFACE_WINDOW,handler(self,self.updateWindow))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_HALL_WINDOW, handler(self, self.sendHallPacket))
    --显示背包红点
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_BAGRED_WINDOW, handler(self, self.showStationManageReda))
    --隐藏背包红点
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDES_BAGRED_WINDOW, handler(self, self.hideStationManageReda))
    --发送礼品盒请求
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_TOOLBOX_WINDOW, handler(self, self.sendToMyBagPacket))
    --下载头像完成
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_DOWNLOADLOBBY_PICTURE_WINDOW, handler(self, self.onHeadDoSuccess))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_UPDATE_PICTURE_WINDOW, handler(self, self.addHead))
    --显示站内信红点
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_LETTERRED_WINDOW, handler(self, self.showStationManageRed))
    --隐藏站内信红点
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_HIDES_LETTERRED_WINDOW, handler(self, self.hideStationManageRed))
    --发送商城请求
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SEND_SHOPWINDOW, handler(self, self.sendShopPacket))
    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_RETURN_FIRSTGIFT_WINDOW ,handler(self,self.showFirstGift))
end

--[[
    发送大厅数据包
]]
--function MainLayer:sendHallPacket()
--    self:show()
--    local stream = Packet.new("CSHallLobbyy", _LAIXIA_PACKET_CS_HallLobbyID)
--    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
--    stream:setValue("GameID", laixia.config.GameAppID)
--    laixia.net.sendHttpPacketAndWaiting(stream)
--end

function MainLayer:onTabButtonClicked(sender, event)
    if sender == nil or not sender:isVisible() then
        return
    end

    _G.onTouchButton(event, sender)

    local senderName = sender:getName()
    if event ~= ccui.TouchEventType.ended then 
        return 
    end
    if senderName == "panel_exit" then
        app.m_gameManager:exitGame()
    end
end

--[[
    转盘点击事件
]]
function MainLayer:onGoTurnTable(sender, eventtype) 
    local stream = Packet.new("CSTurnTableEnter", _LAIXIA_PACKET_CS_TurnTableEnterID)
    stream:setValue("HttpCode", laixia.LocalPlayercfg.LaixiaHttpCode) 
    laixia.net.sendHttpPacketAndWaiting(stream)
end

--[[
    fix me 适配函数 回来拉出去
]]
function MainLayer:setAdaptation()
    --修1
    local visiblesize = cc.Director:getInstance():getVisibleSize() -- winSize在手机屏幕中实际显示的部分的分辨率
    local origin = cc.Director:getInstance():getVisibleOrigin() -- 从画布的某个点显示
    local winsize = cc.Director:getInstance():getWinSize() -- 这几分辨率
    local framesize = cc.Director:getInstance():getOpenGLView():getFrameSize() -- 设备分辨率
    --大厅需要设置自适应的所有设置
    self.BGIMG = self:GetWidgetByName("BGIMG")
    self.BGIMG:setPosition(cc.p(display.cx,display.cy))
    self.top = self:GetWidgetByName("LobbyTop")
    self.top:setPosition(cc.p(0,display.top))
    self.bottom = self:GetWidgetByName("LobbyBottom")
    self.bottom:setPosition(cc.p(display.cx,display.bottom))
    -- 三个房间进行适配
    self.mainPanel = self:GetWidgetByName("mainPanel")
    self.mainPanel:setPositionY(display.cy-self.mainPanel:getContentSize().height/2)
    -- 轮播图进行适配
    self.LobbyLeft = self:GetWidgetByName("LobbyLeft")
    self.LobbyLeft:setPositionY(display.cy-self.LobbyLeft:getContentSize().height/2-20)
end

--[[
    首冲点击事件
]]
function MainLayer:onShouchong(sender, event)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FIRSTGIFT_WINDOW)
end

--[[
    显示大厅主UI
]]
function MainLayer:onShow()
    laixia.soundTools.playMusic(soundConfig.SCENE_MUSIC.lobby,true)
    if self.mIsShow == false then
        self:setAdaptation()
        self.mDownLoadApkProgressBG = nil 
        self.mDownLoadApkProgressNum  = nil
        self.mDownLoadApkProgress = nil
        
        self.mPathArray = {}
        self:addPathArray(self.mPathArray)

        self.mButtonArray ={}
------------------------------------------------------------------------------------------------
    laixia.LocalPlayercfg.LaixiaPhoneNum=cc.UserDefault:getInstance():getStringForKey("phone_number")
    -- 首先载入
    self.LobbyTop = self:GetWidgetByName("LobbyTop")
    self.mainPanel = self:GetWidgetByName("mainPanel")
    self.Button_Lobby_Dayly = self:GetWidgetByName("Button_Lobby_Dayly")
    self.Button_Lobby_TurnTable = self:GetWidgetByName("Button_Lobby_TurnTable")
    self.Button_Lobby_ShouChong = self:GetWidgetByName("Button_Lobby_ShouChong")
    
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
            self.BGIMG:loadTexture("new_ui/MainLayer/beijing_zhishi.jpg")
            --芝士签到
            self.Button_Lobby_ShouChong:setVisible(false)
            self:GetWidgetByName("Button_Lobby_Dayly"):loadTextureNormal("new_ui/MainLayer/qiandao_zhishi.png")
            self:GetWidgetByName("Button_Lobby_Dayly"):loadTexturePressed("new_ui/MainLayer/qiandao_zhishi.png")
            self:GetWidgetByName("Button_Lobby_Dayly"):setPositionX(self.Button_Lobby_Dayly:getPositionX()-20)
            --芝士转盘
            self:GetWidgetByName("Button_Lobby_TurnTable"):loadTextureNormal("new_ui/MainLayer/zhuanpan_zhishi.png")
            self:GetWidgetByName("Button_Lobby_TurnTable"):loadTexturePressed("new_ui/MainLayer/zhuanpan_zhishi.png")
            self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_TurnTable"),handler(self, self.onGoTurnTable))
            local mShop = self:GetWidgetByName("Button_Shop",self.bottom)
            mShop:loadTextureNormal("new_ui/MainLayer/shangdian.png")
            mShop:loadTexturePressed("new_ui/MainLayer/shangdian.png")
            self:addButAnimationEventListener(mShop,handler(self, self.goShop))

            self:GetWidgetByName("Image_51",self.top):loadTexture("new_ui/PersonalCenterWindow/jinbi_xinban.png")
            self:GetWidgetByName("Image_51_Copy",self.top):loadTexture("new_ui/common/new_common/laidou.png")

            self.Button_ZhiShiBi = self:GetWidgetByName("Button_39_Copy")
            self:addButAnimationEventListener(self.Button_ZhiShiBi,handler(self, self.goZhishiShop)) -- 跳转到哪里（待定）
            
            local system3 = laixia.ani.CocosAnimManager
            self.chest = system3:playAnimationAt(self.LobbyTop,"doudizhu_icon_chest")
            self.chest:setVisible(false)
        elseif laixia.kconfig.isYingKe == false then
            --登录奖励
            self:GetWidgetByName("Button_Lobby_Dayly"):setOpacity(0)
            local system1 = laixia.ani.CocosAnimManager
            self.sign = system1:playAnimationAt(self.LobbyTop,"doudizhu_icon_sign")
            self.sign:pos(self.Button_Lobby_Dayly:getPositionX()-3-5,self.Button_Lobby_Dayly:getPositionY()-2)

            --幸运转盘
            self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_TurnTable"),handler(self, self.onGoTurnTable))
            self:GetWidgetByName("Button_Lobby_TurnTable"):setOpacity(0)
            local system2 = laixia.ani.CocosAnimManager
            self.turntable = system2:playAnimationAt(self.LobbyTop,"doudizhu_icon_turntable")
            self.turntable:pos(self.Button_Lobby_TurnTable:getPositionX(),self.Button_Lobby_TurnTable:getPositionY())
            --首充
            self:GetWidgetByName("Button_Lobby_ShouChong"):setOpacity(0)
            local system3 = laixia.ani.CocosAnimManager
            self.chest = system3:playAnimationAt(self.LobbyTop,"doudizhu_icon_chest")
            self.chest:setVisible(true)
            self.chest:pos(self.Button_Lobby_ShouChong:getPositionX()-10,self.Button_Lobby_ShouChong:getPositionY())
            if laixia.LocalPlayercfg.isShouchong == true then
                --self:GetWidgetByName("Button_Lobby_ShouChong"):setVisible(true)
                self.Button_Lobby_ShouChong:setVisible(true)
                self.chest:setVisible(true)
            elseif laixia.LocalPlayercfg.isShouchong == false then
                --self:GetWidgetByName("Button_Lobby_ShouChong"):setVisible(false)
                self.Button_Lobby_ShouChong:setVisible(false)
                self.chest:setVisible(false)
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


        self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_Dayly"),handler(self, self.onShowDayley))
        self:addButAnimationEventListener(self:GetWidgetByName("Button_Lobby_ShouChong"),handler(self, self.onShouchong))
        self.Button_bisaichang = self:GetWidgetByName("Button_bisaichang",self.mainPanel)
        self.Button_bisaichang:setPositionX(self.Button_bisaichang:getPositionX()+180)
        self:addButAnimationEventListener(self.Button_bisaichang,handler(self,self.gotoBisaichang))
        

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

            local system = laixia.ani.CocosAnimManager
            self.shoppingAni = system:playAnimationAt(self.bottom,"doudizhu_shopping")
            self.shoppingAni:setLocalZOrder(5)
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
       
        laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_SHOW_MAININTERFACE_WINDOW
        self.mIsShow = true
        self.mTime  = 5

        self.top = self:GetWidgetByName("LobbyTop")
        self.Button_shoujibangding = self:GetWidgetByName("Button_shoujibangding",self.top)
        local system4 = laixia.ani.CocosAnimManager
        self.phone = system4:playAnimationAt(self.top,"doudizhu_phone")
        self.phone:pos(self.Button_shoujibangding:getPositionX(),self.Button_shoujibangding:getPositionY()+7)
        -- self.phone:pos(self.Button_shoujibangding:getContentSize().width/2,self.Button_shoujibangding:getContentSize().height/2+7)
        self:addButAnimationEventListener(self:GetWidgetByName("Button_shoujibangding",self.top),handler(self, self.shoujibangding))

        self:sendWeekOrMonthCard()
    end
        self:addHead() 
        self:initUI()
        self:setTopInfo()
end


--[[
    获得月卡的金币 
]]
function MainLayer:sendWeekOrMonthCard()
    local CSWeekOrMonthCard = Packet.new("CSWeekOrMonthCard", _LAIXIA_PACKET_CS_WeekOrMonthCardID)
    CSWeekOrMonthCard:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSWeekOrMonthCard:setValue("AppID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSWeekOrMonthCard) 
end

--[[
    打开游戏场
]]
function MainLayer:gotoYouxichang(sender, eventtype)
    --gameInfo应配置json文件读取
    local gameInfo = {folderName = "ddz"}
    if gameInfo and gameInfo.folderName then
        local requirePath = "games." .. gameInfo.folderName .. ".GameEntry"
        local filePath = "games/" .. gameInfo.folderName .. "/GameEntry.lua"
        local test = cc.FileUtils:getInstance():getSearchPaths()
        if cc.FileUtils:getInstance():isFileExist(filePath) then
            package.preload[requirePath] = nil
            package.loaded[requirePath] = nil
            local game = require(requirePath).new()
            app.m_gameManager:runGame(game)
        end
    end
end

--[[
    发送版本号
]]
function MainLayer:sendCurVersion(version)
    local stream = Packet.new("CSGetVersion", _LAIXIA_PACKET_CS_GETVERSION)
    stream:setValue("Code", 0)
    stream:setValue("GameID", 1)
    stream:setValue("GameVersion",version)
    laixia.net.sendHttpPacketAndWaiting(stream,nil,2) 
end

--[[
    问号点击事件
]]
function MainLayer:goWenhao()
    if laixia.config.isAudit then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换金币!")
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DUIHUAN_SHOW_WINDOW, "可用于兑换奖励,可在比赛、游戏场中获得!")
    end
end

--[[
    任务点击事件
]]
function MainLayer:onRenwu(sender,evenType)
   ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MARKEDWORDS_WINDOW, "敬请期待")    
end

--[[
    轮播图
]]
local pageIdx = 1
function MainLayer:addPage(pIdx, iIdx, bClone)
 
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
            laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
            print("22222")
        elseif eventtype == ccui.TouchEventType.moved then
        elseif eventtype == ccui.TouchEventType.canceled then

        elseif eventtype == ccui.TouchEventType.ended then    
            --监听的函数
                laixia.LocalPlayercfg.AdvermentIndex = tonumber(sender:getParent():getTag())
                if sender.callFun ~= nil then
                    sender.callFun()
                end
        end

    end)
    self.AdvertisementPageView:insertPage(newPage, iIdx)
end
--
function MainLayer:updatePageView()
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

function MainLayer:onPageViewEvent(sender, eventType)
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

--[[
    手机绑定
]]
function MainLayer:shoujibangding()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_BINDPHONE_WINDOW)
end

--[[
    设置大厅头部显示用户信息
]]
function MainLayer:setTopInfo()
    if laixia.LocalPlayercfg.LaixiaCurrentWindow ==  "MainLayer" then
        self:GetWidgetByName("AtlasLabel_Lable_Gold_Number",self.top):setString(laixia.LocalPlayercfg.LaixiaPlayerGold)
        self:GetWidgetByName("AtlasLabel_Lable_JiangQuan_Number",self.top):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)
        self:GetWidgetByName("nickName",self.top):setString(laixia.helper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname)) 
        self:GetWidgetByName("Button_shoujibangding",self.top):setOpacity(0)
        if laixia.LocalPlayercfg.LaixiaPhoneNum~="" then
            self.phone:setVisible(false)
        end
        if laixia.kconfig.isYingKe == true then
            self:GetWidgetByName("Panel_22"):setVisible(true)
            self:GetWidgetByName("Panel_23"):setVisible(false)
            self.Panel_YingKe = self:GetWidgetByName("Panel_22")
            self:GetWidgetByName("Text_jinbi_xinban", self.Panel_YingKe):setString(laixia.helper.numeralRules_2(laixia.LocalPlayercfg.LaixiaPlayerGold))
            self:GetWidgetByName("Text_laidou_xinban", self.Panel_YingKe):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)
            self:GetWidgetByName("nickName_Copy", self.Panel_YingKe):setString(laixia.helper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname)) 
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
            self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
        end
    end
end

--[[
    芝士版本退出
]]
function MainLayer:TuiChu_Exit()
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "exitGame"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    else
        os.exit()
    end
end

--[[
    获取签到数据
]]
function MainLayer:sendSignInPacket()
    local stream = Packet.new("CSSignLanding", _LAIXIA_PACKET_CS_SignLandingID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream)
end

--[[
    背包红点显示和隐藏
]]
function MainLayer:hideStationManageReda()
    self:hideButtonRed(self.btBackpack)
end

function MainLayer:showStationManageReda(button)
    self:showButtonRed(self.btBackpack)
end 

--[[
    任务红包提示
]]
function MainLayer:showBagTips()
    if self.mIsLoad and laixia.kconfig.isYingKe == false then
        self.Image_tips:setVisible(true)
    end   
end

function MainLayer:hideBagTips()
    if self.mIsLoad then
        self.Image_tips:setVisible(false)
    end   
end

--[[
    站内信红点显示和隐藏
]]
function MainLayer:hideStationManageRed()
    self:hideButtonRed(self.btEail)
end

function MainLayer:showStationManageRed(button)
    self:showButtonRed(self.btEail)
end 

function MainLayer:hideButtonRed(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(false)
    end    
end 

function MainLayer:showButtonRed(button)
    if self.mIsLoad then
        self:GetWidgetByName("Image_RedPiint",button):setVisible(true)
    end   
end 

--[[
    增加头像
]]
function MainLayer:addHead()
    -- 默认头像图片路径
    self.rankIcon = {}
    local headIcon_new = laixia.LocalPlayercfg.LaixiaPlayerHeadUse; --微信头像要用的

    print("===========================wangtianye===============")
    print(headIcon_new)
    if laixia.kconfig.isYingKe == true then
        self.Image_HeadBg = self:GetWidgetByName("Image_HeadBg_zhishi")
    else
        self.Image_HeadBg = self:GetWidgetByName("Image_HeadBg")
    end
    
    self.rankIcon[tostring(laixia.LocalPlayercfg.LaixiaPlayerID)] = self.Image_HeadBg
    local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"

    print("wangtianye")
    print(cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png")
    print("--------------------------")
    print(headIcon_new)

    if headIcon_new ~= nil and headIcon_new ~= "" then
        -- local localIconName = DownloaderHead:SplitLastStr(iconPath, "/")
        local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID..".png"
        local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
        if (fileExist) then
            local localIconPath = localIconName
            self:addHeadIcon(self.Image_HeadBg,localIconPath)
        else
            self:addHeadIcon(self.Image_HeadBg,path)
            local netIconUrl = headIcon_new
            DownloaderHead:pushTask(laixia.LocalPlayercfg.LaixiaPlayerID, netIconUrl,2)
        end
    else
        self:addHeadIcon(self.Image_HeadBg,path)
    end
end        

function MainLayer:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
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
--[[
    发送个人信息
]]
function MainLayer:sendPersonalCenterPacket(sender, eventtype)
    local stream = Packet.new("PersonalCenter", _LAIXIA_PACKET_CS_PersonalCenterID)
    stream:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    stream:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(stream, nil, 1);
end

--[[
    发送排行榜
]]
function MainLayer:sendRankingPacket(sender, eventtype)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_RANK_WINDOW)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REQUEST_RANKLIST_WINDOW,{rankType = 0})
end

--[[
    发送商城
]]
function MainLayer:sendShopPacket()
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType = 1}) 
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW) 
end

function MainLayer:goShop(sender, eventtype)
    self:sendShopPacket()
end

--[[
    邮件
]]
function MainLayer:sendStatinMessagePacket(sender, eventtype)
    if laixia.LocalPlayercfg.LaixiaIsHaveEmil ~= 0 then
        local CSSmsList = Packet.new("CSSmsList", _LAIXIA_PACKET_CS_SmsListID)
        CSSmsList:setValue("GameID", laixia.config.GameAppID)
        CSSmsList:setValue("Type", laixia.LocalPlayercfg.LaixiaIsHaveEmil)
        laixia.net.sendPacket(CSSmsList)
        laixia.LocalPlayercfg.LaixiaIsHaveEmil = 0
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MAIL_WINDOW)
    elseif laixia.LocalPlayercfg.LaixiaIsHaveEmil == 0 then
            
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MAIL_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAIL_WINDOW)
    end
end

--[[
    设置-关于
]]
function MainLayer:GameAbout(sender, eventtype)
    laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_GAMEDESCRIBE_WINDOW)
end

--[[
    设置
]]
function MainLayer:GameSets(sender, eventtype)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SETUP_WINDOW,2) 
end

--[[
    背包
]]
function MainLayer:onMyBag(sender, eventtype)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_TOOLSBOX_WINDOW);
    self:sendToMyBagPacket()
    self.Image_tips:setVisible(false)
    --更新任务列表
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SEND_GETTASKLIST)
end

--显示自建房间
function MainLayer:onSelfBuilding(sender, eventtype)
    laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_PACKET_CREATESELFBUILF
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_PACKET_CREATESELFBUILF)
end

--显示每日登陆的奖励
function MainLayer:onShowDayley(sender, eventtype)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_DAILYSIGN_WINDOW)
end

--轮播图默认图片配置
function MainLayer:addPathArray(pathArray)
    if #pathArray > 0  then
        pathArray = {}
    end
    if laixia.config.isAudit then
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
        table.insert(pathArray,"new_ui/isAudit/rechargefuli_guanggao.png")
    else
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
        table.insert(pathArray,"new_ui/MainLayer/dajiangsai_guanggao.png")
    end
end

-- 精彩活动按钮回调函数 index 展示当前的第几个广告序号
function MainLayer:sendActivityPacket()
    local CSPackItems = Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
    CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end

-- 精彩活动按钮回调函数
function MainLayer:sendActivity(sender, eventtype)
    local CSPackItems = Packet.new("CSActivity",_LAIXIA_PACKET_CS_ActivityID)
    CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end

--获取背包数据
function MainLayer:sendToMyBagPacket()
    local CSPackItems = Packet.new("CSPackItems", _LAIXIA_PACKET_CS_PackItemsID)
    CSPackItems:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSPackItems:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacketAndWaiting(CSPackItems)
end

--刷新top
function MainLayer:updateWindow(msg)
    if self.mIsShow then
        self:sendHasLetterPacket()
        if laixia.kconfig.isYingKe == false then
             self:sendIsShouchong()
        end
        self:setTopInfo()
    end
end

--刷新首冲按钮
function MainLayer:showFirstGift(msg)
    if self.mIsShow then
        if laixia.kconfig.isYingKe == true then
            self.Button_Lobby_ShouChong:setVisible(false)
        else
            if laixia.LocalPlayercfg.isShouchong == true then
                self.Button_Lobby_ShouChong:setVisible(true)
                if laixia.config.isAudit == false then
                    self.chest:setVisible(true)
                end
            elseif laixia.LocalPlayercfg.isShouchong == false then
                self.Button_Lobby_ShouChong:setVisible(false)
                if laixia.config.isAudit == false then
                    self.chest:setVisible(false)
                end
            end
        end
    end
end

--发送是否首充
function MainLayer:sendIsShouchong()
    local CSHasShouChong = Packet.new("CSFirstSuperBag", _LAIXIA_PACKET_CS_FirstSuperBagID)
    CSHasShouChong:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    CSHasShouChong:setValue("GameID", laixia.config.GameAppID)
    laixia.net.sendHttpPacket(CSHasShouChong)
end

--获取排行榜数据
function MainLayer:updateRankWindow()
    self.mSelfRank = 0
    self.AllRankdata = laixia.LocalPlayercfg.LaixiaRankingData
    self.mSelfRank = laixia.LocalPlayercfg.SelfRank 
end

--发送站内信请求
function MainLayer:sendHasLetterPacket()
    local CSHasMail = Packet.new("CSHasMail", _LAIXIA_PACKET_CS_HasMailID)
    CSHasMail:setValue("GameID", laixia.config.GameAppID)
    CSHasMail:setValue("Type", 3)
    laixia.net.sendPacket(CSHasMail)
end

--初始化top控件
function MainLayer:initUI()
    if not laixia.LocalPlayercfg.LaixiaContinuousLoginData then
       self:sendSignInPacket()
       laixia.LocalPlayercfg.LaixiaIsSign = 1
       cc.UserDefault:getInstance():setDoubleForKey("sign_time",os.time())
    else
        local reSign_time = cc.UserDefault:getInstance():getDoubleForKey("sign_time")
        if tonumber(os.time()) - tonumber(reSign_time) >= 60*60 then
           self:sendActivity()
           cc.UserDefault:getInstance():setDoubleForKey("sign_time",os.time())
        elseif laixia.LocalPlayercfg.isShouchong == true and laixia.kconfig.isYingKe == false then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FIRSTGIFT_WINDOW)
        end
    end
    print(laixia.LocalPlayercfg.LaixiaIsDisplayGameNotice )
    if laixia.LocalPlayercfg.LaixiaIsDisplayGameNotice then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_REQUEST_BULLETINS_WINDOW)
    end
    if laixia.kconfig.isYingKe==true then
        if device.platform == "ios" then
        elseif device.platform == "android" then
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "getUserCoin"
            local javaParams = { }
            local javaMethodSig = "()V"        
            local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        end
    end
end

--充值回调
function rechargeCallBack(data)
    print("rechargeCallBack=-------------alexwang")
    print(data)
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)
    self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
end

--芝士金币刷新回调
function updateUserCoin(data)
    print("MainLayer")
    local json = json or require("framework.json");
    local info = json.decode(data);
    laixia.LocalPlayercfg.ZhiShiBiNum = tonumber(info.zscoin)

end

--
local m_time = 0
local m_timeNum = 0
local m_activityTime = 0
local m_activity = 0 
local m_tipTime = 0
function MainLayer:onTick(dt)
    if self.mIsShow then
        m_time = m_time+ dt
        m_tipTime = m_tipTime + dt
        if mBeganDown and m_time >0.5  then
            self:getDownProgerss()
            print(m_time)
            m_time = 0       
       end
       if laixia.kconfig.isYingKe == true then
            self:GetWidgetByName("Text_jinbi_xinban_Copy"):setString(laixia.LocalPlayercfg.ZhiShiBiNum)
            m_timeNum = m_timeNum+ dt
            if m_timeNum > 2 then
                self.Button_tuichuyouxi:setTouchEnabled(true)
                m_timeNum = 0       
            end
        end
        DownloaderHead:tick()
        if laixia.LocalPlayercfg.isShouchong == false or laixia.kconfig.isYingKe == true then
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
        if laixia.LocalPlayercfg.LaixiaPlayerGold ~=nil and laixia.LocalPlayercfg.LaixiaPlayerGold> 0 then
            self:GetWidgetByName("AtlasLabel_Lable_Gold_Number",self.top):setString(laixia.helper.numeralRules_2(laixia.LocalPlayercfg.LaixiaPlayerGold))
        end
        if laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon ~= nil and laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon>=0 then
             self:GetWidgetByName("AtlasLabel_Lable_JiangQuan_Number",self.top):setString(laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon)
        end
        self:GetWidgetByName("nickName",self.top):setString(laixia.helper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname))
       if laixia.LocalPlayercfg.LaixiaPhoneNum~="" then
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

function MainLayer:onDestroy()
    self.mButtonArray = {}
    self.mIsShow = false
end

--刷新头像回调
function MainLayer:onHeadDoSuccess(msg)
    local data = msg.data
    laixia.LocalPlayercfg.LaixiaPlayerHeadUse = data.savePath
    laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil
    self:setTopInfo()
    local mHeadInUse = data.savePath
    local fileExist = cc.FileUtils:getInstance():isFileExist(mHeadInUse)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        self:addHeadIcon(self.Image_HeadBg,mHeadInUse)
    end  
end

--判断是否有任务红包
function MainLayer:isHasTaskRedPack()
    if laixia.LocalPlayercfg.LaixiaPropsData~=nil then
        for key,value in pairs(laixia.LocalPlayercfg.LaixiaPropsData) do
            if tostring(value.ItemID) == "13002" then --这里以后要改为判断任务红包类型
                return true
            end
        end
    end
    return false
end

--排行榜 end
function MainLayer:goZhishiShop(sender, eventType)
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

return MainLayer.new()


