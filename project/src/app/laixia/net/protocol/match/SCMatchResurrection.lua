
local Type = import("...DataType")
local StatusCode = import("...StatusCode")
-- 任务
local function onSCMatchResurrectionPacket(packet)

    dump(packet.data)
    local status = packet:getValue("Status")
    if status == 0 then

        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_HIDE_MATCHEASTER_WINDOW);
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,"复活成功,比赛继续")
    elseif status == 2  then
        laixia.LocalPlayercfg.LaixiaIsInMatch=false
        laixia.LocalPlayercfg.LaixiaMatchquite = true
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)--请求个人详情 用于更新金数量
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MATCHEASTERRESULT_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,{ text = laixia.utilscfg.CoinType().."不足，复活失败", OnCallFunc = function()
            ObjectEventDispatch:pushEvent( _LAIXIA_EVENT_GAMELIST_GOGAMELIST)
        end })
    else
        laixia.LocalPlayercfg.LaixiaIsInMatch=false
        laixia.LocalPlayercfg.LaixiaMatchquite = true
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_HALL_WINDOW)--请求个人详情 用于更新金数量
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_MATCHEASTERRESULT_WINDOW)
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_FLOWWORDS_WINDOW,{ text = "当前阶段已结束，复活失败", OnCallFunc = function()
            ObjectEventDispatch:pushEvent( _LAIXIA_EVENT_GAMELIST_GOGAMELIST)
        end })
    end


end

local SCMatchResurrection =
    {
        ID = _LAIXIA_PACKET_SC_MatchResurrectionID,
        name = "SCMatchResurrection",
        data_array =
        {
            {"GameID",Type.Byte},
            {"Status",Type.Short},
            {"Items", Type.Array, Type.TypeArray.Items },
        },
        HandlerFunction = onSCMatchResurrectionPacket,

    }

return SCMatchResurrection
