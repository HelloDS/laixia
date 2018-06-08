--领取救济金

local Type = import("..DataType")
local StatusCode = import("..StatusCode")

local function onPacketGetBenefitsRet(packet)
    laixiaddz.loggame("onPacketGetBenefitsRet 0");
    local status = packet.data.StatusID
    if status == 1 then
        laixia.LocalPlayercfg.LaixiaBenefitsReceiveNum = 0
    elseif status == 0 then
        laixia.LocalPlayercfg.LaixiaBenefitsReceiveNum = packet.data.RemainCT
        --成功领取一次救济金
        laixia.LocalPlayercfg.LaixiaPlayerGold = laixia.LocalPlayercfg.LaixiaPlayerGold + packet.data.Gold
        -- LocalPlayer 改变，发送事件,感兴趣的界面自主刷新
        -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_PICTURE_WINDOW);
    end
    if packet.data.Gold  > 0  then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_NOMONEY_WINDOW, packet.data)
    end

    --更新牌桌金币数量
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATAGOLD)
    laixiaddz.loggame("onPacketGetBenefitsRet 1")
end

return
    {
        ID = _LAIXIA_PACKET_SC_ReliefFundID,
        name = "SCReliefFund",
        data_array =
        {
            {"StatusID", Type.Short },
            {"RemainCT", Type.Byte },--还能领取救济金的次数
            {"Gold", Type.Int }, --领取的金数
        },
        HandlerFunction = onPacketGetBenefitsRet,
    }

