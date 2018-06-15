

local Type = import("..DataType")

local function onGCumengRetPacket(packet)
    if tostring(packet.data.ItemID) == "1200018" or tostring(packet.data.ItemID) == "1100018" or tostring(packet.data.ItemID) == "120018" then
        laixia.LocalPlayercfg.isShouchong = false
    end
end

local  SCRechargeToClient =
    {
        ID = _LAIXIA_PACKET_SC_RechargeToClientID,
        name = "SCRechargeToClient",
        data_array=
        {
            {"Money",Type.Float},
            {"Value",Type.Int},
            {"PayType",Type.Byte},
            {"OrderID",Type.UTF8},
            {"ItemID",Type.Int},
        },
        HandlerFunction = onGCumengRetPacket,
    }

return SCRechargeToClient