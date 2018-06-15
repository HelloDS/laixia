
local Type = import("...DataType")

local function onPacketMatchWaitingQueue(packet)
    print(" on SCMatchWaitQueue");
    local table = {}

    table.TabNum = packet:getValue("SurplusTable")
    table.mesg=packet:getValue("MatchNews")

    laixiaddz.LocalPlayercfg.laixiaddzMatchRank=packet:getValue("Ranking")
    laixiaddz.LocalPlayercfg.laixiaddzMatchTotalNum=packet:getValue("Total")
    laixiaddz.LocalPlayercfg.laixiaddzMatchIntegral = packet:getValue("Integral")
    laixiaddz.LocalPlayercfg.laixiaddzMatchRoom =packet:getValue("RoomId")
    --if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow ~= "ShopWindow" then
        -- ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHIOW_MATCHWAITLOADING_WINDOW,table)
--        if laixiaddz.LocalPlayercfg.laixiaddzMatchRoundNum == 1 then
--            packet.data.RoomType = 4
--            packet.data.RoomID = 127 --这里暂时先改死 证明这里是要进入比赛
--            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
--        else
      if packet:getValue("IsBegin")~=0 then
            packet.data.RoomType = 4
            packet.data.RoomID = 127 --这里暂时先改死 证明这里是要进入比赛
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_LANDLORDTABLE_WINDOW,packet.data)
      else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHIOW_MATCHWAITLOADING_WINDOW,table)
      end
    --end
    if  laixiaddz.LocalPlayercfg.laixiaddzMatchLimit < laixiaddz.LocalPlayercfg.laixiaddzMatchTotalNum then
        laixiaddz.LocalPlayercfg.laixiaddzMatchLimit= laixiaddz.LocalPlayercfg.laixiaddzMatchTotalNum
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchWaitQueueID,
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