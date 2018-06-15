local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onSCFruitInitRetPacket(packet)

    if StatusCode.new(packet.data.StatID):isOK() then
        local data = packet.data
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_SHOW_WINDOW,data)
    end
end

local SCFruitInitRet =
    {
        name = "SCFruitInitRet",
        ID = _LAIXIA_PACKET_SC_FruitInitGameRetID,
        data_array =
        {
            { "StatID",                 Type.Short },
            { "FruitStatu",             Type.Int }, --��������״̬
            { "FruitMaxBet",            Type.Int }, --���������ע
            { "RemainderTime",          Type.Int }, --ʣ��ʱ��
            { "FruitHistory",           Type.Array, Type.Int }, --�н���ʷ��¼
            { "MultipleFruitHistory",   Type.Array, Type.Int},   --��ʷˮ������
            { "FruitList",              Type.Array, Type.TypeArray.FruitStrand },--ˮ����˳��
            { "BetConfigList",          Type.Array, Type.TypeArray.DefBet },--��λ����ע����
            { "SelfFruitList",          Type.Array, Type.TypeArray.FruitBet },--�Լ�����ע
            { "FruitBetAll",            Type.Array, Type.TypeArray.FruitBet },--����λ�õ�ˮ���ܳ���
            { "Fruits",                 Type.Array, Type.TypeArray.FruitBet },  --ˮ����עλ��
            { "SevenTime",              Type.Double}, --�ϴγ���7��ʱ�� ����


        },
        HandlerFunction = onSCFruitInitRetPacket,
    }

return SCFruitInitRet