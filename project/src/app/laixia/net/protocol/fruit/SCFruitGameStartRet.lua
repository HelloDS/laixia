local Type = import("...DataType")

local function onSCFruitGameStartRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_GAMESTART,data)
end

local SCFruitGameStartRet =
    {
        name = "SCFruitGameStartRet",
        ID = _LAIXIA_PACKET_SC_FruitGameStartRetID,
        data_array =
        {
            { "FruitStatu",     Type.Int },  --״̬  --0 ��ʾ��ע�׶� --1��ʾ�����׶� --2��ʾ����״̬
            { "RemainderTime",  Type.Int }   --����ʱ��
        },
        HandlerFunction = onSCFruitGameStartRetPacket,
    }

return SCFruitGameStartRet