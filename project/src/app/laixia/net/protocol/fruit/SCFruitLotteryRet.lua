local Type = import("...DataType")

local function onSCFruitLotteryRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_SHOWRESULT,data)
end

local SCFruitLotteryRet =
    {
        name = "SCFruitLotteryRet",
        ID = _LAIXIA_PACKET_SC_FruitLotteryRetID,
        data_array =
        {
            { "FruitStatu",             Type.Int }, --�������ڵ�״̬
            { "RemainGold",             Type.Double }, --����֮����ܳ���
            { "FruitHistory",           Type.Array,Type.Int },--�н�ˮ����ʷ
            { "FruitMultipleHistory",   Type.Array, Type.Int}, --��ʷˮ������
            { "fruitWin",           Type.Array,Type.TypeArray.FruitBet },--����ˮ�����˶���Ǯ
            { "FruitBet",               Type.Array,Type.TypeArray.FruitBet },   --�Լ���ע�б�
            { "winner",                 Type.Array,Type.TypeArray.FruitWinner }, --�н����


        },
        HandlerFunction = onSCFruitLotteryRetPacket,
    }

return SCFruitLotteryRet