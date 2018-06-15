--
-- Author: peter
-- Date: 2017-12-21 14:43:17
--
local Type = import("..DataType")

local function onSCPersonBillPacket(packet)
    --dumpGameData(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_PERSONBILL_WINDOW,packet.data)
end

local SCPersonBill =
    {
        ID = _LAIXIA_PACKET_SC_PERSONBILL,
        name = "SCPersonBill",
        data_array =
        {
        	{ "StatusID", Type.Short },-- 状态码
            { "GameBill", Type.Array,Type.TypeArray.PersonBills},--TypeArray.PersonBills},
        },
        HandlerFunction = onSCPersonBillPacket,
    }

return SCPersonBill