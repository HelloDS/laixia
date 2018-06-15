--endregion

local Type = import("...DataType")

local CSMatchRegister =
    {
        ID = _LAIXIA_PACKET_CS_MatchRegisterID,
        name = "CSMatchRegister",
        data_array =
        {
            {"GameID", Type.Byte},
            {"PageType", Type.Byte},
            {"RoomID", Type.Int},
            {"ItemID",Type.Int},
            { "RegisterCode", Type.UTF8}  --报名码
        }
    }

return CSMatchRegister

