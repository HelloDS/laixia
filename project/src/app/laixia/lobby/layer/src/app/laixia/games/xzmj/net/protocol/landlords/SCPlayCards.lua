-- region 出牌

local Type = import("...DataType")

local function PlayCardPacket(packet)
    laixiaddz.loggame("\n\n出牌消息消息\n\n")
    if packet.data.StatusID~=0  then
        laixiaddz.loggame("出牌状态失败" )
        return
    end
    dumpGameData(packet.data, "outPokers")

    if #packet.data.Cards > 0 then
        laixiaddz.loggame("#packet.data.Cards > 0")
        laixia.LocalPlayercfg.LaixiaOutCards = nil
        laixia.LocalPlayercfg.LaixiaOutCards = packet.data
        laixia.LocalPlayercfg.LaixiaOutCardsCount = laixia.LocalPlayercfg.LaixiaOutCardsCount + 1
        -- 管上牌次数
        laixia.LocalPlayercfg.LaixiaOutCards.count = 0
        laixia.LocalPlayercfg.LaixiaOutCardsIndex = clone(packet.data.Cards)
        laixia.LocalPlayercfg.LaixiaLaiziReplaceCards = clone(packet.data.ReplaceCardss)

        for i =1 ,#laixia.LocalPlayercfg.LaixiaOutCardsIndex  do
            laixiaddz.loggame(laixia.LocalPlayercfg.LaixiaOutCardsIndex[i].CardValue)
        end

        for i =1 ,#laixia.LocalPlayercfg.LaixiaLaiziReplaceCards  do
            laixiaddz.loggame(laixia.LocalPlayercfg.LaixiaLaiziReplaceCards[i].CardValue)
        end

    else
        laixiaddz.loggame("#packet.data.Cards <= 0")
        local count = nil
        if laixia.LocalPlayercfg.LaixiaOutCards ~= nil then
            count = laixia.LocalPlayercfg.LaixiaOutCards.count
        else
            count = 0
        end
        laixia.LocalPlayercfg.LaixiaOutCards = nil
        laixia.LocalPlayercfg.LaixiaOutCards = clone(packet.data)
        laixia.LocalPlayercfg.LaixiaOutCards.count = count + 1
        if laixia.LocalPlayercfg.LaixiaOutCards.count == 2 then
            laixia.LocalPlayercfg.LaixiaOutCardsIndex = nil
        end
    end
    if packet.data.NextSeat == 255 then
        packet.data.NextSeat = -1
    end
    local stageStep = {
        ["State"] = packet.data.State,
        ["Seat"] = packet.data.NextSeat,
        ["Times"] = packet.data.Times,
    }
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog" and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_PLAY_LANDLORDTABLE_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_SYNTABLESTAGE_WINDOW, stageStep)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_PlayCardsID,
        -- 出手牌,
        name = "SCPlayCards",
        data_array =
        {
            { "StatusID", Type.Short },-- 状态码
            { "State", Type.Byte },-- 阶段数
            { "TableID", Type.Int },-- 桌号     用来验证房间消息是不是我有用的（机器人暂用）
            { "ReplaceCardss", Type.Array, Type.TypeArray.Card },-- 被替换的牌值 --癞子
            { "NextSeat", Type.Byte },-- 下一个操作位
            { "Cards", Type.Array, Type.TypeArray.Card },-- 出的牌值
            { "Times", Type.Double },-- 超时时间
            { "Seat", Type.Byte },-- 当前操作位
            { "RoomID", Type.Byte },-- 房间号   用来验证房间消息是不是我有用的（机器人暂用）

        },
        HandlerFunction = PlayCardPacket,
    };



