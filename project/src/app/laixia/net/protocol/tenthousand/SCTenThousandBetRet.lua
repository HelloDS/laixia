local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function TenThousandBetRetCallBack(packet)
    if packet.data.StatID == 0 then --StatusCode.new(packet.data.StatID):isOK()
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENIUNIU_ADDBET ,packet.data )
    elseif packet.data.StatID == 1  then

    else
        StatusCode.new(packet.data.StatID)
    end
end

local SCTenThousandBetRet =
    {
        ID = _LAIXIA_PACKET_SC_TenThousandBetRetID,
        name = "SCTenThousandBetRet",
        data_array =
        {
            --进入状态
            { "StatID",Type.Short} ,
            { "State", Type.Byte },             --游戏状态（0 等待发牌，1 发牌 ，2 下注 3 开牌，4 休息中）
            { "BetType", Type.Byte },           --押注类型 (0.1.2.3)
            { "TypeGold", Type.Int },           --当前押注类型押注筹码
            { "Remain", Type.Double },          --剩余筹码
            { "RestTime", Type.Double },        --此状态结束剩余时间



        },
        HandlerFunction = TenThousandBetRetCallBack
    }
return SCTenThousandBetRet
 