local Type = import("..DataType")

local CSModifySexNickSign =
    {
        ID = _LAIXIA_PACKET_CS_ModifySexNickSignID,
        name = "CSModifySexNickSign",
        data_array =
        {
            {"Code",Type.Short},
            {"Gender", Type.Byte },
            {"SignStr",Type.UTF8},
            {"NickName",Type.UTF8},
            {"ModifyType",Type.Byte},
        },
    }

return CSModifySexNickSign
