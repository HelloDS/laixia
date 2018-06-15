--
-- Author: peter
-- Date: 2018-03-04 18:04:48
--

local Type = import("..DataType")

local CSGetVersionIn = 
    {   
        ID = _LAIXIA_PACKET_CS_GETVERSION ,

        name = "CSGetVersionIn" ,    
        data_array=
        {          
            {"Code",Type.Short,},   
            {"GameID",Type.Byte},   
            {"GameVersion",Type.UTF8},
        }  

    }

return CSGetVersionIn
