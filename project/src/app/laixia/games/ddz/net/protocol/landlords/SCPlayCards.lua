-- region 出牌

local Type = import("...DataType")

local function PlayCardPacket(packet)
    laixiaddz.logGame("\n\n出牌消息消息\n\n")
    if packet.data.StatusID~=0  then
        laixiaddz.logGame("出牌状态失败" )
        return
    end
    dumpGameData(packet.data, "outPokers")

    if #packet.data.Cards > 0 then
        laixiaddz.logGame("#packet.data.Cards > 0")
        laixiaddz.LocalPlayercfg.laixiaddzOutCards = nil
        laixiaddz.LocalPlayercfg.laixiaddzOutCards = packet.data
        laixiaddz.LocalPlayercfg.laixiaddzOutCardsCount = laixiaddz.LocalPlayercfg.laixiaddzOutCardsCount + 1
        -- 管上牌次数
        laixiaddz.LocalPlayercfg.laixiaddzOutCards.count = 0
        laixiaddz.LocalPlayercfg.laixiaddzOutCardsIndex = clone(packet.data.Cards)
        laixiaddz.LocalPlayercfg.laixiaddzLaiziReplaceCards = clone(packet.data.ReplaceCardss)

        for i =1 ,#laixiaddz.LocalPlayercfg.laixiaddzOutCardsIndex  do
            laixiaddz.logGame(laixiaddz.LocalPlayercfg.laixiaddzOutCardsIndex[i].CardValue)
        end

        for i =1 ,#laixiaddz.LocalPlayercfg.laixiaddzLaiziReplaceCards  do
            laixiaddz.logGame(laixiaddz.LocalPlayercfg.laixiaddzLaiziReplaceCards[i].CardValue)
        end

    else
        laixiaddz.logGame("#packet.data.Cards <= 0")
        local count = nil
        if laixiaddz.LocalPlayercfg.laixiaddzOutCards ~= nil then
            count = laixiaddz.LocalPlayercfg.laixiaddzOutCards.count
        else
            count = 0
        end
        laixiaddz.LocalPlayercfg.laixiaddzOutCards = nil
        laixiaddz.LocalPlayercfg.laixiaddzOutCards = clone(packet.data)
        laixiaddz.LocalPlayercfg.laixiaddzOutCards.count = count + 1
        if laixiaddz.LocalPlayercfg.laixiaddzOutCards.count == 2 then
            laixiaddz.LocalPlayercfg.laixiaddzOutCardsIndex = nil
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
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_PLAY_LANDLORDTABLE_WINDOW)
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_SYNTABLESTAGE_WINDOW, stageStep)
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_PlayCardsID,
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



