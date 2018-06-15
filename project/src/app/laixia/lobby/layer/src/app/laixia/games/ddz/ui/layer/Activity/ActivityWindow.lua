local Activity= class("Activity",import("...CBaseDialog"):new())
local soundConfig = laixiaddz.soundcfg;     
local Packet =import("....net.Packet")

function Activity:ctor(...) 
    self.hDialogType = DialogTypeDef.DEFINE_NORMAL_DIALOG
end

function Activity:getName()
    return "WonderfulWindow"
end

function Activity:onInit()
    self.super:onInit(self)  
  
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_SHOW_ACTIVITY_WINDOW,handler(self,self.show))
      --下载图片完成
    ObjectEventDispatch:addEventListener(_laixiaddz_EVENT_DOWNLOAD_ACTIVITY_WINDOW, handler(self, self.onActivityDoSuccess))
end

function Activity:onShow(data)
    if laixia.kconfig.isYingKe == true or laixiaddz.LocalPlayercfg.isShouchong == false then
        laixiaddz.LocalPlayercfg.LaixiaIsSign = 0
    end
    self.mPathArray = {}
    -- local pathArray_1 = {}
    self.mActivityListData ={}
    self.mActivityListData_1 ={}
    self.ActivityButtonArray = {}
    self.ActivityName = {}
    self.dataInfo = data.data.ActivityItems
    laixiaddz.LocalPlayercfg.ActivityItems = self.dataInfo
    self:addPathArray(self.mPathArray, self.mActivityListData, self.mActivityListData_1,self.ActivityButtonArray,self.ActivityName)

    -- self.temp = {}
    -- self.CurNode = 1
    -- self.CurNodeString = nil 
    -- if laixiaddz.LocalPlayercfg.LaixiaIcon ~= nil then
    --     self.temp = laixiaddz.LocalPlayercfg.LaixiaIcon.All
    --     self.CurNode = laixiaddz.LocalPlayercfg.LaixiaIcon.Cur
    --     self.CurNodeString = laixiaddz.LocalPlayercfg.LaixiaIcon.All[self.CurNode]
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
    if laixiaddz.LocalPlayercfg.AdvermentIndex ~=nil then
        for k,v in pairs(self.ActivityName) do  
            -- local pathStrTemp = laixiaddz.LocalPlayercfg.mPathArray[laixiaddz.LocalPlayercfg.AdvermentIndex or 1]
            local pathStrTemp = ui.LobbyWindow.mPathArray[laixiaddz.LocalPlayercfg.AdvermentIndex or 1]
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
    if laixiaddz.LocalPlayercfg.AdvermentIndex == nil then
        self:showOnlyButton(1)
    else
        self:showOnlyButton(self.NowNum*2-1)    
    end
    
end
function Activity:onActivityDoSuccess(msg)
    self.data = msg.data
    local activityInUse = self.data.savePath
    local index = self.data.index
    local fileExist = cc.FileUtils:getInstance():isFileExist(activityInUse)
    if (fileExist) then
        if isTableEmpty(laixiaddz.LocalPlayercfg.LaixiaActivityPath) then
            if laixiaddz.LocalPlayercfg.LaixiaActivityPath[index]==nil then
                laixiaddz.LocalPlayercfg.LaixiaActivityPath[index] = {}
            end
            laixiaddz.LocalPlayercfg.LaixiaActivityPath[index] = activityInUse
            --table.insert(laixiaddz.LocalPlayercfg.LaixiaActivityPath,activityInUse)
        else
            local tagPath = 0
            for k,v in pairs(laixiaddz.LocalPlayercfg.LaixiaActivityPath) do
                if v == activityInUse then
                    tagPath = 1
                end
            end
            if tagPath == 0 then
                if laixiaddz.LocalPlayercfg.LaixiaActivityPath[index]==nil then
                    laixiaddz.LocalPlayercfg.LaixiaActivityPath[index] = {}
                end
                laixiaddz.LocalPlayercfg.LaixiaActivityPath[index] = activityInUse
                --table.insert(laixiaddz.LocalPlayercfg.LaixiaActivityPath,activityInUse)
            end
        end
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
                            pathArray = "",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            zhaocha = {
                            Name = "zhaocha",
                            --ActivityListName = "找\"茬\"活动",
                            ActivityListName = "new_ui/Activity_Alert/btn_pop_huodong_4.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_pop_huodong_2.png",

                            pathArray = "",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            rechargefuli = {
                            Name = "rechargefuli",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_pop_huodong_5.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_pop_huodong_3.png",

                            pathArray = "",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            redpacket = {
                            Name = "redpacket",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/hongbaopaisong_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/hongbaopaisong_1.png",

                            pathArray = "",
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
                            pathArray = "",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },
            yingchunjie = {
                            Name = "yingchunjie",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/yingchunjie_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/yingchunjie_1.png",
                            pathArray = "",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        },    
            yuanxiaojiehuodong = {
                            Name = "yuanxiaojiehuodong",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_yuanxiaojie_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_yuanxiaojie_1.png",
                            pathArray = "",
                            ButtonPath = "new_ui/Activity_Alert/anniu_1.png",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  ,   
            dajiangsai = {
                            Name = "dajiangsai",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_dajiangsai_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_dajiangsai_1.png",
                            pathArray = "",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  , 
            laixianiwota = {
                            Name = "laixianiwota2",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_laixianiwota_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_laixianiwota_1.png",
                            pathArray = "",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  , 
            oppor15shouji = {
                            Name = "oppor15shouji",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_oppor15shouji_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_oppor15shouji_1.png",
                            pathArray = "",
                            ButtonPath = "",
                            ButtonPositionX = 800,
                            ButtonPositionY = 200,
                        }  , 
            iPhonextuiguang1 = {
                            Name = "iPhonextuiguang4",
                            --ActivityListName = "充值福利",
                            ActivityListName = "new_ui/Activity_Alert/btn_iPhonextuiguang1_2.png",
                            ActivityListName_1 = "new_ui/Activity_Alert/btn_iPhonextuiguang1_1.png",
                            pathArray = "",
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
                    if (activityValue.channelID~=nil and activityValue.channelID == tostring(laixiaddz.LocalPlayercfg.CHANNELID)) or activityValue.channelID==nil then
                           -- table.insert(pathArray,activityValue.pathArray)
                            table.insert(ActivityButtonArray,activityValue.ButtonPath)
                            table.insert(ActivityListData,activityValue.ActivityListName)
                            table.insert(ActivityListData_1,activityValue.ActivityListName_1)
                            table.insert(ActivityName,activityValue.Name)
                           break
                    end
                end
            end
        end
        for i,v in pairs(laixiaddz.LocalPlayercfg.LaixiaActivityPath) do     
            -- if (activityValue.channelID~=nil and activityValue.channelID == tostring(laixiaddz.LocalPlayercfg.CHANNELID)) or activityValue.channelID==nil then
               table.insert(pathArray,v)
            -- end
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
        -- self:GetWidgetByName("Activity_Image_Content"):setTouchEnabled(true)
        -- self:GetWidgetByName("Activity_Image_Content"):addTouchEventListener( function(sender, eventType)
        --     self:onHuodongClick(sender, eventType)
        -- end )
        local button = self:GetWidgetByName("Button_huodong")
        local Button_weixin = self:GetWidgetByName("Button_weixin") 
        local Button_share = self:GetWidgetByName("Button_share")
        -- local Button_qqun1 = self:GetWidgetByName("Button_qqun") 
        -- local Button_qqun2 = self:GetWidgetByName("Button_qqun2")
        if self.ActivityButtonArray[mIndex] == "" then
            button:setVisible(false)
            Button_weixin:setVisible(false)
            Button_share:setVisible(false)
            -- Button_qqun1:setVisible(false)
            -- Button_qqun2:setVisible(false)            
        else
            Button_weixin:setVisible(false)
            Button_share:setVisible(false)
            -- Button_qqun1:setVisible(false)
            -- Button_qqun2:setVisible(false) 
            button:setVisible(true)
            button:setPosition(990,87)
            local button = self:GetWidgetByName("Button_huodong"):loadTexture(self.ActivityButtonArray[mIndex])
            self:AddWidgetEventListenerFunction("Button_huodong",handler(self, self.onHuodongClick));
--            local button_FunWenzi = self:GetWidgetByName("Image_FunWenzi",button)
--            button_FunWenzi:loadTexture(self.ActivityButtonArray[mIndex])
        end
        if self.ActivityName[self.mIndex] == "laixianiwota2" then  
            if laixia.kconfig.isYingKe ~= true then
                Button_weixin:setVisible(true)
                self:AddWidgetEventListenerFunction("Button_weixin",handler(self, self.onWXClick))
            end
            -- Button_qqun1:setVisible(true)
            -- self:AddWidgetEventListenerFunction("Button_qqun",handler(self, self.onHuodongClick2))

            -- Button_qqun2:setVisible(true)
            -- self:AddWidgetEventListenerFunction("Button_qqun2",handler(self, self.onHuodongClick2))
        elseif self.ActivityName[self.mIndex] == "iPhonextuiguang4" then
            Button_share:setVisible(true)
            self:AddWidgetEventListenerFunction("Button_share",handler(self, self.goShare))
        end
    --end
end

function Activity:goShare(sender, eventType)
    if eventType == ccui.TouchEventType.ended then 
        print("xuanze share WX OR Friends")
        self.Panel_share = self:GetWidgetByName("Panel_share")
        self.Panel_share:setVisible(true)
        local Btn_WX = self:GetWidgetByName("Button_share_weixin",self.Panel_share)
        local Btn_FR = self:GetWidgetByName("Button_share_FriendCircle",self.Panel_share)
        local btn_clo = self:GetWidgetByName("Button_Close_share",self.Panel_share)
        self:AddWidgetEventListenerFunction("Button_share_weixin",handler(self, self.goShareWX))
        self:AddWidgetEventListenerFunction("Button_share_FriendCircle",handler(self, self.goShareFriend))
        self:AddWidgetEventListenerFunction("Button_Close_share",handler(self, self.closeShare))
    end
end
function Activity:closeShare(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        self.Panel_share:setVisible(false)
    end
end
--分享朋友圈
function Activity:goShareFriend(sender, eventType)
    if eventType == ccui.TouchEventType.ended then 
        if laixia.kconfig.isYingKe == false then
            print("share Friends")
            self.Panel_share:setVisible(false)
            local str = laixiaddz.LocalPlayercfg.LaixiaPlayerID.."7kyn@,ey"
            local token = crypto.md5(str)
            local url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token
            local title = "您有一部iPhone X未领取"
            local description ="你来分享我来送，iPhone X、红包等你拿"
            local flag = 1 -- 0 分享好友  1 分享好友圈
            if device.platform == "android" then
                local luaj = require "cocos.cocos2d.luaj"
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "wxShare"
                local javaParams = {title,url ,description,flag }
                local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
                local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                return value
            elseif device.platform == "ios" then--苹果包
                local args = {title = title, Url = url,description=description,flag = flag }
                local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
            end 
        elseif laixia.kconfig.isYingKe == true then
            local str = laixiaddz.LocalPlayercfg.LaixiaPlayerID.."7kyn@,ey"
            local token = crypto.md5(str)
            if device.platform == "ios" then
                self.Panel_share:setVisible(false)                
                local args = {
                                platform = "timeline",
                                title = "您有一部iPhone X未领取",
                                content = "你来分享我来送，iPhone X、红包等你拿",
                                url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                                imageUrl = "http://img2.inke.cn/MTUxNTE1OTgzNzQ2MiMxNTcjanBn.jpg",
                }
                luaoc.callStaticMethod("IKCRLXBridgeManager", "shareToWX", args)
            elseif device.platform == "android" then
                self.Panel_share:setVisible(false)
                local args = {
                                type = "1",
                                title = "您有一部iPhone X未领取",
                                content = "你来分享我来送，iPhone X、红包等你拿",
                                url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                                icon = "http://wx.laixia.com/images/iphonex/icon.png"
                }
                local jsonStr = json.encode(args)
                local result = {jsonStr}
                local sig = "(Ljava/lang/String;)V"
                local ok, value = luaj.callStaticMethod(APP_ACTIVITY, "wxShare", result, sig)
            end
        end
    end
end
--分享到微信好友
function Activity:goShareWX(sender, eventType)
    if eventType == ccui.TouchEventType.ended then 
        if laixia.kconfig.isYingKe == false then
            print("share WXFriends")
            print("share WXFriends")
            self.Panel_share:setVisible(false)
            local str = laixiaddz.LocalPlayercfg.LaixiaPlayerID.."7kyn@,ey"
            local token = crypto.md5(str)
            local url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token
            local title = "您有一部iPhone X未领取"
            local description ="你来分享我来送，iPhone X、红包等你拿"
            local flag = 0 -- 0 分享好友  1 分享好友圈
            if device.platform == "android" then
                local luaj = require "cocos.cocos2d.luaj"
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "wxShare"
                local javaParams = {title,url ,description,flag }
                local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
                local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                return value
            elseif device.platform == "ios" then--苹果包
                local args = {title = title, Url = url,description=description,flag = flag }
                local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
            end    
        elseif laixia.kconfig.isYingKe == true then
            local str = laixiaddz.LocalPlayercfg.LaixiaPlayerID.."7kyn@,ey"
            local token = crypto.md5(str)
            if device.platform == "ios" then
                local args = {
                                platform = "wechat",
                                title = "您有一部iPhone X未领取",
                                content = "你来分享我来送，iPhone X、红包等你拿",
                                url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                                imageUrl = "http://img2.inke.cn/MTUxNTE1OTgzNzQ2MiMxNTcjanBn.jpg",
                }
                luaoc.callStaticMethod("IKCRLXBridgeManager", "shareToWX", args)
            elseif device.platform == "android" then
                local args = {
                                type = "2",
                                title = "您有一部iPhone X未领取",
                                content = "你来分享我来送，iPhone X、红包等你拿",
                                url = "http://wx.laixia.com/ma?a=share&user_id=".. laixiaddz.LocalPlayercfg.LaixiaPlayerID .."&token="..token,
                                icon = "http://wx.laixia.com/images/iphonex/icon.png"
                }
                local jsonStr = json.encode(args)
                local result = {jsonStr}
                local sig = "(Ljava/lang/String;)V"
                local ok, value = luaj.callStaticMethod(APP_ACTIVITY, "wxShare", result, sig)
            end
            self.Panel_share:setVisible(false)
        end
    end
end

function Activity:onWXClick(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        --分享链接
        local title = "请关注公众号"..laixiaddz.LocalPlayercfg.LaixiaWechatServiceNum
        local Url = "http://wx.laixia.com/download"
        local description ="来下斗地主免费赢大奖，时时赢微信红包！"
        local flag = 0 -- 0 分享好友  1 分享好友圈
        if device.platform == "android" then
            local luaj = require "cocos.cocos2d.luaj"
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "wxShare"
            local javaParams = {title,Url ,description,flag }
            local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            return value
        elseif device.platform == "ios" then--苹果包
            local args = {title = title, Url =Url,description=description,flag = flag }
            local state ,value = luaoc.callStaticMethod("WXinShareManager", "sendLinkContent", args);
            print("wangtianye")
            print(state )
            print(value)
        end
    end
end

function Activity:onHuodongClick2(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.ActivityName[self.mIndex] == "laixianiwota2" then
            local targetPlatform = cc.Application:getInstance():getTargetPlatform()
            if device.platform ==  "android" then 
                local luaj = require "cocos.cocos2d.luaj"
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "joinGroup"
                local javaParams = {"p7F0xwoMQf4aLo46urOcfIDwybt6aSkF"} --来下竞技群
                local javaMethodSig = "(Ljava/lang/String;)Z"
                local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                print(state)
                print(value)
                if state ~= true then
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"安装的版本不支持") 
                end
                return value;
            elseif device.platform == "ios" then
                local luaoc = require("cocos.cocos2d.luaoc")
                local arg = {groupUin="684101446",key="03c228ec69abc24bde0529f74a9f93880e3b9f7cb44e5ebade385e3dbc31267b"}
                local state,value = luaoc.callStaticMethod("GetGeneralInfo", "joinGroup",arg);
                if value=="" then
                    value = 0
                end
                return tonumber(value);
            else    
                return false;
            end 
        end
    end
end

function Activity:onHuodongClick(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.ActivityName[self.mIndex] == "laixianiwota2" or self.ActivityName[self.mIndex] == "qqunfuli" then
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
                    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"安装的版本不支持") 
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
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_SHOP_WINDOW,{buttonType =1}) 
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SHOP_WINDOW)
        elseif self.ActivityName[self.mIndex] == "yingchunjie" or self.ActivityName[self.mIndex] == "yuanxiaojiehuodong"  then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW)
            laixiaddz.LocalPlayercfg.OnReturnFunction = _laixiaddz_EVENT_SHOW_MATCHLIST_WINDOW
            
            -- local CSMatchSignPacket = Packet.new("CSMatchSign", _LAIXIA_PACKET_CS_MatchSignID)
            -- CSMatchSignPacket:setValue("GameID", laixia.config.GameAppID)
            -- laixia.net.sendPacketAndWaiting(CSMatchSignPacket)  

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
        laixiaddz.soundTools.playSound(soundConfig.BUTTON_SOUND.ui_button_open)
        self:destroy() 
    end
end

function Activity:onDestroy()
    laixiaddz.LocalPlayercfg.AdvermentIndex = nil
    if laixiaddz.LocalPlayercfg.isShouchong == true and laixiaddz.LocalPlayercfg.LaixiaIsSign == 1 and laixia.kconfig.isYingKe == false then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FIRSTGIFT_WINDOW)
    else
        laixiaddz.LocalPlayercfg.LaixiaIsSign = 0
    end
end

 
return Activity.new()
