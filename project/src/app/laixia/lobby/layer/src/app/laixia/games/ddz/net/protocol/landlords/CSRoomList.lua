
local Type = import("...DataType")

local CSRoomList = {
    ID = _laixiaddz_PACKET_CS_ListRoomID,
    name = "CSRoomList",
    data_array =
    {
        {"RoomType",Type.Byte},
        {"Timestamp",Type.Int},
    }
}

return CSRoomList