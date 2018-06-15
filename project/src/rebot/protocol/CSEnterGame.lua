-- 进入游戏

local Type = require("rebot.DataType")

return
    {
        ID=_LAIXIA_PACKET_CS_EnterGameID,
        name = "CSEnterGame",
        data_array =
        {
            {"GameID", Type.Byte},
            {"Key", Type.Short},
        },

    }