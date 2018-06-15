--
-- Author: peter
-- Date: 2018-03-26 14:41:52
--

local Type = import("...DataType")

local function onSCMatchSignPacket(packet)

    dump(packet.data)
    laixia.LocalPlayercfg.LaixiaMatchSigndata =packet:getValue("PageTypeMessage")
    --
    ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SIGN)

end

local  SCMatchSign =
    {
        name = "SCMatchSign",
        ID=_LAIXIA_PACKET_SC_MatchSignID, --比赛列表
        data_array=
        {
        	{"GameID", Type.Byte},
            {"PageTypeMessage",Type.Array,Type.TypeArray.PageSignMessage},
        },
        HandlerFunction = onSCMatchSignPacket,

    }

return SCMatchSign