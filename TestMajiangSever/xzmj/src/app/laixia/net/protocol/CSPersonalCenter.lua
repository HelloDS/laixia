local Type = import("..DataType")

local CSPersonalCenter =
    {
        ID = _LAIXIA_PACKET_CS_PersonalCenterID ,

        name = "CSPersonalCenter" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
        }
    }

return CSPersonalCenter
