
local Type = import("...DataType")

local function onPacketClearPokers(packet)
    if   laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_CLEAR_LANDLORDTABLE_WINDOW,packet.data)
    end
end

return
    {
        name = "SCEndShowCards",
        ID = _laixiaddz_PACKET_SC_EndShowCardsID,
        data_array =
        {
            {"AllClearPokers",Type.Array,Type.TypeArray.ClearCard},
        },

        HandlerFunction = onPacketClearPokers,
    }
--endregion
