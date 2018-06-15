--龙虎斗压注申请

local Type = import("...DataType")

local CSDragonTigerBet =
    {
        ID = _LAIXIA_PACKET_CS_DragonTigerBetID,

        name = "CSDragonTigerBet",
        data_array =
        {
            {"type", Type.Byte},
            {"chip", Type.Int}
        }
    }

return CSDragonTigerBet