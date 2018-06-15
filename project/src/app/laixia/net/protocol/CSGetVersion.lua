
local Type = import("..DataType")

local CSGetVersion = 
    {   
        ID = _LAIXIA_PACKET_CS_GETVERSION ,

        name = "CSGetVersion" ,    
        data_array=
        {          
            {"Code",Type.Short,},   
            {"GameID",Type.Byte},   
            {"GameVersion",Type.UTF8},
        }  

    }

return CSGetVersion
