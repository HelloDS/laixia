
local Type = import("...DataType")
local StatusCode = import("...StatusCode")

local function onSCLeaveRoomPacket(packet)

    local StatusID = packet:getValue("StatusID")
    if StatusCode.new(StatusID):isOK() then
        local test = 1
    end
end

return
    {
        ID = _laixiaddz_PACKET_SC_LeaveRoomID,
        name = "SCLeaveRoom",
        data_array =
        {
            { "roomId", Type.Byte},
            { "tableId",Type.Int},
            { "offPid",Type.Int},
        },
        HandlerFunction = onSCLeaveRoomPacket
    }

