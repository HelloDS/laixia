local Type = import("...DataType")

local function onSCFruitLastWinnerBetRetRetPacket(packet)

end

local SCFruitLastWinnerBetRetRet =
    {
        name = "SCFruitLastWinnerBetRetRet",
        ID = _LAIXIA_PACKET_SC_FruitLastWinnerBetRetID,
        data_array =
        {

        },
        HandlerFunction = onSCFruitLastWinnerBetRetRetPacket,
    }

return SCFruitLastWinnerBetRetRet