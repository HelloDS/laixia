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

    if (ObjectLocalPlayerData.laixiaddzLastLoginPlatform == 2) then
        rcValue = ObjectLocalPlayerData.laixiaddzPhoneNum;
    else
        if device.platform == "android" then
            if laixiaddz_SDK_CONTROL == 0 then
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
    if (laixiaddz.config.laixiaddz_DEBUG_ACCOUNT) then
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
    id = id or self.laixiaddzRoomID;
    return id == laixiaddz.config.laixiaddz_SUPERROOM_ID and 1 or id;
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
        if laixiaddz_SDK_CONTROL == 0 then
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
    if (laixiaddz.config.laixiaddz_DEBUG_ACCOUNT) then
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
    if laixiaddz.kconfig.isYingKe==true then
        rcValue = 201010
	elseif device.platform == "android" then
	    local javaClassName = APP_ACTIVITY
	    local javaMethodName = "getUMengChannelID"
	    local javaParams = { }
	    local javaMethodSig = "()Ljava/lang/String;"
	    local state, value = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	    rcValue = value 
    elseif device.platform == "ios" then
        if laixiaddz.LocalPlayercfg.CHANNELID~=nil then
            rcValue = tonumber(laixiaddz.LocalPlayercfg.CHANNELID)
        else
        	rcValue = 111267	   
	    end
    end
    return rcValue;   
end

function ObjectLocalPlayerData:getGamePlatformID()
    if laixiaddz.config.isYingKe == true then
        ObjectLocalPlayerData.laixiaddzLastLoginPlatform = 9
        return 9 
    end
    return ObjectLocalPlayerData.laixiaddzLastLoginPlatform;
end 

-- 返回密码
function ObjectLocalPlayerData:getPassword()
    return ObjectLocalPlayerData.laixiaddzPassword;
end

--登录之前，初始化数据
function ObjectLocalPlayerData:initData()
    ObjectLocalPlayerData.laixiaddzPropsData = nil
    ObjectLocalPlayerData.laixiaddzShowActivyWindow = 0
    ObjectLocalPlayerData.laixiaddzContinuousLoginData = nil
    ObjectLocalPlayerData.laixiaddzIsHaveEmil = 0
    ObjectLocalPlayerData.laixiaddzBankruptItemID = nil
    ObjectLocalPlayerData.laixiaddzIsChangeHead = false
    ObjectLocalPlayerData.laixiaddzBenefitsReceiveNum = 0
    ObjectLocalPlayerData.laixiaddzIsInMatch = false
    ObjectLocalPlayerData.laixiaddzRankingData = nil     --排行榜数据(金)
    ObjectLocalPlayerData.laixiaddzisConnectCardTable = false
    ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoom = {}
    ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoomCoupon = {}
    ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoomMatch = {}
    ObjectLocalPlayerData.laixiaddzBroadCastInInHall = {}
    ObjectLocalPlayerData.laixiaddzBenefitsMaxNum = 0
 
end 
-- 心-跳-时-间-戳
ObjectLocalPlayerData.laixiaddzHeartBeatTime = 0 
ObjectLocalPlayerData.laixiaddzIsChangeHead = false         --更换头像使用

--保存進入商城之前的界面

ObjectLocalPlayerData.OnReturnFunction = _laixiaddz_EVENT_SHOW_HALL_WINDOW  --上面公共条回退消息，默认是回大厅
ObjectLocalPlayerData.laixiaddzBenefitsReceiveNum = 0      --救济金剩余次数 
ObjectLocalPlayerData.laixiaddzBenefitsMaxNum = 0      --救济金最大次数
ObjectLocalPlayerData.laixiaddzIsDisplayGameNotice = true      --是登录后否显示公告

--充值界面显示
ObjectLocalPlayerData.laixiaddzIsShowPayWindow = true  --是否显示充值界面
ObjectLocalPlayerData.laixiaddzPayType=0 --充值类型 --微信1支付宝为2
-- 登--陆
ObjectLocalPlayerData.laixiaddzPhoneNumTMP = ""
ObjectLocalPlayerData.laixiaddzPasswordTMP = ""
ObjectLocalPlayerData.laixiaddzUserID = "Visitor"; -- 游客 
ObjectLocalPlayerData.laixiaddzLastLoginPlatform = 4;  -- 上次请求登录的platform 1 游客 2 手机4.为微博 6为微游戏   7 小米
ObjectLocalPlayerData.laixiaddzHeadPortraitPath = ""
ObjectLocalPlayerData.laixiaddzPassword = ""
ObjectLocalPlayerData.laixiaddzTokenID = ""
ObjectLocalPlayerData.laixiaddzPhoneNum = ""
-- 声-音开关设-置
ObjectLocalPlayerData.laixiaddzSoundOn = laixiaddz.config.laixiaddz_SoundOn
--设置屏幕亮度
ObjectLocalPlayerData.laixiaddzScreenBright = 115  --屏幕亮度
--ObjectLocalPlayerData.laixiaddzMusicValue = 0.5  --音量
--ObjectLocalPlayerData.laixiaddzSoundValue = 0.5   --音效

ObjectLocalPlayerData.laixiaddzMusicValue = 1  --音量
ObjectLocalPlayerData.laixiaddzSoundValue = 1   --音效
ObjectLocalPlayerData.laixiaddzZhendong = true --震动


ObjectLocalPlayerData.laixiaddzTCPSever = laixiaddz.config.laixiaddz_TCP_SERVER_ADDRESS;
ObjectLocalPlayerData.laixiaddzHttpCode = 0

ObjectLocalPlayerData.LaixiaPlayerID = 0  -- playerID,目前放在cfg中
ObjectLocalPlayerData.laixiaddzExperience = 0  -- 经验
-- 进入游戏大厅
ObjectLocalPlayerData.laixiaddzPlayerGender = 0 -- 0男，1女
ObjectLocalPlayerData.laixiaddzPlayerGold = 0  --金
ObjectLocalPlayerData.MatchGold = 0 --比赛金币数
ObjectLocalPlayerData.laixiaddzPlayerNickname = ""
ObjectLocalPlayerData.laixiaddzPlayerGiftCoupon = 0 -- 奖券
ObjectLocalPlayerData.laixiaddzPlayerLevel = 0
ObjectLocalPlayerData.laixiaddzPlayerTitle = ""
ObjectLocalPlayerData.laixiaddzPlayerCheckExp = 0  -- 当前所在等级的升级条件
ObjectLocalPlayerData.laixiaddzPlayerNextLevelExp = 0  -- 下一级所需条件
ObjectLocalPlayerData.laixiaddzPlayerShengLv = 0  -- 胜率
-- 站内信
ObjectLocalPlayerData.laixiaddzIsHaveEmil = 0-- 当前是否有新站内信 (0没有，1有,2有,3有)
-- 个人中心
ObjectLocalPlayerData.laixiaddzPlayerMaxWintimes = 0                                     -- 最大赢取
ObjectLocalPlayerData.laixiaddzPlayerVictoryTimes = 0                                     -- 总胜利次数
ObjectLocalPlayerData.laixiaddzPlayerFailureTimes = 0                                     -- 总失败次数
ObjectLocalPlayerData.laixiaddzPlayerGeXingqianming = "string"  -- 个性签名
ObjectLocalPlayerData.laixiaddzPlayerHeadPicture = nil       -- 刚选择的头像
ObjectLocalPlayerData.laixiaddzPlayerHeadUse = nil  -- 在使用的头像
-- 本次登陆是否签到
ObjectLocalPlayerData.laixiaddzContinuousLoginData = nil  --签到具体数据
--排行榜
ObjectLocalPlayerData.laixiaddzRankingData = nil     --排行榜数据(金)
-- 道具包裹
ObjectLocalPlayerData.laixiaddzPropsData = nil   -- 道具数据
ObjectLocalPlayerData.laixiaddzShowActivyWindow = 0
ObjectLocalPlayerData.laixiaddzBankruptItemID = nil
-- 广播
ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoom = {}
ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoomCoupon = {}
ObjectLocalPlayerData.laixiaddzBroadCastInPokerRoomMatch = {}
ObjectLocalPlayerData.laixiaddzBroadCastInInHall = {}
-- 游戏中
ObjectLocalPlayerData.laixiaddzRoomID = 0;        
ObjectLocalPlayerData.laixiaddzMySeat = -1;               -- 记录自己的座位号
ObjectLocalPlayerData.laixiaddzLandlordSeat = -1;     -- 记录地主的座位号
ObjectLocalPlayerData.laixiaddzCurrentWindow = nil            --当前显示的层
ObjectLocalPlayerData.laixiaddzCurrentNomarlWindow = nil      --当前二级界面
ObjectLocalPlayerData.laixiaddzOutCards = nil                --出的牌数据
ObjectLocalPlayerData.laixiaddzOutCardsIndex = nil           --出的牌值
ObjectLocalPlayerData.laixiaddzLaiziReplaceCards = {}        --癞子牌的值
ObjectLocalPlayerData.laixiaddzOutCardsCount = 0             --三家连续不出牌次数  
ObjectLocalPlayerData.laixiaddzInGolds = nil                   --牌桌携带金数
ObjectLocalPlayerData.laixiaddzisConnectCardTable = false      --是否连上牌桌
ObjectLocalPlayerData.laixiaddzIsShake = 2
-----------------------------------------------自建桌
--自建桌数据
ObjectLocalPlayerData.laixiaddzSelfBuildIntegral = 0   -- 自建房积分
ObjectLocalPlayerData.laixiaddzSelfBuildTable = -1  --自建桌ID
ObjectLocalPlayerData.laixiaddzSelfInning = 0  --自建桌当前局数
ObjectLocalPlayerData.laixiaddzSelfTotalInning = 0 -- 自建桌总局数
-----------------------------------------------比赛数据
ObjectLocalPlayerData.laixiaddzMatchdata ={}     --比赛列表数据
ObjectLocalPlayerData.laixiaddzIsInMatch = false  --比赛loading界面的显示判断 也是牌桌内发送牌桌消息的判断
ObjectLocalPlayerData.laixiaddzGamePageType =0 --记录比赛的类型，大奖赛还是常规赛 2是常规赛1是大奖赛
ObjectLocalPlayerData.laixiaddzGameListIndex = 0 --读取数据的排序
ObjectLocalPlayerData.laixiaddzMatchRoomType =-1  --比赛房间类型  1.人满开赛，0 定时开赛
ObjectLocalPlayerData.laixiaddzMatchRoom =nil  --比赛房间id
ObjectLocalPlayerData.laixiaddzMatchLimit =0  --人满开赛时候人数限制
ObjectLocalPlayerData.laixiaddzMatchID =0 --比赛ID
ObjectLocalPlayerData.laixiaddzJoinMatch = false --确认参与比赛退出牌桌，退出比赛用  --data ：09、10
ObjectLocalPlayerData.laixiaddzMatchRank= 0  --当前名次
ObjectLocalPlayerData.laixiaddzMatchTotalNum =0  --总人数
ObjectLocalPlayerData.laixiaddzIsShowMatchRank= true --排行和奖励方案切换
ObjectLocalPlayerData.laixiaddzMatchIntegral= 0  --积分
ObjectLocalPlayerData.laixiaddzMatchLastRoom = 0 --定时比赛退出比赛时候的保存地址
ObjectLocalPlayerData.laixiaddzMatchStage = 0  --保存比赛的同步阶段，用于在阶段变化的时候牌桌显示
ObjectLocalPlayerData.laixiaddzMatchlastStage=1  --保存上一局的阶段
ObjectLocalPlayerData.laixiaddzMatchShowbar = false
ObjectLocalPlayerData.laixiaddzMatchRoundNum = 0 --用于判断第几阶段
-----------------------------------------------比赛数据
ObjectLocalPlayerData.laixiaddzMatchName ="" -- 比赛名称
ObjectLocalPlayerData.laixiaddzisMatchDetail= false -- 是否是比赛详情页，用于定时开赛，并且在人满开赛已经报名的情况下
ObjectLocalPlayerData.laixiaddzMatchVerification = false
ObjectLocalPlayerData.laixiaddzMatchquite= false --false 代表不是比赛退出， true代表比赛退出
ObjectLocalPlayerData.laixiaddzMatchDifen= 0-- 比赛底分
-------------------------------------------------
---新增字段
ObjectLocalPlayerData.laixiaddzWechatServiceNum = "laixia"
ObjectLocalPlayerData.laixiaddzBisaiNum = 0
ObjectLocalPlayerData.laixiaddzBisaiWin = 0
ObjectLocalPlayerData.laixiaddzIsSign = 0   --判断是否是第一次denglu
ObjectLocalPlayerData.laixiaddzBisaiSecond = 0
ObjectLocalPlayerData.AdvermentIndex = nil  -- 轮播图
ObjectLocalPlayerData.ZhiShiBiNum = 0   -- 芝士币数量
ObjectLocalPlayerData.laixiaddzisSNG = false  -- 是否是SNG的比赛
--背包红点保存
ObjectLocalPlayerData.laixiaddzBagisShow = false
--保存是否托管的状态
ObjectLocalPlayerData.laixiaddzisTrusteeship = false
ObjectLocalPlayerData.PluginChannel = nil
ObjectLocalPlayerData.isShouchong = false --首充
ObjectLocalPlayerData.NowRankinSNG = 2
ObjectLocalPlayerData.laixiaddzTaskList = {}

-- 写入_G.SharedData数据
function ObjectLocalPlayerData:WriteData()

    local savadata = { };
    savadata.Phone = ObjectLocalPlayerData.laixiaddzPhoneNum
    savadata.Password = ObjectLocalPlayerData.laixiaddzPassword
    if laixiaddz.config.isYingKe == true then
        savadata.LastLoginPlatform = 9 
    else
        savadata.LastLoginPlatform = ObjectLocalPlayerData.laixiaddzLastLoginPlatform
    end
    local cjson = require("json")
    -- 转成json
    local jsonData = cjson.encode(savadata)
    print("SaveSharedData : " .. jsonData)
    -- jsonData = DataEncode(jsonData)
    cc.UserDefault:getInstance():setStringForKey("SharedData", jsonData)
    cc.UserDefault:getInstance():flush()
     if ObjectLocalPlayerData.laixiaddzScreenBright == nil then
       ObjectLocalPlayerData.laixiaddzScreenBright = 115
    end
     if ObjectLocalPlayerData.laixiaddzMusicValue == nil then 
      ObjectLocalPlayerData.laixiaddzMusicValue = 1
    end
    if ObjectLocalPlayerData.laixiaddzSoundValue == nil then 
      ObjectLocalPlayerData.laixiaddzSoundValue = 1
    end
    
    savadata.laixiaddzMusicValue = ObjectLocalPlayerData.laixiaddzMusicValue 
    savadata.laixiaddzSoundValue = ObjectLocalPlayerData.laixiaddzSoundValue 
    savadata.laixiaddzScreenBright = ObjectLocalPlayerData.laixiaddzScreenBright 
     local cjson = require("json")
    -- 转成json
    local jsonData = cjson.encode(savadata)
    print("SaveSharedData : " .. jsonData)
    cc.UserDefault:getInstance():setStringForKey("SharedData", jsonData)
    cc.UserDefault:getInstance():flush()
end


-- 快速开始
return ObjectLocalPlayerData
