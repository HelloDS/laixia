local Type = import("...DataType")


local function onPacketSCCreateExitRet(packet)
    local data = packet.data
    ObjectEventDispatch:pushEvent(_LAIXIA_ECENT_UPDATE_UIINEXIT,data)
end

return
    {
        ID = _LAIXIA_PACKET_SC_CreateExitRetID,
        name = "SCCreateExitRet",
        data_array =
        {
            {"RoomID", Type.Byte},
            {"TableID", Type.Int},
            {"ExitPidID", Type.Int},
            {"Seat",Type.Byte},         --��λ��,
        },
        HandlerFunction = onPacketSCCreateExitRet,
    }
