require "common.game.anysdkConst"
local PluginChannel = class("PluginChannel")
local user_plugin = nil
local iap_plugin_maps = nil
local CallBack = nil
local share_plugin = nil
local analytics_plugin = nil
local PayPluginId = nil

--local app_platform_num = {
--    {"160100","探娱"},
--    {"000255","UC"}
--}

function PluginChannel:onUserResult(code, msg )
    print("pluginChannel ---code")
    print(code)
    print(msg)
    if code == UserActionResultCode.kInitSuccess then

    elseif code == UserActionResultCode.kInitFail then

    elseif code == UserActionResultCode.kLoginSuccess then --登录成功
        local data={}
        data = stringSplit(msg,"@")
        USER_ID=data[1]
        TOKEN=data[2]
        HEADIMAGE = data[3]
        CallBack(true)
    elseif code == UserActionResultCode.kLoginNetworkError then
        CallBack(false)
    elseif code == UserActionResultCode.kLoginNoNeed then
        CallBack(false)
    elseif code == UserActionResultCode.kLoginFail then
        CallBack(false)
    elseif code == UserActionResultCode.kLoginCancel then
        CallBack(false)
    elseif code == UserActionResultCode.kLogoutSuccess then
        CallBack(false)
    elseif code == UserActionResultCode.kLogoutFail then
        CallBack(false)
    elseif code == UserActionResultCode.kPlatformEnter then
    --do
    elseif code == UserActionResultCode.kPlatformBack then
    --do
    elseif code == UserActionResultCode.kPausePage then
    --do
    elseif code == UserActionResultCode.kExitPage then
--        System.exit(0);
          os.exit()
--        if nil ~= user_plugin and user_plugin:isFunctionSupported("exit") then
--            user_plugin:callFuncWithParam("exit");
--        end
    elseif code == UserActionResultCode.kAntiAddictionQuery then
    --do
    elseif code == UserActionResultCode.kRealNameRegister then
    --do
    elseif code == UserActionResultCode.kAccountSwitchSuccess then
    --do
    elseif code == UserActionResultCode.kAccountSwitchFail then
    --do
    elseif code == UserActionResultCode.kOpenShop then
    --do
    end
end

function PluginChannel:onPayResult( code, msg )
    print("pluginChannel ==-onPayResult--code")
    print(code)
    print(msg)
    local codeToString = tostring(code)
    if code == PayResultCode.kPaySuccess or codeToString == "pay success" or code == "0" then
         CallBack(true)
         return
    elseif code == PayResultCode.kPayFail then
         CallBack(false)
    elseif code == PayResultCode.kPayCancel then
         CallBack(false)
    elseif code == PayResultCode.kPayNetworkError then
         CallBack(false)
    elseif code == PayResultCode.kPayProductionInforIncomplete then
        CallBack(false)
    elseif code == PayResultCode.kPayInitSuccess then
        
    elseif code == PayResultCode.kPayInitFail then
        CallBack(false)
    elseif code == PayResultCode.kPayNowPaying then
        CallBack(false)
    elseif code == PayResultCode.kPayRechargeSuccess then
        CallBack(false)
    end


end

function PluginChannel:onShareResult(code, msg)
    if code == ShareResultCode.kShareSuccess then
        CallBack(true)
    elseif code == ShareResultCode.kShareFail then
        CallBack(false)
    elseif code == ShareResultCode.kShareCancel then
        CallBack(false)
    elseif code == ShareResultCode.kShareNetworkError then
        CallBack(false)
    end
end
function PluginChannel.create()
    local model = PluginChannel.new()

    return model
end
function PluginChannel:ctor()
    --for plugin
    local agent
    if laixia.kconfig.isYingKe ~=  true then
        agent = AgentManager:getInstance()

        --init
        --plugin //c++层初始化
        local appKey = "4F0C4EB2-040C-5E50-8140-7816E4560ADA";
        local appSecret = "5b420d9582d3ee9b0753706f69bc3b45";
        local privateKey = "0826544992DB311579B1734E3C4720E1";

        local oauthLoginServer = laixia.config.ServerURL.."OAuth";
        agent:init(appKey,appSecret,privateKey,oauthLoginServer)
        --load
        agent:loadAllPlugins()
    end

    if laixia.kconfig.isYingKe==true then
        laixiaddz.LocalPlayercfg.CHANNELID = 201010
    else
        laixiaddz.LocalPlayercfg.CHANNELID = agent:getChannelId();
    end

    if laixia.kconfig.isYingKe ~= true then
        -- get user plugin
        user_plugin = agent:getUserPlugin()
        if user_plugin ~= nil then
            user_plugin:setActionListener(self.onUserResult)
        end
        iap_plugin_maps = agent:getIAPPlugin()
        for key, value in pairs(iap_plugin_maps) do
            value:setResultListener(self.onPayResult)
        end
        agent:setIsAnaylticsEnabled(true)

        share_plugin = agent:getSharePlugin()
        if share_plugin ~= nil then
            share_plugin:setResultListener(self.onShareResult)
        end
        analytics_plugin = agent:getAnalyticsPlugin()
    end
end
function PluginChannel:setEndCallBack(callback)
    CallBack = nil
    CallBack=callback
end
function PluginChannel:isLogined()
    local islogined=false
    if user_plugin ~= nil then
        islogined = user_plugin:isLogined()
    end
    return islogined;
end

function PluginChannel:getUserID()
    if user_plugin ~= nil then
        return user_plugin:getUserID();
    end
    return 0
end
function PluginChannel:login()
    if user_plugin ~= nil then
        user_plugin:setActionListener(self.onUserResult)
        user_plugin:login()
    end
end

function PluginChannel:logout()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("logout") then
            user_plugin:callFuncWithParam("logout")
        end
    end
end
function PluginChannel:exit()
    if nil ~= user_plugin and user_plugin:isFunctionSupported("exit") then
        user_plugin:callFuncWithParam("exit");
    end
end
function PluginChannel:enterPlatform()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("enterPlatform") then
            user_plugin:callFuncWithParam("enterPlatform")
        end
    end
end

function PluginChannel:showToolBar()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("showToolBar") then
            local param1 = PluginParam:create(ToolBarPlace.kToolBarMidLeft)
            user_plugin:callFuncWithParam("showToolBar", param1)
        end
    end
end

function PluginChannel:hideToolBar()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("hideToolBar") then
            user_plugin:callFuncWithParam("hideToolBar")
        end
    end
end

function PluginChannel:accountSwitch()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("accountSwitch") then
            user_plugin:callFuncWithParam("accountSwitch")
        end
    end
end

function PluginChannel:realNameRegister()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("realNameRegister") then
            user_plugin:callFuncWithParam("realNameRegister")
        end
    end
end

function PluginChannel:antiAddictionQuery()
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("antiAddictionQuery") then
            user_plugin:callFuncWithParam("antiAddictionQuery")
        end
    end
end

function PluginChannel:submitLoginGameRole(netData)
    if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("submitLoginGameRole") then
            local data = PluginParam:create({
                roleId = netData.roleId,
                roleName= netData.roleName,
                roleLevel = netData.roleLevel,
                zoneId = netData.zoneId,
                zoneName =   netData.zoneName,
                roleCTime =  netData.roleCTime,
                roleLevelMTime = netData.roleLevelMTime,
                dataType = netData.dataType,
                ext=""})
            user_plugin:callFuncWithParam("submitLoginGameRole", data)


            local resqdata={}
            resqdata["version"]=tostring(netData.roleName)
            resqdata["error"]=netData.zoneId
            resqdata["user_id"]=USER_ID
            resqdata["detail_err"]=tostring(netData.roleId)
            resqdata["app_platform"]=netData.roleLevel
            resqdata["section_name"]=netData.zoneName
            logServerRequest(resqdata,"SaveClientError")
        end
    end
end

function PluginChannel:share(type,towhere,imgPath)

    if share_plugin ~= nil then
        local info 
        if tostring(type) == "0" then
            info = {
                text = "来下斗地主",
                mediaType = tostring(type),--0文字 1图片 2网址
                shareTo = tostring(towhere),--0 聊天 1 朋友圈 2 收藏
            }
        elseif tostring(type) == "1" then
            info = {
                title = "来下斗地主",
                titleUrl = "http://wx.laixia.com/download",
                site = "来下斗地主",
                siteUrl = "http://wx.laixia.com/download",
                text = "来下斗地主",
                thumbImage = imgPath,
                imagePath = imgPath,
                mediaType = tostring(type),--0文字 1图片 2网址
                shareTo = tostring(towhere),--0 聊天 1 朋友圈 2 收藏
            }
        else
             info = {
                title = "来下斗地主",
                titleUrl = "http://wx.laixia.com/download",
                site = "来下斗地主",
                siteUrl = "http://wx.laixia.com/download",
                url = "http://wx.laixia.com/download",
                comment = "无",
                text = "来下斗地主",
                mediaType = tostring(type),--0文字 1图片 2网址
                shareTo = tostring(towhere),--0 聊天 1 朋友圈 2 收藏
                
            }
        end

        share_plugin:share(info)

    end
end

function PluginChannel:pay(productType,ProductId,rmb,produceName,orderID)
    print("1111111111111111")
    if iap_plugin_maps ~= nil then
        local info = {
            Product_Price=tostring(rmb),
            Product_Id=tostring(ProductId),
            Product_Name=produceName,
            Server_Id="1",
            Product_Count="1",
            Role_Id=laixiaddz.LocalPlayercfg.LaixiaUserID,
            Role_Name="asd",
            EXT = orderID
        }
      --  self:onChargeRequest(info)

        print("22222222222222"..rmb)
        print(iap_plugin_maps)
        
        for key, value in pairs(iap_plugin_maps) do
            print("3333333333333")
            print(key)
            print(value)
            print(productType)
            if productType == "weixin" and key == "399" then
                value:payForProduct(info)
                return
            elseif productType == "weixin" and key == "387" then
                value:payForProduct(info)
                return
            elseif productType == "appstore" then
                value:payForProduct(info)
                return
            elseif productType == "zhifubao" and key == "388" then
                value:payForProduct(info)
                return
            end
        --     --微信支付
         end
         --没找到微信或者支付宝的时候
         for key,value in pairs(iap_plugin_maps) do
            value:payForProduct(info)
            return
         end
    end
end
-----------------------------------------------------------------------------
--统计接口
------------------------------------------------------------------------------


function PluginChannel:startSession()
    if analytics_plugin ~= nil then
        analytics_plugin:startSession()
    end
end

function PluginChannel:stopSession()
    if analytics_plugin ~= nil then
        analytics_plugin:stopSession()
    end
end

function PluginChannel:logError(errID, errMsg)
    if analytics_plugin ~= nil then
        analytics_plugin:logError(errID, errMsg)
    end
    analytics_plugin:setCaptureUncaughtException(true)
end

-- function PluginChannel:logEvent(eventID, paramMap)
--     if analytics_plugin ~= nil then
--         if paramMap == nil then
--             analytics_plugin:logEvent(eventID)
--         else
--             analytics_plugin:logEvent(eventID, paramMap)
--         end
--     end
-- end

-- function PluginChannel:logTimedEventBegin(eventID)
--     if analytics_plugin then
--         analytics_plugin:logTimedEventBegin(eventID)
--     end
-- end

-- function PluginChannel:logTimedEventEnd(eventID)
--     if analytics_plugin then
--         analytics_plugin:logTimedEventEnd(eventID)
--     end
-- end

-- function PluginChannel:setAccount()
--     if analytics_plugin ~= nil then
--         if analytics_plugin:isFunctionSupported("setAccount") then
--             local paramMap = {
--                     Account_Id = "123456",
--                     Account_Name = "test",
--                     Account_Type = tostring(AccountType.ANONYMOUS),
--                     Account_Level = "1",
--                     Account_Age = "1",
--                     Account_Operate = tostring(AccountOperate.LOGIN),
--                     Account_Gender = tostring(AccountGender.MALE),
--                     Server_Id = "1",
--                 }
--             local data = PluginParam:create(paramMap)
--             analytics_plugin:callFuncWithParam("setAccount", data)
--         end
--     end
-- end

function PluginChannel:onChargeRequest(info)
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("onChargeRequest") then
            local paramMap = {
                    Order_Id = info.Product_Id,
                    Product_Name =info.Product_Name,
                    Currency_Amount = info.Product_Price,
                    Currency_Type = "CNY",
                    Payment_Type = "1",
                    Virtual_Currency_Amount = "6",
                }
            local data = PluginParam:create(paramMap)
            analytics_plugin:callFuncWithParam("onChargeRequest", data)
        end
    end
end

function PluginChannel:onChargeOnlySuccess()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("onChargeOnlySuccess") then
            local paramMap = {
                    Order_Id = "123456",
                    Product_Name = "test",
                    Currency_Amount = tostring(2.0),
                    Currency_Type = "CNY",
                    Payment_Type = "1",
                    Virtual_Currency_Amount = tostring(100),
                }
            local data = PluginParam:create(paramMap)
            analytics_plugin:callFuncWithParam("onChargeOnlySuccess", data)
        end
    end
end

function PluginChannel:onChargeSuccess()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("onChargeSuccess") then
            local data = PluginParam:create("123456")
            analytics_plugin:callFuncWithParam("onChargeSuccess", data)
        end
    end
end

function PluginChannel:onChargeFail()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("onChargeFail") then
            local paramMap = {
                    Order_Id = "123456",
                    Fail_Reason = "test",
                }
            local data = PluginParam:create(paramMap)
            analytics_plugin:callFuncWithParam("onChargeFail", data)
        end
    end
end

-- function PluginChannel:onPurchase()
--     if analytics_plugin ~= nil then
--         if analytics_plugin:isFunctionSupported("onPurchase") then
--             local paramMap = {
--                     Item_Id = "123456",
--                     Item_Type = "test",
--                     Item_Count = tostring(2),
--                     Virtual_Currency = "1",
--                     Currency_Type = "000000",
--                 }
--             local data = PluginParam:create(paramMap)
--             analytics_plugin:callFuncWithParam("onPurchase", data)
--         end
--     end
-- end

-- function PluginChannel:onUse()
--     if analytics_plugin ~= nil then
--         if analytics_plugin:isFunctionSupported("onUse") then
--             local paramMap = {
--                     Item_Id = "123456",
--                     Item_Type = "test",
--                     Item_Count = tostring(2),
--                     Use_Reason = "1",
--                 }
--             local data = PluginParam:create(paramMap)
--             analytics_plugin:callFuncWithParam("onUse", data)
--         end
--     end
-- end

-- function PluginChannel:onReward()
--     if analytics_plugin ~= nil then
--         if analytics_plugin:isFunctionSupported("onReward") then
--             local paramMap = {
--                     Item_Id = "123456",
--                     Item_Type = "test",
--                     Item_Count = tostring(2),
--                     Use_Reason = "1",
--                 }
--             local data = PluginParam:create(paramMap)
--             analytics_plugin:callFuncWithParam("onReward", data)
--         end
--     end
-- end

function PluginChannel:startLevel()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("startLevel") then
            local paramMap = {
                    Level_Id = TASK_ID,
                    Seq_Num = "1",
                }
            local data = PluginParam:create(paramMap)
            analytics_plugin:callFuncWithParam("startLevel", data)
        end
    end
end

function PluginChannel:finishLevel()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("finishLevel") then
            local data = PluginParam:create(TASK_ID)
            analytics_plugin:callFuncWithParam("finishLevel", data)
        end
    end
end

function PluginChannel:failLevel()
    if analytics_plugin ~= nil then
        if analytics_plugin:isFunctionSupported("failLevel") then
            local paramMap = {
                    Level_Id = TASK_ID,
                    Fail_Reason = "dead",
                }
            local data = PluginParam:create(paramMap)
            analytics_plugin:callFuncWithParam("failLevel", data)
        end
    end
end

return PluginChannel;




