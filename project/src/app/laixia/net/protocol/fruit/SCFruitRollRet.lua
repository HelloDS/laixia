local Type = import("...DataType")

local function onSCFruitRollRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_SHOWRESULTANIMATION,data)
end

local SCFruitRollRet =
    {
        name = "SCFruitRollRet",
        ID = _LAIXIA_PACKET_SC_FruitRollRetID,
        data_array =
        {
            { "FruitStatu",     Type.Int }, --��������״̬
            { "FruitResult",    Type.Array ,Type.Int}, --�н�ˮ��
            { "SevenTime",      Type.Double}, --�ϴγ���7��ʱ�� ����
        },
        HandlerFunction = onSCFruitRollRetPacket,
    }

return SCFruitRollRet