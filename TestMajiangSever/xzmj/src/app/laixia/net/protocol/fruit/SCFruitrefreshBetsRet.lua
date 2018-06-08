local Type = import("...DataType")

local function onSCFruitrefreshBetsRetPacket(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_FRUITTABBLE_UPDATE_ALLCHIP,data)
end

local SCFruitrefreshBetsRet =
    {
        name = "SCFruitrefreshBetsRet",
        ID = _LAIXIA_PACKET_SC_FruitrefreshBetsRetID,
        data_array =
        {
            { "FruitStatu", Type.Int },--����״̬
            { "Fruits",     Type.Array ,Type.TypeArray.FruitBet}, --ÿ��ˮ����ע


        },
        HandlerFunction = onSCFruitrefreshBetsRetPacket,
    }

return SCFruitrefreshBetsRet