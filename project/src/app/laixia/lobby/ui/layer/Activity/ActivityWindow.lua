local Activity= class("Activity",import("...CBaseDialog"):new())
local soundConfig = laixia.soundcfg;     
local Packet =import("....net.Packet")

function Activity:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function Activity:getName()
    return "WonderfulWindow"
end

function Activity:onInit()
    self.super:onInit(self)  

    ObjectEventDispatch:addEventListener(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW,handler(self,self.show))
end

function Activity:onShow(data)
    if laixia.kconfig.isYingKe == true or laixia.LocalPlayercfg.isShouchong == false then
        laixia.LocalPlayercfg.LaixiaIsSign = 0
    end
    self.mPathArray = {}
    self.mActivityListData ={}
    self.mActivityListData_1 ={}
    self.ActivityButtonArray = {}
    self.ActivityName = {}
    self.dataInfo = data.data.ActivityItems
    laixia.LocalPlayercfg.ActivityItems = self.dataInfo
    self:addPathArray(self.mPathArray  ,self.mActivityListData, self.mActivityListData_1,self.ActivityButtonArray,self.ActivityName)

    -- self.temp = {}
    -- self.CurNode = 1
    -- self.CurNodeString = nil 
    -- if laixia.LocalPlayercfg.LaixiaIcon ~= nil then
    --     self.temp = laixia.LocalPlayercfg.LaixiaIcon.All
    --     self.CurNode = laixia.LocalPlayercfg.LaixiaIcon.Cur
    --     self.CurNodeString = laixia.LocalPlayercfg.LaixiaIcon.All[self.CurNode]
    -- end

    -- self.tempCommon = {}
    -- local tempNum = 1
    -- if self.temp ~= nil then
    --     for key,value in pairs(self.ActivityName) do
    --         for k,v in pairs(self.temp) do
    --             if v == value then
    --                 self.tempCommon[tempNum] = v
    --                 tempNum = tempNum + 1 
    --             end
    --         end
    --     end
    -- end

    self.NowNum = 1
    if laixia.LocalPlayercfg.AdvermentIndex ~=nil then
        for k,v in pairs(self.ActivityName) do  
            local pathStrTemp = ui.LobbyWindow.mPathArray[laixia.LocalPlayercfg.AdvermentIndex or 1]
            local pathArray = string.split(pathStrTemp,"/")
            local pathStr = string.sub(pathArray[#pathArray],0,string.len(pathArray[#pathArray])-4)
            if v.."_guanggao" == pathStr then
                self.NowNum = k
            end
        end
    end


    self:AddWidgetEventListenerFunction("Activity_Button_Close",handler(self, self.onShutDown));
    --加载第一个活动
    if #self.mPathArray > 0  then
      self:GetWidgetByName("Activity_Image_Content"):loadTexture(self.mPathArray[1])
    end
    self.index = 1
    self.beiJing = self:GetWidgetByName("beijing")
    self.beiJing:setTouchEnabled(true)
    self.beiJing:setTouchSwallowEnabled(true)
    self.mListView  = self:GetWidgetByName("ListView_Acctivity_Button")
    self.mCell =  self:GetWidgetByName("Image_Activity_Cell")
    self:addUI()
    if laixia.LocalPlayercfg.AdvermentIndex == nil then
        self:showOnlyButton(1)
    else
        self:showOnlyButton(self.NowNum*2-1)    
    end
    
end

function Activity:addUI()
    self.ButtonArray ={}
    local ActivityListData =self.mActivityListData
    local ActivityListData_1 =self.mActivityListData_1
    for i =1,#ActivityListData do
        local mode  = self.mCell:clone()
        self.mListView:pushBackCustomItem(mode)

        local btn_now = self:GetWidgetByName("Activity_Button_Now",mode)
        table.insert(self.ButtonArray,btn_now)
        btn_now:setVisible(false)
        local btn_des = self:GetWidgetByName("Activity_Button",mode)
        table.insert(self.ButtonArray,btn_des)
        btn_des:setVisible(false)

        btn_now:loadTexture(ActivityListData[i])
        btn_des:loadTexture(ActivityListData_1[i])
        -- self:GetWidgetByName("Activity_Button_Label",btn_des):setString(ActivityListData[i])
        -- self:GetWidgetByName("Activity_Button_Label",btn_now):setString(ActivityListData[i])

        btn_des.index = i
        btn_des:addTouchEventListener(handler(self, self.onShowActivity))
        
        local mShowIndex = 1
        if self.NowNum ~= 0 or self.NowNum ~= nil then
            mShowIndex = self.NowNum
        end
        if i == mShowIndex then
            local sender = {}
            sender.index = i
            self:onShowActivity(sender)
        end

    end
end

--添加图片路径 --按钮名称 --活动按钮路径
function Activity:addPathArray(pathArray ,ActivityListData,ActivityListData_1,ActivityButtonArray,ActivityName)
        --活动配置
        self.ActivityConfig = {
            qqunfuli = {
                            Name = "qqunfuli",
                            --ActivityListName = "Q群福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_pop_huodong_6.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_pop_huodong_1.png",
                            pathArray = "new_ui/Activity_Alert/pop_huodong_q.png",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            zhaocha = {
                            Name = "zhaocha",
                            --ActivityListName = "找\"茬\"活动",
                            ActivityListName = "new_ui/Activity_Alert/btn_pop_huodong_4.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_pop_huodong_2.png",

                            pathArray = "new_ui/Activity_Alert/zhaochahuodong.png",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            rechargefuli = {
                            Name = "rechargefuli",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_pop_huodong_5.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_pop_huodong_3.png",

                            pathArray = "new_ui/Activity_Alert/chongzhihuodong.png",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            redpacket = {
                            Name = "redpacket",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/hongbaopaisong_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/hongbaopaisong_1.png",

                            pathArray = "new_ui/Activity_Alert/hongbaohuodong.png",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            yingkebisai = {
                            Name = "yingkebisai",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_yingke_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_yingke_1.png",
                            channelID = "201009",
                            pathArray = "new_ui/Activity_Alert/yingkebisai.png",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            yingchunjie = {
                            Name = "yingchunjie",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/yingchunjie_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/yingchunjie_1.png",
                            pathArray = "new_ui/Activity_Alert/yingchunjiehuodong.png",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },    
            yuanxiaojiehuodong = {
                            Name = "yuanxiaojiehuodong",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_yuanxiaojie_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_yuanxiaojie_1.png",
                            pathArray = "new_ui/Activity_Alert/yuanxiaojiehuodong.png",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  ,   
            dajiangsai = {
                            Name = "dajiangsai",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_dajiangsai_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_dajiangsai_1.png",
                            pathArray = "new_ui/Activity_Alert/dajiangsaihuodong.png",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  ,           
        }

        if #pathArray > 0  then
            pathArray = {}
        end
        if #ActivityButtonArray >  0 then
            ActivityButtonArray = {}
        end
        if #ActivityListData > 0  then
            ActivityListData = {}
        end
        if #ActivityName > 0 then
            ActivityName = {}
        end
        for key, var in ipairs(self.dataInfo) do
            for activityIndex, activityValue in pairs(self.ActivityConfig) do
                if var.activityName == activityIndex then
                    if (activityValue.channelID~=nil and activityValue.channelID == tostring(laixia.LocalPlayercfg.CHANNELID)) or activityValue.channelID==nil then
                           table.insert(pathArray,activityValue.pathArray)
                            table.insert(ActivityButtonArray,activityValue.ButtonPath)
                            table.insert(ActivityListData,activityValue.ActivityListName)
                            table.insert(ActivityListData_1,activityValue.ActivityListName_1)
                            table.insert(ActivityName,activityValue.Name)
                           break
                    end
                end
            end
        end



end
--显示新的活动界面
function Activity:onShowActivity(sender, eventType)
   -- if eventType == ccui.TouchEventType.ended then
        local mIndex = sender.index
        self.mIndex = mIndex
        local index = (mIndex - 1)*2+1
        self:showOnlyButton(index)    
        local path = "activity_redpacklv2.png"--这个是默认图？
        local pathArray = self.mPathArray
        if mIndex > 0 and mIndex <= #pathArray then
            path = pathArray[mIndex]
        end

        self:GetWidgetByName("Activity_Image_Content"):loadTexture(path)
        self:GetWidgetByName("Activity_Image_Content"):setTouchEnabled(true)
        self:GetWidgetByName("Activity_Image_Content"):addTouchEventListener( function(sender, eventType)
            self:onHuodongClick(sender, eventType)
        end )
        local button = self:GetWidgetByName("Button_huodong")
        if self.ActivityButtonArray[mIndex] == "" then
            button:setVisible(false)
        else
            button:setVisible(true)
            button:setPosition(990,87)
            
            local button = self:GetWidgetByName("Button_huodong"):loadTexture(self.ActivityButtonArray[mIndex])
            self:AddWidgetEventListenerFunction("Button_huodong",handler(self, self.onHuodongClick));
--            local button_FunWenzi = self:GetWidgetByName("Image_FunWenzi",button)
--            button_FunWenzi:loadTexture(self.ActivityButtonArray[mIndex])
        end

    --end
end
function Activity:onHuodongClick(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.ActivityName[self.mIndex] == "qqunfuli" then
            local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            if device.platform ==  "android" then 
                local luaj = require "cocos.cocos2d.luaj"
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "joinGroup"
                local javaParams = {"ChUE9L9Mqt7XxGLSvEA7n7fl2ORNj8ly"} --来下竞技群
                local javaMethodSig = "(Ljava/lang/String;)Z"
                local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                print(state)
                print(value)
                if state ~= true then
                    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"安装的版本不支持") 
                end
                return value;
            elseif device.platform == "ios" then
                local luaoc = require("cocos.cocos2d.luaoc")
                local arg = {groupUin="436823668",key="1a8a014fc97ec4aaadc17d660e8dd86f26194bd63c1a50a13b705e30926fdc21"}
                local state,value = luaoc.callStaticMethod("GetGeneralInfo", "joinGroup",arg);
                if value=="" then
                    value = 0
                end
                return tonumber(value);
            else    
                return false;
            end 
        elseif self.ActivityName[self.mIndex] == "rechargefuli" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SHOP_WINDOW,{buttonType =1}) 
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SHOP_WINDOW)
        elseif self.ActivityName[self.mIndex] == "yingchunjie" or self.ActivityName[self.mIndex] == "yuanxiaojiehuodong"  then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW)
            laixia.LocalPlayercfg.OnReturnFunction = _LAIXIA_EVENT_SHOW_MATCHLIST_WINDOW
                
            local CSMatchListPacket = Packet.new("CSMatchGame", _LAIXIA_PACKET_CS_MatchGameID)
            CSMatchListPacket:setValue("GameID", laixia.config.GameAppID)
            CSMatchListPacket:setValue("PageType", 1 )
            laixia.net.sendPacketAndWaiting(CSMatchListPacket)
        end
    end
end

--显示唯一的前景按钮
function Activity:showOnlyButton(index)
   laixia.UItools.onShowOnly(index,self.ButtonArray)   
end

function Activity:onShutDown(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        laixia.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy() 
    end
end

function Activity:onDestroy()
    laixia.LocalPlayercfg.AdvermentIndex = nil
    if laixia.LocalPlayercfg.isShouchong == true and laixia.LocalPlayercfg.LaixiaIsSign == 1 and laixia.kconfig.isYingKe == false then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FIRSTGIFT_WINDOW)
    end
    -- local CSWeekOrMonthCard = Packet.new("CSWeekOrMonthCard", _LAIXIA_PACKET_CS_WeekOrMonthCardID)
    -- CSWeekOrMonthCard:setValue("Code", laixia.LocalPlayercfg.LaixiaHttpCode)
    -- CSWeekOrMonthCard:setValue("AppID", laixia.config.GameAppID)
    -- laixia.net.sendHttpPacket(CSWeekOrMonthCard) 
end

 
return Activity.new()
