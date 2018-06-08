-- 龙虎斗刷新棋牌桌面上的信息

local Type = import("...DataType")

local function SCDragonTigerTableSyncFunction(packet)
    local temp = {[1] = 0,[2] = 0,[3] = 0,[4]=0,[5] = 0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0}
    laixia.LocalPlayercfg.LHD.detayArrTotalChips = {[1] = 0,[2] = 0,[3] = 0,[4]=0,[5] = 0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0}

    laixia.LocalPlayercfg.LHD.arrMyChips = packet.data.arrMyChips

    laixia.logGame("=====我的压注金额:"..tostring(packet.data.arrMyChips[1]))
    for i = 1, #temp do
        temp[i] = laixia.LocalPlayercfg.LHD.arrTotalChips[i]
    end

    laixia.LocalPlayercfg.LHD.arrTotalChips = packet.data.arrTotalChips

    for i = 1, #laixia.LocalPlayercfg.LHD.arrTotalChips do
        laixia.LocalPlayercfg.LHD.detayArrTotalChips[i] = laixia.LocalPlayercfg.LHD.arrTotalChips[i]-temp[i]-laixia.LocalPlayercfg.LHD.arrMyChips[i]
    end

    laixia.LocalPlayercfg.LHD.remain = packet.data.remain
    laixia.LocalPlayercfg.LaixiaPlayerGold = packet.data.remain
    laixia.LocalPlayercfg.LHD.banker = packet.data.banker
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_DRAGON_UPDATE_WINDOW)
    for k,v in pairs(laixia.LocalPlayercfg.LHD.detayArrTotalChips)  do
        if v<0 then
            local sun = 1
        end
    end

end

local SCDragonTigerTableSync =
    {
        ID = _LAIXIA_PACKET_SC_DragonTigerTableSyncID,

        name = "SCDragonTigerTableSync",
        data_array =
        {
            { "arrMyChips", Type.Array, Type.Int },
            { "arrTotalChips", Type.Array, Type.Int },
            { "remain", Type.Double },
            { "banker", Type.UTF8 }
        },
        HandlerFunction = SCDragonTigerTableSyncFunction

    }

return SCDragonTigerTableSync






