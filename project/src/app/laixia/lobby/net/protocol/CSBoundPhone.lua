
local Type = import("..DataType")

local CSBoundPhone =
    {
        ID = _LAIXIA_PACKET_CS_BoundPhoneID ,

        name = "CSBoundPhone" ,
        data_array=
        {
            {"Code",Type.Short},
            {"GameID",Type.Short},
            {"Account",Type.UTF8},
            {"Passwd",Type.UTF8},
            {"PhoneCode",Type.UTF8},
        }

    }

return CSBoundPhone