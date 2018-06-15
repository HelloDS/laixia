local Type = import("...DataType")
local StatusCode = import("...StatusCode")
local function onPacketSCCreateGoonRet(packet)
    if StatusCode.new(packet.data.Status):isOK() == true   then

        if laixiaddz.LocalPlayercfg.LaixiaPlayerID == packet.data.PlayerID then
            --             ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_DATELANDLORDTABLE_WINDOW, "¼ÌÐøÓÎÏ·µ÷ÓÃ")
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_WAITTINGCARTOON_WINDOW)

            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_HIDE_TABLERESULT_WINDOW)
        end
        local data = packet.data
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_CONTINUESELFBUILD,data)
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_CreateGoonRetID,
        name = "SCCreateGoonRet",
        data_array =
        {
            {"Status", Type.Short},
            {"PlayerID", Type.Int},
            {"Players", Type.Array, Type.TypeArray.SelfBuilPlayers},
        },
        HandlerFunction = onPacketSCCreateGoonRet,
    }
