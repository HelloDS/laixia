-- region 发底牌

local Type = import("...DataType")

local function onSCDealHandPacket(packet)
    laixiaddz.logGame("发牌消息 ButtomSeat：" .. packet.data.ButtomSeat .. "       Seats:" .. packet.data.Seats)
    dumpGameData(packet.data, "发牌表数据")
    if #packet.data.Cards == 3 then
        laixiaddz.LocalPlayercfg.laixiaddzLandlordSeat = packet.data.ButtomSeat
    end
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog" and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_DEAL_LANDLORDTABLE_WINDOW, packet.data)
        -- 开始发手牌标志比赛没有结束
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
        -- 删除中间等待界面
    end
end

local SCDealHand =
    {
        ID = _laixiaddz_PACKET_SC_DealHandID,
        name = "SCDealHand",

        data_array =
        {
            { "Reelect", Type.Byte },-- 0正常发牌,1重新发牌
            { "Seats", Type.Byte },-- 当前座位 --当前 操作
            { "ButtomSeat", Type.Byte },-- 庄家座位 这个值发手牌时，是自己座位号
            { "Cards", Type.Array, Type.TypeArray.Card },

        },
        HandlerFunction = onSCDealHandPacket,

    }

return SCDealHand
-- endregion
