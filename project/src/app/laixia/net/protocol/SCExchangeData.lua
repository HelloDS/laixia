local Type = import("..DataType")

local function onSCExchangeDataPacket(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_EXCHANGE_WINDOW,packet:getValue("ShowExchange"))
end

local  SCExchangeData =
    {
        ID = _LAIXIA_PACKET_SC_ExchangeDataID,
        name = "SCExchangeData",
        data_array=
        {
            {"LastTime",    Type.Double},
            {"ShowExchange",  Type.Array,Type.TypeArray.ShowExchange},
        },
        HandlerFunction = onSCExchangeDataPacket,
    }

return SCExchangeData