local Type = import("...DataType")

local function onSCFruitRebetRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_UPDATE_MYCHIP,data)
end

local SCFruitRebetRet =
    {
        name = "SCFruitRebetRet",
        ID = _LAIXIA_PACKET_SC_FruitRebetRetID,
        data_array =
        {
            {  "FruitStatu",  Type.Short },  --״̬��
            {  "RemainGold",  Type.Double }, --ʣ�����
            {  "MyFruitBets", Type.Array,Type.TypeArray.FruitBet } --ÿ��ˮ���µĽ��
        },
        HandlerFunction = onSCFruitRebetRetPacket,
    }

return SCFruitRebetRet