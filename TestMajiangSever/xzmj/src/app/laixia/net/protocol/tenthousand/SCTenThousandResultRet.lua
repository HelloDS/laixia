local Type = import("...DataType")

local function TenThousandResultRetCallBack(packet)

    local data = packet.data

    local PacketArray ={}

    local resultArray = {}
    if data.OneResult == 255 then
        data.OneResult = -1
    end

    table.insert(resultArray,data.OneResult )
    if data.TwoResult == 255 then
        data.TwoResult = -1
    end

    table.insert(resultArray,data.TwoResult )
    if data.ThreeResult == 255 then
        data.ThreeResult = -1
    end
    table.insert(resultArray,data.ThreeResult )

    if data.FourResult == 255 then
        data.FourResult = -1
    end
    table.insert(resultArray,data.FourResult )

    local tempArray ={}
    local pokerArray = {}
    pokerArray.poker = {}
    pokerArray.pokerType = 0

    pokerArray.poker =     data.BankerPoker
    pokerArray.pokerType = data.BankerType
    table.insert(tempArray,pokerArray)

    local pokerArray1 = {}
    pokerArray1.poker = {}
    pokerArray1.pokerType = 0

    pokerArray1.poker = data.OnePoker
    pokerArray1.pokerType = data.OnePokerType
    table.insert(tempArray,pokerArray1)

    local pokerArray2 = {}
    pokerArray2.poker = {}
    pokerArray2.pokerType = 0

    pokerArray2.poker =  data.TwoPoker
    pokerArray2.pokerType = data.TwoPokerType
    table.insert(tempArray,pokerArray2)

    local pokerArray3 = {}
    pokerArray3.poker = {}
    pokerArray3.pokerType = 0

    pokerArray3.poker =     data.ThreePoker
    pokerArray3.pokerType = data.ThreePokerType
    table.insert(tempArray,pokerArray3)

    local pokerArray4 = {}
    pokerArray4.poker = {}
    pokerArray4.pokerType = 0

    pokerArray4.poker =     data.FourPoker
    pokerArray4.pokerType = data.FourPokerType
    table.insert(tempArray,pokerArray4)


    table.insert(PacketArray,resultArray)      --东西南北是否获胜
    table.insert(PacketArray,data.SelfWinGold) --每个位置赢了多少
    table.insert(PacketArray,data.WinGold)     --一共赢了多少
    table.insert(PacketArray,tempArray)        --没个位置的牌，第五个为庄家的牌

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_WANRENNIUNIU_SHOW_RESULT ,PacketArray)
end

local SCTenThousandResultRet =
    {
        ID = _LAIXIA_PACKET_SC_TenThousandResultRetID,
        name = "SCTenThousandResultRet",
        data_array =
        {
            { "OneResult", Type.Byte },             --1输赢    --0表示平局1表示赢-1表示失败
            { "TwoResult", Type.Byte },             --2输赢    --0表示平局1表示赢-1表示失败
            { "ThreeResult", Type.Byte },           --3输赢    --0表示平局1表示赢-1表示失败
            { "FourResult", Type.Byte },            --4输赢    --0表示平局1表示赢-1表示失败
            { "SelfWinGold", Type.Array,Type.Int },       --自己赢取的金币

            { "WinGold", Type.Int },                --自己赢的总金币
            { "BankerPoker", Type.Array,Type.Int }, --庄家牌
            { "BankerType", Type.Int },             --庄家牌型
            { "OnePoker", Type.Array,Type.Int },    --1的牌
            { "OnePokerType", Type.Int },           --1的牌型
            { "TwoPoker", Type.Array,Type.Int },    --2的牌
            { "TwoPokerType", Type.Int },           --2的牌型
            { "ThreePoker", Type.Array,Type.Int },  --3的牌
            { "ThreePokerType", Type.Int },         --3的牌型
            { "FourPoker", Type.Array,Type.Int },   --4的牌
            { "FourPokerType", Type.Int },          --4的牌型

        },
        HandlerFunction = TenThousandResultRetCallBack
    }
return SCTenThousandResultRet
 