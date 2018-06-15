-- 进入个人中心时调用此协议

local Type = import("..DataType")

local function onGCEnterPersonalRetPacket(packet)
    dump(packet.data)
    local statesID = packet:getValue("StatusID")
    if statesID ~= 0 then
        return
    end

    laixia.LocalPlayercfg.LaixiaPlayerMaxWintimes = packet:getValue("MaxWintimes")
    laixia.LocalPlayercfg.LaixiaPlayerVictoryTimes = packet:getValue("VictoryTimes")
    laixia.LocalPlayercfg.LaixiaPlayerFailureTimes = packet:getValue("FailureTimes")
    laixia.LocalPlayercfg.LaixiaPlayerGeXingqianming = packet:getValue("SignStr")
    laixia.LocalPlayercfg.LaixiaPlayerGold = packet:getValue("GoldNum")
    laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = packet:getValue("JiangquanNum")
    laixia.LocalPlayercfg.LaixiaPlayerLevel = packet:getValue("Level")
    laixia.LocalPlayercfg.LaixiaPlayerTitle= packet:getValue("Title")
    laixia.LocalPlayercfg.LaixiaExperience = packet:getValue("Experience")
    laixia.LocalPlayercfg.LaixiaPlayerCheckExp = packet:getValue("NowExp")
    laixia.LocalPlayercfg.LaixiaPlayerNextLevelExp = packet:getValue("NextExp")
    --
    laixia.LocalPlayercfg.LaixiaBisaiNum = packet:getValue("bisaiNum")
    laixia.LocalPlayercfg.LaixiaBisaiWin = packet:getValue("bisaiWin")
    laixia.LocalPlayercfg.LaixiaBisaiSecond = packet:getValue("bisaiSecond")
    laixia.LocalPlayercfg.LaixiaPhoneNum = packet:getValue("phoneNum")

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LOBBYDETAILS_WINDOW)
    -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_TISHIYUWECHAT_WINDOW)
end

local SCPersonalCenter =
    {
        ID = _LAIXIA_PACKET_SC_PersonalCenterID,
        name = "SCPersonalCenter",
        data_array =
        {
            { "StatusID", Type.Short },
            { "CanMdName", Type.Byte },-- 能否修改昵称0表示可以，1表示不可以
            { "SignStr", Type.UTF8 },-- 签名
            { "GoldNum", Type.Double },--当前金币
            { "JiangquanNum", Type.Int },--当前奖券
            { "Level", Type.Int },-- 等级
            { "Experience", Type.Int },-- 经验
            { "NowExp", Type.Int },-- 前一等级所需
            { "NextExp", Type.Int },-- 后一等级所需
            { "MaxWintimes", Type.Int },-- 最大倍数
            { "VictoryTimes", Type.Int },-- 胜利次数
            { "FailureTimes", Type.Int },-- 失败次数
            { "Title", Type.UTF8 },-- 称号
            { "bisaiNum" , Type.Int},--比赛次数
            { "bisaiWin" , Type.Int},--比赛胜利次数
            { "bisaiSecond", Type.Int},--比赛第二名次数
            { "phoneNum", Type.UTF8},--手机号
        },
        HandlerFunction = onGCEnterPersonalRetPacket,
    }

return SCPersonalCenter