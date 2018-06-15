
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onPacketMatchQuitDesk(packet)
    -- 比赛退出房间
    local StatusID = packet:getValue("Status")
    print(StatusID)

    if StatusID == 1 then
        -- 当请求失败的时候退出
        laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false
        laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable = false
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
        -- 请求个人详情
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
        return
    end

    if StatusCode.new(packet.data.Status):isOK() then
        laixiaddz.LocalPlayercfg.laixiaddzIsInMatch = false
        laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable = false

        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "比赛过程中退出比赛")
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_MATCHWAITLOADING_WINDOW)
        if laixiaddz.LocalPlayercfg.laixiaddzJoinMatch == false then
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
            -- 请求个人详情
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_GAMELIST_GOGAMELIST)
        else
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_MAST_MATCHJOIN_WINDOW)
            -- 进入比赛
        end
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_MatchQuitDeskID,
        name = "SCMatchQuitDesk",
        data_array =
        {
            { "GameID", Type.Byte },
            { "Status", Type.Short },
        },
        HandlerFunction = onPacketMatchQuitDesk,
    }