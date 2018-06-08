-- 创建本地的数据保存。可以保存一些数据
-- local PlayerDataType = {}

 
local APP_ENV = APP_ENV;
local luaj = APP_ENV.luaj;


local ObjectLocalPlayerData = { }

--获取VersionCode
function ObjectLocalPlayerData:getAppVersionCode()        
    if targetPlatform ==  3 then                    
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getAppVersionCode"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"	    
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        if value=="" then
            value = 0
        end
        return tonumber(value);
    elseif(targetPlatform ==  4 or targetPlatform ==  5)then
        local luaoc = require("cocos.cocos2d.luaoc")
        local state,value = luaoc.callStaticMethod("GetGeneralInfo", "getAppVersionCode");
        if value=="" then
            value = 0
        end
        return tonumber(value);
    else
        return 0;
    end
end

--获取安卓版本
function ObjectLocalPlayerData:getAndroidVersion()
    if targetPlatform ==  3 then
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getAndroidVersion"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"	    
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return value;
    elseif(targetPlatform ==  4 or targetPlatform ==  5)then
        local state,value = luaoc.callStaticMethod("GetGeneralInfo", "getSystemVersionCode");
        return value;
    else
        return "";
    end
end

-- 取得账号ID
function ObjectLocalPlayerData:getAccountID()
    local rcValue = "";

    if (ObjectLocalPlayerData.LaixiaLastLoginPlatform == 2) then
        rcValue = ObjectLocalPlayerData.LaixiaPhoneNum;
    else
        if device.platform == "android" then
            if LAIXIA_SDK_CONTROL == 0 then
                --local luaj = require "cocos.cocos2d.luaj"
                local javaClassName = APP_ACTIVITY
                local javaMethodName = "getUtdid"
                local javaParams = { }
                local javaMethodSig = "()Ljava/lang/String;"
                local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                rcValue = value
            end
        elseif device.platform == "ios" then
    	  		local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "getIDFV");
    	  		rcValue = ret
    		else
            rcValue = device.getOpenUDID();
        end
    end
    print("return value:" .. rcValue);
    if (laixia.config.LAIXIA_DEBUG_ACCOUNT) then
        rcValue = rcValue .. "-" .. tostring(os.time());
    end
    if(rcValue==nil or rcValue=="" or rcValue==-3) then 
 	
        if device.platform == "android" then
     			local javaClassName = APP_ACTIVITY
                local javaMethodName = "jni_GetDeviceID"
                local javaParams = { }
                local javaMethodSig = "()Ljava/lang/String;"
                local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
                rcValue = value
        end
    end  
    return rcValue;
end  
 



function ObjectLocalPlayerData:room_query_Id(id)
    id = id or self.LaixiaRoomID;
    return id == laixia.config.LAIXIA_SUPERROOM_ID and 1 or id;
end 
-- 返回手机的设备类型
function ObjectLocalPlayerData:getMobileInfo()
    local rcValue = "huawei-6p";
    if device.platform == "android" then
        local javaClassName = APP_ACTIVITY
        local javaMethodName = "jni_GetDeviceName"
        local javaParams = { }
        local javaMethodSig = "()Ljava/lang/String;"
        local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)

        rcValue = value
    elseif device.platform == "ios" then
    		local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "getPhoneModel", args);
        rcValue = ret
    end

    return rcValue
end 


function ObjectLocalPlayerData:getUtdid()
    local rcValue = "";
    if device.platform == "android" then
        if LAIXIA_SDK_CONTROL == 0 then
            local javaClassName = APP_ACTIVITY
            local javaMethodName = "getUtdid"
            local javaParams = { }
            local javaMethodSig = "()Ljava/lang/String;"
            local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
            rcValue = value
        end
    elseif device.platform == "ios" then
    	  local ok,ret = luaoc.callStaticMethod("GetGeneralInfo", "getIDFV");
    	  rcValue = ret
    else
        rcValue = device.getOpenUDID();
    end
    if (laixia.config.LAIXIA_DEBUG_ACCOUNT) then
        rcValue = rcValue .. "-" .. tostring(os.time());
    end
    return rcValue
end

function ObjectLocalPlayerData:getIMEI()
    local rcValue = "123456789012345";
    if device.platform == "android"then            
--        local luaj = require "cocos.cocos2d.luaj"
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getStaticIMEI"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"	    
        local state,value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
        return value;
        -- return rcValue;
    else    
        return rcValue;
    end 	
end 
-- 取得渠道ID
function ObjectLocalPlayerData.getumengChannelID()    
    local rcValue = "0";
    if laixia.kconfig.isYingKe==true then
        rcValue = 201010
	elseif device.platform == "android" then
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getUMengChannelID"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"
	    local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	    rcValue = value 
    elseif device.platform == "ios" then
        if laixia.LocalPlayercfg.CHANNELID~=nil then
            rcValue = tonumber(laixia.LocalPlayercfg.CHANNELID)
        else
        	rcValue = 111267	   
	    end
    end
    return rcValue;   
end

function ObjectLocalPlayerData:getGamePlatformID()
    if laixia.config.isYingKe == true then
        ObjectLocalPlayerData.LaixiaLastLoginPlatform = 9
        return 9 
    end
    return ObjectLocalPlayerData.LaixiaLastLoginPlatform;
end 

-- 返回密码
function ObjectLocalPlayerData:getPassword()
    return ObjectLocalPlayerData.LaixiaPassword;
end

--登录之前，初始化数据
function ObjectLocalPlayerData:initData()
    ObjectLocalPlayerData.LaixiaPropsData = nil
    ObjectLocalPlayerData.LaixiaShowActivyWindow = 0
    ObjectLocalPlayerData.LaixiaContinuousLoginData = nil
    ObjectLocalPlayerData.LaixiaIsHaveEmil = 0
    ObjectLocalPlayerData.LaixiaBankruptItemID = nil
    ObjectLocalPlayerData.LaixiaIsChangeHead = false
    ObjectLocalPlayerData.LaixiaBenefitsReceiveNum = 0
    ObjectLocalPlayerData.LaixiaIsInMatch = false
    ObjectLocalPlayerData.LaixiaRankingData = nil     --排行榜数据(金)
    ObjectLocalPlayerData.LaixiaisConnectCardTable = false
    ObjectLocalPlayerData.LaixiaBroadCastInPokerRoom = {}
    ObjectLocalPlayerData.LaixiaBroadCastInPokerRoomCoupon = {}
    ObjectLocalPlayerData.LaixiaBroadCastInPokerRoomMatch = {}
    ObjectLocalPlayerData.LaixiaBroadCastInInHall = {}
    ObjectLocalPlayerData.LaixiaBenefitsMaxNum = 0
 
end 
-- 心-跳-时-间-戳
ObjectLocalPlayerData.LaixiaHeartBeatTime = 0 
ObjectLocalPlayerData.LaixiaIsChangeHead = false         --更换头像使用

--保存進入商城之前的界面

ObjectLocalPlayerData.OnReturnFunction = _LAIXIA_EVENT_SHOW_HALL_WINDOW  --上面公共条回退消息，默认是回大厅
ObjectLocalPlayerData.LaixiaBenefitsReceiveNum = 0      --救济金剩余次数 
ObjectLocalPlayerData.LaixiaBenefitsMaxNum = 0      --救济金最大次数
ObjectLocalPlayerData.LaixiaIsDisplayGameNotice = true      --是登录后否显示公告

--充值界面显示
ObjectLocalPlayerData.LaixiaIsShowPayWindow = true  --是否显示充值界面
ObjectLocalPlayerData.LaixiaPayType=0 --充值类型 --微信1支付宝为2
-- 登--陆
ObjectLocalPlayerData.LaixiaPhoneNumTMP = ""
ObjectLocalPlayerData.LaixiaPasswordTMP = ""
ObjectLocalPlayerData.LaixiaUserID = "Visitor"; -- 游客 
ObjectLocalPlayerData.LaixiaLastLoginPlatform = 4;  -- 上次请求登录的platform 1 游客 2 手机4.为微博 6为微游戏   7 小米
ObjectLocalPlayerData.LaixiaHeadPortraitPath = ""
ObjectLocalPlayerData.LaixiaPassword = ""
ObjectLocalPlayerData.LaixiaTokenID = ""
ObjectLocalPlayerData.LaixiaPhoneNum = ""
-- 声-音开关设-置
ObjectLocalPlayerData.LaixiaSoundOn = laixia.config.Laixia_SoundOn
--设置屏幕亮度
ObjectLocalPlayerData.LaixiaScreenBright = 115  --屏幕亮度
--ObjectLocalPlayerData.LaixiaMusicValue = 0.5  --音量
--ObjectLocalPlayerData.LaixiaSoundValue = 0.5   --音效

ObjectLocalPlayerData.LaixiaMusicValue = 1  --音量
ObjectLocalPlayerData.LaixiaSoundValue = 1   --音效
ObjectLocalPlayerData.LaixiaZhendong = true --震动


ObjectLocalPlayerData.LaixiaTCPSever = laixia.config.LAIXIA_TCP_SERVER_ADDRESS;
ObjectLocalPlayerData.LaixiaHttpCode = 0

ObjectLocalPlayerData.LaixiaPlayerID = 0  -- playerID,目前放在cfg中
ObjectLocalPlayerData.LaixiaExperience = 0  -- 经验
-- 进入游戏大厅
ObjectLocalPlayerData.LaixiaPlayerGender = 0 -- 0男，1女
ObjectLocalPlayerData.LaixiaPlayerGold = 0  --金
ObjectLocalPlayerData.MatchGold = 0 --比赛金币数
ObjectLocalPlayerData.LaixiaPlayerNickname = ""
ObjectLocalPlayerData.LaixiaPlayerGiftCoupon = 0 -- 奖券
ObjectLocalPlayerData.LaixiaPlayerLevel = 0
ObjectLocalPlayerData.LaixiaPlayerTitle = ""
ObjectLocalPlayerData.LaixiaPlayerCheckExp = 0  -- 当前所在等级的升级条件
ObjectLocalPlayerData.LaixiaPlayerNextLevelExp = 0  -- 下一级所需条件
ObjectLocalPlayerData.LaixiaPlayerShengLv = 0  -- 胜率
-- 站内信
ObjectLocalPlayerData.LaixiaIsHaveEmil = 0-- 当前是否有新站内信 (0没有，1有,2有,3有)
-- 个人中心
ObjectLocalPlayerData.LaixiaPlayerMaxWintimes = 0                                     -- 最大赢取
ObjectLocalPlayerData.LaixiaPlayerVictoryTimes = 0                                     -- 总胜利次数
ObjectLocalPlayerData.LaixiaPlayerFailureTimes = 0                                     -- 总失败次数
ObjectLocalPlayerData.LaixiaPlayerGeXingqianming = "string"  -- 个性签名
ObjectLocalPlayerData.LaixiaPlayerHeadPicture = nil       -- 刚选择的头像
ObjectLocalPlayerData.LaixiaPlayerHeadUse = nil  -- 在使用的头像
-- 本次登陆是否签到
ObjectLocalPlayerData.LaixiaContinuousLoginData = nil  --签到具体数据
--排行榜
ObjectLocalPlayerData.LaixiaRankingData = nil     --排行榜数据(金)
-- 道具包裹
ObjectLocalPlayerData.LaixiaPropsData = nil   -- 道具数据
ObjectLocalPlayerData.LaixiaShowActivyWindow = 0
ObjectLocalPlayerData.LaixiaBankruptItemID = nil
-- 广播
ObjectLocalPlayerData.LaixiaBroadCastInPokerRoom = {}
ObjectLocalPlayerData.LaixiaBroadCastInPokerRoomCoupon = {}
ObjectLocalPlayerData.LaixiaBroadCastInPokerRoomMatch = {}
ObjectLocalPlayerData.LaixiaBroadCastInInHall = {}
-- 游戏中
ObjectLocalPlayerData.LaixiaRoomID = 0;        
ObjectLocalPlayerData.LaixiaMySeat = -1;               -- 记录自己的座位号
ObjectLocalPlayerData.LaixiaLandlordSeat = -1;     -- 记录地主的座位号
ObjectLocalPlayerData.LaixiaCurrentWindow = nil            --当前显示的层
ObjectLocalPlayerData.LaixiaCurrentNomarlWindow = nil      --当前二级界面
ObjectLocalPlayerData.LaixiaOutCards = nil                --出的牌数据
ObjectLocalPlayerData.LaixiaOutCardsIndex = nil           --出的牌值
ObjectLocalPlayerData.LaixiaLaiziReplaceCards = {}        --癞子牌的值
ObjectLocalPlayerData.LaixiaOutCardsCount = 0             --三家连续不出牌次数  
ObjectLocalPlayerData.LaixiaInGolds = nil                   --牌桌携带金数
ObjectLocalPlayerData.LaixiaisConnectCardTable = false      --是否连上牌桌
ObjectLocalPlayerData.LaixiaIsShake = 2
-----------------------------------------------自建桌
--自建桌数据
ObjectLocalPlayerData.LaixiaSelfBuildIntegral = 0   -- 自建房积分
ObjectLocalPlayerData.LaixiaSelfBuildTable = -1  --自建桌ID
ObjectLocalPlayerData.LaixiaSelfInning = 0  --自建桌当前局数
ObjectLocalPlayerData.LaixiaSelfTotalInning = 0 -- 自建桌总局数
-----------------------------------------------比赛数据
ObjectLocalPlayerData.LaixiaMatchdata ={}     --比赛列表数据
ObjectLocalPlayerData.LaixiaIsInMatch = false  --比赛loading界面的显示判断 也是牌桌内发送牌桌消息的判断
ObjectLocalPlayerData.LaixiaGamePageType =0 --记录比赛的类型，大奖赛还是常规赛 2是常规赛1是大奖赛
ObjectLocalPlayerData.LaixiaGameListIndex = 0 --读取数据的排序
ObjectLocalPlayerData.LaixiaMatchRoomType =-1  --比赛房间类型  1.人满开赛，0 定时开赛
ObjectLocalPlayerData.LaixiaMatchRoom =nil  --比赛房间id
ObjectLocalPlayerData.LaixiaMatchLimit =0  --人满开赛时候人数限制
ObjectLocalPlayerData.LaixiaMatchID =0 --比赛ID
ObjectLocalPlayerData.LaixiaJoinMatch = false --确认参与比赛退出牌桌，退出比赛用  --data ：09、10
ObjectLocalPlayerData.LaixiaMatchRank= 0  --当前名次
ObjectLocalPlayerData.LaixiaMatchTotalNum =0  --总人数
ObjectLocalPlayerData.LaixiaIsShowMatchRank= true --排行和奖励方案切换
ObjectLocalPlayerData.LaixiaMatchIntegral= 0  --积分
ObjectLocalPlayerData.LaixiaMatchLastRoom = 0 --定时比赛退出比赛时候的保存地址
ObjectLocalPlayerData.LaixiaMatchStage = 0  --保存比赛的同步阶段，用于在阶段变化的时候牌桌显示
ObjectLocalPlayerData.LaixiaMatchlastStage=1  --保存上一局的阶段
ObjectLocalPlayerData.LaixiaMatchShowbar = false
ObjectLocalPlayerData.LaixiaMatchRoundNum = 0 --用于判断第几阶段
-----------------------------------------------比赛数据
ObjectLocalPlayerData.LaixiaMatchName ="" -- 比赛名称
ObjectLocalPlayerData.LaixiaisMatchDetail= false -- 是否是比赛详情页，用于定时开赛，并且在人满开赛已经报名的情况下
ObjectLocalPlayerData.LaixiaMatchVerification = false
ObjectLocalPlayerData.LaixiaMatchquite= false --false 代表不是比赛退出， true代表比赛退出
ObjectLocalPlayerData.LaixiaMatchDifen= 0-- 比赛底分
-------------------------------------------------
---新增字段
ObjectLocalPlayerData.LaixiaWechatServiceNum = ""
ObjectLocalPlayerData.LaixiaBisaiNum = 0
ObjectLocalPlayerData.LaixiaBisaiWin = 0
ObjectLocalPlayerData.LaixiaIsSign = 0   --判断是否是第一次denglu
ObjectLocalPlayerData.LaixiaBisaiSecond = 0
ObjectLocalPlayerData.AdvermentIndex = nil  -- 轮播图
ObjectLocalPlayerData.ZhiShiBiNum = 0   -- 芝士币数量
ObjectLocalPlayerData.LaixiaisSNG = false  -- 是否是SNG的比赛
--背包红点保存
ObjectLocalPlayerData.LaixiaBagisShow = false
--保存是否托管的状态
ObjectLocalPlayerData.LaixiaisTrusteeship = false
ObjectLocalPlayerData.PluginChannel = nil
ObjectLocalPlayerData.isShouchong = false --首充
ObjectLocalPlayerData.NowRankinSNG = 2
ObjectLocalPlayerData.LaixiaTaskList = {}

-- 写入_G.SharedData数据
function ObjectLocalPlayerData:WriteData()

    local savadata = { };
    savadata.Phone = ObjectLocalPlayerData.LaixiaPhoneNum
    savadata.Password = ObjectLocalPlayerData.LaixiaPassword
    if laixia.config.isYingKe == true then
        savadata.LastLoginPlatform = 9 
    else
        savadata.LastLoginPlatform = ObjectLocalPlayerData.LaixiaLastLoginPlatform
    end
    local cjson = require("json")
    -- 转成json
    local jsonData = cjson.encode(savadata)
    print("SaveSharedData : " .. jsonData)
    -- jsonData = DataEncode(jsonData)
    cc.UserDefault:getInstance():setStringForKey("SharedData", jsonData)
    cc.UserDefault:getInstance():flush()
     if ObjectLocalPlayerData.LaixiaScreenBright == nil then
       ObjectLocalPlayerData.LaixiaScreenBright = 115
    end
     if ObjectLocalPlayerData.LaixiaMusicValue == nil then 
      ObjectLocalPlayerData.LaixiaMusicValue = 1
    end
    if ObjectLocalPlayerData.LaixiaSoundValue == nil then 
      ObjectLocalPlayerData.LaixiaSoundValue = 1
    end
    
    savadata.LaixiaMusicValue = ObjectLocalPlayerData.LaixiaMusicValue 
    savadata.LaixiaSoundValue = ObjectLocalPlayerData.LaixiaSoundValue 
    savadata.LaixiaScreenBright = ObjectLocalPlayerData.LaixiaScreenBright 
     local cjson = require("json")
    -- 转成json
    local jsonData = cjson.encode(savadata)
    print("SaveSharedData : " .. jsonData)
    cc.UserDefault:getInstance():setStringForKey("SharedData", jsonData)
    cc.UserDefault:getInstance():flush()
end


-- 快速开始
return ObjectLocalPlayerData
