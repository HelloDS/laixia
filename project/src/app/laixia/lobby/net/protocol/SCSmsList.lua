--请求短消息

local Type = import("..DataType")

local function onSCSmsListPacket(packet)
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_UPDATE_MAIL_WINDOW,packet:getValue("Messages"))
end

local  SCSmsList =
    {
        name = "SCSmsList",
        ID = _LAIXIA_PACKET_SC_SmsListID,
        data_array=
        {
            {"Messages", Type.Array,Type.TypeArray.Letter},
        },
        HandlerFunction = onSCSmsListPacket,
    }

return SCSmsList