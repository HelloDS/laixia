
local Type = import("...DataType")

local function AttriChangePacket(packet)
    dump(packet.data)
    laixia.logGame("属性消息" )
    dumpGameData(packet.data,"属性数据")
    if laixia.LocalPlayercfg.LaixiaCurrentWindow == "CardTableDialog"  and laixia.LocalPlayercfg.LaixiaisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_ATTRICHANGE_LANDLORDTABLE_WINDOWS,packet.data)
    end
end

return
    {
        ID= _LAIXIA_PACKET_SC_AttriChangeID ,--属性变化,
        name = "SCAttriChange",
        data_array =
        {
            {"AttriChangeItem",Type.Array,Type.TypeArray.Attribute},

        },
        HandlerFunction =AttriChangePacket
    };