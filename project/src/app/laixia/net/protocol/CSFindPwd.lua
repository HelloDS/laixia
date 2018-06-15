local Type = import("..DataType")

local CSFindPwd =
    {
        ID = _LAIXIA_PACKET_CS_FindPwdID ,
        name = "CSFindPwd" ,
        data_array=
        {
            {"Rdf",Type.Short,},
            {"GameID",Type.Short},
            {"Number",Type.UTF8},
            {"Code",Type.UTF8,},
        }

    }

return CSFindPwd