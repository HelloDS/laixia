local Type = import("...DataType")

local function onSCFruitAddBetRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_UPDATE_MYCHIP,data)
end

local SCFruitAddBetRet =
    {
        name = "SCFruitAddBetRet",
        ID = _LAIXIA_PACKET_SC_FruitAddBetRetID,
        data_array =
        {
            { "FruitStatu", Type.Short },  --״̬��
            { "RemainGold", Type.Double }, --ʣ�����
            { "MyFruitBets", Type.Array,Type.TypeArray.FruitBet } --ÿ��ˮ���µĽ��
        },
        HandlerFunction = onSCFruitAddBetRetPacket,
    }

return SCFruitAddBetRet