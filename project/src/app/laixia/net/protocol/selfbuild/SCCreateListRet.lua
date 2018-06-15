local Type = import("...DataType")
--用于创建自建桌的界面
local function onPacketSCCreateListRet(packet)
    if packet.data.Status ==  0  then
        local data =  packet.data.RoomList
        ObjectEventDispatch:pushEvent(_LAIXIA_EVENT_SHOW_SELFBUILDING_WINDOW,data)
    end
end

return
    {
        ID = _LAIXIA_PACKET_SC_CreateListRetID,
        name = "SCCreateListRet",
        data_array =
        {
            { "Status", Type.Short},
            { "RoomList", Type.Array, Type.TypeArray.SelfBuilRooms },--创建房间数据
        },
        HandlerFunction = onPacketSCCreateListRet,
    }
