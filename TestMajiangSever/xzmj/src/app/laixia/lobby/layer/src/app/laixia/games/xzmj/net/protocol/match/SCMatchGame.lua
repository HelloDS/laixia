
local Type = import("...DataType")

local function onSCMatchGamePacket(packet)
    dump(packet.data)
    laixia.LocalPlayercfg.LaixiaMatchdata =packet:getValue("PageTypeMessage")

    for i = 1, #laixia.LocalPlayercfg.LaixiaMatchdata do
        if (#laixia.LocalPlayercfg.LaixiaMatchdata[i].rooms) > 0 then
            laixia.LocalPlayercfg.LaixiaGamePageType = laixia.LocalPlayercfg.LaixiaMatchdata[i].PageType
            laixia.LocalPlayercfg.LaixiaGameListIndex =  laixia.LocalPlayercfg.LaixiaMatchdata[i].Sort
        end
    end

    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MATCHSTATE_WINDOW_WINDOW)
end

local  SCMatchGame =
    {
        name = "SCMatchGame",
        ID=_LAIXIA_PACKET_SC_MatchGameID, --比赛列表
        data_array=
        {
            {"GameID", Type.Byte},
            {"PageTypeMessage",Type.Array,Type.TypeArray.PageTypeMessage},
        },
        HandlerFunction = onSCMatchGamePacket,

    }

return SCMatchGame