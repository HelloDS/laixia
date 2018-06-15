--[[
    大厅主场景界面
            此场景上将存放大厅所有的Layer
            大厅只有一个场景，有多个Layer
]]
require("common.LXConstant")      
require("common.LXEngine")
require("common.CommonInterFace")
ObjectEventDispatch = require("common.MonitorSystem") 
local DownloaderHead = require("common.DownloaderHead")
local laixiaHelper = require("common.tools.Helpers")
local IconListUtils = require("common.tools.IconListUtils")
local UItools = require("common.tools.UITools")

laixia.Packet = require("lobby.net.Packet")
laixia.net = require("lobby.net.LaixiaNet")

local MAX_NUM1 = 100000000; -- 1亿
local MAX_NUM2 = 10000;
if device.platform == "android" then
    luaj.callStaticMethod(APP_ACTIVITY, "registMessageCallback", {}, "()V") 
    luaj.callStaticMethod(APP_ACTIVITY, "registerConnectionCallback", {}, "()V") 
elseif device.platform == "ios" then
    --ios不用
end

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)
--关于wifi和电源的显示操作

local JAVAMETHODNAMEISE = "isElectricity" -- 返回是否正在充电
local JAVAPARAMSISE = {}
local JAVAMETHODSIGISE = "()Z"
local JAVAMETHODNAMEE = "onElectricity"  -- 返回当前的电量百分比 float
local JAVAPARAMSE = {}
local JAVAMETHODSIGE = "()F"
local JAVAMETHODNAMEN = "onWiFiIntensity" -- 返回当前wifi强度的类型 
local JAVAPARAMSN = {}
local JAVAMETHODSIGN = "()I"

local APP_PACKAGE_NAME = "com/laixia/game/ddz/" 
local ACTIVITY_NAME = "AppActivity"
local APP_ACTIVITY = APP_PACKAGE_NAME..ACTIVITY_NAME 

local luaj = nil
if device.platform == "android" then
   luaj =   require "cocos.cocos2d.luaj"
end

function MainScene:initBatter()
    self.Img_wifi = _G.seekNodeByName(self.Panel_up,"Image_network_type")
    self.label_Time = _G.seekNodeByName(self.Panel_up,"Text_time")
    self.ProgressBar_battery = _G.seekNodeByName(self.Panel_up,"LoadingBar_electric")
    self.Img_battery = _G.seekNodeByName(self.Panel_up,"Image_electric_bg")
    self.Text_4G = _G.seekNodeByName(self.Panel_up,"Text_4G")
    local function Updatefun(  )
        self:TimeUpdate()
    end

    -- 主界面时间 30秒 刷新一次
    local delay = cc.DelayTime:create(30)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create( Updatefun ))

    self.Panel_up:runAction(cc.RepeatForever:create(sequence))
    Updatefun()
    self:UpdateNetAndElectricity()
end


--[[
    刷新界面电量和wifi效果
]]--
function MainScene:UpdateNetAndElectricity(  )
    local function Updatefun(  )
        self:ElectricityUpdate()
        self:NetworkUpdate()
    end
    local delay = cc.DelayTime:create(0.8)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create( Updatefun ))
    self.Panel_up:runAction(sequence)
end

function MainScene:ElectricityUpdate()
    if device.platform == "android" then
        if luaj ~= nil then
            --请求当前电量状态
            print("MainScene JAVAMETHODNAMEISE")
            local status2, isCharging = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEISE, JAVAPARAMSISE, JAVAMETHODSIGISE)
            --请求当前电量
            local status1, per = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEE, JAVAPARAMSE, JAVAMETHODSIGE)
            if self.Img_battery ~= nil or self.ProgressBar_battery ~= nil then --or self.ProgressBar_lowbattery ~= nil 
                if isCharging then
                    --print("正在充电")
                    self.Img_battery:show()
                    self.ProgressBar_battery:show()
                    self.ProgressBar_battery:setPercent(math.floor(per * 100))
                else
                    if per > 0.1 then
                        --print("电量大于0.1")
                        self.Img_battery:show()
                        self.ProgressBar_battery:show()
                        self.ProgressBar_battery:setPercent(math.floor(per * 100))
                    else
                        --print("电量小于0.1")
                        self.Img_battery:show()
                        self.ProgressBar_battery:hide()
                    end
                end
            end
        end
    elseif device.platform == "ios" then
        local ok1,isCharging = luaoc.callStaticMethod("GetGeneralInfo", "isBatteryStateCharging");
        local ok2,per = luaoc.callStaticMethod("GetGeneralInfo", "getBatteryLevel");

        if self.Img_battery ~= nil --or self.ProgressBar_lowbattery ~= nil
            or self.ProgressBar_battery ~= nil then

            if isCharging == 1 then
               -- print("正在充电")
                self.Img_battery:show()
                self.ProgressBar_battery:show()

                self.ProgressBar_battery:setPercent(math.floor(per * 100))
            else
                if per > 0.1 then
                   -- print("电量大于0.1")
                    self.Img_battery:show()
                    self.ProgressBar_battery:show()
                    self.ProgressBar_battery:setPercent(math.floor(per * 100))
                else
                    --print("电量小于0.1")
                    self.Img_battery:show()
                    self.ProgressBar_battery:hide()
                end
            end
        end
    end
end

--[[
    onisNetType java 
    返回的值
    *   0 无网络
    *   5 wifi
    *   2 2g
    *   3 3g
    *   4 4g
]]--
function MainScene:NetworkUpdate()
    if device.platform == "android" then
        local wfstatus, level = luaj.callStaticMethod(APP_ACTIVITY, JAVAMETHODNAMEN, JAVAPARAMSN, JAVAMETHODSIGN)
        local status, nettype = luaj.callStaticMethod(APP_ACTIVITY, "onisNetType", JAVAPARAMSN, JAVAMETHODSIGN)
        
        if nettype == 0 then
            --print("无网络")
            --self.Img_wifi:hide()
            self.Img_wifi:loadTexture("new_ui/LobbyScene/up/xinhao5.png")
            self.Text_4G:hide()
        elseif nettype == 2 then
            --print("3g")
            --self.Img_wifi:hide()
            self.Text_4G:show()
            self.Img_wifi:loadTexture("new_ui/LobbyScene/up/xinhao1.png")
        elseif nettype == 3 then
            --print("3g")
            -- self.Img_wifi:hide()
            self.Text_4G:show()
            self.Img_wifi:loadTexture("new_ui/LobbyScene/up/xinhao1.png")

        elseif nettype == 4 then
            --print("4g")
            self.Text_4G:show()
            self.Img_wifi:loadTexture("new_ui/LobbyScene/up/xinhao1.png")

        elseif wfstatus == 0 or wfstatus == 2 then
            self.Img_wifi:loadTexture("new_ui/LobbyScene/up/xinhao1.png")
            self.Text_4G:show()

        elseif wfstatus == 1 or wfstatus == true or nettype == 5 then
            self.Text_4G:hide()
            if level == 1 then
                self.Img_wifi:loadTexture("new_ui/LobbyScene/up/wifi4.png")
            elseif level == 2 then
                self.Img_wifi:loadTexture("new_ui/LobbyScene/up/wifi3.png")
            elseif level == 3 then
                self.Img_wifi:loadTexture("new_ui/LobbyScene/up/wifi2.png")
            elseif level == 4 or level == 5 then
                self.Img_wifi:loadTexture("new_ui/LobbyScene/up/wifi1.png")
            end
            self.Img_wifi:show()
        end
    elseif device.platform == "ios" then

        local netstatus = network.getInternetConnectionStatus()
        if netstatus == 0 then
        elseif netstatus == 1 then
            self.Img_wifi:show()
        elseif netstatus == 2 then

        end
    end
end

--更新时间  (开一个时间调度 更新时间)
function MainScene:TimeUpdate()
    local temp = os.date("%H") .. ":" .. os.date("%M")
    if(self.label_Time ~= nil and self.mTime ~=temp ) then
        self.mTime = temp
        self.label_Time:setString(self.mTime)
    end
end
------------

--获取用户数据
function MainScene:getUserInfo()
    local state,value=""
    local state2,value2=""
    local array = {}
    if device.platform == "android" then
         local javaClassName = "com/laixia/game/ddz/AppActivity"
         local javaMethodName = "getNativeInfo"
         local javaParams = { }
         local javaMethodSig = "()Ljava/lang/String;"        
         state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        state,value = luaoc.callStaticMethod("IKCRBridgeManager", "userInfo");
        state2,value2 = luaoc.callStaticMethod("IKCRBridgeManager", "getToken");
    end
    dump(value)
    if value ~="" and value~=nil then
        local json = json or require("framework.json");
        local array = json.decode(value)
        laixia.LocalPlayercfg.LaixiaPlayerID =  array.uid
        laixia.LocalPlayercfg.HEAD_URL = array.icon
        laixia.LocalPlayercfg.LaixiaPlayerNickname = array.name
        if tonumber(array.sex)~=nil and tonumber(array.sex)~="" then
            laixia.LocalPlayercfg.LaixiaPlayerGender = 2-tonumber(array.sex)
        end
        if device.platform == "android" then
            laixia.LocalPlayercfg.LaixiaTokenID =array.token
        else
            if value2~="" and value2~=nil then
                laixia.LocalPlayercfg.LaixiaTokenID = value2
            end
        end
    end
end
--获取用户钱
function MainScene:getUserCoin()
    local stream =  laixia.Packet.new("userInfo", "MEDUSA_CASH_ACCOUNT")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data = event
        if event.dm_error == 0 then
            laixia.LocalPlayercfg.LaixiaGoldCoin = data.gold_coin or 0
            laixia.LocalPlayercfg.LaixiaLdCoin   = data.laidou_coin or 0
            laixia.LocalPlayercfg.LaixiaZsCoin   = data.zscoin or 0
            laixia.LocalPlayercfg.LaixiaBalance   = data.balance or 0
            if self["loadData"] then
                self:loadData() 
            end           
        else
            print("MEDUSA_CASH_ACCOUNT===获取失败")
        end 
    end) 
end


--[[
 * 获取用户信息
 * @param  nil
--]]
function MainScene:getAccountInfo()
    -- {uid=10002 nick="10002" portrait="http://img2.inke.cn/OTI2NzcxNTE0NDU5N TIx.jpg" sex=3 }
    
    local stream =  laixia.Packet.new("userInfo", "LXG_USER_INFO")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event.userinfo
        if event.dm_error == 0 then
            laixia.LocalPlayercfg.LaixiaPlayerID = data1.uid
            print("LaixiaPlayerID___________________________" .. laixia.LocalPlayercfg.LaixiaPlayerID)
            laixia.LocalPlayercfg.LaixiaPlayerNickname = data1.nick
            print("LaixiaPlayerNickname_____________________" .. laixia.LocalPlayercfg.LaixiaPlayerNickname)
            if self.Text_name then
                self.Text_name:setString(laixiaHelper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname))
            end
            laixia.LocalPlayercfg.HEAD_URL = data1.portrait
        else
            print("LXG_USER_INFO===获取失败")
        end 
    end) 

    self:getUserCoin()
end


--[[
 * 用户 货币数量
 * @param  nil
--]]
function MainScene:loadData()
    if self.Text_gold_number then
        self.Text_gold_number:setString(self:numeralRules_2(laixia.LocalPlayercfg.LaixiaGoldCoin))
    end
    if self.Text_zsb_number then
        self.Text_zsb_number:setString(self:numeralRules_2(laixia.LocalPlayercfg.LaixiaZsCoin))
    end
end

--run2 取整数显示最高级别，亿，万为单位
function MainScene:numeralRules_2(num)
    local retStrNumber;

    if(num < MAX_NUM2)then
        retStrNumber = tostring(num);
    elseif(num >=MAX_NUM2 and num <MAX_NUM1)then
        retStrNumber =  tonumber(string.sub(tostring(num / MAX_NUM2),1,5)).. "万";
    --retStrNumber = tostring(math.floor(num /MAX_NUM2))..xDict.DICT(_ID_DICT_TYPE_TEN_THOUSAND);
    elseif(num >= MAX_NUM1) then
        retStrNumber = tonumber(string.sub(tostring(num / MAX_NUM1),1,5)).. "亿";
    --retStrNumber = tostring(math.floor(num /MAX_NUM2))..xDict.DICT(_ID_DICT_TYPE_HUNDRED_MILLION);
    else
        error("not implement");
    end
    return retStrNumber;
end

--获取用户手机号
function MainScene:getMobileInfo()
    local stream =  laixia.Packet.new("getMobileInfo", "LXG_USER_PHONE_GET")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    stream:setValue("query_type", 0)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            laixia.LocalPlayercfg.PhoneNumber =  data1.data.phone
            print("request getMobileInfo success")
        else
            print("getMobileInfo success")
        end 
    end)
end

--[[
    构造函数
]]
function MainScene:ctor()
    print("MainScene ctor")
    app.m_gameManager = require("common.GameManager").new()
    --注册一个liveId
    if device.platform== "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "setLiveid"
        local javaParams = {laixia.lobby_liveid}
        local javaMethodSig = "(Ljava/lang/String;)V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        
    end
    --获取用户数据
    self:getUserInfo()

    self:initCsb()
    -- self:getGameState()  -- TODO 断线重连打开 ↓行注释
     self:noGameInitMainScene()
end


--[[
 * 不需要重连游戏
 * @param  nil 
--]]
function MainScene:noGameInitMainScene()
    audio.playMusic("sound/music/game_hall.mp3" , true)
    local userDefault = cc.UserDefault:getInstance()
    local isBackgroundOn = userDefault:getIntegerForKey("isBackgroundOn", 1)==1 -- 音乐
    if isBackgroundOn == false then
        audio.pauseMusic()
    end
    self:getUserInfo()
    self:getUserCoin()
    self:getMobileInfo()
    ObjectEventDispatch:addEventListener("_LAIXIA_EVENT_DOWNLOADLOBBY_PICTURE_WINDOW", handler(self, self.onHeadDoSuccess))
    self:init()
    self:initBatter()
end

--[[
 * 初始化节点
 * @param  nil 
]]
function MainScene:initCsb()
    --初始化界面
    local csbNode = cc.CSLoader:createNode("new_ui/LobbyScene.csb")
    csbNode:setAnchorPoint(0.5, 0.5)
    csbNode:setPosition(display.cx,display.cy)
    self:addChild(csbNode)
    self.rootNode = csbNode
    local Image_bg = _G.seekNodeByName(csbNode, "Image_bg")
    if Image_bg then
        S_SIZE(Image_bg, display.width, display.height)
    end
    _G.adap(csbNode)
end
--[[
    初始化
]]
function MainScene:init()
    self:getAccountInfo()
    self.Panel_root = _G.seekNodeByName(self.rootNode,"Panel_root")

    self.Panel_up = _G.seekNodeByName(self.Panel_root,"Panel_up")
    self.Panel_middle = _G.seekNodeByName(self.Panel_root,"Panel_middle")
    self.Panel_down = _G.seekNodeByName(self.Panel_root,"Panel_down")

    self.Text_time = _G.seekNodeByName(self.Panel_up,"Text_time")
    self.Text_name = _G.seekNodeByName(self.Panel_up,"Text_name")
    self.Text_zsb_number = _G.seekNodeByName(self.Panel_up,"Text_zsb_number")
    self.Text_gold_number = _G.seekNodeByName(self.Panel_up,"Text_gold_number")
    self.Button_add_zsb = _G.seekNodeByName(self.Panel_up,"Button_add_zsb")
    self.Button_add_zsb:addTouchEventListener(handler(self,self.onTouchAddZSB))
    self.Button_add_jinbi = _G.seekNodeByName(self.Panel_up,"Button_add_jinbi")
    self.Button_add_jinbi:addTouchEventListener(handler(self,self.onGotoShop))
    self.PageView_activity = _G.seekNodeByName(self.Panel_up,"PageView_activity")
    self.PageView_activity:addEventListener(handler(self, self.onPageViewEvent))
    self.Button_setting = _G.seekNodeByName(self.Panel_up,"Button_setting")
    self.Button_setting:addTouchEventListener(handler(self,self.onGotoSetting))
    self.Image_HeadBg = _G.seekNodeByName(self.Panel_up,"Image_icon_frame")
    self.Image_HeadBg:setTouchEnabled(true)
    self.Image_HeadBg:addTouchEventListener(handler(self, self.onGotoPersonCenter))
    self.Image_Head = _G.seekNodeByName(self.Panel_up,"Image_icon")
    self.Image_Head:setVisible(false)

    self.Panel_activity = _G.seekNodeByName(self.PageView_activity,"Panel_activity")
    self.Image_activity = _G.seekNodeByName(self.Panel_activity,"Image_activity")

    --中间游戏icon区域
    self.Panel_gamelist = _G.seekNodeByName(self.Panel_middle,"Panel_gamelist")
    --下面区域的四个按钮
    self.Button_activity = _G.seekNodeByName(self.Panel_down, "Button_activity")
    self.Button_activity:addTouchEventListener(handler(self, self.onGotoActivity))
    self.Button_task = _G.seekNodeByName(self.Panel_down,"Button_task")
    if self.Button_task then
        self.Button_task:addTouchEventListener(handler(self, self.onGotoTask))
    end
    self.Button_email = _G.seekNodeByName(self.Panel_down,"Button_email")
    self.Button_email:addTouchEventListener(handler(self,self.requestEmailData))
    self.Button_bag  = _G.seekNodeByName(self.Panel_down,"Button_bag")
    self.Button_bag:addTouchEventListener(handler(self,self.onGotoBag))
    self.Button_shop  = _G.seekNodeByName(self.Panel_down,"Button_shop")
    self.Button_shop:addTouchEventListener(handler(self,self.onGotoShop))

    self.Button_ranking  = _G.seekNodeByName(self.Panel_down,"Button_ranking")
    if self.Button_ranking then
        self.Button_ranking:addTouchEventListener(handler(self,self.onGotoRanking))
    end

    self.Img_email_red  = _G.seekNodeByName(self.Panel_down,"Image_em_red")
    self.Button_back = _G.seekNodeByName(self.Panel_up,"Button_back")
    self.Button_back:addTouchEventListener(handler(self,self.onExitGame))

    self.Button_sign = _G.seekNodeByName(self.Panel_down,"Button_sign")
    self.Button_sign:addTouchEventListener(handler(self,self.onTouchSign))

    self:onShow()
    --下载活动页面
    local ActivityLayer = require("lobby.layer.activity.ActivityLayer")
    ActivityLayer.GetUrlAndDown()
    self:signNotifyWindow()

    --跑马灯
    -- local BroadcastWindows = require("lobby.layer.hall.BroadcastWindows")
    -- self:addChild(BroadcastWindows, 10000)
end

function MainScene:onGotoSetting(sender,eventtype)
    _G.onTouchButton(sender,eventtype)
    if eventtype == ccui.TouchEventType.ended then
        print("Button_settingf")
        local SettingLayer = require("lobby.layer.setting.SettingLayer").new()
        self:addChild( SettingLayer)

    end
end
function MainScene:updatePageView()
    --sign_1 = 3
    --删除原来的页面(第一页保留用于clone)
    for i = #self.PageView_activity:getPages() - 1, 1, -1 do
        self.PageView_activity:removePageAtIndex(i) 
    end

    if type(laixia.LocalPlayercfg.LaixiaLunBoPath) == "table" and
        #laixia.LocalPlayercfg.LaixiaLunBoPath > 1 then
        self.mPathArray = laixia.LocalPlayercfg.LaixiaLunBoPath
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
        self.PageView_activity:scrollToPage(1)
    elseif pages >= 3 then
        self:addPage(pages, 0, false)
        self:addPage(1, 1, true)
        self:addPage(2, 2, true)
        self.PageView_activity:scrollToPage(1)
    end
end

function MainScene:addPage(pIdx, iIdx, bClone)
 
    local newPage = nil
    if not bClone then
        newPage = self.PageView_activity:getPage(0)
    else
        newPage = self.PageView_activity:getPage(0):clone()
    end

    newPage:setTag(pIdx)

    local adImg = _G.seekNodeByName(newPage,"Image_activity")
    adImg.callFun = handler(self, self.sendActivityPacket)
    adImg:loadTexture(self.mPathArray[pIdx])
    
    adImg:setSwallowTouches(false)
    adImg:setTouchEnabled(true)
    
    adImg:addTouchEventListener(function(sender,eventtype)
       if eventtype == ccui.TouchEventType.began then
        elseif eventtype == ccui.TouchEventType.moved then
        elseif eventtype == ccui.TouchEventType.canceled then

        elseif eventtype == ccui.TouchEventType.ended then    
            --监听的函数
                laixia.LocalPlayercfg.AdvermentIndex = tonumber(sender:getParent():getTag())
                print("pIdx====="..pIdx)
                _G.onTouchButton(sender, eventType)
                self:onGotoActivitylayer(pIdx);

        end

    end)
    self.PageView_activity:insertPage(newPage, iIdx)
 
end
function MainScene:onPageViewEvent(sender, eventType)
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

function MainScene:onDelaty(sender)
    self.Image_HeadBg:setTouchEnabled(false)
    self.Button_activity:setTouchEnabled(false)
    -- self.Button_task:setTouchEnabled(false)
    self.Button_email:setTouchEnabled(false)
    self.Button_bag:setTouchEnabled(false)
    self.Button_shop:setTouchEnabled(false)
    self.Button_sign:setTouchEnabled(false)
    self.Button_add_zsb:setTouchEnabled(false)
    local dela = cc.DelayTime:create(0.5)
    local fun = cc.CallFunc:create(function()
        self.Image_HeadBg:setTouchEnabled(true)
        self.Button_activity:setTouchEnabled(true)
        -- self.Button_task:setTouchEnabled(true)
        self.Button_email:setTouchEnabled(true)
        self.Button_bag:setTouchEnabled(true)
        self.Button_shop:setTouchEnabled(true)
        self.Button_sign:setTouchEnabled(true)
        self.Button_add_zsb:setTouchEnabled(true)
        end)
    local seq = cc.Sequence:create(dela,fun)
    sender:runAction(seq)

end

--[[
    打开活动弹窗
]]
function MainScene:onGotoActivity(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        print("onGotoActivity")
        self:onGotoActivitylayer(1);
    end
end

function MainScene:onGotoActivitylayer( _index )
    if _index == nil or  _index <= 0 then
        return
    end 
    local activityLayer = require("lobby.layer.activity.ActivityLayer").new(_index)
    self:addChild(activityLayer)
end


--[[
    打开公告弹窗
]]
function MainScene:onGotoNotice()

    local IsShow = laixia.LocalPlayercfg.IsShowNoticeLayer
    if IsShow == nil or IsShow == false  then
        local NoticeLayer = require("lobby.layer.notice.NoticeLayer").new()
        --self:addChild(NoticeLayer)
            self:destroyScheduler()
            _G.setPlatformAdap(true)
            _G.setCommonDisplay(true)
            require("games.xzmj.src.app.scenes.MainScene").new()


    end
end

--[[
    个人中心
]]


function MainScene:onGotoPersonCenter(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        local PersonCenterLayer = require("lobby.layer.personcenter.PersonCenterLayer").new()
        -- PersonCenterLayer:requestPersonCenterData()
        self:addChild(PersonCenterLayer)
    end
end


--[[
    打开任务弹窗
]]
function MainScene:onGotoTask(sender,eventtype)
    _G.onTouchButton(sender,eventType)
    if eventtype == ccui.TouchEventType.ended then
        local taskLayer = require("lobby.layer.task.TaskLayer").new()
        self:addChild(taskLayer)
    end
end


--[[
    打开排行弹窗
]]
function MainScene:onGotoRanking(sender,eventtype)
     _G.onTouchButton(sender,eventType)
    if eventtype == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        print("=========打开排行弹窗=====")
        -- self:popUpTips("敬请期待")
        local taskLayer = require("lobby.layer.rank.RankLayer").new()
        self:addChild(taskLayer)
    end
end

--[[
 * 新邮件请求
 * @param  nil 
--]] 
function MainScene:emailNewReq()
    local stream =  laixia.Packet.new("email", "LXG_MAIL_CHECK_NEW")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1.dm_error == 0 then
            if self["emailShowRedPot"] then
                self:emailShowRedPot(data1.data)
            end
        else
            if self["setEmailRedPot"] then
                self:setEmailRedPot(false)
            end
        end
    end) 
    -- local sendPacket = cc.XMLHttpRequest:new()
    -- sendPacket.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- sendPacket:registerScriptHandler(function()
    --     local statusString = "Http Status Code:"..sendPacket.readyState  
    --     local data_json = sendPacket.response
    --     local data1 = json.decode(data_json)
    --     if data1.dm_error == 0 then
    --         self:emailShowRedPot(data1.data)
    --     else
    --         self:setEmailRedPot(false)
    --     end 
    -- end)
    -- local URL1 = "47.93.102.58:9230/mail/check_new?uid="..laixia.LocalPlayercfg.LaixiaPlayerID
    -- sendPacket:open("GET",URL1,true)
    -- sendPacket:send()
end

--[[
 * 显示邮件红点
 * @param  data = {new_mail}
--]]
function MainScene:emailShowRedPot(data)
    if data and data.new_mail then
        if tonumber(data.new_mail) > 0 then
            self:setEmailRedPot(true)
            return
        end
    end
    self:setEmailRedPot(false)
end

--[[
 * 设置邮件红点显示
 * @param  isV 是否显示
--]]
function MainScene:setEmailRedPot(isV)
    if self.Img_email_red then
        self.Img_email_red:setVisible(isV or false)
    end
end

--[[
 * 请求邮件列表
 * @param  sender 按钮
 * @param  eventType 事件类型
--]]
function MainScene:requestEmailData(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        local stream =  laixia.Packet.new("mail", "LXG_MAIL_COLLECTIONS")
        stream:setReqType("get")
        stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID )
        laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
            local data1 = event
            if data1.dm_error == 0 then
                self:onGotoEmail(data1)
            else
                print("请求列表失败！↓")
                scene:popUpTips(data1.error_msg)
                dump(data1)           
            end 
        end)
    end
end

--[[
 * 跳转邮件界面
 * @param  packet 信息
--]]
function MainScene:onGotoEmail(packet)
    self:setEmailRedPot(false)
    local data = packet.data
    if data and type(data) == "table" then
        local emailLayer = require("lobby.layer.email.EmailLayer").new(data)
        self:addChild(emailLayer)
    end
end

--[[
 * 跳转签到界面
 * @param  packet 信息
--]]
function MainScene:onGotoSign(data)
    if data then 
            self:destroyScheduler()
            _G.setPlatformAdap(true)
            _G.setCommonDisplay(true)
            require("games.xzmj.src.app.scenes.MainScene").new()
    end
    -- 测试比赛列表协议
    -- local sendPacket1 = cc.XMLHttpRequest:new()
    -- sendPacket1.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    -- sendPacket1:registerScriptHandler(function()
    --     local statusString = "Http Status Code:"..sendPacket1.readyState  
    --     --获得返回的内容  
    --     local data_json = sendPacket1.response
    --     local data1 = json.decode(data_json)
    --     if data1.dm_error == 0 then
    --         print("请求列表成功！↓")
    --         dump(data1.data.match_list)
    --         -- local 
    --         -- local tabs = json.decode(data_json)
    --         -- print(data1.data.tabs)
    --     else
    --         print("请求列表失败！↓")
    --         dump(data1)
    --     end 
    -- end)
    -- local URL1 = "http://47.93.102.58:9351/api/match/show"
    -- sendPacket1:open("GET",URL1,true)
    -- sendPacket1:send()
end

--[[
 * 请求签到按钮
 * @param  sender 按钮
 * @param  eventType 事件类型
--]]
function MainScene:onTouchSign(sender,eventType)
    _G.onTouchButton(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        self:signReq()
    end
end

--[[
 * 请求签到信息
 * @param  isNotify 开始游戏主动弹出
--]]
function MainScene:signReq(isNotify)
    local stream =  laixia.Packet.new("bag", "LXG_SIGN_COLLECTIONS")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        local data1 = event
        if data1 and data1.dm_error == 0 then
            print("请求签到成功！↓")
            -- dump(data1)
            if isNotify then
                if data1.playerInfo and data1.playerInfo.has_get then
                    if data1.playerInfo.has_get == 0 then
                        self:onGotoSign(data1)
                        return
                    end               
                end
                if self["onGotoNotice"] then
                    self:onGotoNotice()
                end
            else
                if self["onGotoSign"] then
                    self:onGotoSign(data1)
                end
            end
        else
            if self["onGotoNotice"] then
                self:onGotoNotice()
            end
            print("请求签到失败！↓")
            dump(data1)
        end 
    end)
end

--[[
 * 主动弹出签到
 * @param nil
--]]
function MainScene:signNotifyWindow()
    local IsShow = laixia.LocalPlayercfg.IsShowSignWindow
    if not IsShow then
        self:signReq(true)
    end
end

--[[
 * 更新金币
 * @param  gold 更新数量
 * @param  isCover 覆盖
--]]
function MainScene:updateGold(gold,isCover)
    if isCover then
        laixia.LocalPlayercfg.LaixiaGoldCoin = tonumber(gold)
    else
        laixia.LocalPlayercfg.LaixiaGoldCoin = laixia.LocalPlayercfg.LaixiaGoldCoin + tonumber(gold)
    end
    if self.Text_gold_number then
        self.Text_gold_number:setString(self:numeralRules_2(laixia.LocalPlayercfg.LaixiaGoldCoin))
    end
end

--[[
 * 更新芝士币
 * @param  coin 更新数量
--]]
function MainScene:updateCoin(coin,isCover)
    if isCover then
        laixia.LocalPlayercfg.LaixiaZsCoin = tonumber(coin)
    else
        laixia.LocalPlayercfg.LaixiaZsCoin = laixia.LocalPlayercfg.LaixiaZsCoin + tonumber(coin)
    end
    if self.Text_zsb_number then
        self.Text_zsb_number:setString(self:numeralRules_2(laixia.LocalPlayercfg.LaixiaZsCoin))
    end
end

--[[
 * 添加芝士币
 * @param  sender 按钮
 * @param  eventType 事件类型
--]]
function MainScene:onTouchAddZSB(sender,eventtype)
    _G.onTouchButton(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        self:addZSB()
    end
end

--[[
 * 添加芝士币
 * @param  sender 按钮
 * @param  eventType 事件类型
--]]
function MainScene:addZSB()
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "gotoChargePage"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        local state ,value = luaoc.callStaticMethod("IKCRBridgeManager", "showPayView");
    elseif device.platform == "windows" then
        print("device.platform == windows")
    end
end

--[[
 * 打开商城功能
 * @param  sender 更新数量
--]]
function MainScene:onGotoShop(sender,eventtype)
    _G.onTouchButton(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        local shopLayer = require("lobby.layer.shop.ShopLayer").new()
        self:addChild(shopLayer)
    end
end

function MainScene:onGotoBag(sender,eventtype)
    _G.onTouchButton(sender, eventtype)
    if eventtype == ccui.TouchEventType.ended then
        self:onDelaty(sender)
        local BagLayer = require("lobby.layer.bag.BagLayer").new()
        -- BagLayer:sendRequest()
        self:addChild(BagLayer)
    end
end

function MainScene:onShow()
    print("onshowfunction")
    -----------------
    local BGIMG_ = _G.seekNodeByName(self.rootNode,"Image_bg")
    --键盘事件  
    local function onKeyPressed(keyCode, event) 
        local buf = string.format("%d键按下!", keyCode)  
    end  
  
    local function onKeyReleased(keyCode, event)   
        local buf = string.format("%d键抬起!", keyCode)   
        if keyCode == 47 then
        end
    end  
    local listener = cc.EventListenerKeyboard:create()  
    listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED)  
    listener:registerScriptHandler(onKeyReleased, cc.Handler.EVENT_KEYBOARD_RELEASED)  
  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, BGIMG_) 

    --TODO 声音管理
    --TODO 动画管理
    --laixia.soundTools.playMusic(soundConfig.SCENE_MUSIC.lobby,true)
    self:addPathArray()--self.mPathArray)
    self:updatePageView()
    --------------------------------------------------------------------------------------------
    self:setTopInfo()
--    self:updatePageView()
    --创建大厅icon图标
    self:createGridNode()

    -- 获取邮件红点
    self:emailNewReq()
end
--[[
   设置头部信息
]]
local m_time = 0
local m_tipTime = 0
local m_lunboTime = 0
local m_activity = 0 
local m_activityTime = 0
function MainScene:setTopInfo()
        self:addHead()
        if self.Text_name then
            self.Text_name:setString(laixiaHelper.StringRules_6(laixia.LocalPlayercfg.LaixiaPlayerNickname)) 
        end  
        self.entryId = cc.Director:getInstance():getScheduler():scheduleScriptFunc( function(dt) 
                m_time = m_time+ dt
                m_tipTime = m_tipTime + dt
        
                m_lunboTime = m_lunboTime + dt
                if m_lunboTime >= 2 and m_lunboTime <= 2.03 then
                    --self:addPathArray()
                    self:updatePageView()
                end
                if self.Text_time then
                    self.Text_time:setString(os.date("%H:%M"))
                end
                --DownloaderHead:tick()
                --DownloadActivity:tick()

        --        if laixia.LocalPlayercfg.isShouchong == false or laixia.kconfig.isYingKe == true then
        --            self.Button_Lobby_ShouChong:setVisible(false)
        --            if laixia.config.isAudit == false and laixia.kconfig.isYingKe == false then
        --                self.chest:setVisible(false)
        --            end
        --        end
                 --排行榜
                if m_time < 0.3  then
                    return 
                end
                -- --如果有任务红包 显示tips ---@fuya
                -- if m_tipTime >= 1800 then
        --     if self:isHasTaskRedPack() then
        --         self:showBagTips()
        --     end 
        --     m_tipTime = 0    
        -- end
       

                m_activityTime = m_activityTime + dt
                if m_activityTime > 3 then
                    -- local num  = 0
                    -- if self.mPathArray and type(self.mPathArray) == "table" then
                    --     num  = #self.mPathArray
                    -- end
                    -- m_activity = (m_activity )%num + 1
                    if self.PageView_activity then
                        self.PageView_activity:scrollToPage(2)
                    end
                    m_activityTime = 0
                end 
        end, 0, false)
end
--[[
    增加大厅头像
]]
function MainScene:addHead()
    -- 默认头像图片路径
    self.rankIcon = {}
    --local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID%10))..".png"
    local headIcon_new = laixia.LocalPlayercfg.HEAD_URL; --微信头像要用的
    
    self.rankIcon[tostring(laixia.LocalPlayercfg.LaixiaPlayerID)] = self.Image_HeadBg
    local path = "images/ic_morenhead"..tostring(tonumber(laixia.LocalPlayercfg.LaixiaPlayerID)%10)..".png"

    local localIconName = cc.FileUtils:getInstance():getWritablePath() .. laixia.LocalPlayercfg.LaixiaPlayerID ..".png" --laixia.LocalPlayercfg.LaixiaPlayerID
    local fileExist = cc.FileUtils:getInstance():isFileExist(localIconName)
    if (fileExist) then
        path = localIconName
        self:addHeadIcon(self.Image_HeadBg,path)
    else
        local netIconUrl = headIcon_new
        DownloaderHead:pushTask(laixia.LocalPlayercfg.LaixiaPlayerID, netIconUrl,2,self)
    end
    self:addHeadIcon(self.Image_HeadBg,path)
end

function MainScene:onHeadDoSuccess(msg)
    local data = msg
    print("DownSuccess...")
    laixia.LocalPlayercfg.HEAD_URL = data.savePath
    --local localIconPath = cc.FileUtils:getInstance():getWritablePath() .. data.playerID..".png";
    local fileExist = cc.FileUtils:getInstance():isFileExist(laixia.LocalPlayercfg.HEAD_URL)
    local image_rank_di = self.rankIcon[tostring(data.playerID)]
    if(fileExist) and image_rank_di~=nil then
        image_rank_di:removeAllChildren()
        self:addHeadIcon(image_rank_di,laixia.LocalPlayercfg.HEAD_URL )
    end  
end

function MainScene:addHeadIcon(head_btn,path)
    if (head_btn == nil or head_btn == "") then
        return
    end
    local templet = "images/touxiangkuang_now.png"
    UItools.addHead(head_btn, path, templet)
   
end
--[[
    增加滚动图
]]
function MainScene:addPathArray()
--TODO 测试数据
    laixia.LocalPlayercfg.LaixiaLunBoPath[1] = {}
    laixia.LocalPlayercfg.LaixiaLunBoPath[1] = "new_ui/LobbyScene/huodong1.png"--"http://pic.laixia.com/upload/activityfiles/yuanxiaojiehuodong_guanggao.png"
--    laixia.LocalPlayercfg.LaixiaLunBoPath[2] = "http://pic.laixia.com/upload/activityfiles/laixianiwota_guanggao.png"

    self.mPathArray = {}
    self.mLunBoName = {}
    if #self.mPathArray > 0  then
        self.mPathArray = {}
    end
    if #self.mLunBoName > 0  then
        self.mLunBoName = {}
    end
    if #laixia.LocalPlayercfg.LaixiaLunBoPath == 1 then
        for i=1,6 do
            for k,v in pairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
--            for k,v in pairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--                table.insert(self.mLunBoName,v)    
--            end    
        end
    elseif #laixia.LocalPlayercfg.LaixiaLunBoPath == 2 then
        for i=1,3 do
            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
--            for k,v in pairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--                table.insert(self.mLunBoName,v)    
--            end 
        end
    elseif #laixia.LocalPlayercfg.LaixiaLunBoPath == 3 then   
        for i=1,2 do
            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
            end
--            for k,v in pairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--                table.insert(self.mLunBoName,v)    
--            end 
        end
    elseif #laixia.LocalPlayercfg.LaixiaLunBoPath == 4 then
        for i=1,2 do
            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
                if i == 2 and j == 2 then
                    break
                end
            end
--            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--                table.insert(self.mLunBoName,v)
--                if i == 2 and j == 2 then
--                    break
--                end
--            end
        end      
    elseif #laixia.LocalPlayercfg.LaixiaLunBoPath == 5 then
        for i=1,2 do
            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
                table.insert(self.mPathArray,v)
                if i == 2 and j == 1 then
                    break
                end
            end
--            for j,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--                table.insert(self.mLunBoName,v)
--                if i == 2 and j == 1 then
--                    break
--                end
--            end
        end         
    elseif #laixia.LocalPlayercfg.LaixiaLunBoPath == 6 then
        for i,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoPath) do
            table.insert(self.mPathArray,v)
        end
--        for i,v in ipairs(laixia.LocalPlayercfg.LaixiaLunBoName) do
--            table.insert(self.mLunBoName,v)
--        end
    end
end

--[[
    创建IconList
]]
function MainScene:createGridNode()
    local json_gameList = cc.FileUtils:getInstance():getStringFromFile("data/gamelist.json")
    if not json_gameList or json_gameList == "" then
        return nil
    end
    local gameList = json.decode(json_gameList)
    local pageHolder = self.Panel_gamelist
    pageHolder:setAnchorPoint(cc.p(0.5,1))
    local size = pageHolder:getContentSize()
    local gridNode = require("lobby.node.GridNode").new({
        column = 3,
        row = 3,
        columnSpace = 0,
        rowSpace = 0,
        contentSize = size,
        padding = {left = 0, right = 0, top = 45, bottom = 0},
        bCirc = false,
        imgDotNormal = nil,
        imgDotSelected = nil,
        indicatorBarHeight = 0
    }):onTouch_Lobby(handler(self, self.onGridListener))
    gridNode:setPosition(cc.p(pageHolder:getContentSize().width / 2, pageHolder:getContentSize().height))
    gridNode:addTo(pageHolder)
    self:setIconListInfo(gridNode, gameList)
    gridNode:reload(gridNode:getCurPageIdx())
end

--[[
    点击图标
]]
function MainScene:onGridListener(event)
    if event.item == nil then return end
    if event.name == "clicked" then
        --游戏
        if event.item.m_gameInfo.type == "game"then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.entryId)

            IconListUtils.clickGameIcon(event.item)
        end
    end
end

--[[
    设置图标列表
]]
function MainScene:setIconListInfo(gridNode, gameList)
    if not gridNode or not gameList or #gameList == 0 then 
        return 
    end
    gridNode:removeAllItem()

    --添加子项
    for k,v in ipairs(gameList) do
        local content = gridNode:newItem()
        local img = IconListUtils.createIcon(v)
            :addTo(content, IconListUtils.ITEM_TAG.ICON, IconListUtils.ITEM_TAG.ICON)

        img:setContentSize(cc.size(IconListUtils.m_iconSize.width, IconListUtils.m_iconSize.height))
        -- local label = cc.ui.UILabel.new({text=v.displayName, size=24, color=display.COLOR_WHITE})
        --     :align(display.BOTTOM_CENTER, IconListUtils.m_itemSize.width / 2, 0)
        --     :addTo(content, IconListUtils.ITEM_TAG.NAME, IconListUtils.ITEM_TAG.NAME)
        content.m_gameInfo = v
        content:setContentSize(cc.size(IconListUtils.m_itemSize.width, IconListUtils.m_itemSize.height))
        gridNode:addItem(content)
        content:setNodeEventEnabled(true)
        content:addNodeEventListener(cc.NODE_EVENT, function(event)
            if event.name == "exit" then
                if content.handlerProgress ~= nil then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(content.timerHandler)
                    content.handlerProgress = nil
                end
            end            
        end)
    end
end

--传一字符串就行
function MainScene:popUpTips(msg)
    local data_ = {
        message = msg,
        w = display.cx,
        h = display.cy+200,
        type_ = 1
    }
    local MatterTips = require("lobby.layer.tips.MatterTips").new(data_)
    MatterTips:setPosition(cc.p(data_.w,data_.h))
    self:addChild(MatterTips,1111)
end

--退出游戏
function MainScene:onExitGame(sender,eventtype)
    _G.onTouchButton(sender, eventtype)
    if eventtype ~= ccui.TouchEventType.ended then
        return
    end
    if device.platform == "android" then
        local javaClassName = "com/laixia/game/ddz/AppActivity"
        local javaMethodName = "exitGame"
        local javaParams = { }
        local javaMethodSig = "()V"        
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
    elseif device.platform == "ios" then
        luaoc.callStaticMethod("IKCRLXBridgeManager", "dismiss");
    else
        app:exit()
    end
end

--[[
 * 获取是否在牌桌中
 * @param  nil
--]]
function MainScene:getGameState()
    local stream =  laixia.Packet.new("getGameState", "LXG_PLAYER_MATCH_STATE")
    stream:setReqType("get")
    stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
    laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
        self.isGame = true
        if event.dm_error == 0 then
            print("getGameState ===比赛↓")  
            dump(event.data)
            local info
            if event.data then
                info = json.decode(event.data)
            end
            local RoomType
            if info and info.table_id and info.m_ins_id then
                local table_id = tostring(info.table_id)
                local m_ind = tostring(info.m_ins_id)
                if m_ind == "0" then
                    print("getGameState ===无赛")
                    self.isGame = false
                else
                    local matchId
                    local arr = string.split(m_ind,"_")
                    if arr and type(arr) == "table" then
                        matchId = arr[1]
                    end
                    --获取比赛id
                    matchId = tonumber(matchId)
                    local TableID = table_id
                    local RoomID = matchId
                    laixia.LocalPlayercfg.LaixiaMatchInsId = m_ind

                    if tonumber(TableID) == 0 then
                        print("getGameState === 比赛中 等待中 没分牌桌!")
                        self.isGame = true
                        -- 请求重连
                        RoomType = 4
                        self:reconnectEnterGame(RoomType,TableID,RoomID)
                    else
                        print("getGameState === 请求重连1!")
                        if RoomID< 100 and RoomID > 0 then
                            RoomType = 2
                        else
                            RoomType = 4
                        end
                        -- 请求重连
                        self:reconnectEnterGame(RoomType,TableID,RoomID)
                    end
                end
            end
        end
        if self.isGame == false then
            -- TableID == 0 没分桌或没开桌
            local RoomID
            local stream =  laixia.Packet.new("getGameState", "LXG_PLAYER_ENROLL_LIST")
            stream:setReqType("get")
            stream:setValue("uid", laixia.LocalPlayercfg.LaixiaPlayerID)
            laixia.net.sendHttpPacketAndWaiting(stream.key, stream, function(event) 
                dump(event,"LXG_PLAYER_ENROLL_LIST------event")
                if event.dm_error == 0 then
                    local match_id_list = event.data or {}
                    --for i=1,#match_id_list do
                    for k,match_id in pairs(match_id_list) do
                        local game_id = tonumber(match_id)
                        if game_id < 100 and game_id>0 then
                            self.isGame = true
                            RoomType = 2
                            RoomID = game_id
                            break
                        end
                    end
                end
                if self.isGame == true then
                    print("getGameState === 请求重连2!")
                    self:reconnectEnterGame(RoomType,TableID,RoomID)
                else
                    print("getGameState === 初始大厅!")
                    self:noGameInitMainScene()
                end
            end)
        end
    end) 
end
--重新进入游戏
function MainScene:reconnectEnterGame(RoomType,TableID,RoomID)
    self:destroyScheduler()
    _G.setPlatformAdap(true)
    _G.setCommonDisplay(true)
    local paramData = {RoomType = RoomType,TableID = TableID,RoomID = RoomID,match_ins_id = laixia.LocalPlayercfg.match_ins_id}
    local DDZLobbyScene = require("games.ddz.layer.DDZLobbyScene").new(paramData)
    display.replaceScene(DDZLobbyScene)
end


--[[
 * 注销活动定时器
 * @param  nil 
--]]
function MainScene:destroyScheduler()
    if self.entryId then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.entryId)
        self.entryId = nil
    end
end


--[[
 * 注销
 * @param  nil 
--]]
function MainScene:onDestroy()
    self:destroyScheduler()
end

return MainScene
