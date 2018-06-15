local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function EnterTenThousandRetCallBack(packet)
    if StatusCode.new(packet.data.StatID):isOK() then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENIUNIU_SHOW_MAINWINDOW ,packet.data )
    end
end

local SCEnterTenThousandRet =
    {
        ID = _LAIXIA_PACKET_SC_EnterTenThousandRetID,
        name = "SCEnterTenThousandRet",
        data_array =
        {
            --进入状态
            { "StatID", Type.Short },           --状态吗
            { "State", Type.Byte },             --游戏状态（0 等待发牌，1 发牌 ，2 下注 3 开牌，4 休息状态 ）

            { "FlopType", Type.Byte },          --翻牌阶段是否开启（0 开，1 关）
            { "FlopMax", Type.Byte },           --翻牌阶段阶段最大次数
            { "WaitPokerTime", Type.Int },      --等待发牌时间
            { "SendPokerTime", Type.Int },      --发牌时间
            { "PokerTime", Type.Int },          --下注时间
            { "OpenPokerTime", Type.Int },      --开牌时间
            { "TakeRestTime", Type.Int },       --休息时间
            { "GameMaxBet", Type.Int },         --各位置押注最大筹码
            { "MaxBetGold", Type.Int },         --玩家可押注的最大筹码
            { "OneGold", Type.Int },            --自己押1金币
            { "TwoGold", Type.Int },            --自己押2金币
            { "ThreeGold", Type.Int },          --自己押3金币
            { "FourGold", Type.Int },           --自己押4金币

            { "OneTotalGold", Type.Double },    --押1所有金币
            { "TwoTotalGold", Type.Double },    --押2所有金币
            { "ThreeTotalGold", Type.Double },  --押3所有金币
            { "FourTotalGold", Type.Double },   --押4所有金币

            { "RestTime", Type.Double },        --此状态结束剩余时间   --毫秒要除以一千
            { "BetList",Type.Array, Type.Int},  --筹码列表


        },
        HandlerFunction = EnterTenThousandRetCallBack
    }
return SCEnterTenThousandRet
 