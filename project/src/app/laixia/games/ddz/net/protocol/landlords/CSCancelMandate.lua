-- 玩家托管

local Type = import("...DataType")

CSCancelMandate =
    {
        ID=_laixiaddz_PACKET_CS_CancelMandateID ,--托管,
        name = "CSCancelMandate",
        data_array =
        {
            {"isMandate",Type.Byte},   --0:取消托管；1请求托管
            {"RoomID",Type.Byte},
            {"ServerUsed",Type.Byte},     --服务器使用不需要赋值
            {"TableID",Type.Int},
        },

    };

return CSCancelMandate
