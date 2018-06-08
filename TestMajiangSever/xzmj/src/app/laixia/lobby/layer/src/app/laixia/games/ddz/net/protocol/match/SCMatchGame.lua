
local Type = import("...DataType")

local function onSCMatchGamePacket(packet)
    dump(packet.data)
    laixiaddz.LocalPlayercfg.laixiaddzMatchdata =packet:getValue("PageTypeMessage")

    for i = 1, #laixiaddz.LocalPlayercfg.laixiaddzMatchdata do
        if (#laixiaddz.LocalPlayercfg.laixiaddzMatchdata[i].rooms) > 0 then
            laixiaddz.LocalPlayercfg.laixiaddzGamePageType = laixiaddz.LocalPlayercfg.laixiaddzMatchdata[i].PageType
            laixiaddz.LocalPlayercfg.laixiaddzGameListIndex =  laixiaddz.LocalPlayercfg.laixiaddzMatchdata[i].Sort
        end
    end

    ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW)
end

local  SCMatchGame =
    {
        name = "SCMatchGame",
        ID=_laixiaddz_PACKET_SC_MatchGameID, --比赛列表
        data_array=
        {
            {"GameID", Type.Byte},
            {"PageTypeMessage",Type.Array,Type.TypeArray.PageTypeMessage},
        },
        HandlerFunction = onSCMatchGamePacket,

    }

return SCMatchGame