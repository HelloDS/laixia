
local Type = import("...DataType")

local function onPacketMatchWaitingQueue(packet)
    print(" on SCMatchWaitQueue");
    local table = {}

    table.TabNum = packet:getValue("SurplusTable")
    table.mesg=packet:getValue("MatchNews")

    laixia.LocalPlayercfg.LaixiaMatchRank=packet:getValue("Ranking")
    laixia.LocalPlayercfg.LaixiaMatchTotalNum=packet:getValue("Total")
    laixia.LocalPlayercfg.LaixiaMatchIntegral = packet:getValue("Integral")
    laixia.LocalPlayercfg.LaixiaMatchRoom =packet:getValue("RoomId")
    --if laixia.LocalPlayercfg.LaixiaCurrentWindow ~= "ShopWindow" then
        -- ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHIOW_MATCHWAITLOADING_WINDOW,table)
--        if laixia.LocalPlayercfg.LaixiaMatchRoundNum == 1 then
--            packet.data.RoomType = 4
--            packet.data.RoomID = 127 --这里暂时先改死 证明这里是要进入比赛
--            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
--        else
      if packet:getValue("IsBegin")~=0 then
            packet.data.RoomType = 4
            packet.data.RoomID = 127 --这里暂时先改死 证明这里是要进入比赛
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
      else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHIOW_MATCHWAITLOADING_WINDOW,table)
      end
    --end
    if  laixia.LocalPlayercfg.LaixiaMatchLimit < laixia.LocalPlayercfg.LaixiaMatchTotalNum then
        laixia.LocalPlayercfg.LaixiaMatchLimit= laixia.LocalPlayercfg.LaixiaMatchTotalNum
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_MatchWaitQueueID,
        name = "SCMatchWaitQueue",
        data_array =
        {
            {"GameID", Type.Byte },
            {"RoomId",Type.Int},
            {"SurplusTable",Type.Int},
            {"Total",Type.Int},
            {"Ranking",Type.Int},
            {"Integral",Type.Int},
            {"MatchNews",Type.UTF8},
            {"IsBegin",Type.Int},
        },
        HandlerFunction = onPacketMatchWaitingQueue,
    }