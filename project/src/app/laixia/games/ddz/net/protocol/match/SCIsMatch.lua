--region 短线重连请求进入比赛

local Type = import("...DataType")

local function onPacketSCIsMatch(packet)
    if packet.data.GameID == 4 or packet.data.GameID == 1 then
        local function _onReadyCall()
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_VERSIONOPEN_WINDOW)           --请求功能开关
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_HEARTTICK_WINDOW)          --发送心跳

            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SEND_RELIEFINFO_WINDOW)       --请求救济金次数

            if packet.data.isMatch == 0 then
                laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = true
                --不做处理服务器会发牌桌同步消息 进入比赛
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_FLOWWORDS_WINDOW,"重新连接成功，比赛继续。")
            elseif  packet.data.isMatch == 1 then
                ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_ISONLINEROOM_WINDOW)
            end
        end
        local nnet = laixiaddz.net.Net;
        if(nnet.mProcessState == 2)  then
            _onReadyCall()
        else
            nnet:registerReadyFunc(_onReadyCall)
                :setProcessState(1)
        end
    else
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_IsMatchID,
        name = "SCIsMatch",
        data_array =
        {
            {"GameID",Type.Byte},     --游戏ID 4
            {"isMatch",Type.Short},    --比赛标记 0有比赛 1没有比赛
        },
        HandlerFunction = onPacketSCIsMatch,
    }

--endregion
