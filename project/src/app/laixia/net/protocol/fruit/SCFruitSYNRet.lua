local Type = import("...DataType")

local function onSCFruitSYNRetPacket(packet)
--local a = packet --
end

local SCFruitSYNRet =
    {
        name = "SCFruitSYNRet",
        ID = _T_PACKET_SC_FruitSYNRetID,
        data_array =
        {
            { "PlayerName",     Type.UTF8 }, --玩家
            { "betList",    Type.Array ,Type.TypeArray.FruitBet} --下注了那些水果
        },
        HandlerFunction = onSCFruitSYNRetPacket,
    }

return SCFruitSYNRet