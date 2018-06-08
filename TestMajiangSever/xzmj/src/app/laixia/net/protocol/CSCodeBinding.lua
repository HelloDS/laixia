local Type = import("..DataType")

local CSCodeBinding =
    {
        ID = _LAIXIA_PACKET_CSCodeBindingID,

        name = "CSCodeBinding" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
            {"PhoneNum",Type.UTF8},
        }
    }

return CSCodeBinding
