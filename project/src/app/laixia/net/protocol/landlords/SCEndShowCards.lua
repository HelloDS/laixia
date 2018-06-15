
local Type = import("...DataType")

local function onPacketClearPokers(packet)
    if   laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_CLEAR_LANDLORDTABLE_WINDOW,packet.data)
    end
end

return
    {
        name = "SCEndShowCards",
        ID = _LAIXIA_PACKET_SC_EndShowCardsID,
        data_array =
        {
            {"AllClearPokers",Type.Array,Type.TypeArray.ClearCard},
        },

        HandlerFunction = onPacketClearPokers,
    }
--endregion
