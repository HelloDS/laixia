
local Type = import("...DataType")

local function AttriChangePacket(packet)
    dump(packet.data)
    laixiaddz.logGame("属性消息" )
    dumpGameData(packet.data,"属性数据")
    if laixiaddz.LocalPlayercfg.laixiaddzCurrentWindow == "CardTableDialog"  and laixiaddz.LocalPlayercfg.laixiaddzisConnectCardTable == true then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_ATTRICHANGE_LANDLORDTABLE_WINDOWS,packet.data)
    end
end

return
    {
        ID= _laixiaddz_PACKET_SC_AttriChangeID ,--属性变化,
        name = "SCAttriChange",
        data_array =
        {
            {"AttriChangeItem",Type.Array,Type.TypeArray.Attribute},

        },
        HandlerFunction =AttriChangePacket
    };