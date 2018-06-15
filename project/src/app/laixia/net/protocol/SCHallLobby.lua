local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onGCEnterLobbyRetPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusCode.new(StatusID):isOK() then
        laixia.LocalPlayercfg.LaixiaPlayerGold = packet:getValue("GoldNum")
        laixia.LocalPlayercfg.LaixiaPlayerGiftCoupon = packet:getValue("JiangquanNum")
        laixia.LocalPlayercfg.LaixiaPlayerLevel = packet:getValue("Level")
        laixia.LocalPlayercfg.LaixiaPlayerTitle= packet:getValue("Title")
        laixia.LocalPlayercfg.LaixiaExperience = packet:getValue("Experience")
        laixia.LocalPlayercfg.LaixiaPlayerCheckExp = packet:getValue("NowExp")
        laixia.LocalPlayercfg.LaixiaPlayerNextLevelExp = packet:getValue("NextExp")
        laixia.LocalPlayercfg.LaixiaPlayerShengLv = packet:getValue("ShengLv")  --胜率
        local mIsExpired = packet:getValue("IsExpired") -- 首充活动是否过期 （0 过期  1 未过期）

        if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
            return
        end
        if laixia.LocalPlayercfg.LaixiaMatchquite == true then
            laixia.LocalPlayercfg.LaixiaMatchquite = false
            return
        end
        if laixia.LocalPlayercfg.LaixiaCurrentWindow ==  "LobbyWindow" then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_WINDOW)
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAININTERFACE_TOP_WINDOW)
        end

    end
end

local GCEnterLobbyRet =
    {
        ID = _LAIXIA_PACKET_SC_HallLobbyID,
        name = "GCEnterLobbyRet",
        data_array =
        {
            { "StatusID", Type.Short },
            { "ShengLv", Type.Int },  --胜率   如果50% 则发50
            { "Level", Type.Int },-- 等级
            { "Experience", Type.Int },-- 经验
            { "NowExp", Type.Int },-- 前一等级所需
            { "NextExp", Type.Int },-- 后一等级所需
            { "JiangquanNum", Type.Int },--当前奖券
            { "GoldNum", Type.Double },--当前金币
            { "Ibnp", Type.Short },--是否完成首冲（1完成0 未完成）
            { "IsExpired", Type.Short },--首冲活动是否过期0过期1表示未过期
            { "Title", Type.UTF8 },-- 称号

        },
        HandlerFunction = onGCEnterLobbyRetPacket,
    }

return GCEnterLobbyRet