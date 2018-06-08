-- 获取签到表

local Type = import("..DataType")

local function onSCContinuousLandingRetPacket(packet)

    laixia.LocalPlayercfg.LaixiaContinuousLoginData = packet.data
    if laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 0 then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_DAILYSIGN_WINDOW)
    else
        laixia.LocalPlayercfg.LaixiaIsSign = 0
        if laixia.LocalPlayercfg.LaixiaShowActivyWindow == 1 then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_ACTIVITY_WINDOW)
        end
        if laixia.LocalPlayercfg.LaixiaContinuousLoginData.IsSign == 1 and laixia.LocalPlayercfg.LaixiaContinuousLoginData.TypeSign == 0 then
            --日常签到完成，服务器会SignDay+1处理
            if laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay==1 then
                laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay = 7
            else
                laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay = laixia.LocalPlayercfg.LaixiaContinuousLoginData.SignDay - 1
            end
        end
    end

end

local GCContinuousLandingRet =
    {
        ID = _LAIXIA_PACKET_SC_SignLandingID,
        name = "GCContinuousLandingRet",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "IsSign", Type.Byte },-- 是否已经领取  --hasGet
            { "TypeSign", Type.Byte },-- 签到类型0：常规1：活动  --type
            { "SignDay", Type.Short },-- 当前签到天   --curDay
            { "Days", Type.Short },-- 已经签到天数    --days
            { "ActiveInfo", Type.UTF8 },    --活动已签到数据    ---actSign
            { "Shows", Type.Array, Type.TypeArray.SignInTabel },-- 签到配置表
        },
        HandlerFunction = onSCContinuousLandingRetPacket,
    }

return GCContinuousLandingRet