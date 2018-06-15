local Type = import("..DataType")

local CSRevisePwd =
    {
        ID = _LAIXIA_PACKET_CS_RevisePwdID ,

        name = "CSRevisePwd" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"NewPassword",Type.UTF8},
            {"OldPassword",Type.UTF8},
        }

    }

return CSRevisePwd