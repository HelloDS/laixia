
local Type = import("...DataType")

local function onGCRoomListRetPacket(packet)

    if (packet.data.StatusID == 43 or packet.data.StatusID == 45  )then
        ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_MARKEDWORDS_WINDOW,{Text ="服务器维护中！",OnCallFunc = function ()
            ObjectEventDispatch:pushEvent(_laixiaddz_EVENT_SHOW_HALL_WINDOW)
        end})
    else
        local rooms = packet:getValue("RoomArray")
        ObjectEventDispatch:dispatchEvent( { name = _laixiaddz_EVENT_UPDATE_SELECTROOM_WINDOW, data = rooms })
    end
end

local RoomListRet =
    {
        ID = _laixiaddz_PACKET_SC_ListRoomID,
        name = "SCRoomList",
        data_array =
        {
            { "StatusID", Type.Short },
            { "RoomType", Type.Byte},
            { "Timestamp", Type.LuaNumber },
            { "RoomArray", Type.Array, Type.TypeArray.RoomList },--房间列表
        }
    }
RoomListRet.HandlerFunction = onGCRoomListRetPacket;

return RoomListRet