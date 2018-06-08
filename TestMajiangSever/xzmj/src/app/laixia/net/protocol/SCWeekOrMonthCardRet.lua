local Type = import("..DataType")

local function onSCWeekOrMonthCardRetPacket(packet)
    local StatusID = packet:getValue("StatusID") --状态吗
end


local  SCWeekOrMonthCardRet =
    {
        ID = _LAIXIA_PACKET_SC_WeekOrMonthCardRetID ,
        name = "SCWeekOrMonthCardRet",
        data_array=
        {
            {"StatusID",    Type.Short},
        },
        HandlerFunction = onSCWeekOrMonthCardRetPacket,

    }

return SCWeekOrMonthCardRet
