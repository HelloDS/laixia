
local Env = APP_ENV;

local userDefault = Env.userDefault; --

local laixia = laixia;
laixia.ProtoModelType = laixia.ProtoModelType or import("..DataType")
local Type =  laixia.ProtoModelType;
local StatusCode = import("..StatusCode")

local function onSCLoginRetPacket(packet)
    dumpGameData(packet);
    local statusID = packet:getValue("StatusID")
    print(statusID)
    if (statusID ~= 0) then
        local noticeData = {}
        userDefault:setBoolForKey("isauto", false) --防止授权没有成功造成登录影响
        --userDefault:setIntegerForKey("GamePlatformID",1)
        noticeData.Content = packet:getValue("Maintenance")
        noticeData.OnCallFunc = function() os.exit() end
        StatusCode.new(packet.data.StatusID,noticeData)
        return
    end
    laixia.LocalPlayercfg.LaixiaPlayerID = packet:getPlayerID()
    print("playerID"..laixia.LocalPlayercfg.LaixiaPlayerID )
    laixia.LocalPlayercfg:initData()
    laixia.net.endTCP()

    if laixia.kconfig.isYingKe==true then
    else
        laixia.LocalPlayercfg.LaixiaPlayerNickname = packet:getValue("Name")
    end
    print("nickName"..laixia.LocalPlayercfg.LaixiaPlayerNickname )
    -- 昵称
    laixia.LocalPlayercfg.LaixiaHttpCode = packet:getValue("HttpCode")
    -- 保存code值，
    if laixia.kconfig.isYingKe== true then
    else
        laixia.LocalPlayercfg.LaixiaUserID = packet:getValue("Account") 
    end
    print("LaixiaUserID"..laixia.LocalPlayercfg.LaixiaUserID )
    -- 头像图片地址   
    if laixia.kconfig.isYingKe==true  then
    else
        laixia.LocalPlayercfg.LaixiaHeadPortraitPath = packet:getValue("HeadImgPath")
    end
    print("LaixiaHeadPortraitPath"..laixia.LocalPlayercfg.LaixiaHeadPortraitPath )
    -- 刚选择的头像   游客头像
    laixia.LocalPlayercfg.LaixiaPlayerHeadPicture = nil
    -- 在使用的头像   微信头像
    laixia.LocalPlayercfg.LaixiaPlayerHeadUse = nil

    laixia.LocalPlayercfg.LaixiaWechatServiceNum= packet:getValue("weChatServer")

    -- local strIsEmpty = string.isEmpty;
    -- if not strIsEmpty(laixia.LocalPlayercfg.LaixiaHeadPortraitPath) then
    --     local imagePath = laixia.UItools.Split(laixia.LocalPlayercfg.LaixiaHeadPortraitPath, "/")
    --     imagePath = imagePath[#imagePath]
    --     local localIconName = string.sub(imagePath, 1, string.len(imagePath) -4)
    --     laixia.LocalPlayercfg.LaixiaPlayerHeadUse = localIconName
    -- end
    laixia.LocalPlayercfg.LaixiaPlayerHeadUse = laixia.LocalPlayercfg.LaixiaHeadPortraitPath--laixia.LocalPlayercfg.LaixiaPlayerID..".png"

    -- 性别
    laixia.LocalPlayercfg.LaixiaPlayerGender = packet:getValue("Gender")
    local PlatformID = packet:getValue("PlatformID")
    print("PlatformID"..PlatformID )
    if laixia.config.isYingKe == true then
        laixia.LocalPlayercfg.LaixiaLastLoginPlatform = 9
    else
        laixia.LocalPlayercfg.LaixiaLastLoginPlatform = PlatformID
    end
    print("lastLoginPlatform"..laixia.LocalPlayercfg.LaixiaLastLoginPlatform )
    if PlatformID ~= 1 then            -- 返回平台不为1则不是游客账号，可以修改密码
        laixia.LocalPlayercfg.LaixiaPassword = laixia.LocalPlayercfg.LaixiaPassword
        userDefault:setBoolForKey("isauto", true)
        userDefault:setIntegerForKey("GamePlatformID", PlatformID) --写入账号登录的平台
        laixia.LocalPlayercfg:WriteData()
    else
        userDefault:setBoolForKey("isauto", false)
    end

    if laixia.LocalPlayercfg.LaixiaPassword ~= "" then
        laixia.LocalPlayercfg.LaixiaPassword = laixia.LocalPlayercfg.LaixiaPassword
    end

    laixia.LocalPlayercfg.LaixiaTCPSever = packet:getValue("Address")
    laixia.LocalPlayercfg.LaixiaPhoneNum = packet:getValue("PhoneNum")
    print("phoneNumber"..laixia.LocalPlayercfg.LaixiaPhoneNum)
    cc.UserDefault:getInstance():setStringForKey("phone_number", laixia.LocalPlayercfg.LaixiaPhoneNum)

    laixia.LocalPlayercfg:WriteData();
    laixia.net.setHttpConnected(true);
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MARKEDJUMP_WINDOW)
    laixia.net.startTcp()
    --断线重连更新commtopwindow的用户信息显示
    -- if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "LoadingWindow" then
    --     ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_PICTURE_WINDOW);
    -- end
end

local SCLoginRet =
    {
        name = "SCLoginRet",
        ID = _LAIXIA_PACKET_SC_Login_ID,
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "HttpCode", Type.Short },-- 校验码
            { "Account", Type.UTF8 },-- 帐号
            { "Password", Type.UTF8 },-- 密码
            { "PlatformID", Type.Byte },-- 平台类型
            { "Address", Type.UTF8 },-- 地址
            { "Name", Type.UTF8 },-- 昵称
            { "Gender", Type.Byte },-- 性别 0男 1女
            { "HeadImgPath", Type.UTF8 },-- 头像路径
            { "Maintenance", Type.UTF8 },-- 维护公告
            { "weChatServer",Type.UTF8 },--微信服务号
            { "PhoneNum",Type.UTF8},
        },
        HandlerFunction = onSCLoginRetPacket,
    }

return SCLoginRet