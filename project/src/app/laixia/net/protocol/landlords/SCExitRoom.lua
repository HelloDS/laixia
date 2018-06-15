
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketHandler(packet)

    if StatusCode.new(packet.data.StatusID):isOK() == true then
        laixia.LocalPlayercfg.LaixiaisConnectCardTable = false

        if laixia.LocalPlayercfg.LaixiaJoinMatch == false then
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "常规牌桌中退出牌桌")
            laixia.LocalPlayercfg.LaixiaRoomID = 0
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW);
        else
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MAST_MATCHJOIN_WINDOW) -- 进入比赛
            ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "常规牌桌中退出牌桌")
        end
    else
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"牌局中,不可退出")
    end

end

return
    {
        ID = _LAIXIA_PACKET_SC_ExitRoomID,
        name = "SCExitRoom",
        data_array =
        {
            { "StatusID", Type.Short },
        },
        HandlerFunction = onPacketHandler,
    };
