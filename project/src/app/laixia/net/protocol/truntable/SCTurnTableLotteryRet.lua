local Type = import("...DataType")
local StatusCode = import("...StatusCode")
-- 大转盘进入游戏回调
local function TurnTableLotteryCallBack(packet)

    if StatusCode.new(packet.data.StatID):isOK() then
        local data = packet.data

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SENDLOTTRYTMSG_TOTURNTABLE,data)
    else
        ui.TurnWindow.mIsPlaying = false
    end
end

local SCTurnTableLotteryRet =
    {
        ID = _LAIXIA_PACKET_SC_TurnTableLotteryRetID,
        name = "SCTurnTableLotteryRet",
        data_array =
        {
            {"StatID",Type.Short} ,
            -- 中奖命中
            { "hitIndex", Type.Int },
            -- 摇奖时间
            { "rollTime", Type.Int },
            { "ItemID", Type.Int },---itemID
            { "ItemNum" , Type.Int},
            { "GoldNum", Type.Double },
            { "FreeTime",Type.Int},
        },
        HandlerFunction = TurnTableLotteryCallBack
    }
return SCTurnTableLotteryRet
 