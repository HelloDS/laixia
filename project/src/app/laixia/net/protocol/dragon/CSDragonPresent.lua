
local Type = import("...DataType")

local CSDragonPresent = {

        ID = _LAIXIA_PACKET_CS_DragonPresentID,

        name = "CSDragonPresent",

        data_array =
        {
            {"GameID",Type.Short},
            {"ItemID",Type.Int} ,
            {"ItemCount",Type.Int} ,
            {"FriendID",Type.Int},

        },
}

return CSDragonPresent
