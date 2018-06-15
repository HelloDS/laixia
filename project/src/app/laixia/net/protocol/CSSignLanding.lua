local Type = import("..DataType")

local CSSignLanding =
    {
        ID = _LAIXIA_PACKET_CS_SignLandingID ,

        name = "CSSignLanding" ,
        data_array=
        {
            {"Code",Type.Short,},
            {"GameID",Type.Short},
        }

    }

return CSSignLanding


 